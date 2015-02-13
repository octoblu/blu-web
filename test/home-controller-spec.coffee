describe 'HomeController', ->
  beforeEach ->
    module 'blu'

    inject ($controller) ->
      @authenticatorService = {}
      @routeParams = {}
      @sut = $controller('HomeController', {
        AuthenticatorService: @authenticatorService,
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
      @authenticatorService.authenticate = sinon.stub()

    it 'should call authenticatorService.authenticate with the uuid and pin entered', ->
      @routeParams.uuid = @uuidsAndPins[0].uuid
      @sut.login @uuidsAndPins[0].pin
      expect(@authenticatorService.authenticate).to.have.been.calledWith @uuidsAndPins[0].uuid, @uuidsAndPins[0].pin

    it 'should call authenticatorService.authenticate with the uuid and pin entered', ->
      @routeParams.uuid = @uuidsAndPins[1].uuid
      @sut.login @uuidsAndPins[1].pin
      expect(@authenticatorService.authenticate).to.have.been.calledWith @uuidsAndPins[1].uuid, @uuidsAndPins[1].pin
