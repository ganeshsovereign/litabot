require 'json'
require 'bearychat'

class RTMConnection
  attr_reader :rtm

  def initialize(config)
    @rtm = ::Bearychat.rtm(config.token)
  end

  def send(target, message)
    rtm.send pack_msg_data(target, message)
  end

  private
  def pack_msg_data(target, message)
    {
      vchannel: target.room,
      text: message
    }
  end

end
