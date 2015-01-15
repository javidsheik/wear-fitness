define(["config"], function(config) {

    "use strict";   
     
    function getCookie(cname) {
        var name = cname + "=";
      
        var ca = document.cookie.split(';');
        for(var i=0; i<ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0)==' ') c = c.substring(1);
            if (c.indexOf(name) != -1) return c.substring(name.length,c.length);
        }
        return "";
    } 


    function getToken(){
     return getCookie('token');
    }
    
    function getUser(){
     return getCookie('user_id').substring(4);
    }
    
    
    function searchFoods(input) {
        return $.ajax(config.api + "/foods/search/" + encodeURIComponent(input) + "?token=" + getToken());
    }
    
    function getFood(id) {
        return $.ajax(config.api +"/food/id/" + id);
    }
    
    function addFood(food) {     
        food.token = getToken();
        console.log(food);        return $.ajax(config.api + "/foods/create" , {
                    data: JSON.stringify(food),
                    contentType: "application/json",
                    type: "POST"
                });
    }
    
    
    function editFood(food) {
        return addFood(food); // These have been combined with the node server api
    }
    
    
    function getGoal() {
        return $.ajax(config.api + "/goals" + "?token=" + getToken() +"&user_id=" + getUser());
    }    
    
    function getActivities(activity_date,page,pageSize) {
        return $.ajax(config.api +  "/activities" + "?token=" + getToken() +"&user_id=" + getUser() +  (activity_date ? ("&start_date=" + activity_date) : "")  + (page ? ("&page=" + page) : "") + (pageSize ? ("&pageSize=" + pageSize) : "") );
    }  
    
    function getActivityStats(start_date,end_date,group_by,page,pageSize) {
        return $.ajax(config.api + "/activities/stats" + "?token=" + getToken() + "&user_id=" + getUser() + 
                (group_by ? ("&group_by=" + group_by) : "") + 
                (start_date ? ("&start_date=" + start_date) : "")  +
                (end_date ? ("&end_date=" + end_date) : "")  +        
                (page ? ("&page=" + page) : "") + (pageSize ? ("&pageSize=" + pageSize) : "") );
    }  
    
    
    function getCircles(page,pageSize) {
        return $.getJSON(config.api +  "/circles/detail_list" + "?token=" + getToken() +"&user_id=" + getUser() + (page ? ("&page=" + page) : "") + (pageSize ? ("&pageSize=" + pageSize) : "") );
    }  
    
    function saveGoal(goal) {

    goal.token = getToken();
     
        return $.ajax(config.api +  "/goals/create", {        
                    data: JSON.stringify(goal),
                    contentType: "application/json",
                    type: "POST"
                });
    }
        
    return { 
        searchFoods: searchFoods,
        getFood: getFood,
        addFood: addFood,
        editFood: editFood,
        getGoal: getGoal,
        saveGoal: saveGoal,
        getActivityList: getActivities,
        getCircleList: getCircles,
        getActivityStats:getActivityStats
    };
});