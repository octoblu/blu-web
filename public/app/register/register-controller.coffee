class RegisterController
  constructor: (AuthenticatorService, $location) ->
    @AuthenticatorService = AuthenticatorService
    @location = $location

  register: (pin) =>
    @AuthenticatorService.registerWithPin(pin)
    .then (res) =>
      @location.path "/#{res.uuid}"
    .catch =>
      @error = "Unable to register a new device. Please try again."
      console.error @error

angular.module('blu').controller 'RegisterController', RegisterController
