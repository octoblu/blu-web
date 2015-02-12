'use strict';

angular.module('blu')
  .controller('HomeController', function($scope, $location){
    $scope.login = function(){
      $location.path('/login');
    };

    $scope.register = function(){
      $location.path('/register');
    }
  });
