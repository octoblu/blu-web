describe 'HomeController', ->
  beforeEach ->
    module 'blu'

    inject ($controller, $q, $rootScope) ->
      @q = $q
      @rootScope = $rootScope
      @authenticatorService = {}
      @routeParams = {}
      @meshbluService = {}
      @sut = $controller('HomeController', {
        AuthenticatorService: @authenticatorService,
        MeshbluService : @meshbluService,
        $routeParams : @routeParams
      })

  beforeEach ->
  it 'should exist', ->
    expect(@sut).to.exist

  it 'should have a function called login', ->
    expect(@sut.login).to.exist

  describe 'when login is called with a pin', ->
    beforeEach ->
      @uuidsAndPins = [
        {
          uuid : 'U1'
          pin : '12345'
        }
        {
          uuid: 'U2'
          pin: '54321'
        }
      ]
      @authenticatorService.authenticate = sinon.stub().returns @q.when()

    it 'should call authenticatorService.authenticate with the uuid and pin entered', ->
      @routeParams.uuid = @uuidsAndPins[0].uuid
      @sut.login @uuidsAndPins[0].pin
      expect(@authenticatorService.authenticate).to.have.been.calledWith @uuidsAndPins[0].uuid, @uuidsAndPins[0].pin

    it 'should call authenticatorService.authenticate with the uuid and pin entered', ->
      @routeParams.uuid = @uuidsAndPins[1].uuid
      @sut.login @uuidsAndPins[1].pin
      expect(@authenticatorService.authenticate).to.have.been.calledWith @uuidsAndPins[1].uuid, @uuidsAndPins[1].pin

    describe 'when authenticatorService->authenticate() resolves a token', ->
      beforeEach ->
        @token = 'awesomeness'
        @authenticatorService.authenticate.returns @q.when(@token)
        @meshbluService.getTriggers = sinon.stub().returns @q.when()

      it 'should set the session token on the meshblu service', ->
        @sut.login @uuidsAndPins[1].pin
        @rootScope.$digest()
        expect(@meshbluService.token).to.equal @token

      it 'should set uuid on the meshblu service', ->
        @routeParams.uuid = @uuidsAndPins[1].uuid
        @sut.login @uuidsAndPins[1].pin
        @rootScope.$digest()
        expect(@meshbluService.uuid).to.equal @routeParams.uuid

      it 'should call meshbluService->getTriggers()', ->
        @sut.login @uuidsAndPins[1].pin
        @rootScope.$digest()
        expect(@meshbluService.getTriggers).to.have.been.called

      describe 'when meshbluService.getTriggers returns some triggers', ->
        beforeEach ->
          @triggers = [
            { type: 'rifle' }
            { type: 'hair' }
          ]
          @meshbluService.getTriggers.returns @q.when(@triggers)

        it 'should add those triggers to the scope', ->
          @sut.login @uuidsAndPins[1].pin
          @rootScope.$digest()
          expect(@sut.triggers).to.deep.equal @triggers

    describe 'when authenticatorService->authenticate() rejects its promise', ->
      beforeEach ->
        @message = 'Error: pin is invalid'
        @authenticatorService.authenticate.returns @q.reject new Error @message

      it 'should add the error message to itself so the user can see it', ->
        @sut.login @uuidsAndPins[1].pin
        @rootScope.$digest()
        expect(@sut.error).to.equal @message

    describe 'when authenticatorService->authenticate() resolves a different token', ->
      beforeEach ->
        @token = 'supercool'
        @authenticatorService.authenticate.returns(@q.when(@token))
        @meshbluService.getTriggers = sinon.stub().returns @q.when()

      it 'should set the session token on the meshblu service', ->
        @sut.login @uuidsAndPins[1].pin
        @rootScope.$digest()
        expect(@meshbluService.token).to.equal @token

      it 'should set uuid on the meshblu service', ->
        @routeParams.uuid = @uuidsAndPins[0].uuid
        @sut.login @uuidsAndPins[0].pin
        @rootScope.$digest()
        expect(@meshbluService.uuid).to.equal @routeParams.uuid

    describe '->triggerTheTrigger', ->
      it 'should be a function', ->
        expect(@sut.triggerTheTrigger).to.be.a 'function'

      describe 'when triggerTheTrigger is called with a trigger', ->
        beforeEach ->
          @trigger = type: 'finger', flow: 'Yo', uuid: 'goooeyid'

        it 'should call meshbluService.trigger with the flow id and trigger id', ->
          @sut.triggerTheTrigger @trigger
          expect(@meshbluService.trigger).to.have.been.calledWith @trigger.flow, @trigger.uuid
