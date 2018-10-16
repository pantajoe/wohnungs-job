class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :enable_pry
  before_action :set_raven_context

  private

  # This before_action enables pry for the next request,
  # if it was disabled by `disable-pry`
  # See https://github.com/pry/pry/wiki/FAQ#wiki-disable_pry
  def enable_pry
    return if Rails.env.production?

    ENV['DISABLE_PRY'] = nil
  end

  def set_raven_context
    Raven.user_context(id: session[:current_user_id]) # or else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
