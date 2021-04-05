require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    doc.css(".student-card").map do |s|
      student = {}
      student[:name] = s.css(".student-name").text
      student[:location] = s.css(".student-location").text
      student[:profile_url] = s.css("a")[0]["href"]
      student
    end
  end
  
  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student = {}
    doc.css(".social-icon-container a").each do |u|
      domain = u['href'].scan(/twitter|linkedin|github/)
      if !domain.empty?
        student[domain[0].to_sym] = u['href']
      else
        student[:blog] = u['href']
      end
    end
    student[:profile_quote] = doc.css(".profile-quote").text
    student[:bio] = doc.css(".description-holder p").text
    student
  end
end

