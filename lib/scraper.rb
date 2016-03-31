require 'nokogiri'
require 'open-uri'

class Scraper

 def self.scrape_index_page(index_url)
    student_array = []
    
    doc = Nokogiri::HTML(open(index_url))

    doc.search(".student-card").collect do |student|
      {
        name: student.search("h4.student-name").text,
        location:  student.search("p.student-location").text,
        profile_url: "http://students.learn.co/#{student.search("a").attribute("href").value}"
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    specific_student = {}
    begin
      doc = Nokogiri::HTML(open(profile_url))
    rescue 
      specific_student[:github_url] = nil
    else
      doc.search(".social-icon-container a").each do |social|
       if social.attribute("href").value.scan(/github.com/) == ["github.com"]
         specific_student[:github_url] = social.attribute("href").value
       else
        specific_student[:github_url] = nil
      end
    end
    end 
    specific_student
  end


  def self.scrape_learn_for_karma(github_url)
    specific_karma = {}
    if github_url != nil
      gh_parse = URI::parse(github_url)
      learn_url = "https://www.learn.co" + gh_parse.path + ".html"
      begin
        doc = Nokogiri::HTML(open(learn_url))
      rescue
        specific_karma[:karma] = nil
      else
        points = doc.css(".karma-points h3").text.to_i
        specific_karma[:karma] = points
      end
    else
      specific_karma[:karma] = nil
    end
    specific_karma
  end


end

