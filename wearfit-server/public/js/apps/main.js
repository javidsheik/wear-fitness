requirejs.config({
    paths: {
        jquery: "../libs/jquery-1.10.0.min",     
        knockout: "../libs/knockout-min",
        mapping: "../libs/knockout.mapping" ,       
        async: "../libs/async",
        goog: "../libs/goog",
        propertyParser : "../libs/propertyParser",        
        datatables: '//cdn.datatables.net/1.10-dev/js/jquery.dataTables',
        bootDataTable: "https://cdn.datatables.net/plug-ins/a5734b29083/integration/bootstrap/3/dataTables.bootstrap.js",
        responsiveDataTable: "https://cdn.datatables.net/responsive/1.0.1/js/dataTables.responsive"
    },
    shim: {
        jquery: {
            exports: "jQuery"
        },
        bootstrap: {
            deps: ["jquery"]
        } ,
        deps: ['knockout', 'mapping'],
        callback: function (ko, mapping) {
            ko.mapping = mapping;
        }
        
    }
});

define("jquery", function() {
    return window.jQuery;
});

define("bootstrap", function() {
    // Doesn't export anything, already on the page.
});



