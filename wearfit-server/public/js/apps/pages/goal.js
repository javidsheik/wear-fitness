define(["jquery", "api",  "knockout","mapping", "knockout-bindings"], function($, api, ko,komap) {
    
    "use strict";
    
    
    var goal = null;
    var blankGoal = { 
            daily_steps: "",
			daily_distance: "",
            daily_calories: "",
            daily_percent: ""
            
        };

    function setCurrentGoal(newGoal) {
        goal = $.extend({}, blankGoal, newGoal); // Ensure it has all the right properties
    }
    
    function getCurrentGoal(){
         return goal;
    }
    
    function getServiceGoal(callback) {
        api.getGoal().done(function(data) {

            goal = data.data[0];
            callback(goal);
        });
    }
    
    function saveGoal(goal) {
    
    
        api.saveGoal(goal).done(function(data) {
        
                alert(data.data.message);
                goal = null;
            });        
    }
    
    
    $(function() {      
    
    
    
    getServiceGoal(function(goal){
    
        var GoalModel = function(data){
        
            var self = this;
            this.save;
            
            komap.fromJS(data,{},self);
        }
        
            setCurrentGoal(goal);
            
            var model = new GoalModel(getCurrentGoal());
           
            
            model.save = function(){
                saveGoal(komap.toJS(model));
            }        
            
            ko.applyBindings(model, document.getElementById("goalForm"));
        
        });
       
    });
    
    return {
        setCurrentGoal: setCurrentGoal,
        getCurrentGoal: getCurrentGoal,
        getServiceGoal: getServiceGoal
    };
});
