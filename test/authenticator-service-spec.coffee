describe 'AuthenticatorService', ->
  beforeEach ->
    module 'blu', =>
      return

    inject ($httpBackend, $rootScope, AuthenticatorService) =>
      @rootScope = $rootScope
      @httpBackend = $httpBackend
      @sut = AuthenticatorService

  it 'should exist', ->
    expect(@sut).to.exist

  describe '->registerWithPin', ->
    beforeEach ->
      @pinUrl = 'https://pin.octoblu.com/devices'

    describe 'when called', ->

      it 'should post to pin.octoblu.com with the pin and the device type', ->
        @httpBackend.expectPOST(@pinUrl, {
            pin: '12345'
            device:
              type: 'blu'
          }
        ).respond()

        @sut.registerWithPin '12345'
        @httpBackend.flush()

      it 'should post to pin.octoblu.com with the pin and the device type', ->
        @httpBackend.expectPOST(@pinUrl, {
            pin: '12345 stop it hurts aaaaaaaagh'
            device:
              type: 'blu'
          }
        ).respond()

        @sut.registerWithPin '12345 stop it hurts aaaaaaaagh'
        @httpBackend.flush()

      it 'should return the uuid sent by the server', ->
         @uuid = 'Erik Loves Copy and Paste'
         @httpBackend.expectPOST(@pinUrl).respond uuid: @uuid
         @sut.registerWithPin('what does Erik love?').then (@result) =>
         @httpBackend.flush()

         expect(@result.uuid).to.equal @uuid

      it 'should return the uuid sent by the server', ->
         @uuid = 'Aaron Want to Marry Copy and Paste'
         @httpBackend.expectPOST(@pinUrl).respond uuid: @uuid
         @sut.registerWithPin('what does Aaron want?').then (@result) =>
         @httpBackend.flush()

         expect(@result.uuid).to.equal @uuid

  describe '->authenticate', ->

    describe 'when it is called with a uuid and pin', ->
      beforeEach ->
        @uuid = 'copy-and-paste-4-ever'
        @pin = 'Erik thinks so'
        @authenticateUrl = "https://pin.octoblu.com/devices/#{@uuid}/sessions"

      it 'should call the authenticate url for that uuid with the pin', ->
        @httpBackend.expectPOST(@authenticateUrl,
          pin: @pin
        ).respond()
        @sut.authenticate @uuid, @pin
        @httpBackend.flush()
