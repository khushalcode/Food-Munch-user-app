importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyD-VAoiI5hTABCqvbxMWMrIqzFPuFPujaM",
  authDomain: "ayush-482e1.firebaseapp.com",
  databaseURL: "https://ammart-8885e-default-rtdb.firebaseio.com",
  projectId: "ayush-482e1",
  storageBucket: "ayush-482e1.firebasestorage.app",
  messagingSenderId: "868402273001",
  appId: "1:868402273001:web:61baefcc6e2f0635452e78",
  measurementId: "G-VPY80CJ51M"
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});