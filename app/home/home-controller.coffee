class HomeController
  constructor: ($cookies, $location, DeviceService, TriggerService) ->
    @cookies = $cookies
    @location = $location
    @DeviceService = DeviceService
    @TriggerService = TriggerService
    @colorIndex = 0
    @randomRobotId = _.sample [1...9]

    return @location.path('/') unless @cookies.uuid
    return @redirectToLogin() unless @cookies.token

    devicePromise = @DeviceService.getDevice(@cookies.uuid, @cookies.token)
    devicePromise.catch @redirectToLogin
    devicePromise.then (@device) =>
      return @notClaimed = true unless @device.owner?

      @refreshTriggers().catch (error) =>
        @errorMessage = error.message


  redirectToLogin: =>
    @location.path "/#{@cookies.uuid}/login"

  refreshTriggers: =>
    @TriggerService.getTriggers(@cookies.uuid, @cookies.token, @device.owner).then (@triggers) =>
      @noFlows = _.isEmpty @triggers

      _.each @triggers, (trigger, i) =>
        trigger.color = "##{trigger.id[0...6]}"
        trigger.span  = if i % 5 == 0 then 2 else 1

  triggerTheTrigger: (trigger) =>
    trigger.triggering = true
    @TriggerService.trigger(trigger.flow, trigger.id, @cookies.uuid, @cookies.token).then ()=>
      delete trigger.triggering


angular.module('blu').controller 'HomeController', HomeController
