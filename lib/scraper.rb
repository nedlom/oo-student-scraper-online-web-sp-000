require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  
  #student: doc.css("div.student-card").last
  #name: student.css("h4.student-name").text
  #location: student.css("p.student-location").text
  #profile_url: student.css("a").attribute("href").value

  def self.scrape_index_page(index_url)
    students = []
    #student = {}
    #html = open("https://learn-co-curriculum.github.io/student-scraper-test-page/")
    #doc = Nokogiri::HTML(html)
    html = open(index_url)
    doc = Nokogiri::HTML(html)

    doc.css("div.student-card").each do |s|
      student = {}
      student[:name] = s.css("h4.student-name").text
      student[:location] = s.css("p.student-location").text
      student[:profile_url] = s.css("a").attribute("href").value
      #binding.pry
      students << student
    end
      #binding.pry
    students
  end
  
  
  #social: doc.css("div.social-icon-container a").attribute("href").value
  # .split(/\/\/|\./)[1].to_sym
  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    student = {}
    doc.css("div.social-icon-container a").each do |x|
      y = x.attribute("href").value
      if y.include?("twitter")
        student[:twitter] = y
      elsif y.include?("linkedin")
        student[:linkedin] = y
      elsif y.include?("git")
        student[:github] = y
      else
        student[:blog] = y
      end
      #z = y.split(/\/\/|\./)[1].to_sym
      #student[y.to_sym] = y
    end
    student[:profile_quote] = doc.css("div.profile-quote").text
    student[:bio] = doc.css("div.description-holder p").text
    #binding.pry
    student
    #binding.pry
  end

end

