class HomeController
  constructor: (AuthenticatorService, TriggerService, $routeParams, $cookies, $location) ->
    @location = $location
    @cookies = $cookies
    @AuthenticatorService = AuthenticatorService
    @TriggerService = TriggerService
    @routeParams = $routeParams
    @colorIndex = 0 

    @location.path('/') unless @cookies.uuid
    @location.path("/#{@cookies.uuid}/login") unless @cookies.token
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
    @TriggerService.trigger(trigger.flow, trigger.uuid, @cookies.uuid, @cookies.token).then ()=>
      delete trigger.triggering

angular.module('blu').controller 'HomeController', HomeController
