define(["log", "goog!visualization,1,packages:[corechart]"], function(log) {

    "use strict";
    
    function drawChart() {
        var totals = log.getTotals();
        totals.fatCals = totals.fat * 9;
        totals.carbCals = totals.carb * 4;
        totals.proteinCals = totals.protein * 4;
        totals.otherCals = Math.max(0, totals.calories - totals.fatCals - totals.carbCals - totals.proteinCals);
    
        var data = new google.visualization.DataTable();
        data.addColumn("string", "macro");
        data.addColumn("number", "grams");
        data.addRows([
            ["Fat", totals.fatCals],
            ["Carbs", totals.carbCals],
            ["Protein", totals.proteinCals],
            ["Other", totals.otherCals]
        ]);
        
        var options = {
            title: "Calories from...",
            width: 400,
            height: 300
        };
        
        var chart = new google.visualization.PieChart(document.getElementById("chart"));
        chart.draw(data, options); 
    }
    
    $(function() {
        drawChart();
        log.logChanged(drawChart);
    });
});