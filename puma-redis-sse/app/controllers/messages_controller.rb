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
  #         name: 'hoge',
  #         content: 'foo',
  #       }
  #       sse.write(data, event: 'messages.create')
  #       sleep 1
  #     end
  #     # render nothing: true
  #   rescue IOError
  #     # Client disconnected
  #   ensure
  #     sse.close
  #   end
  # end
  def events
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
  ensure
    redis.quit
    sse.close
  end
end
