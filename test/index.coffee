espeak = require '../index'
assert = require 'assert'

describe 'espeak', ->
  it 'should work', (done) ->
    espeak.speak 'test', (err, wav) ->
      assert.ifError err
      assert.equal typeof wav, 'object'
      assert.ok wav.buffer
      assert.ok wav.toDataUri()
      done()
      
  it 'should be able to add additional arguments', (done) ->
    args = ['-p 60', '-s 90']
    espeak.speak 'test', args, (err, wav) ->
      assert.ifError err
      assert.equal typeof wav, 'object'
      assert.ok wav.buffer
      assert.ok wav.toDataUri()
      done()
      
  it 'should be able to set cmd path', ->
    assert.equal espeak.cmd, 'espeak'
    espeak.cmd = '/usr/bin/espeak'
    assert.equal espeak.cmd, '/usr/bin/espeak'
