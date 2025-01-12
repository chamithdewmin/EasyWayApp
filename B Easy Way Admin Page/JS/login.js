// Load environment variables from .env file
import { initializeApp } from "https://www.gstatic.com/firebasejs/11.1.0/firebase-app.js";
import { getAuth, signInWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/11.1.0/firebase-auth.js";

// Firebase configuration using environment variables
const firebaseConfig = {
    apiKey: import.meta.env.VITE_FIREBASE_API_KEY,
    authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN,
    projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID,
    storageBucket: import.meta.env.VITE_FIREBASE_STORAGE_BUCKET,
    messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
    appId: import.meta.env.VITE_FIREBASE_APP_ID,
    measurementId: import.meta.env.VITE_FIREBASE_MEASUREMENT_ID
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

// Submit button event
document.getElementById("loginForm").addEventListener("submit", function (event) {
    event.preventDefault();

    const emailField = document.getElementById("email");
    const passwordField = document.getElementById("password");

    const email = emailField.value;
    const password = passwordField.value;

    signInWithEmailAndPassword(auth, email, password)
        .then((userCredential) => {
            // Clear input fields on successful login
            emailField.value = "";
            passwordField.value = "";
            window.location.href = "grand.html";
        })
        .catch((error) => {
            // Clear input fields on failed login
            emailField.value = "";
            passwordField.value = "";

            let errorMessage;
            switch (error.code) {
                case "auth/wrong-password":
                case "auth/user-not-found":
                    errorMessage = "Invalid username or password. Please try again.";
                    break;
                case "auth/invalid-email":
                    errorMessage = "Invalid email format. Please enter a valid email.";
                    break;
                default:
                    errorMessage = "Invalid username or password. Please try again later.";
            }
            // Display user-friendly error message in an alert box
            alert(errorMessage);
        });
});
