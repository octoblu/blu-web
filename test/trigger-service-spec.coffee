describe 'TriggerService', =>
  beforeEach ->
    module 'blu', ($provide) =>
      return

    inject (_$httpBackend_, TriggerService) =>
      @httpBackend = _$httpBackend_
      @sut = TriggerService

  it 'should exist', ->
    expect(@sut).to.exist

  describe '->trigger', ->
    it 'should exist', ->
      expect(@sut.trigger).to.exist

    describe 'when it is called with a uuid and token present', ->
      it 'should message meshblu using those credentials and data', ->
        @httpBackend.expectPOST('https://meshblu.octoblu.com/messages', {
            devices: ['flow-uuid']
            topic: 'button'
            payload:
              from: 'trigger-id'
          },{
            meshblu_auth_uuid:  'device-uuid'
            meshblu_auth_token: 'device-token'
            Accept:         "application/json, text/plain, */*"
            "Content-Type": "application/json;charset=utf-8"
          }
        ).respond()
        @sut.trigger 'flow-uuid', 'trigger-id', 'device-uuid', 'device-token'
        @httpBackend.flush()

  describe '->getTriggers', ->
    it 'should exist', ->
      expect(@sut.getTriggers).to.exist

    describe 'when getTriggers is called with a uuid and token', ->
      it 'should query meshblu using those credentials', ->
        @httpBackend.expectGET('https://meshblu.octoblu.com/devices?type=octoblu:flow', (headers)=>
          expect(headers.meshblu_auth_uuid).to.equal  'device-uuid'
          expect(headers.meshblu_auth_token).to.equal 'device-token'
        ).respond()
        @sut.getTriggers('device-uuid', 'device-token')
        @httpBackend.flush()

      describe 'when meshblu returns some flows', ->
        beforeEach ->
          flow = {
            flow: [
              { type: 'trigger', name: 'Women Trigger', id: 1234 }
              { type: 'bacon', id: 4321 }
              { type: 'not-something-important', id: 2341 }
            ],
            uuid: 6789
          }
          @httpBackend.expectGET('https://meshblu.octoblu.com/devices?type=octoblu:flow').respond devices: [ flow ]

        it 'should return a list containing one trigger', ->
          @sut.getTriggers(null, null).then (triggers) =>
            expect(triggers.length).to.equal 1
          @httpBackend.flush()

        it 'should return a correctly formatted trigger', ->
          @sut.getTriggers(null, null).then (triggers) =>
            expect(triggers).to.deep.equal [{flow: 6789, name: 'Women Trigger', id: 1234 }]
          @httpBackend.flush()

      describe 'when meshblu returns a different flow', ->
        beforeEach ->
          flow = {
            flow: [
              { type: 'bacon', id: 12345 }
              { type: 'trigger', name: 'Monster Trigger', id: 128937 }
              { type: 'not-something-important', id: 90123 }
            ],
            uuid: 1589
          }
          @httpBackend.expectGET('https://meshblu.octoblu.com/devices?type=octoblu:flow').respond devices: [ flow ]

        it 'should return a correctly formatted trigger', ->
          @sut.getTriggers(@uuid, @token).then (triggers) =>
            expect(triggers).to.deep.equal [{flow: 1589, name: 'Monster Trigger', id: 128937 }]
          @httpBackend.flush()


    describe 'when getTriggers is called with a different uuid and token present', ->
      beforeEach ->
        @uuid = 'What?'
        @token = 'I\'m Hungry'

      it 'should query meshblu using those credentials', ->
        @httpBackend.expectGET(@flowSearchUrl, (headers)=>
          expect(headers.meshblu_auth_uuid).to.equal @uuid
          expect(headers.meshblu_auth_token).to.equal @token
        ).respond()
        @sut.getTriggers @uuid, @token
        @httpBackend.flush()



