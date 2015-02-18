describe 'LoginController', ->
  beforeEach ->
    module 'blu'

    inject ($controller, $q, $rootScope) ->
      @q = $q
      @authenticatorService = {}
      @location = {}
      @rootScope = $rootScope
      @cookies = {}
      @sut = $controller('LoginController', {
        AuthenticatorService: @authenticatorService
        $location : @location
        $cookies: @cookies
      })

  describe '->login', ->
    describe 'when login is called with a pin', ->
      beforeEach ->
        @authenticatorService.authenticate = sinon.stub().returns @q.when()

      it 'should call authenticatorService.authenticate with the uuid and pin entered', ->
        @cookies.uuid = 'U1'
        @sut.login '12345'
        expect(@authenticatorService.authenticate).to.have.been.calledWith 'U1', '12345'

      it 'should call authenticatorService.authenticate with the uuid and pin entered', ->
        @cookies.uuid = 'U2'
        @sut.login '54321'
        expect(@authenticatorService.authenticate).to.have.been.calledWith 'U2', '54321'

      describe 'when authenticatorService->authenticate() resolves a token', ->
        beforeEach ->
          @authenticatorService.authenticate.returns @q.when('awesomeness')

        it 'should set the session token cookie', ->
          @sut.login '54321'
          @rootScope.$digest()
          expect(@cookies.token).to.equal 'awesomeness'

      describe 'when authenticatorService->authenticate() resolves a different token', ->
        beforeEach ->
          @authenticatorService.authenticate.returns @q.when('supercool')
          @triggerService.getTriggers = sinon.stub().returns @q.when()

        it 'should store the token on in the cookies', ->
          @sut.login '54321'
          @rootScope.$digest()
          expect(@cookies.token).to.equal 'supercool'

      describe 'when authenticatorService->authenticate() rejects its promise', ->
        beforeEach ->
          @message = 'Error: pin is invalid'
          @authenticatorService.authenticate.returns @q.reject new Error @message

        it 'should add the error message to itself so the user can see it', ->
          @sut.login '1337'
          @rootScope.$digest()
          expect(@sut.error).to.equal @message
