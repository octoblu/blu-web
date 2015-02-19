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
    beforeEach ->
      @messageTriggerUrl = 'https://meshblu.octoblu.com/messages'
    it 'should exist', ->
      expect(@sut.trigger).to.exist

  describe 'when it is called with a uuid and token present', ->
    beforeEach ->
      @uuid = 1
      @token = 2
      @trigger = flow: 1, uuid: 2, name: 3

    it 'should message meshblu using those credentials and data', ->
      @httpBackend.expectPOST(@messageTriggerUrl, {
          headers:
            meshblu_auth_uuid: @uuid
            meshblu_auth_token: @token
          data:
            devices: @trigger.flow
            topic: 'button'
            payload:
              from: @trigger.uuid
        }
      ).respond()
      @sut.trigger @trigger.flow, @trigger.uuid, @uuid, @token
      @httpBackend.flush()

  describe '->getTriggers', ->
    it 'should exist', ->
      expect(@sut.getTriggers).to.exist

    describe 'when getTriggers is called with a uuid and token present', ->
      beforeEach ->
        @flowSearchUrl = 'https://meshblu.octoblu.com/devices?type=octoblu:flow'
        @uuid = 1
        @token = 2

      it 'should query meshblu using those credentials', ->
        @httpBackend.expectGET(@flowSearchUrl, (headers)=>
          expect(headers.meshblu_auth_uuid).to.equal @uuid
          expect(headers.meshblu_auth_token).to.equal @token
        ).respond()
        @sut.getTriggers(@uuid, @token)
        @httpBackend.flush()

      it 'should have the query parameter type=octoblu:flow', ->
        @httpBackend.expectGET(@flowSearchUrl, (headers)=>
          expect(headers.meshblu_auth_uuid).to.equal @uuid
          expect(headers.meshblu_auth_token).to.equal @token
        ).respond()
        @sut.getTriggers(@uuid, @token)
        @httpBackend.flush()

      describe 'when meshblu returns some flows', ->
        beforeEach ->
          @flow1 = {
            flow: [
              { type: 'trigger', name: 'Women Trigger', uuid: 1234 }
              { type: 'bacon', uuid: 4321 }
              { type: 'not-something-important', uuid: 2341 }
            ],
            uuid: 6789
          }
          @httpBackend.expectGET(@flowSearchUrl).respond devices: [ @flow1 ]

        it 'should return a list containing one trigger', ->
          @sut.getTriggers(@uuid, @token).then (triggers) =>
            expect(triggers.length).to.equal 1
          @httpBackend.flush()

        it 'should return a correctly formatted trigger', ->
          @sut.getTriggers(@uuid, @token).then (triggers) =>
            expect(triggers).to.deep.equal [{flow: 6789, name: 'Women Trigger', uuid: 1234 }]
          @httpBackend.flush()

      describe 'when meshblu returns a different flow', ->
        beforeEach ->
          @flow1 = {
            flow: [
              { type: 'bacon', uuid: 12345 }
              { type: 'trigger', name: 'Monster Trigger', uuid: 128937 }
              { type: 'not-something-important', uuid: 90123 }
            ],
            uuid: 1589
          }
          @httpBackend.expectGET(@flowSearchUrl).respond devices: [ @flow1 ]

        it 'should return a correctly formatted trigger', ->
          @sut.getTriggers(@uuid, @token).then (triggers) =>
            expect(triggers).to.deep.equal [{flow: 1589, name: 'Monster Trigger', uuid: 128937 }]
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



