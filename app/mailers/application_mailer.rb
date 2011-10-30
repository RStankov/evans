# encoding: utf-8
class ApplicationMailer < ActionMailer::Base
  include CustomPaths

  default from: '"Ruby ФМИ" <evans@ruby.bg>', reply_to: '"Ruby ФМИ" <fmi@ruby.bg>'
end