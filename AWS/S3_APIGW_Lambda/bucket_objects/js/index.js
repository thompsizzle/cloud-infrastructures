var ssm = new AWS.SSM({
    region: 'us-east-1',
    accessKeyId: 'AKIARIYZKVXPCH5Y23TT',
    secretAccessKey: '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'
});

var params = {
    Name: 'api-gateway-invoke-url',
    WithDecryption: false
};

var API_ENDPOINT = null;
ssm.getParameter(params, function(err, data) {
    if (err) console.log(err, err.stack);
    else API_ENDPOINT = data.Parameter.Value;
});

// Setup divs that will be used to display interactive messages
var errorDiv = document.getElementById('error-message')
var resultsDiv = document.getElementById('results-message')

function clearNotifications() {
    // Clear any exisiting notifications in the browser notifications divs
    errorDiv.textContent = '';
    resultsDiv.textContent = '';
}

document.getElementById('form-submit').addEventListener('click', function(e) {
    sendData(e);
});

function sendData (e) {
    e.preventDefault()
    clearNotifications()
    fetch(API_ENDPOINT, {
        method: 'GET',
        mode: 'cors'
    })
    .then((response) => {
        console.log(response);
        response.text().then((data) => {
            resultsDiv.textContent = data;
        });
    })
    .catch(function(err) {
        errorDiv.textContent = 'Contact site administrator';
        console.log(err)
    });
};