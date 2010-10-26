#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class StatusMessagesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html
  respond_to :json, :only => :show

  def create
    public_flag = params[:status_message][:public]
    public_flag.match(/(true)/) ? public_flag = true : public_flag = false
    params[:status_message][:public] = public_flag 

    data = clean_hash params[:status_message]
    message = params[:status_message][:message]
    status_message = current_user.post(:status_message, data)
    render :nothing => true
  end

  def destroy
    @status_message = current_user.find_visible_post_by_id params[:id]
    @status_message.destroy
    respond_with :location => root_url
  end

  def show
    @status_message = current_user.find_visible_post_by_id params[:id]
    respond_with @status_message
  end

  private
  def clean_hash(params)
    return {
      :message => params[:message],
      :to      => params[:to],
      :public  => params[:public]
    }
  end
end
