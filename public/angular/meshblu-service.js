angular.module('blu')
  .service('meshbluService', function($http, $q, $cookies) {
    var self = this, conn, creds = {};

    self.getCredentials = function() {
      return $q.when({
        uuid : $cookies.meshblu_uuid,
        token : $cookies.meshblu_token
      });
    };

    self.saveCredentials = function(credentials) {
    	creds = credentials;
      $cookies.meshblu_uuid = credentials.uuid;
      $cookies.meshblu_token = credentials.token;
    };

    self.start = function(resolve, reject) {
      self.getCredentials()
        .then(function(creds) {
        	if(conn){
        		resolve(conn);
        		return;
        	}
          conn = meshblu.createConnection(creds);
          conn.on('ready', function(data) {
            console.log('Connected to Meshblu', data);
            resolve(conn);
          });
          conn.on('notReady', function() {
            console.log('Not connected to Meshblu');

            conn.register({
              'type': 'octobluDashboard'
            }, function(data) {
              console.log(data);
              self.saveCredentials(data);

              conn.authenticate({
                'uuid': data.uuid,
                'token': data.token
              }, function(data) {
                console.log(data);
              });
            });
          });
          conn.on('disconnect', function(){
          	reject();
          });
        });
    };

    self.getConnection = function(resolve, reject) {
      if (conn) {
        resolve(conn, creds);
      } else {
        self.start(function(){
        	resolve(conn, creds);
        }, function(){
        	reject();
        });
      }
    };

    return self;
  });
