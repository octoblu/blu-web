class LoginController
  constructor: (AuthenticatorService, $location, $cookies) ->
    @AuthenticatorService = AuthenticatorService
    @location = $location
    @cookies = $cookies
    @uuid = $location.uuid

  login: (uuid, pin) =>
    @AuthenticatorService.authenticate uuid, pin
      .then (token) =>
        @cookies.uuid = uuid
        @cookies.token = token
        @location.path "/#{uuid}"
      .catch (error) =>
        @error = error.message


angular.module('blu').controller 'LoginController', LoginController
