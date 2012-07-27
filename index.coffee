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
      cb null, new Wav Buffer.concat buffers, buffersLength
  espeak.stdin.end text

class Wav
  constructor: (@buffer) ->
  toDataUri: ->
    return 'data:audio/x-wav;base64,' + @buffer.toString 'base64'

module.exports =
  speak: speak
  cmd: cmd