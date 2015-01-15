var jwt      = require('jwt-simple');
var moment   = require('moment');
var mongoose = require('mongoose');
var AccessToken  = mongoose.model('AccessToken');

exports.find_token = function (token, callback){

 var query = AccessToken.findOne({token: token});
 
  query.exec (function(err,token){
  if(err)
     return err;
  else
    return token;
  });
}

exports.verify_access_token = function(token) {

var message ;
  	 
		  if (!token) {
  			      message= 'Token Not found';
			 }
			 else{
 
			  try{
			     
				 var decoded = jwt.decode(token.token, 'jwtExpressSecret');
				 
				 if (decoded.exp <= Date.now()) {
				      message= 'Access token has expired';
				   }
				   else{
				      message = 'valid';				
				   }
				   
			    
			   }catch(err){
			  // console.log(err);
			     message = 'Undefined Token';
			   }
			}			
			
	console.log(message);
	
	return message;

}


exports.get_access_token = function(user,expires) {

	return jwt.encode({
			  iss: user.email,
			  exp: expires
			}, 'jwtExpressSecret');
 
 
 }