require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  
  #student: doc.css("div.student-card")
  #name: student.css("h4.student-name").text
  #location: student.css("p.student-location").text
  #profile_url: student.css("a").attribute("href").value

  def self.scrape_index_page(index_url)
    students = []
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    doc.css("div.student-card").each do |s|
      student = {}
      student[:name] = s.css("h4.student-name").text
      student[:location] = s.css("p.student-location").text
      student[:profile_url] = s.css("a").attribute("href").value
      students << student
    end
    students
  end
 
  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    student = {}
    doc.css("div.social-icon-container a").each do |s|
      site = s.attribute("href").value
      if site.include?("twitter")
        student[:twitter] = site
      elsif site.include?("linkedin")
        student[:linkedin] = site
      elsif site.include?("git")
        student[:github] = site
      else
        student[:blog] = site
      end
    end
    student[:profile_quote] = doc.css("div.profile-quote").text
    student[:bio] = doc.css("div.description-holder p").text
    student
  end
end

