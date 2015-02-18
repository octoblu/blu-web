class RegisterController
  constructor: (AuthenticatorService, $location) ->
    @AuthenticatorService = AuthenticatorService
    @location = $location
    @str = "hi"

  register: (pin) =>
    console.log pin
    @AuthenticatorService.registerWithPin(pin)
    .then (res) =>
      @location.path "/#{res.uuid}"
    .catch =>
      @error = "Unable to register a new device. Please try again."

angular.module('blu').controller 'RegisterController', RegisterController
