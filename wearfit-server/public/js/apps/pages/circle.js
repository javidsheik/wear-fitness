define(["jquery", "api", "search","date", "knockout","mapping","datatables", "knockout-bindings","goog!visualization,1,packages:[corechart]"], function($, api, search, date, ko,komap) {
    
    "use strict";
    
   
    
   var circleModel;
   var table;
   var model ;
  

    function getCircleList(callback) {
        api.getCircleList().done(function(data) {
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

    
    function formatFriends ( friends ) {
    // `d` is the original data object for the row
    var html = '<div  style="height:350px;overflow: scroll">';
    
    var row= '';
    
    for(var i=0; i < friends.length; i++) {
        row += '<div>'+
        '<div><img width="64" height="64" class="img-circle" src="' + friends[i].profile_picture + '"><img>&nbsp;'+
             friends[i].first_name + ' ' + friends[i].last_name +  '</div>'+
            '<div> <div id= "chart_' + friends[i]._id + '"/></div>'+
        '</div>';
        
        
        
      }
      html +=  (row + '</div>');
    
    return html;
    
    }
    
   
     $(function()  {
     
     

     // knockout view model
           
            
            var mappingOptions = {
                    'circles': {
                 
                        // overriding the default creation / initialization code
                        create: function (options) {
                 
                            return (new (function () {
                 
                                // setup the computed binding
                                this.computedURL = ko.computed(function () {
                                    return 'friends/'+ this.circle._id();
                                }, this);
                 
                                this.friendsTotal = ko.computed(function () {
                                    return this.circle.friends().length;
                                }, this);
                               
                                
                                komap.fromJS(options.data, {}, this);
                            })());
                        }
                    }
                };
                
             function ViewModel(data) {
                var self = this;
                
               
                komap.fromJS(data, mappingOptions, self);
                
            }    
            
            // get data - sample data from Donors Choose API
            getCircleList(function (result) {

                // bind the data
                model = new ViewModel(result.data);
                ko.applyBindings(model);

                // apply DataTables magic
               table = $("#circleList").DataTable({
                    responsive: true                
                });
             });
             
             
             $('#circleList tbody').on('click', 'td.details-control', function () {
                    var tr = $(this).closest('tr');
                    var row = table.row( tr );
             
                    if ( row.child.isShown() ) {
                        // This row is already open - close it
                        row.child.hide();
                        tr.removeClass('shown');
                    }
                    else {
                        // Open this row
                        
                        var plainJs = ko.toJS(model); 
                        var friends = plainJs.circles[row.index()].users;                        
                        
                        row.child( formatFriends(friends) ).show();
                        
                        for(var i=0; i < friends.length; i++) {
                         var chartName = "chart_"+ friends[i]._id;
                         var dact = [];
        
                            for(var j=0; j< friends[i].activities.length; j++){
                               dact[friends[i].activities[j]._id.month] = new Object();
                               dact[friends[i].activities[j]._id.month].calories_consumed = friends[i].activities[j].calories_consumed;  
                               dact[friends[i].activities[j]._id.month].calories_burnt = friends[i].activities[j].calories_burnt;
                              }            
                        drawChart(dact,new Date().getFullYear(),chartName);
                       }
                       
                       
                        tr.addClass('shown');
                    }
                } );
            
      return {
           getCircleList: getCircleList
         };
   });
});