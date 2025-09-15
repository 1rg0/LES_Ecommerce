$(document).ready(function () {
    const chatInput = $('#chat-input');
    const sendButton = $('#send-chat-button');
    const chatMessages = $('.chat-messages');

    var token = $('form[action="/Conta/Logout"] input[name="__RequestVerificationToken"]').val();

    let chatHistory = [];

    function appendMessage(text, type) {
        const messageDiv = $(`<div class="message ${type}-message mb-2">${text}</div>`);
        chatMessages.append(messageDiv);
        chatMessages.scrollTop(chatMessages[0].scrollHeight);


        const role = (type === 'user') ? 'user' : 'model';
        chatHistory.push({ role: role, text: text });
    }

    const initialBotMessage = chatMessages.find('.bot-message').text().trim();
    if (initialBotMessage) {
        chatHistory.push({ role: 'model', text: initialBotMessage });
    }

    function handleSend() {
        const userText = chatInput.val().trim();
        if (userText === "") return;

        appendMessage(userText, 'user');
        chatInput.val('');
        sendButton.prop('disabled', true).html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>');

        const dataToSend = {
            texto: userText,
            historico: chatHistory.slice(0, -1)
        };

        $.ajax({
            url: '/Recomendacao/ObterRecomendacao',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(dataToSend),
            headers: {
                'RequestVerificationToken': token
            },
            success: function (response) {
                appendMessage(response.resposta, 'bot');
            },
            error: function (xhr) {
                appendMessage('Desculpe, não consegui processar sua pergunta agora. Tente novamente mais tarde.', 'bot');
                console.error(xhr.responseText);
            },
            complete: function () {
                sendButton.prop('disabled', false).html('<i class="bi bi-send-fill"></i> Enviar');
            }
        });
    }

    sendButton.on('click', handleSend);
    chatInput.on('keypress', function (e) {
        if (e.which === 13) {
            handleSend();
        }
    });
});