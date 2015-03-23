class HomeController
  constructor: ($cookies, $location, $routeParams, DeviceService, TriggerService) ->
    @cookies = $cookies
    @location = $location
    @routeParams = $routeParams
    @DeviceService = DeviceService
    @TriggerService = TriggerService
    @colorIndex = 0
    @randomRobotId = _.sample [1...9]

    return @redirectToLogin() unless @cookies.token

    devicePromise = @DeviceService.getDevice(@routeParams.uuid, @cookies.token)
    devicePromise.catch @redirectToLogin
    devicePromise.then (@device) =>
      @triggersLoaded = true
      return @notClaimed = true unless @device.owner?

      @refreshTriggers().catch (error) =>
        @errorMessage = error.message


  redirectToLogin: =>
    @location.path "/#{@routeParams.uuid}/login"

  refreshTriggers: =>
    @TriggerService.getTriggers(@routeParams.uuid, @cookies.token, @device.owner).then (@triggers) =>
      @noFlows = _.isEmpty @triggers

      _.each @triggers, (trigger, i) =>
        trigger.color = "##{trigger.id[0...6]}"

  triggerTheTrigger: (trigger) =>
    trigger.triggering = true
    @TriggerService.trigger(trigger.flow, trigger.id, @routeParams.uuid, @cookies.token).then ()=>
      delete trigger.triggering


angular.module('blu').controller 'HomeController', HomeController
