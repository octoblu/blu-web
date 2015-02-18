angular
.module 'blu', ['ngCookies', 'ngRoute']
.config ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: '/register.html'
      controller:  'RegisterController'
    .when '/:uuid', 
      templateUrl: '/home.html'
      controller:  'HomeController'
    .otherwise redirectTo: '/'
.run ($rootScope, $location) ->
