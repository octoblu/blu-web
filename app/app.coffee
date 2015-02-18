angular
.module 'blu', ['ngCookies', 'ngRoute', 'ngMaterial']
.config ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: '/register.html'
      controller:  'RegisterController'
      controllerAs: 'controller'
    .when '/:uuid', 
      templateUrl: '/home.html'
      controller:  'HomeController'
      controllerAs: 'controller'
    .when '/:uuid/login', 
      templateUrl: '/login.html'
      controller:  'LoginController'
      controllerAs: 'controller'
    .otherwise redirectTo: '/'
.run ($rootScope, $location) ->
