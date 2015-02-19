class DeviceService
  constructor: ($http) ->
    @http = $http

  getDevice: (uuid, token) =>
    config = 
      headers: 
        meshblu_auth_uuid: uuid
        meshblu_auth_token: token

    @http
      .get "https://meshblu.octoblu.com/devices/#{uuid}", config
      .then (response) =>
        _.first response.data.devices

angular.module('blu').service('DeviceService', DeviceService)
