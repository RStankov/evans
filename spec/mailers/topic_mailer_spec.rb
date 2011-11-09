# encoding: utf-8

require "spec_helper"

describe TopicMailer do
  let(:user) { create :user }
  let(:reply) { create :reply }
  let(:reply_email) { "topic-#{reply.topic_id}@ruby.bg" }

  describe "new reply" do
    subject { TopicMailer.new_reply(reply, user) }

    it { should have_subject "Нов отговор от #{reply.topic_title}" }
    it { should have_reply_to reply_email }
    it { should have_body_text reply.body }
    it { should have_body_text topic_reply_url(reply.topic, reply) }
    it { should deliver_to user.email }
  end

  describe "receive reply" do
    before { reply }

    def receive_reply_mail(to, from, body)
      mail = Mail.new
      mail.to = to
      mail.from = from
      mail.body = body

      TopicMailer.receive_reply mail
    end

    def last_reply
      @last_reply ||= reply.topic.replies.last
    end

    it "creates a reply to a topic" do
      receive_reply_mail reply_email, user.email, 'Нов отговор'

      last_reply.should_not eq reply
      last_reply.user.should eq user
      last_reply.body.should eq 'Нов отговор'
    end

    it "does not create a reply without valid user" do
      -> {
        receive_reply_mail reply_email, 'john.doe@example.org', 'Нов отговор'
      }.should_not change(Reply, :count)
    end

    it "does not create a reply without valid reply topic address" do
      -> {
        receive_reply_mail 'invalid.address@example.org', user.email, 'Нов отговор'
      }.should_not change(Reply, :count)
    end
  end
end
