'use strict';

angular.module('blu', ['ngCookies', 'ngRoute'])
.config(function($routeProvider) {
        $routeProvider
            // route for the home page
            .when('/', {
                controller  : 'RegisterController'
            })
            .when('/:uuid', {
              templateUrl : '/home/home.html',
              controller : 'HomeController'
            })
			.otherwise( { redirectTo: "/" });
    })
  .run(function($rootScope, $location) {

  });

