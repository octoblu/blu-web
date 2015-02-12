describe 'HomeController', ->
  beforeEach ->
    module 'blu'

    inject ($controller, $rootScope, $location) ->
      @rootScope = $rootScope
      @scope = $rootScope.$new()
      @fakeLocation = new FakeLocation()

      @sut = $controller('HomeController', {
        $rootScope: @rootScope
        $scope : @scope
        $location: @fakeLocation
      })

  beforeEach ->
  it 'should exist', ->
    expect(@sut).to.exist

  it 'should add a login function to the scope', ->
    expect(@scope.login).to.exist

  it 'should add a register function to the scope', ->
    expect(@scope.register).to.exist

  describe 'when login is called', ->
    beforeEach ->
      @scope.login()
    it 'should call $location.path', ->
      expect(@fakeLocation.path).to.have.been.called
    it 'should call $location.path with the login route', ->
      expect(@fakeLocation.path).to.have.been.calledWith '/login'

  describe 'when register is called', ->
    beforeEach ->
      @scope.register()
    it 'should call $location.path', ->
      expect(@fakeLocation.path).to.have.been.called
    it 'should call $location.path with the register route', ->
      expect(@fakeLocation.path).to.have.been.calledWith '/register'



class FakeLocation
  constructor: ()->
   @path = sinon.stub()
