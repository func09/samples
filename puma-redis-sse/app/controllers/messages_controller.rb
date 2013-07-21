require 'reloader/sse'
class MessagesController < ApplicationController

  include ActionController::Live

  def index
    @messages = Message.all
  end

  def create
    permited = params.require(:message).permit(:room_id, :name, :content)
    @message = Message.create(permited)
    $redis.publish('messages.create', @message.to_json)
    render nothing: true
  end

  # def events
  #   response.headers['Content-Type'] = 'text/event-stream'
  #   sse = Reloader::SSE.new(response.stream)
  #   begin
  #     loop do
  #       data = {
  #         time: Time.now
  #       }
  #       logger.debug data
  #       sse.write(data, event: 'messages.create')
  #       sleep 1
  #     end
  #     # render nothing: true
  #   rescue IOError
  #     # Client disconnected
  #     logger.debug 'disconnected'
  #   ensure
  #     sse.close
  #   end
  # end
  def events
    logger.debug 'start events'
    response.headers['Content-Type'] = 'text/event-stream'
    sse = Reloader::SSE.new(response.stream)
    redis = Redis.new
    redis.subscribe('messages.create') do |on|
      on.message do |event, data|
        sse.write(data, event: 'messages.create')
      end
    end
    render nothing: true
  rescue IOError
    logger.debug 'disconnected'
  ensure
    logger.debug 'ensured'
    redis.quit
    sse.close
  end
end
