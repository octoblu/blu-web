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
              online: true
          }
        ).respond()

        @sut.registerWithPin '12345'
        @httpBackend.flush()

      it 'should post to pin.octoblu.com with the pin and the device type', ->
        @httpBackend.expectPOST(@pinUrl, {
            pin: '12345 stop it hurts aaaaaaaagh'
            device:
              type: 'blu'
              online: true
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
    describe 'when the service responds with a 201', ->
      beforeEach ->
        @httpBackend.expectPOST('https://pin.octoblu.com/devices/copy-and-paste-4-ever/sessions',
          pin: 'Erik thinks so'
        ).respond(201, token: 'tolkein')

      describe 'when it is called with a uuid and pin', ->
        it 'should call the authenticate url for that uuid with the pin and respond with the token', (done) ->
          @sut.authenticate('copy-and-paste-4-ever', 'Erik thinks so').then (token) =>
            expect(token).to.equal 'tolkein'
            done()
          @httpBackend.flush()

    describe 'when the service responds with a non-201', ->
      beforeEach ->
        @httpBackend.expectPOST('https://pin.octoblu.com/devices/copy-and-paste-4-ever/sessions',
          pin: 'Erik thinks so'
        ).respond(401, 'you done screwed up')

      describe 'when it is called with a uuid and pin', ->
        it 'should reject the promise and return the error', (done) ->
          @sut.authenticate('copy-and-paste-4-ever', 'Erik thinks so').catch (error) =>
            expect(error.message).to.equal 'you done screwed up'
            done()
          @httpBackend.flush()
