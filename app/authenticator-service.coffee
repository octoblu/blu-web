class AuthenticatorService
  constructor: ($q, $http) ->
    @q = $q
    @http = $http

  registerWithPin: (pin)=>
    @http.post('https://pin.octoblu.com/devices', {
            pin: "#{pin}"
            device:
              type: 'blu'
              online: true
        }).then (result) => result.data

  authenticate: (uuid, pin) =>
    @http
      .post "https://pin.octoblu.com/devices/#{uuid}/sessions", pin: pin
      .then (result) => result.data.token
      .catch (error) => @q.reject new Error(error.data) 

angular.module('blu').service 'AuthenticatorService', AuthenticatorService

