class RepliesController < ApplicationController
  before_filter :require_user, :only => [:create]
  before_filter :authorize, :only => [:edit, :update]

  def create
    @topic = Topic.find params[:topic_id]
    @reply = @topic.create_reply current_user, params[:reply]

    if @reply.valid?
      redirect_to reply_path(@reply)
    else
      render :new
    end
  end

  def show
    reply = find_reply

    redirect_to topic_path(reply.topic_id, :page => reply.page_in_topic, :anchor => "reply_#{reply.id}")
  end

  def edit
    @reply = find_reply
  end

  def update
    @reply = find_reply

    if @reply.update_attributes params[:reply]
      redirect_to reply_path(@reply)
    else
      render :edit
    end
  end

  private

  def find_reply
    Reply.find params[:id]
  end

  def authorize
    deny_access unless can_edit? find_reply
  end
end
