document.addEventListener('DOMContentLoaded', function () {

    $('#CPF').mask('000.000.000-00', { reverse: true });

    $('#DDD').mask('00');

    var options = {
        onKeyPress: function (cep, e, field, options) {
            var masks = ['0000-0000', '00000-0000'];
            var mask = (cep.length > 8) ? masks[1] : masks[0];
            $('#Numero').mask(mask, options);
        }
    };
    $('#Numero').mask('0000-0000', options);

    $('#cep').mask('00000-000');

    $('#numeroCartao').mask('0000 0000 0000 0000');

    $('#dataValidadeCartao').mask('00/0000');

    $('#cvv').mask('000');

    let enderecosAdicionados = [];
    let cartoesAdicionados = [];
    let proximoIdTemporario = -1;
    let idEmEdicao = null;

    const formPrincipal = document.getElementById('cliente-form');

    const btnAbrirModalEndereco = document.querySelector('button[data-bs-target="#enderecoModal"]');
    const enderecoModal = document.getElementById('enderecoModal');
    const listaEnderecosDiv = document.getElementById('lista-enderecos');
    const formEndereco = document.getElementById('form-endereco');
    const enderecoModalLabel = document.getElementById('enderecoModalLabel');

    const btnAbrirModalCartao = document.querySelector('button[data-bs-target="#cartaoModal"]');
    const cartaoModal = document.getElementById('cartaoModal');
    const listaCartoesDiv = document.getElementById('lista-cartoes');
    const formCartao = document.getElementById('form-cartao');


    btnAbrirModalEndereco.addEventListener('click', function () {
        idEmEdicao = null;
        formEndereco.reset();
        enderecoModalLabel.textContent = 'Adicionar Novo Endereço';
    });

    formEndereco.addEventListener('submit', function (event) {
        event.preventDefault();
        const enderecoData = {
            apelido: document.getElementById('apelido').value,
            cep: document.getElementById('cep').value,
            logradouro: document.getElementById('logradouro').value,
            numero: document.getElementById('numero').value,
            bairro: document.getElementById('bairro').value,
            cidadeTexto: document.getElementById('cidadeId').options[document.getElementById('cidadeId').selectedIndex].text,
            cidadeID: parseInt(document.getElementById('cidadeId').value),
            tipo_EnderecoID: parseInt(document.getElementById('tipoEnderecoId').value),
            tipo_ResidenciaID: parseInt(document.getElementById('tipoResidenciaId').value),
            tipo_LogradouroID: parseInt(document.getElementById('tipoLogradouroId').value),
            observacao: document.getElementById('observacao').value

        };

        if (idEmEdicao) {
            const index = enderecosAdicionados.findIndex(e => e.id === idEmEdicao);
            if (index !== -1) {
                enderecosAdicionados[index] = { ...enderecosAdicionados[index], ...enderecoData };
            }
        } else {
            enderecoData.id = proximoIdTemporario--;
            enderecosAdicionados.push(enderecoData);
        }
        if (enderecoData == null) {
            console.error('Erro ao salvar o endereço: dados inválidos.');
        }

        renderizarListaEnderecos();
        bootstrap.Modal.getInstance(enderecoModal).hide();

    });

    listaEnderecosDiv.addEventListener('click', function (event) {
        const target = event.target;
        const card = target.closest('.card');
        if (!card) return;
        const tempId = parseInt(card.getAttribute('data-temp-id'));

        if (target.classList.contains('btn-excluir-endereco')) {
            enderecosAdicionados = enderecosAdicionados.filter(e => e.id !== tempId);
            renderizarListaEnderecos();
        }

        if (target.classList.contains('btn-editar-endereco')) {
            const enderecoParaEditar = enderecosAdicionados.find(e => e.id === tempId);
            if (enderecoParaEditar) {
                document.getElementById('apelido').value = enderecoParaEditar.apelido;
                document.getElementById('cep').value = enderecoParaEditar.cep;
                document.getElementById('logradouro').value = enderecoParaEditar.logradouro;
                document.getElementById('numero').value = enderecoParaEditar.numero;
                document.getElementById('bairro').value = enderecoParaEditar.bairro;
                document.getElementById('cidadeId').value = enderecoParaEditar.cidadeID;
                document.getElementById('tipoEnderecoId').value = enderecoParaEditar.tipo_EnderecoID;
                document.getElementById('tipoResidenciaId').value = enderecoParaEditar.tipo_ResidenciaID;
                document.getElementById('tipoLogradouroId').value = enderecoParaEditar.tipo_LogradouroID;
                document.getElementById('observacao').value = enderecoParaEditar.observacao;

                idEmEdicao = tempId;
                enderecoModalLabel.textContent = 'Editar Endereço';
                new bootstrap.Modal(enderecoModal).show();
            }
        }
    });

    btnAbrirModalCartao.addEventListener('click', function () {
        idEmEdicao = null;
        formCartao.reset();

        document.getElementById('dataValidadeCartao').value = '';

        // Adicione estas 2 linhas para limpar o erro ao abrir o modal
        document.getElementById('numero-cartao-error').style.display = 'none';
        document.getElementById('numeroCartao').classList.remove('is-invalid');
    });

    formCartao.addEventListener('submit', function (event) {
        event.preventDefault();

        const numeroCartaoInput = document.getElementById('numeroCartao');
        const numeroCartaoErrorSpan = document.getElementById('numero-cartao-error');

        const numeroCartao = numeroCartaoInput.value.replace(/\s/g, '');

        if (numeroCartao.length !== 16) {
            numeroCartaoErrorSpan.style.display = 'block';
            numeroCartaoInput.classList.add('is-invalid');
            return;
        } else {
            numeroCartaoErrorSpan.style.display = 'none';
            numeroCartaoInput.classList.remove('is-invalid');
        }

        let isPreferencial = document.getElementById('preferencial').checked;

        if (cartoesAdicionados.length === 0) {
            isPreferencial = true;
        }

        if (isPreferencial) {
            cartoesAdicionados.forEach(c => c.preferencial = false);
        }

        const cartaoData = {
            id: proximoIdTemporario--,
            nomeImpresso: document.getElementById('nomeImpresso').value,
            dataValidade: document.getElementById('dataValidadeCartao').value,
            bandeira: document.getElementById('bandeira').value,
            ultimosQuatroDigitos: numeroCartao.slice(-4),
            preferencial: isPreferencial
        };

        cartoesAdicionados.push(cartaoData);
        renderizarListaCartoes();
        bootstrap.Modal.getInstance(cartaoModal).hide();
    });

    listaCartoesDiv.addEventListener('click', function (event) {
        const target = event.target;
        const card = target.closest('.card');
        if (!card) return;
        const tempId = parseInt(card.getAttribute('data-temp-id'));

        if (target.classList.contains('btn-excluir-cartao')) {
            cartoesAdicionados = cartoesAdicionados.filter(c => c.id !== tempId);
            renderizarListaCartoes();
        }
    });

    function renderizarListaEnderecos() {
        listaEnderecosDiv.innerHTML = '';
        if (enderecosAdicionados.length === 0) {
            listaEnderecosDiv.innerHTML = '<p>Nenhum endereço adicionado.</p>';
            return;
        }
        enderecosAdicionados.forEach(endereco => {
            const enderecoCardHtml = `
                <div class="card mb-2" data-temp-id="${endereco.id}">
                    <div class="card-body">
                        <h5 class="card-title">${endereco.apelido}</h5>
                        <p class="card-text">${endereco.logradouro}, ${endereco.numero} - ${endereco.bairro}, ${endereco.cidadeTexto}</p>
                        <button type="button" class="btn btn-sm btn-outline-primary btn-editar-endereco">Editar</button>
                        <button type="button" class="btn btn-sm btn-outline-danger btn-excluir-endereco">Excluir</button>
                    </div>
                </div>
            `;
            listaEnderecosDiv.insertAdjacentHTML('beforeend', enderecoCardHtml);
        });
    }

    function renderizarListaCartoes() {
        listaCartoesDiv.innerHTML = '';
        if (cartoesAdicionados.length === 0) {
            listaCartoesDiv.innerHTML = '<p>Nenhum cartão adicionado.</p>';
            return;
        }
        cartoesAdicionados.forEach(cartao => {
            const preferencialBadge = cartao.preferencial ? '<span class="badge bg-success">Preferencial</span>' : '';
            const cartaoCardHtml = `
                <div class="card mb-2" data-temp-id="${cartao.id}">
                    <div class="card-body">
                        <h5 class="card-title">${cartao.bandeira} - Final **** ${cartao.ultimosQuatroDigitos} ${preferencialBadge}</h5>
                        <p class="card-text">${cartao.nomeImpresso}</p>
                        <button type="button" class="btn btn-sm btn-outline-danger btn-excluir-cartao">Excluir</button>
                    </div>
                </div>
            `;
            listaCartoesDiv.insertAdjacentHTML('beforeend', cartaoCardHtml);
        });
    }

    formPrincipal.addEventListener('submit', async function (event) {
        event.preventDefault();
        const formData = new FormData(formPrincipal);
        const clienteData = Object.fromEntries(formData.entries());

        clienteData.Enderecos = enderecosAdicionados;
        clienteData.Cartoes = cartoesAdicionados;

        try {
            const response = await fetch('/Clientes/Create', {
                method: 'POST',
                headers: {
                    'RequestVerificationToken': document.querySelector('input[name="__RequestVerificationToken"]').value,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(clienteData)
            });

            if (response.ok) {
                const result = await response.json();
                window.location.href = result.redirectToUrl;
            } else {
                const errorData = await response.json();
                const businessAlertsDiv = document.getElementById('business-alerts');

                document.querySelectorAll('.text-danger').forEach(span => span.textContent = '');
                businessAlertsDiv.innerHTML = '';
                businessAlertsDiv.style.display = 'none';

                let generalErrors = [];

                for (const key in errorData) {
                    const fieldName = key;
                    const errorMessages = errorData[key];

                    if (fieldName === '') {
                        errorMessages.forEach(msg => generalErrors.push(msg));
                    } else {
                        const span = document.querySelector(`[data-valmsg-for="${fieldName}"]`);
                        if (span) {
                            span.textContent = errorMessages.join(' ');
                        }
                    }
                }
            }
        } catch (error) {
            console.error('Erro ao enviar o formulário:', error);
        }
    });
});