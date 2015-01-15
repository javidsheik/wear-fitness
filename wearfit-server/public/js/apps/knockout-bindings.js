define(["jquery", "../libs/knockout"], function($, ko) {
    ko.bindingHandlers.dropdown = {
        init: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
            var propertyName = valueAccessor();
            $(element).find("li a").click(function() {
                var selection = $(this).text();
                $(element).find(".selection").text(selection);
                viewModel[propertyName] = selection;
            });
        },
        update: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
            var propertyName = valueAccessor();
            var value = viewModel[propertyName];
            $(element).find(".selection").text(value);
        }
    }
});
