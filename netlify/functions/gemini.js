const https = require('https');

exports.handler = async function(event, context) {
  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
      },
      body: ''
    };
  }

  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  const apiKey = process.env.GEMINI_API_KEY;
  const { message } = JSON.parse(event.body);

  const postData = JSON.stringify({
    contents: [{
      parts: [{
        text: `You are a helpful travel assistant for the Layover Friends app. Help travelers with visa requirements, airport tips, layover activities, currency advice, and travel hacks. Keep responses concise and friendly. User question: ${message}`
      }]
    }]
  });

  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'generativelanguage.googleapis.com',
      path: `/v1beta/models/gemini-2.0-flash:generateContent?key=${apiKey}`,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(postData)
      }
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => { data += chunk; });
      res.on('end', () => {
        try {
          const parsed = JSON.parse(data);
          const reply = parsed.candidates?.[0]?.content?.parts?.[0]?.text || 'Sorry, I could not process that.';
          resolve({
            statusCode: 200,
            headers: {
              'Access-Control-Allow-Origin': '*',
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({ reply })
          });
        } catch (e) {
          resolve({
            statusCode: 200,
            headers: { 'Access-Control-Allow-Origin': '*' },
            body: JSON.stringify({ reply: 'Debug: ' + data })
          });
        }
      });
    });

    req.on('error', (e) => {
      resolve({
        statusCode: 500,
        headers: { 'Access-Control-Allow-Origin': '*' },
        body: JSON.stringify({ reply: 'Error: ' + e.message })
      });
    });

    req.write(postData);
    req.end();
  });
};