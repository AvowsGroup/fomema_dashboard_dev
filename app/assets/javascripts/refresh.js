var count = 0;

function setReloadInterval(interval) {
    clearInterval(myInterval); // Clear any previously set intervals
    myInterval = setInterval(function () {
        count++; // Increment the count
        console.log("Count: " + count); // Display count in the console
        window.location.reload(); // Refresh the page
    }, interval * 1000); // Convert seconds to milliseconds
}

var myInterval; // Declare a variable to store the interval