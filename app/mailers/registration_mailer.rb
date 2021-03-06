# encoding: utf-8
class RegistrationMailer < ActionMailer::Base
  default :from => '"Ruby ФМИ" <evans@ruby.bg>', :reply_to => '"Ruby ФМИ" <fmi@ruby.bg>'

  def confirmation(sign_up)
    @activation_url = activation_url(sign_up.token, :only_path => false)

    mail :to => sign_up.email,
         :subject => 'Потвърждение на регистрация'
  end

  def activation(user)
    @email = user.email

    mail :to => user.email,
         :subject => 'Успешна регистрация'
  end
end
