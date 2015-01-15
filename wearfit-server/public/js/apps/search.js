 define(["api", "jquery", "../libs/bootstrap"], function(api, $) {
    "use strict";
 
    var nameToFoodMap,
        selected,
        foodSelectedCallback;
 
    function search(query, process) {
        // Call the API
        api.searchFoods(query).done(function(results) {
            var foods = [],
                i,
                food;
            // Map names back to ids for later.
            //console.log(results.data.foods);
            results = results.data.foods;
            nameToFoodMap = {};
            for (i = 0; i < results.length; i++) {
                food = results[i];
                nameToFoodMap[food.name] = food;
                
                // Add the name to the list for the drop down.
                foods.push(food.name);
            }
            
            // Show the list
            process(foods);
        });
    }
    
    function updater(item) {
        selected = null;
        if (!nameToFoodMap || !nameToFoodMap[item])
            return null;
            
        selected = nameToFoodMap[item];
        if (foodSelectedCallback)
            foodSelectedCallback(selected);
        return item;
    }
    
    function getSelectedFood() {
        return selected;
    }
    
    function onFoodSelected(callback) {
        foodSelectedCallback = callback;
    }
 
    $(function() {
        $("#search").typeahead({
            source: search,
            updater: updater
        });
    });
    
    return {
        getSelectedFood: getSelectedFood,
        onFoodSelected: onFoodSelected
    };
    
 });