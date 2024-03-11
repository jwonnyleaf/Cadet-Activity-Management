# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:omniauth]

  def logout
    reset_session
    redirect_to home_path, notice: 'You are logged out.'
  end

  def omniauth
    auth = request.env['omniauth.auth']
    @user = User.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |u|
      u.email = auth['info']['email']
      names = auth['info']['name'].split
      u.first_name = names[0]
      u.last_name = names[1..].join(' ')

      # Making the default Minor Unit point to a Dummy entry
      # for the time being, since the audit system isn't up yet.
      u.unit = Unit.find_by(name: "Unassigned Unit")
    end

    if @user.valid?
      session[:user_id] = @user.id
      redirect_to user_path(@user), notice: 'You are logged in.'
    else
      redirect_to home_path, alert: 'Login failed.'
    end
  end
end
