class HomeController
  constructor: (TriggerService, $cookies, $location) ->
    @location = $location
    @cookies = $cookies
    @TriggerService = TriggerService
    @colorIndex = 0

    return @location.path('/') unless @cookies.uuid
    return @location.path("/#{@cookies.uuid}/login") unless @cookies.token

    @TriggerService.getTriggers(@cookies.uuid, @cookies.token).then (@triggers) =>
      if @triggers.length < 1
        @message = 'You have no triggers. Visit app.octoblu.com/admin/groups to give Blu access to flows.'
    .catch (@error) =>
      @errorMsg = @error

  nextColor: =>
    [
      'blue'
      'purple'
      'green'
      'orange'
      'red'
    ][@colorIndex++ % 5]

  triggerTheTrigger: (trigger) =>
    trigger.triggering = true
    @TriggerService.trigger(trigger.flow, trigger.id, @cookies.uuid, @cookies.token).then ()=>
      delete trigger.triggering

angular.module('blu').controller 'HomeController', HomeController
