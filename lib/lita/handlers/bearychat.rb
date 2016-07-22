require "json"

module Lita
  module Handlers
    class Bearychat < Handler
      INNEED_PARAMS = %w{ subdomain sender vchannel username text }
      config :token

      http.post '/bearychat' do |request, response|
        params = JSON.parse(request.body.read)
        if params['token'] != config.token
          response.status = 401
        else
          subdomain, sender, vchannel, username, text = params.values_at(*INNEED_PARAMS)
          # Creates a new room with the given ID, or merges and saves supplied
          user = Lita::User.create(sender, {
            name: username,
            subdomain: subdomain
          })
          source = Lita::Source.new(user: user, room: vchannel)
          message = Lita::Message.new(robot, format_text(text.to_s), source)
          robot.receive(message)
        end
        response.finish
      end

      private
      def format_text(text)
        mention_string = "@#{robot.mention_name}"
        text.index(mention_string) ? text : "#{mention_string} #{text}"
      end

    end
    Lita.register_handler(Bearychat)
  end
end
