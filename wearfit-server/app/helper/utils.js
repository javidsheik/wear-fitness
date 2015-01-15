var jwt      = require('jwt-simple');
var moment   = require('moment');
var mongoose = require('mongoose');


exports.randomString = function (length) {
  var chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHUJKLMNOPQRSTUVWXYZ';
  var result = '';
  for (var i = length; i > 0; --i) result += chars[Math.round(Math.random() * (chars.length - 1))];
  return result;
}

exports.prettyJSON = function(data) {
  return require("prettyjson").render(data);
}

exports.responses = function(res, status, obj) {
  var resultPrint     = {}
  if (status == 200) {
    resultPrint.data = obj
  } else {
    resultPrint     = obj
  }
  resultPrint.id      = require('node-uuid').v4()
  resultPrint.status  = status

  return res.status(status).json(resultPrint )
}


exports.activityTypes = function(type){

 var activity_types = [];
              
              activity_types.push('Walking');
              activity_types.push('Running');
              activity_types.push('Cycling');
              activity_types.push('Tennis');
              activity_types.push('Basketball');
              activity_types.push('Shopping');
              activity_types.push('Soccer');
              activity_types.push('Swimming');
              activity_types.push('Trekking');                        
              activity_types.push('Yoga');
              activity_types.push('Zumba');
              activity_types.push('Salsa');
              activity_types.push('Ballet');
              activity_types.push('Swing');
              activity_types.push('Ball room dancing');
              activity_types.push('Belly Dancing');
              activity_types.push('Tap Dance');
              activity_types.push('Folk');
              activity_types.push('Western Dance');
              activity_types.push('Aerobics');
              activity_types.push('Gym');              
              
    return activity_types;          

}
exports.danceTracking = function(activity,weight,weight_unit){

 var activity_type   = activity.track_type;
 var start_time      = activity.start_time;
 var start_time_unit = activity.start_time_unit;
 var end_time        = activity.end_time;
 var end_time_unit   = activity.end_time_unit;
 var intensity       = activity.intensity;
 
 var calories= 0;
 
  if(activity.track_type == 'Activity'){
  
      if(activity.activity_type == 'Zumba'){
      
      var weight = weight;
      var minutes = end_time-start_time;
      var low_met = 6.5;
      var med_met = 7.5;
      var high_met = 8.5;
      
      var met=0;
      
     if(intensity == 'Low')
         met = low_met;
     else  if(intensity == 'Medium')
         met = med_met;
     else  if(intensity == 'High')
         met = high_met;
         
          if (weight_unit == 'lbs'){
              calories = Math.round(met * 3.5 * (weight*0.45359237) / 200 * minutes);
          }else if (weight_unit == 'kgs'){
              calories = Math.round(met * 3.5 * (weight) / 200 * minutes);
          }
      }
      
      else if(activity.activity_type == 'Salsa'){
      }
      else if(activity.activity_type == 'Ballet'){
      }
      else if(activity.activity_type == 'Swing'){
      }
      else if(activity.activity_type == 'Ball room dancing'){
      }
      else if(activity.activity_type == 'Belly Dancing'){
      }
      else if(activity.activity_type == 'Tap Dance'){
      }
      else if(activity.activity_type == 'Folk'){
      }
      else if(activity.activity_type == 'Western Dance'){
      }
      else if(activity.activity_type == 'Aerobics'){
      }
      else if(activity.activity_type == 'Hip Hop'){
      }
      
      return calories;
   }
}

