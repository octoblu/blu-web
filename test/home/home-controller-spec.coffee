describe 'HomeController', ->
  beforeEach ->
    module 'blu'

    inject ($controller, $q, $rootScope) ->
      emptyPromise = $q.when()
      @q = $q
      @rootScope = $rootScope
      @authenticatorService = {}
      @routeParams = {}
      @triggerService =  {getTriggers: sinon.stub().returns(emptyPromise)}
      @sut = $controller('HomeController', {
        AuthenticatorService: @authenticatorService,
        TriggerService : @triggerService,
        $routeParams : @routeParams
      })

  it 'should exist', ->
    expect(@sut).to.exist
