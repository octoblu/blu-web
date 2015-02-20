describe 'RegisterController', ->
  beforeEach ->
    module 'blu'

    inject ($controller, $q, $rootScope) ->
      @q = $q
      @rootScope = $rootScope

  describe 'when the user has no existing session', ->
    beforeEach ->
      inject ($controller, $rootScope) ->
        @location = {}
        @authenticatorService = {}
        @sut = $controller 'RegisterController',
          $cookies: {}
          $location: @location
          AuthenticatorService: @authenticatorService

    describe 'when register is called', ->
    beforeEach ->
      @pin = "1234"
      @authenticatorService.registerWithPin = sinon.stub().returns @q.when()

    it 'should call have been called with the pin', ->
      @sut.register @pin
      expect(@authenticatorService.registerWithPin).to.have.been.calledWith @pin

    describe 'when called with a different pin', ->
      beforeEach ->
        @pin = "12345"
      it 'should call AuthenticatorService.registerWithPin with the new pin', ->
        @sut.register @pin
        expect(@authenticatorService.registerWithPin).to.have.been.calledWith @pin

    describe 'when authenticatorService rejects it\'s promise', ->
      beforeEach ->
        @authenticatorService.registerWithPin.returns @q.reject('oh no')

      it 'should tell the user that it couldn\'t register a device', ->
        @sut.register @pin
        @rootScope.$digest()
        expect(@sut.error).to.equal 'Unable to register a new device. Please try again.'

    describe 'when authenticatorService fulfills it\'s promise', ->
      beforeEach ->
        @deviceUUID = "b7d08bd0-5360-432c-9fd0-998fea6b802f"
        @loginPath = "/#{@deviceUUID}/login"
        @authenticatorService.registerWithPin.returns @q.when(uuid : @deviceUUID )
        @location.path = sinon.stub()

      it 'should redirect the user to the home location', ->
        @sut.register @pin
        @rootScope.$digest()
        expect(@location.path).to.have.been.calledWith @loginPath

      it 'should not have an error', ->
        @sut.register @pin
        @rootScope.$digest()
        expect(@sut.error).to.not.exist

    describe 'when authenticatorService fulfills it\'s promise', ->
      beforeEach ->
        @deviceUUID = "6f920317-72dd-40c0-ac03-7955b805dab0"
        @loginPath = "/#{@deviceUUID}/login"
        @authenticatorService.registerWithPin.returns @q.when(uuid : @deviceUUID )
        @location.path = sinon.stub()

      it 'should redirect the user to the home location', ->
        @sut.register @pin
        @rootScope.$digest()
        expect(@location.path).to.have.been.calledWith @loginPath

  describe 'when the user has an existing session', ->
    beforeEach ->
      @location = path: sinon.spy()

      inject ($controller, $rootScope) =>
        @sut = $controller 'RegisterController',
          $cookies: 
            uuid:  'some-uuid'
            token: 'some-token'
          $location: @location
          AuthenticatorService: {}

    it 'should call location.path', ->
      expect(@location.path).to.have.been.calledWith '/some-uuid'

  describe 'when a different user has an existing session', ->
    beforeEach ->
      @location = path: sinon.spy()

      inject ($controller, $rootScope) =>
        @sut = $controller 'RegisterController',
          $cookies: 
            uuid:  'voracious-animals'
            token: 'token'
          $location: @location
          AuthenticatorService: {}

    it 'should call location.path', ->
      expect(@location.path).to.have.been.calledWith '/voracious-animals'

