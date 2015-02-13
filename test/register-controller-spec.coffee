describe 'RegisterController', ->
  beforeEach ->
    module 'blu'

    inject ($controller, $rootScope) ->
      @scope = $rootScope.$new()
      @meshbluService = new MeshbluService()

      @sut = $controller('RegisterController', {
        $rootScope: @rootScope
        $scope : @scope
        meshbluService: @meshbluService
      })

  beforeEach ->
  it 'should exist', ->
    expect(@sut).to.exist


  it 'should add a register function to the scope', ->
    expect(@scope.register).to.exist

  xdescribe 'when register is called', ->
    beforeEach ->
      @scope.register()
    it 'should call $location.path', ->
      expect(@fakeLocation.path).to.have.been.called
    it 'should call $location.path with the register route', ->
      expect(@fakeLocation.path).to.have.been.calledWith '/register'



class MeshbluService
  constructor: ()->
   @path = sinon.stub()
