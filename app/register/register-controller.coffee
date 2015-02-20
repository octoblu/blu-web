class RegisterController
  constructor: ($cookies, $location, AuthenticatorService) ->
    @cookies  = $cookies
    @location = $location
    @AuthenticatorService = AuthenticatorService

    @location.path "/#{@cookies.uuid}" if @cookies.uuid?

  register: (pin) =>
    @AuthenticatorService.registerWithPin(pin)
    .then (res) =>
      @cookies.uuid = res.uuid
      @cookies.token = res.token
      @location.path "/#{res.uuid}"
    .catch =>
      @errorMessage = "Unable to register a new device. Please try again."

angular.module('blu').controller 'RegisterController', RegisterController
