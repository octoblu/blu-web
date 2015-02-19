describe 'DeviceService', ->
  beforeEach ->
    module 'blu', ($provide) =>
      return

    inject ($httpBackend, DeviceService) =>
      @sut = DeviceService
      @httpBackend = $httpBackend

  it 'should exist', ->
    expect(@sut).to.exist

  describe '->getDevice', ->
    it 'should be a function', ->   
      expect(@sut.getDevice).to.be.a 'function'

    it 'should call get device with auth headers', ->
      @httpBackend.expectGET('https://meshblu.octoblu.com/devices/uuid', {
          meshblu_auth_uuid: 'uuid'
          meshblu_auth_token: 'token'
          Accept: "application/json, text/plain, */*"
        }).respond(devices: [])

      @sut.getDevice('uuid', 'token')
      @httpBackend.flush()

    it 'should call get device with other auth headers', ->
      @httpBackend.expectGET('https://meshblu.octoblu.com/devices/not-a-uuid-probably', {
          meshblu_auth_uuid: 'not-a-uuid-probably'
          meshblu_auth_token: 'totally-a-token'
          Accept: "application/json, text/plain, */*"
        }).respond(devices: [])

      @sut.getDevice('not-a-uuid-probably', 'totally-a-token')
      @httpBackend.flush()

    it 'should call get device and return a device', ->
      @httpBackend
        .expectGET 'https://meshblu.octoblu.com/devices/not-a-uuid-probably'
        .respond {
          devices: [{foo: 'mine-shaft-inverts'}]
        }

      @sut.getDevice 'not-a-uuid-probably', 'totally-a-token'
          .then (device)=>
            expect(device).to.deep.equal {foo: 'mine-shaft-inverts'}
      @httpBackend.flush()

  
