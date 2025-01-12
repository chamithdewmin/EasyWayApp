// Load environment variables from .env file
require('dotenv').config();

// Firebase configuration from environment variables
const firebaseConfig = {
    apiKey: process.env.FIREBASE_API_KEY,
    authDomain: process.env.FIREBASE_AUTH_DOMAIN,
    projectId: process.env.FIREBASE_PROJECT_ID,
    storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
    messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
    appId: process.env.FIREBASE_APP_ID,
    measurementId: process.env.FIREBASE_MEASUREMENT_ID
};

// Initialize Firebase
const app = firebase.initializeApp(firebaseConfig);
const database = firebase.database();

// OpenWeatherMap API key from environment variables
const apiKey = process.env.OPENWEATHERMAP_API_KEY;

// Load specific content based on sidebar selection
function loadContent(page) {
    const pageContent = document.getElementById('pageContent');
    const pageTitle = document.getElementById('pageTitle');

    switch(page) {
        case 'home':
            pageTitle.textContent = "Home";
            loadHomePage();
            break;
        case 'registeredVehicles':
            pageTitle.textContent = "Registered Vehicles";
            loadRegisteredVehicles();
            break;
        case 'paymentHistory':
            pageTitle.textContent = "Payment History";
            loadPayments();
            break;
        case 'complaints':
            pageTitle.textContent = "Complaints";
            loadComplaints();
            break;
        case 'emergencyServices':
            pageTitle.textContent = "Emergency Services";
            loadEmergencyServices();
            break;
        case 'tollManagement':
            pageTitle.textContent = "Toll Management";
            loadTollManagement();
            break;
        case 'userManagement':
            pageTitle.textContent = "User Management";
            loadUserManagement();
            break;
        case 'logout':
            window.location.href = 'web.html';
            break;
        default:
            pageTitle.textContent = "Welcome to EasyWay Admin Dashboard";
            pageContent.innerHTML = "Select an option from the sidebar to view details here.";
            break;
    }
}

// Example function to load payments data from Firebase
function loadPayments() {
    const pageContent = document.getElementById('pageContent');
    pageContent.innerHTML = `
        <table id="PaymentsTable" border="1" style="width: 100%; text-align: center;">
            <thead>
                <tr>
                    <th>User ID</th>
                    <th>Payment ID</th>
                    <th>Cost (RS)</th>
                    <th>Date & Time</th>
                    <th>Payment Method</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody id="PaymentsTableBody">
                <tr><td colspan="5">Loading...</td></tr>
            </tbody>
        </table>
    `;

    const paymentsRef = database.ref('payments');
    const PaymentsTableBody = document.getElementById('PaymentsTableBody');
    PaymentsTableBody.innerHTML = ''; // Clear loading message

    // Listen to payment data in real-time
    paymentsRef.on('value', snapshot => {
        const paymentsData = snapshot.val();
        PaymentsTableBody.innerHTML = ''; // Clear previous rows

        if (paymentsData) {
            Object.keys(paymentsData).forEach(userId => {
                const userPayments = paymentsData[userId];
                Object.keys(userPayments).forEach(paymentId => {
                    const payment = userPayments[paymentId];
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>${userId}</td>
                        <td>${paymentId}</td>
                        <td>${payment.cost || 'N/A'}</td>
                        <td>${payment.payment_date || 'N/A'}</td>
                        <td>${payment.payment_method || 'N/A'}</td>
                        <td>${payment.details || 'N/A'}</td>
                    `;
                    PaymentsTableBody.appendChild(row);
                });
            });
        } else {
            PaymentsTableBody.innerHTML = '<tr><td colspan="5">No payments found.</td></tr>';
        }
    }, error => {
        console.error("Error loading data:", error);
        PaymentsTableBody.innerHTML = '<tr><td colspan="5">Error loading data.</td></tr>';
    });
}

// Example function to load registered vehicles data
function loadRegisteredVehicles() {
    const pageContent = document.getElementById('pageContent');
    pageContent.innerHTML = `
        <table id="vehiclesTable" border="1" style="width: 100%; text-align: center;">
            <thead>
                <tr>
                    <th>Vehicle ID</th>
                    <th>Vehicle Type</th>
                    <th>Model</th>
                    <th>License Plate Number</th>
                    <th>Owner Name</th>
                </tr>
            </thead>
            <tbody id="vehiclesTableBody">
                <tr><td colspan="5">Loading...</td></tr>
            </tbody>
        </table>
    `;

    const vehiclesRef = database.ref('vehicle_registration');
    const vehiclesTableBody = document.getElementById('vehiclesTableBody');
    vehiclesTableBody.innerHTML = ''; // Clear loading message

    vehiclesRef.on('value', snapshot => {
        const vehicles = snapshot.val();
        vehiclesTableBody.innerHTML = ''; // Clear previous rows

        if (vehicles) {
            Object.keys(vehicles).forEach(vehicleId => {
                const vehicle = vehicles[vehicleId];
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${vehicleId}</td>
                    <td>${vehicle.vehicle_type || 'N/A'}</td>
                    <td>${vehicle.model || 'N/A'}</td>
                    <td>${vehicle.license_plate || 'N/A'}</td>
                    <td>${vehicle.owner_name || 'N/A'}</td>
                `;
                vehiclesTableBody.appendChild(row);
            });
        } else {
            vehiclesTableBody.innerHTML = '<tr><td colspan="5">No vehicles found.</td></tr>';
        }
    }, error => {
        console.error("Error loading data:", error);
        vehiclesTableBody.innerHTML = '<tr><td colspan="5">Error loading data.</td></tr>';
    });
}  

// Function to load the Home page with weather, date, and time
function loadHomePage() {
    const pageContent = document.getElementById('pageContent');
    pageContent.innerHTML = `
        <div class="home-page">
            <div class="weather-card">
                <h3>Current Weather</h3>
                <div id="weather">
                    <p>Loading weather data...</p>
                </div>
            </div>
            <div class="date-time">
                <h3>Current Date & Time</h3>
                <div id="dateTime">
                    <p id="date"></p>
                    <p id="time"></p>
                </div>
            </div>
        </div>
    `;
    loadWeather();
    displayDateTime();
}

// Function to load weather data
function loadWeather() {
    const weatherDiv = document.getElementById('weather');
    const url = `https://api.openweathermap.org/data/2.5/weather?q=Matara&appid=${apiKey}&units=metric`;

    fetch(url)
        .then(response => {
            if (!response.ok) {
                throw new Error(`Error: ${response.status} ${response.statusText}`);
            }
            return response.json();
        })
        .then(data => {
            if (data && data.main) {
                const { main, weather, name, sys } = data;
                weatherDiv.innerHTML = `
                    <p><strong>${name}, ${sys.country}</strong></p>
                    <p><img src="http://openweathermap.org/img/wn/${weather[0].icon}.png" alt="${weather[0].description}" /> ${weather[0].description}</p>
                    <p><strong>${main.temp}°C</strong> (Feels like ${main.feels_like}°C)</p>
                `;
            } else {
                weatherDiv.innerHTML = "<p>No weather data available.</p>";
            }
        })
        .catch(error => {
            console.error('Fetch error:', error);
            weatherDiv.innerHTML = "<p>Unable to fetch weather data.</p>";
        });
}

// Function to display the current date and time
function displayDateTime() {
    const dateElement = document.getElementById('date');
    const timeElement = document.getElementById('time');

    function updateDateTime() {
        const now = new Date();
        dateElement.textContent = `Date: ${now.toLocaleDateString()}`;
        timeElement.textContent = `Time: ${now.toLocaleTimeString()}`;
    }

    updateDateTime();
    setInterval(updateDateTime, 1000); // Update time every second
}
