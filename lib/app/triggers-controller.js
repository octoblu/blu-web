'use strict';

angular.module('blu')
  .controller('triggersController', function($scope, meshbluService){

    meshbluService.getConnection(function(conn){
      console.log('Connected');
    });
  });
