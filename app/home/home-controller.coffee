class HomeController
  constructor: (AuthenticatorService, TriggerService, $routeParams) ->
    @AuthenticatorService = AuthenticatorService
    @TriggerService = TriggerService
    @routeParams = $routeParams
    @colorIndex = 0 

    @triggers = [
      name: 'Tigers'
    ,
      name: 'Axed'
    ,
      name: 'Tragic Flaw'
    ]
    
  login: (pin) =>
    @AuthenticatorService.authenticate @$routeParams.uuid, pin
      .then (token) =>
        @TriggerService.uuid = @$routeParams.uuid
        @TriggerService.token = token
        @TriggerService.getTriggers()
      .then (triggers) =>
        @triggers = triggers
      .catch (error) =>
        @error = error.message

  nextColor: =>
    [
      'blue'
      'purple'
      'green'
      'orange'
      'red'
    ][@colorIndex++ % 5]

  triggerTheTrigger: (trigger) =>
    @TriggerService.trigger trigger.flow, trigger.uuid

angular.module('blu').controller 'HomeController', HomeController
