$(document).ready(function () {

    function parseCurrency(textValue) {
        if (!textValue || typeof textValue !== 'string') {
            return 0;
        }
        var cleanedValue = textValue.replace('R$', '').replace(/\s/g, '').replace(/\./g, '').replace(',', '.');
        var number = parseFloat(cleanedValue);

        return isNaN(number) ? 0 : number;
    }

    function atualizarHiddenInputsDeCupons() {

        $('#hidden-cupons-container').empty();

        var index = 0;
        $('#cupons-aplicados-lista').find('.btn-remover-cupom').each(function () {
            var codigo = $(this).data('codigo');
            var hiddenInput = `<input type="hidden" name="CuponsAplicados[${index}]" value="${codigo}" />`;
            $('#hidden-cupons-container').append(hiddenInput);
            index++;
        });
    }

    function atualizarResumoPagamento() {

        var subtotal = parseCurrency($('#subtotal-carrinho').text());
        var frete = parseCurrency($('#frete-valor').text());
        var descontoTotal = 0;


        $('#cupons-aplicados-lista').find('.badge').each(function () {
            var text = $(this).text();
            var valorMatch = text.match(/\(R\$\s*([\d,.]+)\)/);
            if (valorMatch && valorMatch[1]) {
                descontoTotal += parseCurrency(valorMatch[1]);
            }
        });

        $('#valor-desconto').text("-" + descontoTotal.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }));

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

        if (restante <= 0.01) {
            $('#pagamento-error').slideUp();
            $('#lista-cartoes-pagamento').closest('.card').removeClass('border-danger');
        }
    }

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

    $('.money-mask').mask('000.000.000.000.000,00', { reverse: true });

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

    $('#checkout-form').submit(function (e) {
        var enderecoSelecionado = $('input[name="EnderecoSelecionadoId"]:checked').val();
        var errorDiv = $('#endereco-error');

        if (!enderecoSelecionado) {
            e.preventDefault();
            errorDiv.slideDown();
            $('.card-body#address-selection').closest('.card').addClass('border-danger');
            return false;
        } else {
            errorDiv.slideUp();
            $('.card-body#address-selection').closest('.card').removeClass('border-danger');
        }

        var valorRestante = parseCurrency($('#valor-restante-resumo').text());
        var pagamentoErrorDiv = $('#pagamento-error');
        var pagamentoCard = $('#lista-cartoes-pagamento').closest('.card');

        if (valorRestante > 0.01) {
            e.preventDefault();
            pagamentoErrorDiv.slideDown();
            pagamentoCard.addClass('border-danger');
            return false;
        } else {
            pagamentoErrorDiv.slideUp();
            pagamentoCard.removeClass('border-danger');
        }
    });

    $('#address-selection').on('change', '.address-radio', function () {
        if ($(this).is(':checked')) {
            $('#endereco-error').slideUp();
            $('.card-body#address-selection').closest('.card').removeClass('border-danger');
        }
    });
});