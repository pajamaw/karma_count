require_relative "../lib/scraper.rb"
require_relative "../lib/student.rb"
require 'nokogiri'

class Cli
  BASE_URL = "http://students.learn.co"

  def run
    make_students
    add_attributes_to_students
    add_karma_to_students
    high_score
  end

  def make_students
    students_array = Scraper.scrape_index_page(BASE_URL)
    Student.create_from_collection(students_array)
  end

  def add_attributes_to_students
    Student.all.each do |student|
      attributes = Scraper.scrape_profile_page(student.profile_url)
      student.add_student_attributes(attributes)

    end
  end

  def add_karma_to_students
    Student.all.each do |student|
      attributes = Scraper.scrape_learn_for_karma(student.github_url)
      student.add_student_attributes(attributes)
    end
  end

  def high_score
    counter = 0
    competitors = Student.all.select do |student|
        student.karma if !(student.karma.nil? )
      end
    competitors.sort_by!{|student| student.karma}
    puts "_________________________________KARMA HIGH SCORE____________________________"
    competitors.reverse.each do |student|
          counter += 1 
          puts ""
          puts " #{counter}. #{student.name.upcase} from #{student.location} with #{student.karma} POINTS!"
          puts "-----------------------------------------------------------------------------"
    end
    end

 # def top_10 
  #  counter = 0
  #   puts "_________________________________KARMA TOP 10____________________________"
  #  COMPETITORS.reverse.each do |student|
     # until counter == 10
      #    counter += 1 
      #    puts ""
      #    puts " #{counter}. #{student.name.upcase} from #{student.location} with #{student.karma} POINTS!"
      #    puts "-----------------------------------------------------------------------------"
   # end
  #  end

end