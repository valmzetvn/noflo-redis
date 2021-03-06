noflo = require 'noflo'
{RedisComponent} = require '../lib/RedisComponent.coffee'

class Get extends RedisComponent
  constructor: ->
    @inPorts =
      key: new noflo.Port
    @outPorts =
      out: new noflo.Port
      error: new noflo.Port

    super()

  doAsync: (key, callback) ->
    unless @redis
      callback new Error 'No Redis connection available'
      return

    @redis.get key, (err, reply) =>
      return callback err if err
      return callback new Error 'No value' if reply is null
      @outPorts.out.beginGroup key
      @outPorts.out.send reply
      @outPorts.out.endGroup()
      @outPorts.out.disconnect()
      callback()

exports.getComponent = -> new Get
