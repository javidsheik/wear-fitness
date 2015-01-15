define(["jquery"], function($) {

    "use strict";

    // Private variables
    var date,
        today,
        changedCallback;
    
    // Return the date in m/d/yyyy format
    function prettyDate() {
        return (date.getFullYear()) + "-" + (date.getMonth() + 1) + "-" +  date.getDate();
    }

    // Update the displayed date
    function showDate() {
        $('#date').text(prettyDate(date));
    }
    
    // Assign a callback for the date changed event.
    function dateChanged(callback) {
        changedCallback = callback;
    }
    
    // Trigger the callback
    function triggerEvent() {
        if (typeof changedCallback == "function")
            changedCallback(prettyDate());
    }
   
    // Move one day into the future
    function nextDate() {
        date.setDate(date.getDate() + 1);
        showDate();
        triggerEvent();
    }

    // Move one day into the past
    function prevDate() {
        date.setDate(date.getDate() - 1);
        showDate();
        triggerEvent();
    }
    
    // Set the date to today
    function resetDate() {
        date = today = new Date();
        showDate();
        triggerEvent();
    }
    
    // Initialize and setup event handlers
    $(function() {
        resetDate();
        
        $("#date").click(resetDate);
        $("#nextDate").click(nextDate);
        $("#prevDate").click(prevDate);
    });
    
    // return public functions
    return {
        prettyDate: prettyDate,
        dateChanged: dateChanged
    };
});