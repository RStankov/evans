# encoding: utf-8
class TopicMailer < ApplicationMailer
  def new_reply(reply, user)
    @user      = user
    @reply     = reply
    @reply_url = reply_url(reply)

    mail to: user.email, subject: "Нов отговор от #{reply.topic_title}"
  end
end
