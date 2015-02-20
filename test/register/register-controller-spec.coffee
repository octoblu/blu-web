describe 'RegisterController', ->
  beforeEach ->
    module 'blu'

    inject ($controller, $q, $rootScope) ->
      @q = $q
      @rootScope = $rootScope

  describe 'when the user has no existing session', ->
    beforeEach ->
      inject ($controller, $rootScope) ->
        @location = path: sinon.stub()
        @authenticatorService = registerWithPin: sinon.stub()
        @cookies = {}
        @sut = $controller 'RegisterController',
          $cookies: @cookies
          $location: @location
          AuthenticatorService: @authenticatorService

    describe 'when authenticatorService rejects its promise', ->
      beforeEach ->
        @authenticatorService.registerWithPin.returns @q.reject(new Error('oh no'))

      it "should tell the user that it couldn't register a device", ->
        @sut.register '1234'
        @rootScope.$digest()
        expect(@sut.errorMessage).to.equal 'Unable to register a new device. Please try again.'

    describe 'when registerWithPin fulfills its promise with shock', ->
      beforeEach ->
        @authenticatorService.registerWithPin.returns @q.when(uuid: 'shock', token: 'and-aww-yeah')

      describe 'when called with the pin 1234', ->
        beforeEach ->
          @sut.register '1234'
          @rootScope.$digest()

        it 'should call authenticatorService registerWithPin with the pin', ->
          expect(@authenticatorService.registerWithPin).to.have.been.calledWith '1234'

        it 'should not have an error', ->
          expect(@sut.error).to.not.exist

        it 'should set the uuid in the cookies', ->
          expect(@cookies.uuid).to.equal 'shock'

        it 'should set the uuid in the cookies', ->
          expect(@cookies.token).to.equal 'and-aww-yeah'

    describe 'when registerWithPin fulfills their promise', ->
      beforeEach ->
        @authenticatorService.registerWithPin.returns @q.when(uuid: 'slow-turning-windmill', token: 'how-quixotic')

      describe 'when called with the pin 6543', ->
        beforeEach ->
          @sut.register '6543'
          @rootScope.$digest()

        it 'should call authenticatorService registerWithPin with the pin', ->
          expect(@authenticatorService.registerWithPin).to.have.been.calledWith '6543'

        it 'should set the uuid in the cookies', ->
          expect(@cookies.uuid).to.equal 'slow-turning-windmill'

        it 'should set the token in the cookies', ->
          expect(@cookies.uuid).to.equal 'slow-turning-windmill'

        it 'should redirect the user to the home page', ->
          expect(@location.path).to.have.been.calledWith '/slow-turning-windmill'


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

