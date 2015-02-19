class HomeController
  constructor: ($cookies, $location, DeviceService, TriggerService) ->
    @cookies = $cookies
    @location = $location
    @DeviceService = DeviceService
    @TriggerService = TriggerService
    @colorIndex = 0

    return @location.path('/') unless @cookies.uuid
    return @location.path("/#{@cookies.uuid}/login") unless @cookies.token

    @DeviceService.getDevice(@cookies.uuid, @cookies.token)
      .then (device) =>
        unless device.owner?
          @notClaimed = true
          return

        @TriggerService.getTriggers(@cookies.uuid, @cookies.token, device.owner).then (@triggers) =>
          @noFlows = _.isEmpty @triggers

          _.each @triggers, (trigger) =>
            trigger.color = "##{trigger.id[0...6]}"
      .catch (@error) =>
        @errorMsg = @error

  triggerTheTrigger: (trigger) =>
    trigger.triggering = true
    @TriggerService.trigger(trigger.flow, trigger.id, @cookies.uuid, @cookies.token).then ()=>
      delete trigger.triggering

angular.module('blu').controller 'HomeController', HomeController
