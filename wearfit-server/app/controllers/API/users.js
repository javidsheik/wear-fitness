var mongoose = require('mongoose');
var User     = mongoose.model('User');
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


exports.login = function (req, res, next) {

 console.log("--------------------------------" + req.body);
 
  var email    = req.body.email
  var password = req.body.password

  
  User.findOne( { email: email } , function (err, user) {

        var data = req.body;
		
        if (err) {
          return utils.responses(res, 501, user)
        }

        if (!user) {
		  console.log("--------------------------------"+ email + "not registered");
		  data.status = "401";
		  data.message = "Email is not registered";
          return utils.responses(res, 401, data)
        }

        if (!user.authenticate(password)) {
		  console.log("--------------------------------" + email + "not valid");
		  data.status = "401";
		  data.message = "Invalid login Credentials ";
          return utils.responses(res, 401, data)
        }

		
		var expires = moment().add('days', 7).valueOf();
		
		var token = token_utils.get_access_token(user,expires);
 
     // console.log("TOKEN:"+token);
	  
        // Save Access Token
		
		var stoken = new AccessToken();
		
		stoken.email = user.email;
		stoken.token = token;
		stoken.expires = expires;
		stoken.created = new Date().toISOString();

		  stoken.save(function(err, doc) {

			if(err) return utils.responses(res, 500, err)

			  return utils.responses(res, 200, stoken)
		  })  
      })  
}

 

exports.update_profile = function (req, res, next) {

  var id = req.body.user_id;
  var token = req.body.token;
  
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  
		  var condition = {_id: id};
          
          if(!id){
						
						        var message = req.body;
								message.status= '401';
								message.message = "User is required";
		  
								return utils.responses(res, 401, message)
          }
	      else{
		  
          User.findOne(condition, function (err, doc){
          
		  if(!doc){
		  
		           var message = req.body;
				   message.status= '401';
				   message.message = "User not Found";
		  
				 return utils.responses(res, 401, message)
		    }
			else
			{
		  
              doc.first_name    = req.body.first_name;
              doc.last_name     = req.body.last_name;
              doc.gender        = req.body.gender;
              doc.date_of_birth = req.body.date_of_birth;
              doc.height        = req.body.height;
              doc.weight        = req.body.weight;
              doc.height_unit   = req.body.height_unit;
              doc.weight_unit   = req.body.weight_unit;  
              doc.address       = req.body.address;  
              doc.city          = req.body.city;  
              doc.state         = req.body.state;  
              doc.zip           = req.body.zip;  
              doc.mobile             = req.body.mobile; 
              doc.device_id          = req.body.device_id; 
              doc.device_model       = req.body.device_model; 
              doc.device_manufacturer = req.body.device_manufacturer; 
              
			  if(req.files.profile_photo)
                doc.set('profile_photo.file',req.files.profile_photo);
              
              var message = new Object();
              
                                doc.save(function(err) {
								
                                          if(err){
                                          
                                               message.status= '401';
                                               message.message = "Error Updating profile" 
                                               message.error   = err;
              
                                               return utils.responses(res, 200, message)
                                           }
                                           else
                                           {
                                           
                                                User.findOne(condition, function (err, user){
                                           
                                                message.status= '200';
                                                message.message = "Profile updated successfully!" 
                                               
                                                return utils.responses(res, 200, user)                     
                                                
                                              });
                                           
                                                
                                           }
								  });
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

exports.get_profile = function (req, res, next) {

  var email = req.params.email;
  var token = req.query.token;
  
  
  
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		 if(msg == 'valid') {
		  
		  var query =  User.findOne({email: email});
		  
		  query.select('-hashed_password -tokens -invitation_token -salt -provider')
		  
         
			 query.exec(function (err, user) {
					if (err) return utils.responses(res, 500, err)

                   
		           return utils.responses(res, 200, user)
		        })
 
			  
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
		  
		  
  })
 
}


exports.logout = function (req, res, next) {

  var token = req.body.token
  
  AccessToken.findOne({token: token} , function(err,tok) {
  
  
  var message = req.body;
  
  var msg = token_utils.verify_access_token(tok);
  
  //console.log(msg);
  
		  if(msg == 'valid') {
		  
			  AccessToken.remove({'token' : token}, function(err) {
				if(err){
				 console.log(err);
				 return utils.responses(res, 401, err)
				 }
			  });
			  
			  var message;
			  message.status = '200';
			  message.message = 'Logged out Successfully!';
			  
			  return utils.responses(res, 200, message)
		  }else{
		  
			message.status= '401';
			message.message = msg;
  
			return utils.responses(res, 401, message)
 
		  }
		  
		  
  })
  
}

exports.signup = function (req, res, next) {

 var email = req.body.email;

 async.waterfall([
    function(next) {
      crypto.randomBytes(16, function(err, buf) {
        var token = buf.toString('hex');
        next(err, token);
      });
    },
    function(token, next) {
	    var user = new User();
		user.email = email;
        user.invitation_token = token;
        user.invitation_expires = Date.now() + 43200000; // 12 hour
        user.mode = 'invite';
		
        user.save(function(err) {
          next(err, token, user);
        });
    }, function(token, user, next) {
        user.url_invitation = req.protocol + '://' + req.headers.host + '/invite/' + token

       Mailer.sendOne('invitation', "Numa Digital Fitness - Invitation", user, function (err, responseStatus, html, text){
          next(err, responseStatus);
        })
		
		      var message = req.body;
			  message.status = '200';
			  message.message = 'Invitation sent successfully.';
			  
			  return utils.responses(res, 200, message)			  
		
      }
    ], function(err) {
		  if (err) {
		  
		  var message = req.body;
			  message.status = '500';
			  message.message = 'Failed sending invitation. please try again later. ' + err;
			  
			  return utils.responses(res, 200, message)
			
		  }
     
    });
}



exports.postForgotPassword = function (req, res) {

  async.waterfall([
    function(next) {
      crypto.randomBytes(16, function(err, buf) {
        var token = buf.toString('hex');
        next(err, token);
      });
    },
    function(token, next) {
      User.findOne({ email: req.body.email.toLowerCase() }, function(err, user) {

        if (!user) {
           var message = new Object();
			  message.status = '404';
			  message.message = 'Email address not found. ' + err;
			  
			  return utils.responses(res, 200, message)
        }

        user.reset_password_token = token;
        user.reset_password_expires = Date.now() + 43200000; // 12 hour

        user.save(function(err) {
          next(err, token, user);
        });
      });
    }, function(token, user, next) {
        user.url_reset_password = req.protocol + '://' + req.headers.host + '/reset/' + token

        Mailer.sendOne('forgot-password', "Numa Digital Fitness - Password Reset", user, function (err, responseStatus, html, text){
          next(err, responseStatus);
        })
        
         var message = new Object();
		     message.status = '200';
			 message.message = 'Email sent successfully for password reset.';
			  
	     return utils.responses(res, 200, message)	
              
      }
    ], function(err) {
      if (err) {
		  
		  var message = req.body;
			  message.status = '500';
			  message.message = 'Failed resetting password. please try again later. ' + err;
			  
			  return utils.responses(res, 200, message)
			
		  }
    });
}


exports.fb_login = function (req, res, next) {

    var first_name = req.body.first_name;
    var last_name  = req.body.last_name;
    var profile_id = req.body.profile_id
    var email      = req.body.email;
    var accessToken = req.body.accessToken;

  
      User.findOne({ 'facebook_id' : profile_id }, function(err, existingUser) {
       
       if(existingUser){
       
       existingUser.tokens.push({ kind: 'facebook', accessToken: accessToken });

                    existingUser.save(function(err) {
                   
                                    var expires = moment().add('days', 7).valueOf();
                                    
                                    var token = token_utils.get_access_token(existingUser,expires);
                             
                                 
                                    var stoken = new AccessToken();
                                    
									
                                    stoken.email = existingUser.email;
                                    stoken.token = token;
                                    stoken.expires = expires;
                                    stoken.created = new Date().toISOString();

                                      stoken.save(function(err, doc) {

                                        if(err) return utils.responses(res, 500, err)

                                          return utils.responses(res, 200, stoken)
                                      })  
                             
                                      
                    });
       }
       else
       {

        User.findOne({ email: email }, function(err, existingEmailUser) {
          if (existingEmailUser) {
          
             var message= new Object();
             message.status = '401';
             message.message = 'There is already an account using this email address. Sign in to that account.' ;
             return utils.responses(res, 401, message)
                       
          } else {
            var user = new User();
            user.email            = email;
            user.facebook_id      = profile_id;
            user.provider         = 'facebook';
            user.first_name       = first_name;
            user.last_name        = last_name;
            user.fb_photo_profile = 'https://graph.facebook.com/' + profile_id + '/picture?type=large';

            user.tokens.push({ kind: 'facebook', accessToken: accessToken });

            user.save(function(err) {
              
                                    var expires = moment().add('days', 7).valueOf();
                                    
                                    var token = token_utils.get_access_token(user,expires);
                             
                                 
                                    var stoken = new AccessToken();
                                    
                                    stoken.email = user.email;
                                    stoken.token = token;
                                    stoken.expires = expires;
                                    stoken.created = new Date().toISOString();

                                      stoken.save(function(err, doc) {

                                        if(err) return utils.responses(res, 500, err)

                                          return utils.responses(res, 200, stoken)
                                      })  
          
              
            });
          }
        });
       } 
      });    
}
