module ApplicationHelper
  def time_ago(time)
  "#{time_ago_in_words(time)}前"
  end
end
