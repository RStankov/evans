# encoding: utf-8
class CommentsController < ApplicationController
  before_filter :require_user

  def create
    @solution = Solution.find params[:solution_id]

    unless @solution.commentable_by? current_user
      deny_access
      return
    end

    @comment = @solution.comments.build params[:comment]
    @comment.user = current_user

    if @comment.save
      redirect_to @comment, notice: 'Коментарът е добавен успешно'
    else
      render :new
    end
  end
end