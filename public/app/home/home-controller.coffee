class HomeController
  constructor: (@AuthenticatorService) ->
    console.log @AuthenticatorService
  login: =>
    @AuthenticatorService.authenticate 'U1', '12345'


angular.module('blu').controller 'HomeController', HomeController
