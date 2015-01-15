define(["jquery", "api", "search","date", "knockout","mapping","datatables", "knockout-bindings","goog!visualization,1,packages:[corechart]"], function($, api, search, date, ko,komap) {
    
    "use strict";
    
   
    
   var dashboardModel;
   var table;
   var model ;
  

    function getDashboardData(callback) {
        var start_date = new Date().getFullYear() + "-01-01";
        var end_date   = new Date().getFullYear() + "-12-31";
        api.getActivityStats(start_date,end_date,"month").done(function(data) {
       // console.log(data);
            callback(data);
        }).error(function(data){
          if(data.status == '401'){          
           alert(data.responseText);
           
          }
        })
    }
    
    
    function drawChart(activities,year,divElement) {

          var data = google.visualization.arrayToDataTable([
            ['Month', 'Calories Consumed', 'Calories Burned'],
            ['Jan',  activities[1] ? activities[1].calories_consumed : 0,      activities[1] ? activities[1].calories_burnt : 0],
            ['Feb',  activities[2] ? activities[2].calories_consumed : 0,      activities[2] ? activities[2].calories_burnt : 0],
            ['Mar',  activities[3] ? activities[3].calories_consumed : 0,      activities[3] ? activities[3].calories_burnt : 0],
            ['Apr',  activities[4] ? activities[4].calories_consumed : 0,      activities[4] ? activities[4].calories_burnt : 0],
            ['May',  activities[5] ? activities[5].calories_consumed : 0,      activities[5] ? activities[5].calories_burnt : 0],
            ['Jun',  activities[6] ? activities[6].calories_consumed : 0,      activities[6] ? activities[6].calories_burnt : 0],
            ['Jul',  activities[7] ? activities[7].calories_consumed : 0,      activities[7] ? activities[7].calories_burnt : 0],
            ['Aug',  activities[8] ? activities[8].calories_consumed : 0,      activities[8] ? activities[8].calories_burnt : 0],
            ['Sep',  activities[9] ? activities[9].calories_consumed : 0,      activities[9] ? activities[9].calories_burnt : 0],
            ['Oct',  activities[10] ? activities[10].calories_consumed : 0,      activities[10] ? activities[10].calories_burnt : 0],
            ['Nov',  activities[11] ? activities[11].calories_consumed : 0,      activities[11] ? activities[11].calories_burnt : 0],
            ['Dec',  activities[12] ? activities[12].calories_consumed : 0,      activities[12] ? activities[12].calories_burnt : 0]           
          ]);

          
          var options = {
            legend: {textStyle: {fontName: 'Oswald',fontSize: 14, bold: true}},
            series: { 0: { textStyle: {fontName: 'Oswald',fontSize: 14, bold: true}}, 1: { textStyle: {fontName: 'Oswald',fontSize: 14, bold: true}}},
            title: 'Activities for year '+ year ,          
            titleTextStyle: {color: 'red',fontName: 'Oswald',fontSize: 14, italic: false, bold: true},
            hAxis: {title: 'Month', titleTextStyle: {color: 'red',fontName: 'Oswald',fontSize: 14, italic: false, bold: true}},
            vAxis: {title: 'Calories', titleTextStyle: {color: 'red',fontName: 'Oswald',fontSize: 14, italic: false,bold: true}},
            toolTip: {titleTextStyle: {color: 'red',fontName: 'Oswald',fontSize: 14, bold: true}}
            
          };

          var chart = new google.visualization.ColumnChart(document.getElementById(divElement));

          chart.draw(data, options);

        }

    
   
     $(function()  {
     
     

     // knockout view model
           
            
                
             function ViewModel(data) {
                var self = this;
               
                komap.fromJS(data, {}, self);
                
            }    
            
            // get data - sample data from Donors Choose API
            getDashboardData(function (result) {

                // bind the data
                

                var stats = result.data.stats;
                var agg_distance =0;
                var agg_steps = 0;
                var agg_calories = 0;
                
                var dact=[];
                for(var j=0; j< stats.length; j++){
                    dact[stats[j]._id.month] = new Object();
                    dact[stats[j]._id.month].calories_consumed = stats[j].calories_consumed;  
                    dact[stats[j]._id.month].calories_burnt = stats[j].calories_burnt;
                    
                    agg_distance += stats[j].distance ? stats[j].distance : 0;
                    agg_calories += stats[j].calories_burnt ? stats[j].calories_burnt : 0;
                    agg_steps    += stats[j].steps ? stats[j].steps : 0;
                }            
                
                var adata = new Object();
                adata.agg_distance = agg_distance;
                adata.agg_calories = agg_calories;
                adata.agg_steps    = agg_steps;
                
                model = new ViewModel(adata);
                ko.applyBindings(model, document.getElementById("agg_data"));
                
                drawChart(dact,new Date().getFullYear(),"activity_chart");
             });
             
             
            
      return {
           getDashboardData: getDashboardData
         };
   });
});