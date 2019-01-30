// Send analytics tag on Turbolinks page changes
document.addEventListener('turbolinks:load', function(event) {
    if (typeof gtag === 'function') {
        gtag('config', 'UA-100711792-3', {
            'page_location': event.data.url
        })
    }
});