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
        TriggerService : @triggerService,
        DeviceService : @deviceService,
        $cookies: {uuid: 'uuid', token: 'token'},
        $location: @location
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
        @error = 'ERROR WILL ROBINSON ERROR'
        @getTriggers.reject @error
        
      it 'should have an errorMsg property', ->
        @rootScope.$digest()
        expect(@sut.errorMsg).to.deep.equal @error

  describe 'when the user does not have a valid uuid', ->
    beforeEach ->
      @sut = @controller('HomeController', {
          TriggerService : @triggerService,
          $cookies: {},
          $location: @location

        })
    it 'should redirect the user to the register page', ->
      expect(@location.path).to.have.been.calledWith '/'

  describe 'when the user has a valid uuid but does not have a valid token', ->
    beforeEach ->
      @sut = @controller('HomeController', {
        TriggerService : @triggerService,
        $cookies: {uuid: 1, token: undefined},
        $location: @location
      })
    it 'should redirect the user to the register page', ->
      expect(@location.path).to.have.been.calledWith '/1/login'










