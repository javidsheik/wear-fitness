var fs = require('fs');
var config = require('../config/config');
var utils = require(config.root + '/app/helper/utils');
var crypto = require('crypto');
var request = require('request');

var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var CreateUpdatedAt = require('mongoose-timestamp');


var FoodSchema = new Schema({
    name: {
      type: String,
	  required: true,
      index : {
        unique: true
      }
    },	        
    calories    : Number,
    fat         : Number,
	saturatedFat: Number,
    transFat    : Number,
    cholesterol : Number,
    sodium      : Number,
    carb        : Number,
    fiber       : Number,
    sugars      : Number,
    protein     : Number,
    servingSize : Number,
    servingSizeUnits     : { type: String},
    servingSizeAlt       : Number,
    servingSizeAltUnits  : { type: String},
    servingsPerContainer : Number,
    caloriesFromFat      : Number
    
});

FoodSchema.plugin(CreateUpdatedAt);


FoodSchema.statics = {
  /**
   * Find food by id
   *
   * @param {ObjectId} id
   * @param {Function} cb
   * @api private
   */

  load: function (id, cb) {
    this.findOne({ _id : id }).exec(cb)
  },
  
  /** Search Foods **/
  
  search : function(input) {
      this.find({ "name": new RegExp(input, "i") }).limit(10);
  },

  /**
   * List Foods
   *
   * @param {Object} options
   * @param {Function} cb
   * @api private
   */

  list: function (options, cb) {
    var criteria = options.criteria || {}

    this.find(criteria)
      .sort({'createdAt': -1}) // sort by date
      .limit(options.perPage)
      .skip(options.perPage * options.page)
      .exec(cb)
  }
}

module.exports = mongoose.model('Food', FoodSchema)
