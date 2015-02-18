describe 'HomeController', ->
  beforeEach ->
    module 'blu'

    inject ($controller, $q, $rootScope) ->      
      @q = $q
      @getTriggers = @q.defer()
      @rootScope = $rootScope
      @authenticatorService = {}
      @routeParams = {}
      @cookies = {}
      @location = path: sinon.stub()
      @triggerService =  {getTriggers: sinon.stub().returns(@getTriggers.promise)}
      @controller = $controller
      @sut = $controller('HomeController', {
        AuthenticatorService: @authenticatorService,
        TriggerService : @triggerService,
        $routeParams : @routeParams,
        $cookies: @cookies,
        $location: @location

      })

  it 'should exist', ->
    expect(@sut).to.exist

  describe 'when the user is authenticated (valid uuid | token)', ->
    it 'should call the triggerService.getTriggers', ->
      expect(@triggerService.getTriggers).to.have.been.called

    describe 'when triggerService.getTriggers resolves with a list of triggers', ->
      beforeEach ->
        @triggers = [
            flow: 1
            uuid: 2
            name: 'calico'
          ,
            flow: 2
            uuid: 3
            name: 'tabby'
          ]
        @getTriggers.resolve @triggers
      it 'should set a triggers property with the list of triggers', ->
        @rootScope.$digest()
        expect(@sut.triggers).to.deep.equal @triggers

    describe 'when triggerService.getTriggers resolves with no triggers', ->
      beforeEach ->
        @triggers = []
        @message = 'You have no triggers. Visit app.octoblu.com/admin/groups to give Blu access to flows.'
        @getTriggers.resolve @triggers
      it 'should set a message property with a message', ->
        @rootScope.$digest()
        expect(@sut.message).to.deep.equal @message

    describe 'when triggerService.getTriggers rejects the promise', ->
      beforeEach ->
        @error = 'ERROR WILL ROBINSON ERROR'
        @getTriggers.reject @error
      it 'should have an errorMsg property', ->
        @rootScope.$digest()
        expect(@sut.errorMsg).to.deep.equal @error
        
  describe 'when the user does not have a valid uuid', ->
    beforeEach ->
      @cookies.uuid = undefined
      @sut = @controller('HomeController', {
          AuthenticatorService: @authenticatorService,
          TriggerService : @triggerService,
          $routeParams : @routeParams,
          $cookies: @cookies,
          $location: @location

        })
    it 'should redirect the user to the register page', ->
      expect(@location.path).to.have.been.calledWith '/'

  describe 'when the user has a valid uuid but does not have a valid token', ->
    beforeEach ->
      @cookies.uuid = 1
      @cookies.token = undefined
      @sut = @controller('HomeController', {
        AuthenticatorService: @authenticatorService,
        TriggerService : @triggerService,
        $routeParams : @routeParams,
        $cookies: @cookies,
        $location: @location

      })
    it 'should redirect the user to the register page', ->
      expect(@location.path).to.have.been.calledWith '/1/login'
      
    
    

    

      

