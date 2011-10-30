require 'spec_helper'

describe ReplyObserver do
  before do
    ReplyObserver.stub :active? => true
  end

  let(:topic) { create :topic }
  let(:reply) { build :reply, topic: topic }

  it "notifies reply's topic participants, who want to" do
    first  = double(:user, message_board_notification?: true)
    second = double(:user, message_board_notification?: true)
    third  = double(:user, message_board_notification?: false)

    topic.stub participants: [first, second, third]

    expect_email_delivery TopicMailer, :new_reply, reply, first
    expect_email_delivery TopicMailer, :new_reply, reply, second

    TopicMailer.should_not_receive(:new_reply).with(reply, third)

    reply.save!
  end

  it "doesn't notify the reply author" do
    reply.user = create :user, message_board_notification: true

    topic.stub participants: [reply.user]

    TopicMailer.should_not_receive(:new_reply)

    reply.save!
  end
end
