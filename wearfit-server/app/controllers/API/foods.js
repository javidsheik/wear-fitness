var mongoose = require('mongoose');
var Food   = mongoose.model('Food');
var User     = mongoose.model('User');
var Schema = mongoose.Schema;

var AccessToken     = mongoose.model('AccessToken');
var config   = require('../../config/config');
var utils    = require(config.root + '/app/helper/utils');
var token_utils    = require(config.root + '/app/helper/token_utils');
var async    = require('async');
var jwt      = require('jwt-simple');
var moment      = require('moment');
var async = require('async');

var utility = require('utility');
var crypto = require('crypto');
var errorHelper = require(config.root + '/app/helper/errors');
var Mailer   = require(config.root + '/app/helper/mailer');


exports.details = function( req, res, next) {


  var token   = req.query.token;
  var _id     = req.params.id;
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  
			  var condition = { _id : _id}
			  
			   
			  Food
				.where(condition)
				.sort({createdAt: -1})
				.exec(function(err, foods) {

				  if(err) return utils.responses(res, 500, err)

				  Food.count(condition, function (err, count) {

					if (err) return errorHelper.mongoose(res, err);

					return utils.responses(res, 200, { foods: foods, count: count} );

				  });
				})		  			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
  })    
}

exports.list = function( req, res, next) {


  var token = req.query.token;
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  
			  var page = (req.param('page') > 0 ? req.param('page') : 1) - 1;
			  var perPage = 14;
			  var options = {
				perPage: perPage,
				page: page
			  };

			   
			  Food
			    .find()
				.sort({createdAt: -1})
				.skip(options.perPage * options.page)
				.limit(options.perPage)
				.exec(function(err, foods) {

				  if(err) return utils.responses(res, 500, err)

				  Food.count( function (err, count) {

					if (err) return errorHelper.mongoose(res, err);

					return utils.responses(res, 200, { foods: foods, count: count} );

				  });
				})		  			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
  })    
}

exports.search = function( req, res, next) {


  var token = req.query.token;
  var name = req.params.name;
 
 console.log("searching..."+name);
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  
  
		 if(msg == 'valid') {
		  
			  var page = (req.param('page') > 0 ? req.param('page') : 1) - 1;
			  var perPage = 14;
			  var options = {
				perPage: perPage,
				page: page
			  };
			 
			  var condition = { "name": new RegExp(name, "i") }
			  
			   
			  Food
				.where(condition)
				.sort({createdAt: -1})
				.skip(options.perPage * options.page)
				.limit(options.perPage)
				.exec(function(err, foods) {

				  if(err) return utils.responses(res, 500, err)

				  Food.count(condition, function (err, count) {

					if (err) return errorHelper.mongoose(res, err);

					return utils.responses(res, 200, { foods: foods, count: count} );

				  });
				})		  			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
  })    
}

exports.create = function (req, res, next) {

  var token = req.body.token;
  
 
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  var _id = req.body._id;
  var msg = token_utils.verify_access_token(tok);
  
  
  
		 if(msg == 'valid') {
         
            if(_id){
            //Update Mode.
            
            
            }
            else{
            
			   
			                    food = new Food(req.body);
								
										
								var message = new Object();
								
								food.save(function(err) {
								
								  if(err){
								  
								  console.log(err);
								   message.status= '401';
								   message.message = "Error adding food" 
                                   message.error   = "" + err;
  
								   return utils.responses(res, 200, message)
								  }
								  else{
								  
								  Food.findById(food, function (err,doc) {
								
                                   message.food	 = doc;								
							   	   message.status= '200';
								   message.message = "Food added successfully";
  
								   return utils.responses(res, 200, message)
								   
									})
									
								   
								   }
								});
                                
                }
						
			  	  			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
    }) 
}