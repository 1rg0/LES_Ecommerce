$(document).ready(function () {

    $('.add-to-cart-btn').on('click', function (e) {
        e.preventDefault();

        var button = $(this);
        var produtoId = button.data('produto-id');

        var quantidadeInput = $('#quantidade-' + produtoId);
        var quantidade = quantidadeInput.length > 0 ? quantidadeInput.val() : 1;

        button.prop('disabled', true).html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Adicionando...');

        $.ajax({
            url: '/Carrinho/Adicionar',
            type: 'POST',
            data: {
                produtoId: produtoId,
                quantidade: quantidade
            },
            success: function (response) {
                button.removeClass('btn-primary').addClass('btn-success').html('<i class="bi bi-check-lg"></i> Adicionado!');
            },
            error: function (xhr, status, error) {
                console.error("Erro ao adicionar ao carrinho: " + xhr.responseText);
                button.removeClass('btn-primary').addClass('btn-danger').html('Erro de Estoque');
                alert("Erro ao adicionar produto: " + xhr.responseText);
            },
            complete: function () {
                setTimeout(function () {
                    button.prop('disabled', false).removeClass('btn-success btn-danger').addClass('btn-primary').html('Adicionar ao Carrinho');
                }, 2000);
            }
        });
    });

    $(document).on('click', '.notificacao-link', function (e) {
        e.preventDefault();

        var link = $(this);
        var url = link.attr('href');
        var notificacaoId = link.data('id');

        var token = $('form[action="/Conta/Logout"] input[name="__RequestVerificationToken"]').val();

        if (notificacaoId && token) {
            $.ajax({
                url: '/Notificacoes/MarcarComoLida',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(notificacaoId),
                headers: {
                    'RequestVerificationToken': token
                },
                complete: function () {
                    window.location.href = url;
                }
            });
        } else {
            window.location.href = url;
        }
    });
});