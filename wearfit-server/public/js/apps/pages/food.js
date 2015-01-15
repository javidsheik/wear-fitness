define(["jquery", "api", "search", "knockout", "knockout-bindings"], function($, api, search, ko) {
    
    "use strict";

    var food = null;
    var blankFood = { 
            type: "food",
            name: "",
            calories: "",
            fat: "",
            saturatedFat: "",
            transFat: "",
            cholesterol: "",
            sodium: "",
            carb: "",
            fiber: "",
            sugars: "",
            protein: "",
            vitamina: "",
            vitaminc: "",
            calcium: "",
            iron: "",
            servingSize: "",
            servingSizeUnits: "gms",
            servingSizeAlt: "",
            servingSizeAltUnits: "cup",
            servingsPerContainer: "",
            caloriesFromFat: ""
        };

    function setCurrentFood(newFood) {
        food =  $.extend({}, blankFood, newFood); // Ensure it has all the right properties
    }
    
    function getCurrentFood() {
        return food;
    }
    
    function viewFood() {
    
        var food = search.getSelectedFood();
        if (!food)
            return;
        
        setCurrentFood(food);
        ko.applyBindings(food, document.getElementById("showFood"));
        $("#showFood").modal("show");
         console.log("---------------------------------"+food.name);   
    }
    
    function editFood() {
        var food = search.getSelectedFood();
        if (!food)
            return;

        ko.applyBindings(setCurrentFood(food), document.getElementById("editFood"));
        $("#editFood").modal("show");
    }
    
    function saveEditFood() {
        // In theory knockoutjs should have set the food's properties by now.
        api.editFood(food).done(function() {
            $("#editFood").modal("hide");
            food = null;
        });
    }
    
    function addFood() {
        food = $.extend({}, blankFood);
            ko.applyBindings(food, document.getElementById("editFood"));
        $("#editFood").modal("show");
    }
    
    function saveNewFood() {
        // In theory knockoutjs should have set properties by now.
        api.addFood(food).done(function(data) {
            alert(data.data.message);
            $("#editFood").modal("hide");
            food = null;
        });
    }
    
    function saveFood() {
        if (food && food._id) {
            saveEditFood();
        } else {
            saveNewFood();
        }
    }
    
    $(function() {
        $("#add").click(addFood);
        $("#viewFoodButton").click(viewFood);
        $("#editFoodButton").click(editFood);
        $("#addFoodButton").click(addFood);
        $("#editFoodSave").click(saveFood);
    });
    
    return {
        setCurrentFood: setCurrentFood,
        getCurrentFood: getCurrentFood
    };
});
