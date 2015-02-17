describe 'TriggerService', =>
  beforeEach ->
    module 'blu', ($provide) =>
      return

    inject (_$httpBackend_, TriggerService) =>
      @httpBackend = _$httpBackend_
      @sut = TriggerService

  it 'should exist', ->
    expect(@sut).to.exist

  describe '->getTriggers', ->
    it 'should exist', ->
      expect(@sut.getTriggers).to.exist

    describe 'when getTriggers is called without a uuid and token present', ->
      it 'should throw an error, "unauthenticated"', ->
        try
          @sut.getTriggers()
        catch error
          @error = error

        expect(@error.message).to.equal "unauthenticated"

    describe 'when getTriggers is called with a uuid and token present', ->
      beforeEach ->
        @flowSearchUrl = 'meshblu.octoblu.com/devices?type=octoblu:flow'
        @sut.uuid = 1
        @sut.token = 2

      it 'should query meshblu using those credentials', ->
        @httpBackend.expectGET(@flowSearchUrl, (headers)=>
          expect(headers.meshblu_auth_uuid).to.equal @sut.uuid
          expect(headers.meshblu_auth_token).to.equal @sut.token
        ).respond()
        @sut.getTriggers()
        @httpBackend.flush()

      it 'should have the query parameter type=octoblu:flow', ->
        @httpBackend.expectGET(@flowSearchUrl, (headers)=>
          expect(headers.meshblu_auth_uuid).to.equal @sut.uuid
          expect(headers.meshblu_auth_token).to.equal @sut.token
        ).respond()
        @sut.getTriggers()
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
          @sut.getTriggers().then (triggers) =>
            expect(triggers.length).to.equal 1
          @httpBackend.flush()

        it 'should return a correctly formatted trigger', ->
          @sut.getTriggers().then (triggers) =>
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
          @sut.getTriggers().then (triggers) =>
            expect(triggers).to.deep.equal [{flow: 1589, name: 'Monster Trigger', uuid: 128937 }]
          @httpBackend.flush()


    describe 'when getTriggers is called with a different uuid and token present', ->
      beforeEach ->
        @sut.uuid = 'What?'
        @sut.token = 'I\'m Hungry'

      it 'should query meshblu using those credentials', ->
        @httpBackend.expectGET(@flowSearchUrl, (headers)=>
          expect(headers.meshblu_auth_uuid).to.equal @sut.uuid
          expect(headers.meshblu_auth_token).to.equal @sut.token
        ).respond()
        @sut.getTriggers()
        @httpBackend.flush()

