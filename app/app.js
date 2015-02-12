'use strict';

angular.module('blu', ['ngCookies', 'ngRoute'])
.config(function($routeProvider) {
        $routeProvider
            // route for the home page
            .when('/', {
                templateUrl : '../home/index.html',
                controller  : 'HomeController'
            })
			.otherwise( { redirectTo: "/" });
    })
  .run(function($rootScope, $location) {

  });

