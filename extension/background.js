console.log("aaaaaaaaaa");
chrome.action.onClicked.addListener((tab) => {
    console.log("clicked")
    chrome.runtime.sendNativeMessage('com.soulseek.nativehost', { command: 'run_script' }, (response) => {
        console.log("response")
      if (chrome.runtime.lastError) {
        console.error(chrome.runtime.lastError);
      } else {
        console.log(' executed:', response);
      }
    });
  });