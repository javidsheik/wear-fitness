var fs = require('fs');
var config = require('../config/config');
var utils = require(config.root + '/app/helper/utils');
var crypto = require('crypto');
var request = require('request');

var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var CreateUpdatedAt = require('mongoose-timestamp');


var FriendSchema = new Schema({
    email: {
      type: String,
      required: true
    },
	referred_by :	
	  {
      type : Schema.ObjectId,
      ref : 'User'
    },
	user_id: 
	{
      type : Schema.ObjectId,
      ref : 'User'
    },
    status_flag:
   {
    type: String
   }   
});

FriendSchema.plugin(CreateUpdatedAt);

FriendSchema.statics = {
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

module.exports = mongoose.model('Friend', FriendSchema)
