# encoding: utf-8
class TopicMailer < ApplicationMailer
  def new_reply(reply, user)
    @user      = user
    @reply     = reply
    @reply_url = reply_url(reply)

    mail to: user.email, subject: "Нов отговор от #{reply.topic_title}", reply_to: "topic-#{reply.topic_id}@ruby.bg"
  end

  def receive_reply(mail)
    user  = User.find_by_email(mail.from.first)
    topic = Topic.find_by_id(mail.to.first.match(/topic-([0-9]+)@ruby.bg/).try(:[], 1))
    body  = mail.body.to_s

    if user.present? and topic.present? and body.present?
      topic.create_reply user, body: body
    end
  end
end
