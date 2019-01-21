require 'nokogiri'
require 'open-uri'

def get_name_and_url
  url = "https://www.nosdeputes.fr/deputes"
  doc = Nokogiri::HTML(open(url))

  name_path = doc.css("span.list_nom")
  url_path = doc.css("span.urlphoto")
  name = []
  url_deputy = []
  name_and_url = []

  name_path.map do |value|
    deputy_name = value.text
    deputy_name[0..6] = ""
    deputy_name[-4..deputy_name.length] = ""
    name << deputy_name
  end

  url_path.map do |value|
    url_deputy << value["title"]
  end

  name.map.with_index do |value, i|
    name_and_url << {"name" => value, "url" => "https://www.nosdeputes.fr" + url_deputy[i]}
  end

  name_and_url
end

def get_deputy_email(url)
  doc = Nokogiri::HTML(open(url))
  email = doc.xpath("//*[@id=\"b1\"]/ul[2]/li[1]/ul/li/a").first.text
end

def get_all_email(name_and_url)
  name_and_email = []
  name_and_url.map.with_index do |value, i|
    name = value["name"].split(",")
    f_name = name[1]
    f_name[0] = ""
    l_name = name[0]
    name_and_email << {"first_name" => f_name, "last_name" => l_name,"email" => get_deputy_email(value["url"])}
    break if i == 50
  end
  name_and_email
end

def perform
  puts get_all_email(get_name_and_url)
end

perform