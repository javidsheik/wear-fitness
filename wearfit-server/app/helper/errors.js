"use strict";

var error_results = {};

/**
 * Formats mongoose errors into proper array
 *
 * @param {Array} errors
 * @return {Array}
 * @api public
 */

exports.proper = function (res,errors) {
  var keys = Object.keys(errors)
  var errs = ''; 

  // if there is no validation error, just display a generic error
  if (!keys) {
    return ['Oops! There was an error']
  }

  keys.forEach(function (key) {
    errs += errors[key].msg;
  })

  return errs
}



exports.custom = function (res,error) {

}