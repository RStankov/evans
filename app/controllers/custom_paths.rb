module CustomPaths
  def solution_path(solution)
    task_solution_path(solution.task, solution)
  end

  def solution_url(solution)
    task_solution_url(solution.task, solution)
  end

  def comment_path(comment)
    task_solution_url(comment.solution.task, comment.solution, anchor: "comment-#{comment.id}")
  end

  def comment_url(comment)
    task_solution_url(comment.solution.task, comment.solution, anchor: "comment-#{comment.id}")
  end

  def reply_url(reply)
    topic_reply_url(reply.topic, reply)
  end

  def reply_path(reply)
    topic_reply_path(reply.topic, reply)
  end
end
