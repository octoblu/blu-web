class TriggerService
  constructor: ($http, $cookies)->
    @http = $http
    @cookies = $cookies
  trigger: (flow, uuid) =>
    throw new Error 'unauthenticated' unless @cookies.uuid && @cookies.token
    throw new Error 'no trigger' unless flow && uuid

    @http.post 'meshblu.octoblu.com/messages',
      headers:
        meshblu_auth_uuid: @cookies.uuid
        meshblu_auth_token: @cookies.token
      data:
        devices: flow
        topic: 'button'
        payload:
          from: uuid

  getTriggers: =>
    throw new Error 'unauthenticated' unless @cookies.uuid && @cookies.token
    @http.get 'meshblu.octoblu.com/devices?type=octoblu:flow',
      headers:
        meshblu_auth_uuid: @cookies.uuid
        meshblu_auth_token: @cookies.token
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

