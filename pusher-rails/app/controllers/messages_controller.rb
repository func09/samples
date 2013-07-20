class MessagesController < ApplicationController
  def index
    @room_id = params[:room_id] || 1

  end
end
