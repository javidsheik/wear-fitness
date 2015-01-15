var fs = require('fs');
var config = require('../config/config');
var utils = require(config.root + '/app/helper/utils');
var crypto = require('crypto');
var request = require('request');

var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var CreateUpdatedAt = require('mongoose-timestamp');


var ActivitySchema = new Schema({
    track_type: {
      type: String,
      required: true,
      enum: ['Activity', 'Food', 'Event','Water','Weight']
    },
	activity_date: Date,
	description: {
      type: String
    },
    user_id: 
	  {
      type : Schema.ObjectId,
      ref : 'User'
    },
    food_id: 
	  {
      type : Schema.ObjectId,
      ref : 'Food'
    },
    event_id: 
	  {
      type : Schema.ObjectId,
      ref : 'Event'
    },
	event_status: String,
	event_comments: String,
	unit : { type: String  },
	consumed_value : Number,
    consumed_time: { type: Number, min: 0, max: 12 },
	consumed_time_unit:
    {
	type: String,
	enum: ['AM', 'PM']
	},
	activity_type : {
	   type: String
	},
	calories_burnt: Number,
	calories_consumed: Number,
	activity_start_time:  { type: Number, min: 0, max: 12 },
	activity_end_time:    { type: Number, min: 0, max: 12 },
    activity_start_time_unit:
    {
	type: String,
	enum: ['AM', 'PM']
	},
	activity_end_time_unit:
	{
	type: String,
	enum: ['AM', 'PM']
	},
	distance: Number,
    steps : Number,
	intensity: String
});

ActivitySchema.plugin(CreateUpdatedAt);


var validatePresenceOf = function (value) {
   return value && value.length
}

var validatePresenceOfNumber = function (value) {
   return value && value >= 0
}



ActivitySchema.pre('save', function(next) {

   if (this.track_type == 'Activity'
     && !(validatePresenceOfNumber(this.calories_burnt) && validatePresenceOfNumber(this.activity_start_time) && validatePresenceOfNumber(this.activity_end_time) &&
	 validatePresenceOf(this.activity_start_time_unit) && validatePresenceOf(this.activity_end_time_unit)) )
	 next(new Error('Calories Burnt, Activity Start , Activity End cannot be blank'))
  else if (this.track_type == 'Food'
     && !(validatePresenceOfNumber(this.food_id) && validatePresenceOf(this.unit) || validatePresenceOfNumber(this.consumed_value) ))
	 next(new Error('Unit & Value cannot be blank'))
  else if ( this.track_type == 'Water' 
     && !( validatePresenceOf(this.unit) && validatePresenceOfNumber(this.consumed_value)))
	 next(new Error('Unit & Value cannot be blank'))
  else if (this.track_type == 'Weight'
     &&  !(validatePresenceOf(this.unit)  && validatePresenceOfNumber(this.consumed_value)) )
	 next(new Error('Unit & Value cannot be blank'))
  else if (this.track_type == 'Event' 
     && !(validatePresenceOf(this.event_status)))
     next(new Error('Event and Status cannot be blank'))
  else
    next()
})

ActivitySchema.statics = {
 
  /**
   * List Activity
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

module.exports = mongoose.model('Activity', ActivitySchema)

