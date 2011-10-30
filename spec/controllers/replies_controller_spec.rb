require 'spec_helper'

describe RepliesController do
  log_in_as :student

  let(:reply) { stub_model(Reply, topic: topic) }
  let(:topic) { stub_model(Topic) }

  describe "POST create" do
    before do
      Topic.stub :find => topic
      topic.stub :create_reply => reply
      reply.stub :valid? => true
    end

    it "requires an authenticated user" do
      controller.stub :current_user => nil
      post :create, :topic_id => '42'
      response.should deny_access
    end

    it "looks up the topic by params[:topic_id]" do
      Topic.should_receive(:find).with('42')
      post :create, :topic_id => '42'
    end

    it "tries to create a reply with current_user and params[:reply]" do
      topic.should_receive(:create_reply).with(current_user, 'reply')
      post :create, :topic_id => '42', :reply => 'reply'
    end

    context "when successful" do
      it "redirects to the reply" do
        reply.stub :valid? => true
        post :create, :topic_id => '42'
        response.should redirect_to(topic_reply_path(topic, reply))
      end
    end

    context "when unsuccessful" do
      it "redisplays the form" do
        reply.stub :valid? => false
        post :create, :topic_id => '42'
        response.should render_template(:new)
      end
    end
  end

  describe "GET edit" do
    it "redirects to the page of the topic where the reply is" do
      Reply.stub :find => reply
      reply.stub :topic_id => 10
      reply.stub :page_in_topic => 3
      reply.stub :id => '20'

      get :show, :topic_id => 10, :id => '20'

      response.should redirect_to(topic_path(10, :page => 3, :anchor => 'reply_20'))
    end
  end

  describe "GET edit" do
    before do
      Reply.stub :find => reply
      controller.stub :can_edit? => true
    end

    it "assigns the reply to @reply" do
      Reply.should_receive(:find).with('20')
      get :edit, :topic_id => 10, :id => '20'
      assigns(:reply).should == reply
    end

    it "denies access if the user cannot edit the reply" do
      controller.stub :can_edit? => false
      get :edit, :topic_id => 10, :id => '20'
      response.should deny_access
    end
  end

  describe "PUT update" do
    before do
      Reply.stub :find => reply
      reply.stub :update_attributes
      reply.stub :topic => topic
      controller.stub :can_edit? => true
    end

    it "denies access if the user cannot edit the reply" do
      controller.stub :can_edit? => false
      put :update, :topic_id => 10, :id => '20'
      response.should deny_access
    end

    it "assigns the reply to @reply" do
      Reply.should_receive(:find).with('20')
      put :update, :topic_id => 10, :id => '20'
      assigns(:reply).should == reply
    end

    it "updates the reply" do
      reply.should_receive(:update_attributes).with('attributes')
      put :update, :topic_id => 10, :id => '20', :reply => 'attributes'
    end

    it "redirects to the topic if successful" do
      reply.stub :update_attributes => true
      put :update, :topic_id => 10, :id => '20'
      response.should redirect_to(topic_reply_path(topic, reply))
    end

    it "redisplays the form if unsuccessful" do
      reply.stub :update_attributes => false
      put :update, :topic_id => 10, :id => '20'
      response.should render_template(:edit)
    end
  end
end
