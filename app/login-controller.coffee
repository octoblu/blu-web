class LoginController
  constructor: (AuthenticatorService, $location, $cookies) ->
    @AuthenticatorService = AuthenticatorService
    @location = $location
    @cookies = $cookies

  login: (pin) =>
    @AuthenticatorService.authenticate @cookies.uuid, pin
      .then (token) =>
        @cookies.token = token
      .catch (error) =>
        @error = error.message

angular.module('blu').controller 'LoginController', LoginController
