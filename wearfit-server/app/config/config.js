// config for the express app
// depending on `process.env.NODE_ENV`, default is `development`

var path = require('path')
  , rootPath = path.normalize(__dirname + '/../..')

var config = {
  // Development config
  //
  development: {
    server: {
      port: 3001,
      hostname: 'localhost',
    },
    database: {
      url: 'mongodb://localhost/numaforce'
    },
    BaseApiURL : 'http://localhost:3001/api/',
    root     : rootPath,
    app      : {
      name : 'Numa Digital Fitness'
    },
    twitterAuth: true,
    twitter: {
      consumerKey: process.env.TWITTER_KEY || 'xxxxxxxxxxx',
      consumerSecret: process.env.TWITTER_SECRET  || 'xxxxxxxxxxx',
      callbackURL: '/auth/twitter/callback',
      passReqToCallback: true
    },
    facebookAuth: true,
    facebook: {
      clientID: process.env.FACEBOOK_ID || 'xxxxxxxxxxx',
      clientSecret: process.env.FACEBOOK_SECRET || 'xxxxxxxxxxx',
      callbackURL: '/auth/facebook/callback',
      passReqToCallback: true
    },
    mailgun: {
      user: process.env.MAILGUN_USER || 'postmaster@sandbox2eca26e98bb44d02ab18fbe398186a5a.mailgun.org',
      password: process.env.MAILGUN_PASSWORD || 'dc8ec0adeb1c3d8faac07a30711fa0ce'
    }
  },
  //
  // Production Config
  //
  production: {
    server: {
      port: process.env.PORT || 5000,
      hostname:  'numa.simpliot.com',
    },
    database: {
      url: 'mongodb://numaforce:kittens@ds047930.mongolab.com:47930/heroku_app30947127'
    },
    BaseApiURL : 'http://www.simpliot.com/numa/api/',
    root     : rootPath,
    app      : {
      name : 'Numa'
    },
    twitterAuth: true,
    twitter: {
      // https://apps.twitter.com/app/6070534/keys
      consumerKey: process.env.TWITTER_KEY || 'xxxxxxxxxxx',
      consumerSecret: process.env.TWITTER_SECRET  || 'xxxxxxxxxxx',
      callbackURL: '/auth/twitter/callback',
      passReqToCallback: true
    },	
    facebookAuth: true,
    facebook: {
      clientID: process.env.FACEBOOK_ID || 'xxxxxxxxxxx',
      clientSecret: process.env.FACEBOOK_SECRET || 'xxxxxxxxxxx',
      callbackURL: '/auth/facebook/callback',
      passReqToCallback: true
    },
    mailgun: {
      user: process.env.MAILGUN_USER || 'postmaster@sandbox2eca26e98bb44d02ab18fbe398186a5a.mailgun.org',
      password: process.env.MAILGUN_PASSWORD || 'dc8ec0adeb1c3d8faac07a30711fa0ce'
    },
	gcm: {
        apiKey: "AIzaSyAdvsNjX55_tVX8mJ57Cj_fGN_3OW8CbC4"
    },
    apn: {
        connection: {
            gateway: "gateway.sandbox.push.apple.com",
            cert: "/path/to/cert.pem",
            key: "/path/to/key.pem"
        },
        "feedback": {
            address: "feedback.sandbox.push.apple.com",
            cert: "/path/to/cert.pem",
            key: "/path/to/key.pem",
            interval: 43200,
            batchFeedback: true
        }
    }
  },

  //
  // Testing config
  //
  test: {
    server: {
      port: 4001,
      hostname: 'localhost',
    },
    database: {
      url: 'mongodb://localhost/express_test'
    }
  }
};

module.exports = config['production'];
