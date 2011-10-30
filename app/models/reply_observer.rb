class ReplyObserver < ActiveRecord::Observer
  class << self
    def active?
      not Rails.env.test?
    end
  end

  def after_create(reply)
    return unless ReplyObserver.active?

    reply.topic.participants.each do |user|
      if user.message_board_notification? and reply.user != user
        TopicMailer.new_reply(reply, user).deliver
      end
    end
  end
end
