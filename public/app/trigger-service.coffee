class TriggerService
  constructor: ($http)->
    @http = $http

  getTriggers: =>
    throw new Error 'unauthenticated' unless @uuid && @token
    @http.get 'meshblu.octoblu.com/devices?type=octoblu:flow',
      headers:
        meshblu_auth_uuid: @uuid
        meshblu_auth_token: @token
    .then (response) =>
      triggers = []
      return triggers unless response.data?.devices?

      flows = response.data.devices
      _.each flows, (device) =>
        triggers = _.union triggers, @getTriggersFromDevice(device)

      return triggers

  getTriggersFromDevice: (device) =>
    triggersInFlow = _.where device.flow, { type: 'trigger' }
    _.map triggersInFlow, (trigger) =>
        name: trigger.name
        uuid: trigger.uuid
        flow: device.uuid


angular.module('blu').service 'TriggerService', TriggerService

