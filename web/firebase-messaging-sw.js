importScripts("https://www.gstatic.com/firebasejs/10.4.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.4.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: 'AIzaSyDurvYoZzDyDopwuOhcE0ELP7gLQOkME5k',
    appId: 'fcm-notifications-3347c',

    messagingSenderId: '7794646170',
    projectId: 'fcm-notifications-3347c',


});

const messaging = firebase.messaging();


