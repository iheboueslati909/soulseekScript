const { exec } = require('child_process');

process.stdin.on('data', (data) => {
    let input = data.toString().trim();
    try {
        let message = JSON.parse(input);
        if (message.command === 'run_script') {
            exec('C:\Users\hooba\OneDrive\Bureau\ssscript\soulseekScript\script.bat', (error, stdout, stderr) => {
                if (error) {
                    sendResponse({ status: 'error', message: error.message });
                    return;
                }
                if (stderr) {
                    sendResponse({ status: 'error', message: stderr });
                    return;
                }
                sendResponse({ status: 'success', message: stdout });
            });
        } else {
            sendResponse({ status: 'unknown_command' });
        }
    } catch (e) {
        sendResponse({ status: 'error', message: e.message });
    }
});

function sendResponse(response) {
    let responseString = JSON.stringify(response);
    let responseLength = Buffer.byteLength(responseString);
    process.stdout.write(Buffer.from([responseLength & 0xff, (responseLength >> 8) & 0xff, (responseLength >> 16) & 0xff, (responseLength >> 24) & 0xff]));
    process.stdout.write(responseString);
}
