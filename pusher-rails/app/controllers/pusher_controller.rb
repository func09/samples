class PusherController < ApplicationController
  protect_from_forgery :except => :auth


  def auth
    if session[:session_id]
      response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
        user_id: session[:session_id],
        user_info: {
          name: 'user-' + rand(1000).to_s,
        }
      })
      render :json => response
    else
      render :text => "Forbidden", :status => '403'
    end
  end

end
