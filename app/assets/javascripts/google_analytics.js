// Send analytics tag on Turbolinks page changes
document.addEventListener('turbolinks:load', function(event) {
    if (typeof gtag === 'function') {
        gtag('config', 'G-YD9YH3J21X', {
            'page_location': event.data.url
        })
    }
});
