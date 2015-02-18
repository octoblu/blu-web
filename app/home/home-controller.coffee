class HomeController
  constructor: (AuthenticatorService, TriggerService, $routeParams) ->
    @AuthenticatorService = AuthenticatorService
    @TriggerService = TriggerService
    @routeParams = $routeParams
    @colorIndex = 0 

    @triggers = [
      name: 'Tigers'
      color: @nextColor()
    ,
      name: 'Axed'
      color: @nextColor()
    ,
      name: 'Tragic Flaw'
      color: @nextColor()
    ]
    @TriggerService.getTriggers().then (@triggers) =>
    
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
