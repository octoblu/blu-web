class HomeController
  constructor: (@AuthenticatorService, @MeshbluService, @$routeParams) ->
  login: (pin) =>
    @AuthenticatorService.authenticate @$routeParams.uuid, pin
      .then (token) =>
        @MeshbluService.uuid = @$routeParams.uuid
        @MeshbluService.token = token
        @MeshbluService.getTriggers()
      .then (triggers) =>
        @triggers = triggers
      .catch (error) =>
        @error = error.message

  triggerTheTrigger: (trigger) =>
    @MeshbluService.trigger trigger.flow, trigger.uuid

angular.module('blu').controller 'HomeController', HomeController
