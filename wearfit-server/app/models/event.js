var fs = require('fs');
var config = require('../config/config');
var utils = require(config.root + '/app/helper/utils');
var crypto = require('crypto');
var request = require('request');

var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var CreateUpdatedAt = require('mongoose-timestamp');



var EventSchema = new Schema({
    name: {
      type: String,
      required: true,
      index : {
        unique: true
      }
    },
	user_id: 
	  {
      type : Schema.ObjectId,
      ref : 'User'
    },
	description: {
      type: String
    },
	start_longitude: {
      type: Number
    },
	start_latitude: {
      type: Number
    },
	end_longitude: {
      type: Number
    },
	end_latitude: {
      type: Number
    },
	event_date: Date,
	start_time:  { type: Number, min: 0, max: 12 },
	end_time:    { type: Number, min: 0, max: 12 },
    start_time_unit:
    {
	type: String,
	enum: ['AM', 'PM']
	},
	end_time_unit:
	{
	type: String,
	enum: ['AM', 'PM']
	}
	
});

EventSchema.plugin(CreateUpdatedAt);

var validatePresenceOf = function (value) {
   return value && value.length
}

var validatePresenceOfNumber = function (value) {
   return value && value >= 0
}

EventSchema.pre('save', function(next) {

   if(!(validatePresenceOf(this.start_time_unit) && validatePresenceOf(this.end_time_unit) ))
   	 next(new Error('Start Time, End Time cannot be blank'))  
   else if(!(validatePresenceOfNumber(this.start_longitude) && validatePresenceOfNumber(this.end_longitude) ))
	 next(new Error('Longitudes cannot be blank'))  
   else if(! (validatePresenceOfNumber(this.start_latitude) && validatePresenceOfNumber(this.end_latitude)	))
	 next(new Error('Latitudes cannot be blank'))  
   else
     next()
})

EventSchema.statics = {
  /**
   * Find article by id
   *
   * @param {ObjectId} id
   * @param {Function} cb
   * @api private
   */

  load: function (id, cb) {
    this.findOne({ _id : id }).exec(cb)
  },

  /**
   * List circles
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

module.exports = mongoose.model('Event', EventSchema)
