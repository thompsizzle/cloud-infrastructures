// Setup divs that will be used to display interactive messages
var errorDiv = document.getElementById('error-message')
var successDiv = document.getElementById('success-message')
var resultsDiv = document.getElementById('results-message')

// function output returns input button contents
function nameValue() { return document.getElementById('name').value }
function emailValue() { return document.getElementById('email').value }
function phoneValue() { return document.getElementById('phone').value }
function memberValue() { return document.getElementById('member').value }
function messageValue() { return document.getElementById('message').value }

function clearNotifications() {
    // Clear any exisiting notifications in the browser notifications divs
    errorDiv.textContent = '';
    successDiv.textContent = '';
    resultsDiv.textContent = '';
}

document.getElementById('contact_form').addEventListener('submit', function(e) {
    sendData(e);
});

function sendData (e) {
    e.preventDefault();
    clearNotifications();

    fetch(API_ENDPOINT,{
        headers:{
            "Content-type": "application/json",
        },
        method: 'POST',
        body: JSON.stringify({
            name: nameValue(),
            email: emailValue(),
            phone: phoneValue(),
            member: memberValue(),
            message: messageValue()
        }),
        mode: 'cors'
    })
    .then((response) => {
        // console.log(response);
        response.text().then((data) => {
            resultsDiv.innerHTML = "<div class='message'>Email successfully sent</div>";
        });
    })
    .catch(function(err) {
        errorDiv.innerHTML = "<div class='message error'>Contact site administrator</div>";
        // console.log(err)
    });
};