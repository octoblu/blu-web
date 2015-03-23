describe 'HomeController', ->
  beforeEach ->
    module 'blu'

    inject ($controller, $q, $rootScope) ->
      @q = $q
      @getTriggers = @q.defer()
      @triggerPromise = @q.defer()
      @rootScope = $rootScope
      @location = path: sinon.stub()
      @triggerService =
        getTriggers: sinon.stub().returns(@getTriggers.promise)
        trigger: sinon.stub().returns(@triggerPromise)
      @deviceService =
        getDevice: sinon.stub().returns $q.when(owner: 'owner-uuid')
      @controller = $controller

  describe 'when the user is authenticated (valid uuid | token)', ->
    beforeEach ->
      @sut = @controller('HomeController', {
        $cookies: {token: 'token'}
        $location: @location
        $routeParams: {uuid: 'uuid'}
        TriggerService : @triggerService
        DeviceService : @deviceService
      })
      @rootScope.$digest()

    it 'should call the deviceService.getDevice', ->
      expect(@deviceService.getDevice).to.have.been.calledWith 'uuid', 'token'

    it 'should call the triggerService.getTriggers', ->
      expect(@triggerService.getTriggers).to.have.been.calledWith 'uuid', 'token', 'owner-uuid'

    describe 'when triggerService.getTriggers resolves with a list of triggers', ->
      beforeEach ->
        @triggers = [
            flow: 1
            id: 'sdlkfj'
            name: 'calico'
          ,
            flow: 2
            id: 'ssdf'
            name: 'tabby'
          ]
        @getTriggers.resolve @triggers

      it 'should set a triggers property with the list of triggers', ->
        @rootScope.$digest()
        expect(@sut.triggers).to.deep.equal @triggers

      it 'should set triggersLoaded to true', ->
        @rootScope.$digest()
        expect(@sut.triggersLoaded).to.be.true

    describe 'when triggerService.getTriggers resolves with no triggers', ->
      beforeEach ->
        @triggers = []
        @noFlows = true
        @getTriggers.resolve @triggers

      it 'should set the noFlows property to true', ->
        @rootScope.$digest()
        expect(@sut.noFlows).to.be.true

    describe 'when triggerService.getTriggers rejects the promise', ->
      beforeEach ->
        @getTriggers.reject new Error 'ERROR WILL ROBINSON ERROR'

      it 'should have an errorMsg property', ->
        @rootScope.$digest()
        expect(@sut.errorMessage).to.equal 'ERROR WILL ROBINSON ERROR'

      it 'should not redirect to login property', ->
        @rootScope.$digest()
        expect(@location.path).not.to.have.been.called

  describe 'when the user has a valid uuid but does not have a token', ->
    beforeEach ->
      @sut = @controller 'HomeController',
        $cookies: {token: undefined}
        $location: @location
        $routeParams: {uuid: 1}
        DeviceService:  {}
        TriggerService: {}

    it 'should redirect the user to the register page', ->
      expect(@location.path).to.have.been.calledWith '/1/login'

  describe 'when deviceService rejects on getDevice', ->
    beforeEach ->
      @deviceService = getDevice: sinon.stub().returns @q.reject(new Error('Unauthorized'))
      @sut = @controller 'HomeController',
        $cookies: {token: 'what goes up, must come DEAD'}
        $location: @location
        $routeParams: {uuid: 'ascension'}
        DeviceService:  @deviceService
        TriggerService: {}
      @rootScope.$digest()

    it 'should redirect the user to the register page', ->
      expect(@location.path).to.have.been.calledWith '/ascension/login'

  describe 'when deviceService rejects a different device on getDevice', ->
    beforeEach ->
      @deviceService = getDevice: sinon.stub().returns @q.reject(new Error('Unauthorized'))
      @sut = @controller 'HomeController',
        $cookies: {token: 'Awwww yeeeaahhurkghf'}
        $location: @location
        $routeParams: {uuid: 'sex-injury'}
        DeviceService:  @deviceService
        TriggerService: {}
      @rootScope.$digest()

    it 'should redirect the user to the register page', ->
      expect(@location.path).to.have.been.calledWith '/sex-injury/login'

