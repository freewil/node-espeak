{spawn} = require 'child_process'
cmd = 'espeak'

speak = (text, args..., cb) ->
  args = if args.length then args[0] else []

  cbCalled = false
  buffers = []
  buffersLength = 0
  
  argsDefault = ['--stdin', '--stdout']
  args = args.concat argsDefault
  espeak = spawn cmd, args
  espeak.stdout.on 'error', (e) ->
    if not cbCalled
      cbCalled = true
      cb e
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
  espeak.stdin.end text

class Wav
  constructor: (@buffer) ->
  toDataUri: ->
    return 'data:audio/x-wav;base64,' + @buffer.toString 'base64'

module.exports =
  speak: speak
  cmd: cmd