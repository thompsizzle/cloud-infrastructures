const aws = require("aws-sdk");
const ses = new aws.SES({ region: "us-east-2" });
exports.handler = async function (event) {
	// Extract the properties from the event body from API Gateway
  const { name, email, phone, member, message } = JSON.parse(event.body);
  // Extract the properties from the event within Lambda test
  // const { name, email, phone, member, message } = event;
  const params = {
    Destination: {
      ToAddresses: [`thompsizzle@gmail.com`],
    },
		// Interpolate the data in the strings to send
    Message: {
      Body: {
        Text: {
            Data: `You just got a message from ${name}

            Name: ${name}
            Email: ${email}
            Phone: ${phone}
            Member: ${member}
            Message: ${message}`
        },
      },
      Subject: { Data: `Message from ${name}` },
    },
    Source: "thompsizzle@gmail.com",
  };

  await ses.sendEmail(params).promise();

  return {
    statusCode: 200,
    body: "OK",
    headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Methods": "OPTIONS,POST"
    }
  };

};
