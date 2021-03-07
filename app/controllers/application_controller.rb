class ApplicationController < ActionController::API

  def respond
    render json: ResponseService.new.(), head: :ok
  end
end
