class AuthenticatorService
  constructor: ($q) ->
    @q = $q

  registerWithPin: =>
    @q (resolve, reject) =>
      resolve uuid: 'sawblade'

angular.module('blu').service 'AuthenticatorService', AuthenticatorService

