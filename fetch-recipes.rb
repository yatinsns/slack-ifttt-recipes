require 'json'
require 'nokogiri'

def get_info text
  page = Nokogiri::HTML.parse(text)

  recipe_trigger = page.css("span[class='recipe_trigger']")

  return if recipe_trigger.nil? or recipe_trigger.length == 0
  #puts recipe_trigger[0]['title']

  recipe_action = page.css("span[class='recipe_action']")
  #puts recipe_action[0]['title']

  created_by_div = page.css("div[class='recipe-desc_creation']")
  created_by_a = created_by_div.css("a")
  #puts "by: #{created_by_a.text}"

  
  name_div = page.css("div[class='recipe-desc recipe-desc-compact']")
  name_div_a = name_div[0].css("a")
  #puts "title: #{name_div_a[0].text}"
  
  use_span = page.css("span[class='recipe-desc__stats_item__use-count__number']")
  use_span_full = use_span[0].css("span[class='full_value']")

  fav_span = page.css("span[class='stats_item__favorites-count__number']")
  fav_span_full = fav_span[0].css("span[class='full_value']")

  #puts page

  puts "#{recipe_trigger[0]['title']};#{recipe_action[0]['title']};#{name_div_a[0].text};#{created_by_a.text};#{use_span_full[0].text.lstrip.chomp};#{fav_span_full[0].text.lstrip.chomp}"
end


def get_page index
  response = `curl --silent "https://wrapapi.com/use/yatinsns/ifttt/ifttt/0.0.1?p=#{index}&wrapAPIKey=GBGofZ9xVwo5Yx8zosPm92CAnUaPA41u"`

  obj = JSON.parse response
  obj["data"]["texts"].each do |text|
    get_info text
  end
end

(0..44).each do |index|
  get_page index
end


