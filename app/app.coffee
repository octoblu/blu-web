angular
.module 'blu', ['ngCookies', 'ngRoute']
.config ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: '/app/register/register.html'
      controller:  'RegisterController'
    .when '/:uuid', 
      templateUrl: '/app/home/home.html'
      controller:  'HomeController'
    .otherwise redirectTo: '/'
.run ($rootScope, $location) ->
