describe 'LoginController', ->
  beforeEach ->
    module 'blu'

    inject ($controller, $q, $rootScope) ->
      @q = $q
      @authenticatorService = {}
      @location = {}
      @rootScope = $rootScope
      @location = { path: sinon.spy() }
      @cookies = {}
      @sut = $controller('LoginController', {
        AuthenticatorService: @authenticatorService
        $location : @location
        $cookies : @cookies
        $routeParams: {}
      })

  describe '->login', ->
    describe 'when login is called with a pin', ->
      beforeEach ->
        @authenticatorService.authenticate = sinon.stub().returns @q.when()

      it 'should call authenticatorService.authenticate with the uuid and pin entered', ->
        @sut.login 'U1', '12345'
        expect(@authenticatorService.authenticate).to.have.been.calledWith 'U1', '12345'

      it 'should call authenticatorService.authenticate with the uuid and pin entered', ->
        @sut.login 'U2', '54321'
        expect(@authenticatorService.authenticate).to.have.been.calledWith 'U2', '54321'

      describe 'when authenticatorService->authenticate() resolves a token', ->
        beforeEach ->
          @authenticatorService.authenticate.returns @q.when('awesomeness')

        it 'should set the session token cookie', ->
          @sut.login 'U1', '54321'
          @rootScope.$digest()
          expect(@cookies.token).to.equal 'awesomeness'

        it 'should set the uuid cookie', ->
          @sut.login 'U1', '54321'
          @rootScope.$digest()
          expect(@cookies.uuid).to.equal 'U1'

        it 'should set the uuid cookie', ->
          @sut.login 'Stop repeating yourself', '54321'
          @rootScope.$digest()
          expect(@cookies.uuid).to.equal 'Stop repeating yourself'

        it 'should redirect to the home for this device', ->
          @sut.login 'Stop repeating yourself', '54321'
          @rootScope.$digest()
          expect(@location.path).to.have.been.calledWith '/Stop repeating yourself'

        it 'should redirect to the home for this device', ->
          @sut.login 'Repete', '54321'
          @rootScope.$digest()
          expect(@location.path).to.have.been.calledWith '/Repete'

      describe 'when authenticatorService->authenticate() resolves a different token', ->
        beforeEach ->
          @authenticatorService.authenticate.returns @q.when('supercool')
          @triggerService.getTriggers = sinon.stub().returns @q.when()

        it 'should store the token on in the cookies', ->
          @sut.login 'U1','54321'
          @rootScope.$digest()
          expect(@cookies.token).to.equal 'supercool'

      describe 'when authenticatorService->authenticate() rejects its promise', ->
        beforeEach ->
          @message = 'Error: pin is invalid'
          @authenticatorService.authenticate.returns @q.reject new Error @message

        it 'should add the error message to itself so the user can see it', ->
          @sut.login 'U1', '1337'
          @rootScope.$digest()
          expect(@sut.error).to.equal @message
