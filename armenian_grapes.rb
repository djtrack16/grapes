require 'nokogiri'
require 'net/http'
require 'pp'
#require 'set'
require 'byebug'
#require 'pry'

BASE_URL = 'http://www.vitis.am'
COUNTRY_OF_ORIGIN = 'Սորտի բնօրրան: '
NAME = 'Սորտի անվանում: '
SYNONYMS =  "Սորտի հոմանիշ: "
COLOR_OF_BERRY_SKIN = 'Պտղամաշկի գունավորում: '
GENETIC_ORIGIN = "Ծագում: "
GRAPE_DESCRIPTORS = {
  COUNTRY_OF_ORIGIN => :country_of_origin,
  NAME => :name,
  SYNONYMS => :synonyms,
  COLOR_OF_BERRY_SKIN => :berry_color,
  GENETIC_ORIGIN => :genetic_origin
}

module ArmenianGrapes

  def self.names
    am = vitis_am_crawl.map(&:downcase)
    de = vitis_de_crawl.map(&:downcase)
    (am+de).uniq.sort
  end

  def self.photos
    url = "https://www.vivc.de/index.php?r=fotoverweise%2Fresult&FotoverweiseSearch[landescode]=ITALY"
    html = Net::HTTP.get_response(URI(url)).body
    page = Nokogiri::HTML(html)
    selector = page.css('tbody tr')
    name_and_photo_type = selector.map {|c| [c.children.first.text, c.children[-2].text] }
    photos = selector.css('img').map {|c| c.attributes["src"].value}
    name_and_photo_type.zip(photos).each_with_object(Hash.new([])) do |(pair, link), map|
      name = pair[0]
      map[name] += [[pair[1], link]]
    end
  end

  def self.vitis_de_crawl
    url = "https://www.vivc.de/index.php?per-page=500&SpeciesSearch%5Bleitname%5D=&SpeciesSearch%5Bkenn_nr%5D=&SpeciesSearch%5Bspecies%5D=&SpeciesSearch%5Bb_farbe%5D=&SpeciesSearch%5Blandescode22%5D=ARMENIA&r=species%2Fcountry"
    html = Net::HTTP.get_response(URI(url)).body
    page = Nokogiri::HTML(html)
    names = []
    page.css('tbody').children.children.map(&:text).each_slice(4) do |name, id, species, color|
      names << name
      next
      grape_profile_url = "https://www.vivc.de/index.php?r=passport%2Fview&id=#{id}"
      #puts grape_profile_url
      html = Net::HTTP.get_response(URI(grape_profile_url)).body
      page = Nokogiri::HTML(html)
      hash = {}
      grape_list = page.css('div.passport-view table tr').children.map(&:text).each_slice(3).to_a
      grape_list.first(32).each do |key, _, value|
        next unless value
        val = value.strip
        hash[key.strip] = val if !val.empty?
      end
      synonyms = page.css('tbody table').first.children[1..-1].flat_map {|x| x.css('td').map(&:text)}
      hash["synonyms"] = synonyms
      hash["name"] = hash["prime_name"]
    end
    names
  end

  def self.vitis_am_crawl
    url = "#{BASE_URL}/eng/search"
    html = Net::HTTP.get_response(URI(url)).body
    page = Nokogiri::HTML(html)
    names = []
    grape_link_and_name = page.css('div').css('table').children[3].children.each do |c|
      grape = c.children.children.last
      next unless grape
      names << grape.children.first.text
      next
      [
        grape.attributes['href'].value,
        grape.children.first.text
      ] if grape
    end

    names #profiles(grape_link_and_name)
  end

  def self.profiles(grape_link_and_name)
    grape_link_and_name.map do |url, name|
      profile_page_url = "#{BASE_URL}#{url}"
      html = Net::HTTP.get_response(URI(profile_page_url)).body
      page = Nokogiri::HTML(html)
      attributes = {}
      page.css('div ul li').children.map(&:text).last(19).select {|c| !c.strip.empty?}
          .each_slice(2) {|key,value| attributes[GRAPE_DESCRIPTORS[key]] = value if GRAPE_DESCRIPTORS[key] }

      bud_burst, ripeness = page.css('div table').children.map(&:text).last.split("OIV").last(2)
      bud_burst = bud_burst.split('burst')[1]
      ripeness = ripeness.split('berry')[1]

      puts attributes.merge(ripeness: ripeness, bud_burst: bud_burst)
    end

  end
  
end

pp ArmenianGrapes.photos

