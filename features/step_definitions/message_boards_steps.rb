# encoding: utf-8
Before '@reply_observer' do
  ReplyObserver.stub active?: true
end

Дадено 'че съм студент' do
  backdoor_login Factory(:user)
end

Дадено 'че съществува тема "$title"' do |title|
  Factory(:topic, :title => title)
end

Дадено 'че имам тема "$topic"' do |title|
  Factory(:topic, :user => @current_user, :title => title)
end

Дадено 'че съм отговорил на "$title" с "$reply"' do |title, reply|
  topic = Topic.find_by_title(title) || Factory(:topic, :title => title)
  Factory(:reply, :user => @current_user, :topic => topic, :body => reply)
end

Дадено 'че съществува тема "$title" със съдържание:' do |title, body|
  Factory(:topic, :title => title, :body => body)
end

Дадено 'че студент "$name" е публикувал тема "$topic"' do |user_name, topic|
  user = Factory(:user, :full_name => user_name)
  Factory(:topic, :title => topic, :user => user)
end

Дадено 'че студент "$user" е отговорил на тема "$topic"' do |user_name, topic_title|
  user  = Factory(:user, :full_name => user_name)
  topic = Factory(:topic, :title => topic_title)

  Factory(:reply, :user => user, :topic => topic)
end

Дадено /^съм съгласен да бъда уведомяван при отговори на теми$/ do
  @current_user.update_attributes! message_board_notification: true
end

Когато 'започна да редактирам темата' do
  within 'ol.topic li:first' do
    click_link 'Редактирай'
  end
end

Когато 'започна да редактирам отговорът "$reply"' do |reply|
  within "li:contains('#{reply}')" do
    click_link 'Редактирай'
  end
end

Дадено 'отговори към тема "$title":' do |topic_title, table|
  topic = Topic.find_by_title(topic_title) || Factory(:topic, :title => topic_title)

  table.hashes.each do |options|
    notify = options['Уведомяван при отговор?'] == 'Да' ? true : false
    name   = options['Студент']
    body   = options['Отговор']

    user   = Factory(:user, full_name: name, message_board_notification: notify)
    Factory(:reply, topic: topic, user: user, body: body)
  end
end

Когато 'отговоря на темата "$title" с "$reply"' do |topic_title, reply_body|
  visit topic_path(Topic.find_by_title!(topic_title))
  fill_in 'Отговор', :with => reply_body
  click_button 'Отговори'
end

Когато 'някой отговори на "$title" с "$reply"' do |topic_title, reply_body|
  topic = Topic.find_by_title!(topic_title)
  Factory :reply, topic: topic, body: reply_body
end

Когато 'отговоря на писмото, което съм получил с "$body"' do |body|
  recieved_email = ActionMailer::Base.deliveries.last
  reset_mailer

  mail = Mail.new
  mail.from    @current_user.email
  mail.to      recieved_email.reply_to
  mail.subject "Re: #{recieved_email.subject}"
  mail.body    body

  TopicMailer.receive_reply(mail)
end

То '"$name" трябва да получи писмо с "$body"' do |name, body|
  user = User.find_by_full_name!(name)
  mailbox_for(user.email).should_not be_empty
  open_email(user.email, :with_text => body)
end

То 'трябва да няма "$code" в кода на документа' do |code|
  body.should_not include(code)
end

То '"$name" не трябва да получи писмо' do |name|
  user = User.find_by_full_name!(name)
  mailbox_for(user.email).should be_empty
end

То 'трябва да виждам следните отговори:' do |table|
  table.rows.flatten.each do |reply_body|
    page.should have_content(reply_body)
  end
end
