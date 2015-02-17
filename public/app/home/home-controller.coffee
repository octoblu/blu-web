class HomeController
  constructor: (@AuthenticatorService, @TriggerService, @$routeParams) ->
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

  triggerTheTrigger: (trigger) =>
    @TriggerService.trigger trigger.flow, trigger.uuid

angular.module('blu').controller 'HomeController', HomeController
