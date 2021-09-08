if (confirm('Do you want to present Color screen using message?')) {
    window.webkit.messageHandlers.iOS_MessageHandlerName.postMessage('presentCyanScreen&completion=https://m.naver.com/')
} else {
    
}
