# encoding: utf-8
class SolutionMailer < ApplicationMailer
  def new_comment(comment)
    @task_name      = comment.task_name
    @commenter_name = comment.user_name
    @comment_body   = comment.body
    @solution_url   = solution_url(comment.solution)

    mail :to => comment.solution.user.email,
         :subject => "Нов коментар на #{comment.task_name}"
  end
end
