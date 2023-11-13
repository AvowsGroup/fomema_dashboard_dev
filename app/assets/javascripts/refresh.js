// Function to perform a hard refresh
function hardRefresh() {
    location.reload(true); // Pass true to perform a hard refresh
}

// testing
// Set up a click event listener for the refresh button
document.getElementById('refreshButton').addEventListener('click', function () {
    // Clear existing intervals to prevent multiple timers
    clearInterval(window.refreshInterval);

    // Set up a timer to call the hardRefresh function every 5 seconds
    window.refreshInterval = setInterval(hardRefresh, 5000);  // 5000 milliseconds = 5 seconds

    // Perform a hard refresh after the initial 5 seconds
    setTimeout(hardRefresh, 5000); // 5000 milliseconds = 5 seconds
});

// Perform the first refresh after 5 seconds
setTimeout(hardRefresh, 5000); // 5000 milliseconds = 5 seconds
// testing

// Set up a click event listener for the 5-minute refresh button
document.getElementById('refreshButton5').addEventListener('click', function () {

    // Clear existing intervals to prevent multiple timers
    clearInterval(window.refreshInterval);

    // Set up a timer to call the hardRefresh function every 5 minutes
    window.refreshInterval = setInterval(hardRefresh, 300000); // 300000 milliseconds = 5 minutes

    // Perform a hard refresh after the initial 5 minutes
    setTimeout(hardRefresh, 300000); // 300000 milliseconds = 5 minutes
});

// Perform the first refresh after 5 Minutes
setTimeout(hardRefresh, 300000);


// Set up a click event listener for the 10-minute refresh button
document.getElementById('refreshButton10').addEventListener('click', function () {
    // Set up a timer to call the hardRefresh function every 10 minutes
    setInterval(hardRefresh, 600000); // 600000 milliseconds = 10 minutes

    // Perform a hard refresh after the initial 10 minutes
    window.refreshInterval = setTimeout(hardRefresh, 600000); // 600000 milliseconds = 10 minutes
});

// Perform the first refresh after 10 Minutes
setTimeout(hardRefresh, 600000);
