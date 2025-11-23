module MealsHelper
  def icon_for(type)
    case type
    when 'rice' then '🍚'
    when 'japanese' then '🍣'
    when 'western' then '🍝'
    when 'chinese' then '🥟'
    when 'fish' then '🐟'
    when 'healthy' then '🥗'
    when 'kids' then '🍔'
    when 'dessert' then '🍰'
    when 'drink' then '☕️'
    else '🍽️' # デフォルト
    end
  end
end
