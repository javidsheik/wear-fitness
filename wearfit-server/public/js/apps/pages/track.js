define(["jquery", "api", "search","date", "knockout","mapping","datatables", "knockout-bindings"], function($, api, search, date, ko,komap) {
    
    "use strict";
    
    var activityModel;
    
    function getActivityList(activity_date,callback) {
        api.getActivityList(activity_date).done(function(data) {
            callback(data);
        });
    }
    
   
        $(function()  {
        
         function ActivitiesViewModel(data) {
           var self = this;
           komap.fromJS(data,{},self);
        }
                       
           
        
           
            getActivityList(date.prettyDate(),function(list){
                
                     
                       activityModel = new ActivitiesViewModel(list.data);
                        
                        ko.applyBindings(activityModel); 
                        
                           $("#activityList").DataTable({
                                responsive: true                
                            });             
                          
                       
                    });
                    
                    
            date.dateChanged(function(list){
                getActivityList(date.prettyDate(),function(list) {
                    komap.fromJS(list.data, activityModel);
                    });
                });    
             
      return {
       
        getActivityList: getActivityList
    };
    
   });
});