var fs = require('fs');
var config = require('../config/config');
var utils = require(config.root + '/app/helper/utils');
var crypto = require('crypto');
var request = require('request');
//var relationship = require("mongoose-relationship");

var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var CreateUpdatedAt = require('mongoose-timestamp');


var CircleSchema = new Schema({
    name: {
      type: String,
      required: true
    },
	user_id: 
	  {
      type : Schema.ObjectId,
      ref : 'User'
    },
	description: {
      type: String
    },
    friends: [
	  {
      type : Schema.ObjectId,
      ref : 'Friend'
      }
	],
    tags: [
      {
        type: String
      }
    ],    
    is_active: {
      type: Boolean,
      default: true
    },
	//user_id:        { type:Schema.ObjectId, ref:"User", childPath:"user_id" },
	friends:        [
		{ 
		type:Schema.ObjectId, 
		ref:"Friend", 
		}
	]
});

CircleSchema.index ({ name: 1, user_id: 1 }, {unique: true})

CircleSchema.plugin(CreateUpdatedAt);
//CircleSchema.plugin(relationship, { relationshipPathName:'user_id' });
//CircleSchema.plugin(relationship, { relationshipPathName:'friends' });

/**
 * Validations
 */

var validatePresenceOf = function (value) {
  return value && value.length
}





CircleSchema.statics = {
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

module.exports = mongoose.model('Circle', CircleSchema)