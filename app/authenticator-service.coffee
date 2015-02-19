class AuthenticatorService
  constructor: ($q, $http) ->
    @q = $q
    @http = $http

  registerWithPin: (pin)=>
    @http.post('https://pin.octoblu.com/devices', {
            data:
              pin: "#{pin}"
              device:
                type: 'blu'
        }).then (result) => result.data

  authenticate: (uuid, pin) =>
    @http.post("https://pin.octoblu.com/devices/#{uuid}/sessions", {
            data:
              pin: pin
        }).then (result) => result.data.token

angular.module('blu').service 'AuthenticatorService', AuthenticatorService

