module MealsHelper
  def icon_for(type)
    case type.to_sym
    when :don           then "🍚"
    when :curry         then "🍛"
    when :meat          then "🍖"
    when :fried         then "🍤"
    when :fish          then "🐟"
    when :japanese      then "🍣"
    when :bento         then "🍱"
    when :pasta         then "🍝"
    when :noodles       then "🍜"
    when :chinese       then "🥟"
    when :western_fast  then "🍕"
    when :bread         then "🍞"
    when :nabe          then "🍲"
    when :kids          then "🍔"
    when :salad         then "🥗"
    else '🍽️' # デフォルト
    end
  end
end
