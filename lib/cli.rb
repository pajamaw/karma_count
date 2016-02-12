require_relative "../lib/scraper.rb"
require_relative "../lib/student.rb"
require 'nokogiri'

class Cli
  BASE_URL = "http://students.learn.co"

  def run
    make_students
    add_attributes_to_students
    add_karma_to_students
    display_students
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


  def display_students
    Student.all.each do |student|
      puts "#{student.name.upcase}:"
      puts "  #{student.location}"
      puts "  #{student.karma}"
      puts "----------------------"
    end
  end

end