{spawn} = require 'child_process'

speak = (text, args..., cb) ->
  args = if args.length then args[0] else []

  cbCalled = false
  buffers = []
  buffersLength = 0
  
  argsDefault = ['--stdin', '--stdout']
  args = args.concat argsDefault
  espeak = spawn module.exports.cmd, args
  espeak.stderr.on 'data', (buffer) ->
    if not cbCalled
      cbCalled = true
      cb new Error "Failed to spawn eSpeak, make sure it's installed and espeak.cmd is set properly"
  espeak.stdout.on 'data', (buffer) ->
    buffers.push buffer
    buffersLength += buffer.length
  espeak.stdout.on 'end', ->
    if not cbCalled
      cbCalled = true
      
      # concat all the buffers into one buffer
      # this can be replaced with Buffer.concat() in node v0.8.x
      buffer = new Buffer buffersLength
      targetStart = 0
      for b in buffers
        b.copy buffer, targetStart
        targetStart += b.length
        
      cb null, new Wav buffer
  espeak.stdin.on 'error', (e) ->
    # handle EPIPE errors in stderr 'data' event
    return if e.code is 'EPIPE'
    throw e
      
  espeak.stdin.end text

class Wav
  constructor: (@buffer) ->
  toDataUri: ->
    return 'data:audio/x-wav;base64,' + @buffer.toString 'base64'

module.exports =
  speak: speak
  cmd: 'espeak'
