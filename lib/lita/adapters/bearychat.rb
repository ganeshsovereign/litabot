require 'lita'
require "lita/adapters/bearychat/rtm_connection"

module Lita
  module Adapters

    class Bearychat < Adapter
      config :token, type: String, required: true

      attr_reader :rtm_connection

      def run
        @rtm_connection = RTMConnection.new(config) unless rtm_connection
        robot.trigger(:connected)
        sleep
      end

      def send_messages(target, messages)
        messages.each do |message|
          rtm_connection.send(target, message)
        end
      end

      def shut_down;end
    end

    Lita.register_adapter(:bearychat, Bearychat)
  end
end
