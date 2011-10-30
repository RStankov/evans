# encoding: utf-8

require "spec_helper"

describe TopicMailer do
  describe "new reply" do
    let(:user)  { create :user }
    let(:reply) { create :reply }

    subject { TopicMailer.new_reply(reply, user) }

    it { should have_subject "Нов отговор от #{reply.topic_title}" }
    it { should have_body_text reply.body }
    it { should have_body_text topic_reply_url(reply.topic, reply) }
    it { should deliver_to user.email }
  end
end
