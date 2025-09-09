$(document).ready(function () {

    // --- FUNÇÃO AUXILIAR SEGURA PARA CONVERTER MOEDA ---
    // Converte um texto (ex: "R$ 1.234,56") para um número (ex: 1234.56)
    function parseCurrency(textValue) {
        if (!textValue || typeof textValue !== 'string') {
            return 0;
        }
        // Remove 'R$', espaços, e os pontos de milhar. Depois, troca a vírgula por ponto.
        var cleanedValue = textValue.replace('R$', '').replace(/\s/g, '').replace(/\./g, '').replace(',', '.');
        var number = parseFloat(cleanedValue);

        // Se o resultado não for um número, retorna 0.
        return isNaN(number) ? 0 : number;
    }

    function atualizarHiddenInputsDeCupons() {
        // Limpa o container para não duplicar inputs
        $('#hidden-cupons-container').empty();

        var index = 0;
        // Para cada badge de cupom visível na tela...
        $('#cupons-aplicados-lista').find('.btn-remover-cupom').each(function () {
            var codigo = $(this).data('codigo');
            // Cria um input hidden correspondente
            var hiddenInput = `<input type="hidden" name="CuponsAplicados[${index}]" value="${codigo}" />`;
            // Adiciona o input ao container dentro do form
            $('#hidden-cupons-container').append(hiddenInput);
            index++;
        });
    }

    // --- FUNÇÃO PRINCIPAL PARA ATUALIZAR O RESUMO (CORRIGIDA) ---
    function atualizarResumoPagamento() {
        // 1. Lê os componentes base do preço.
        var subtotal = parseCurrency($('#subtotal-carrinho').text());
        var frete = parseCurrency($('#frete-valor').text());
        var descontoTotal = 0;

        // 2. Recalcula o desconto total a partir dos cupons visíveis na tela.
        $('#cupons-aplicados-lista').find('.badge').each(function () {
            var text = $(this).text(); // Ex: "CUPOM10 (R$ 10,00)"
            var valorMatch = text.match(/\(R\$\s*([\d,.]+)\)/);
            if (valorMatch && valorMatch[1]) {
                descontoTotal += parseCurrency(valorMatch[1]);
            }
        });

        // Atualiza a linha de desconto total
        $('#valor-desconto').text("-" + descontoTotal.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }));

        // 3. Recalcula o total a pagar do zero, garantindo que o valor está sempre correto.
        var totalAPagar = subtotal + frete - descontoTotal;
        $('#total-com-frete').find('strong').text(totalAPagar.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }));

        var totalPagoComCartoes = 0;
        $('.cartao-checkbox:checked').each(function () {
            var cartaoId = $(this).val();
            var valorInput = $('#valor-cartao-' + cartaoId).find('input.valor-pagamento').val();
            var valorNumerico = parseCurrency(valorInput);
            totalPagoComCartoes += valorNumerico;

            var errorSpan = $('#error-cartao-' + cartaoId);
            if (valorNumerico > 0 && valorNumerico < 10 && totalAPagar > totalPagoComCartoes) {
                errorSpan.text('O valor mínimo por cartão é R$ 10,00.');
            } else {
                errorSpan.text('');
            }
        });

        var restante = totalAPagar - totalPagoComCartoes;

        $('#valor-pago-resumo').text(totalPagoComCartoes.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }));
        $('#valor-restante-resumo').text(restante.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }));

        if (restante <= 0.009) {
            $('#valor-restante-resumo').addClass('text-success').removeClass('text-danger').text('R$ 0,00');
        } else {
            $('#valor-restante-resumo').addClass('text-danger').removeClass('text-success');
        }
    }

    // --- EVENT LISTENERS ---

    // Lógica de cálculo de frete
    $('#address-selection').on('change', '.address-radio', function () {
        var enderecoId = $(this).val();
        $('#frete-valor').html('<span class="spinner-border spinner-border-sm"></span> Calculando...');
        $.ajax({
            url: '/Checkout/CalcularFrete',
            type: 'POST',
            data: { enderecoId: enderecoId },
            success: function (response) {
                $('#frete-valor').text(response.valorFreteFormatado);
                atualizarResumoPagamento();
            },
            error: function (xhr) {
                console.error("Erro ao calcular o frete: " + xhr.responseText);
                $('#frete-valor').text("Erro").addClass("text-danger");
            }
        });
    });

    // Inicializa as máscaras
    $('.money-mask').mask('000.000.000.000.000,00', { reverse: true });

    // Lógica de múltiplos cartões
    function reindexarNomesCartoes() {
        var index = 0;
        $('.cartao-checkbox').each(function () {
            var checkbox = $(this);
            var container = checkbox.closest('.form-check');
            var hiddenIdInput = container.find('.cartao-id-hidden');
            var valorInput = container.find('.valor-pagamento');
            if (checkbox.is(':checked')) {
                hiddenIdInput.attr('name', `PagamentosComCartao[${index}].CartaoId`);
                valorInput.attr('name', `PagamentosComCartao[${index}].Valor`);
                index++;
            } else {
                hiddenIdInput.removeAttr('name');
                valorInput.removeAttr('name');
            }
        });
    }

    $('#lista-cartoes-pagamento').on('change', '.cartao-checkbox', function () {
        var cartaoId = $(this).val();
        var valorDiv = $('#valor-cartao-' + cartaoId);
        if ($(this).is(':checked')) {
            valorDiv.slideDown();
        } else {
            valorDiv.slideUp();
            valorDiv.find('input.valor-pagamento').val('');
        }
        reindexarNomesCartoes();
        atualizarResumoPagamento();
    });

    $('#lista-cartoes-pagamento').on('keyup', '.valor-pagamento', function () {
        atualizarResumoPagamento();
    });

    // Lógica de múltiplos cupons
    $('#btn-aplicar-cupom').on('click', function () {
        var codigo = $('#cupom-input').val();
        var btn = $(this);
        var mensagemDiv = $('#cupom-mensagem');

        if (!codigo) {
            mensagemDiv.text('Por favor, digite um código.').addClass('text-danger').removeClass('text-success');
            return;
        }

        btn.prop('disabled', true).text('Aplicando...');
        mensagemDiv.text('').removeClass('text-danger text-success');

        $.ajax({
            url: '/Checkout/AplicarCupom',
            type: 'POST',
            data: { codigo: codigo },
            success: function (response) {
                if (response.sucesso) {
                    var cupomHtml = `<div class="badge bg-light text-dark p-2 me-2 mb-1" id="cupom-${response.cupomAdicionado.codigo}">
                                        ${response.cupomAdicionado.codigo} (${response.cupomAdicionado.valorFormatado})
                                        <button type="button" class="btn-close btn-remover-cupom ms-1" data-codigo="${response.cupomAdicionado.codigo}" aria-label="Remove"></button>
                                     </div>`;
                    $('#cupons-aplicados-lista').append(cupomHtml);
                    $('#linha-desconto').show();
                    mensagemDiv.text('Cupom aplicado!').addClass('text-success');
                    $('#cupom-input').val('');
                    atualizarHiddenInputsDeCupons();
                } else {
                    mensagemDiv.text(response.mensagem).addClass('text-danger');
                }
                btn.prop('disabled', false).text('Aplicar');
                atualizarResumoPagamento();
            }
        });
    });

    $('#cupons-aplicados-lista').on('click', '.btn-remover-cupom', function () {
        var codigo = $(this).data('codigo');

        $.ajax({
            url: '/Checkout/RemoverCupom',
            type: 'POST',
            data: { codigo: codigo },
            success: function (response) {
                if (response.sucesso) {
                    $('#cupom-' + codigo).remove();
                    if ($('#cupons-aplicados-lista').children().length === 0) {
                        $('#linha-desconto').hide();
                    }
                    atualizarHiddenInputsDeCupons();
                    atualizarResumoPagamento();
                }
            }
        });
    });
});