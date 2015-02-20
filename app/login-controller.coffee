class LoginController
  constructor: (AuthenticatorService, $location, $routeParams, $cookies) ->
    @AuthenticatorService = AuthenticatorService
    @location = $location
    @cookies = $cookies
    @uuid = $routeParams.uuid

  login: (uuid, pin) =>
    @AuthenticatorService.authenticate uuid, pin
      .then (token) =>
        @cookies.uuid = uuid
        @cookies.token = token
        @location.path "/#{uuid}"
      .catch (error) =>
        @errorMessage = error.message


angular.module('blu').controller 'LoginController', LoginController
