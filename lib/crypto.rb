require "nokogiri"
require "open-uri"

def crypto_scrap
  url = "https://coinmarketcap.com/all/views/all/"
  doc = Nokogiri::HTML(open(url))

  price_path = doc.css("a.price")
  name_path = doc.css("td.text-left.col-symbol")
  price = []
  name = []
  price_and_name = []

  name_path.map do |value|
    name << value.text
  end
  
  price_path.map do |value|
    price << value.text.tr("$", "").to_f
  end

  name.map.with_index do |name, i|
    price_and_name << {name => price[i]}
  end
  puts price_and_name
end

def perform
  crypto_scrap
end

perform