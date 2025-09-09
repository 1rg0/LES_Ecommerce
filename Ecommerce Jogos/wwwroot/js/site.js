// Executa quando o documento estiver totalmente carregado
$(document).ready(function () {

    // Adiciona um "ouvinte" de clique a qualquer botão que tenha a classe 'add-to-cart-btn'
    $('.add-to-cart-btn').on('click', function (e) {
        e.preventDefault(); // Impede que o botão execute sua ação padrão

        var button = $(this);
        var produtoId = button.data('produto-id'); // Pega o ID do produto do atributo 'data-produto-id'

        // Tenta encontrar um campo de quantidade associado a este botão
        var quantidadeInput = $('#quantidade-' + produtoId);
        var quantidade = quantidadeInput.length > 0 ? quantidadeInput.val() : 1; // Se não encontrar, a quantidade é 1

        // Mostra um feedback visual no botão
        button.prop('disabled', true).html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Adicionando...');

        // Faz a chamada AJAX para o nosso controller
        $.ajax({
            url: '/Carrinho/Adicionar',
            type: 'POST',
            data: {
                produtoId: produtoId,
                quantidade: quantidade
            },
            success: function (response) {
                // Em caso de sucesso
                console.log(response); // Opcional: veja a resposta do controller no console
                button.removeClass('btn-primary').addClass('btn-success').html('<i class="bi bi-check-lg"></i> Adicionado!');

                // Opcional: Atualizar um contador de itens do carrinho no topo da página
                // updateCartCounter(); 
            },
            error: function (xhr, status, error) {
                // Em caso de erro (ex: estoque insuficiente)
                console.error("Erro ao adicionar ao carrinho: " + xhr.responseText);
                button.removeClass('btn-primary').addClass('btn-danger').html('Erro de Estoque');
                alert("Erro ao adicionar produto: " + xhr.responseText); // Mostra o erro para o usuário
            },
            complete: function () {
                // Independentemente do resultado, reativa o botão após um tempo
                setTimeout(function () {
                    button.prop('disabled', false).removeClass('btn-success btn-danger').addClass('btn-primary').html('Adicionar ao Carrinho');
                }, 2000); // 2 segundos
            }
        });
    });
});