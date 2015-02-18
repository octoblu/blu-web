describe 'AuthenticatorService', ->
  beforeEach ->
    module 'blu', ($provide) =>
      return

    inject ($rootScope, AuthenticatorService) =>
      @rootScope = $rootScope
      @sut = AuthenticatorService

  it 'should exist', ->
    expect(@sut).to.exist

  describe '->registerWithPin', ->
    describe 'when called', ->
      beforeEach ->
        @sut.registerWithPin().then (@result) =>
        @rootScope.$digest()

      it 'should return an object with a uuid of "sawblade"', ->
        expect(@result.uuid).to.equal 'sawblade'

    
  
