var mongoose = require('mongoose');
var PushNotification     = mongoose.model('PushNotification');
var apn = require('apn');
var gcm = require('node-gcm');
var config         = require('../config/config')
var _ = require('lodash');


        exports.ios_push = function (device_tokens, payload) {
            apnSender().pushNotification(payload, device_tokens);
        };

        exports.ios_build = function (options) {
            var notif = new apn.Notification(options.payload);

            notif.expiry = options.expiry || 0;
            notif.alert = options.alert;
            notif.badge = options.badge;
            notif.sound = options.sound;

            return notif;
        };

        var apnSender = _.once(function () {
            var apnConnection = new apn.Connection(config.apn.connection);

            apnConnection.on('transmissionError', function (errorCode, notification, recipient) {
                    console.error('Error while pushing to APN: ' + errorCode);
                    
                    // Invalid token => remove device
                    console.log(recipient);
                    if (errorCode === 8) {
                        var token = recipient.toString('hex').toUpperCase();

                        console.log('Invalid token: removing device ' + token);
                        PushNotification.remove({device_token: token},function(err){});
                    }
            });
            
            var apnFeedback = new apn.Feedback(config.apn.feedback)

            apnFeedback.on('feedback', function (deviceInfos) {
                console.log('Feedback service, number of devices to remove: ' + deviceInfos.length);

                deviceInfos.map(function (deviceInfo) {
                    PushNotification.remove({device_token: deviceInfo.token.toString('hex')},function(err){});
                })                
            });

            return apnConnection;
        });
        
        
        exports.android_push = function (device_tokens, message) {

           console.log(device_tokens);
           
            gcmSender().send(message, device_tokens, 4, function (err, res) {
                if(err) console.log(err);

                if (res && res.failure > 0) {
                    var mappedResults = _.map(_.zip(device_tokens, res.results), function (arr) {
                        return _.merge({token: arr[0]}, arr[1]);
                    });

                    handleResults(mappedResults);
                }
            })
        };

        var handleResults = function (results) {
            var idsToUpdate = [],
                idsToDelete = [];

                console.log('Android Push Results:'+results);
                
            results.forEach(function (result) {
                if (!!result.registration_id) {
                    idsToUpdate.push({from: result.token, to: result.registration_id});

                } else if (result.error === 'InvalidRegistration' || result.error === 'NotRegistered') {
                    idsToDelete.push(result.token);
                }
            });

            if (idsToUpdate.length > 0) {
            
            idsToUpdate.forEach(function (tokenUpdate) {
                PushNotification.findOneAndUpdate({device_token: tokenUpdate.from}, {device_token: tokenUpdate.to}, function (err) {
                    if (err) console.error(err);
                        });
                });
    
            }
            
            
            if (idsToDelete.length > 0) {
            
             idsToDelete.map(function (id) {
                    PushNotification.remove({device_token: id},function(err){});
                }) 
            }
            pushAssociations.removeDevices(idsToDelete);
        };

        exports.android_build = function (options) {
            return new gcm.Message(options);
        };

        var gcmSender = _.once(function() {
            return new gcm.Sender(config.gcm.apiKey);
        });
