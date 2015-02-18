class RegisterController
  constructor: (AuthenticatorService, $location) ->
    @AuthenticatorService = AuthenticatorService
    @location = $location

  register: (pin) =>
    @AuthenticatorService.registerWithPin(pin)
    .then (res) =>
      @location.path "/#{res.uuid}/login"
    .catch =>
      @error = "Unable to register a new device. Please try again."

angular.module('blu').controller 'RegisterController', RegisterController
