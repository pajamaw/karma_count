require_relative "../lib/scraper.rb"
require_relative "../lib/student.rb"
require 'nokogiri'

class Cli
  BASE_URL = "http://students.learn.co"

  def run
    header
    accumulate_info_and_explain
    the_app
  end

  def accumulate_info_and_explain
    sleep 1 
    puts "IT MAY TAKE A MINUTE TO LOAD ALL THE USERS"
    sleep 1 
    puts ""
    puts "IF YOU'D LIKE TO CONTINUE WORK WHILE YOU WAIT"
    sleep 1
    puts ""
    puts "PLEASE PRESS CMD + T TO OPEN A NEW TAB"
    make_students
    sleep 2
    header
    puts ""
    puts "BUT HONESTLY IT WILL TAKE A FEW MINUTES"
    add_attributes_to_students
    puts ""
    puts "WE'RE ALMOST THERE I PROMISE"
    sleep 5
    header
    puts ""
    puts "OKAY I LIED...IT'LL BE ABOUT 5 MINUTES"
    add_karma_to_students
  end

    def header
      system 'clear'
      puts "__________________WELCOME TO THE KARMA COUNT_________________________"
      puts ""
    end

    def continue_or_quit
      puts "Press 1 to go back to the main menu, press 2 to exit"
      next_input = gets.strip
      if next_input == "1"
        the_app
      else
        puts "Check back later to see if you've advanced!" 
      end
    end

    def the_app

      input = nil

      loop do 
        header
        puts "1.  TOP 10 KARMA CONTENDERS"
        puts ""
        puts "2.  ALL KARMA CONTENDERS"
        puts ""
        puts "3.  SEARCH"

        input = gets.strip
        break if input == "1" || input == "2" || input == "3"
      end

        if input == "1"
          top_10_karma
        elsif input == "2" 
          all_karma
        else 
          search_for_karma_position
        end

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

  def top_10_karma
    header
    counter = 0
    competitors = Student.all.select do |student|
        student.karma if !(student.karma.nil? )
      end
    competitors.sort_by!{|student| student.karma}
    puts "___________________________KARMA TOP 10______________________________"
      competitors.reverse.each do |student|
        counter += 1 
        puts ""
        puts " #{counter}. #{student.name.upcase} from #{student.location} with #{student.karma} POINTS!"
        puts "---------------------------------------------------------------------"
        break if counter == 10
      end
    continue_or_quit
  end

  def all_karma
    header
    competitors = Student.all.select do |student|
        student.karma if !(student.karma.nil? )
      end
    competitors.sort_by!{|student| student.karma}
    puts "_________________________KARMA HIGH SCORE____________________________"
      competitors.reverse.each_with_index do |student, index|
          puts ""
          puts " #{index.to_i.next}. #{student.name.upcase} from #{student.location} with #{student.karma} POINTS!"
          puts "---------------------------------------------------------------------"   
      end
      continue_or_quit
    end

    def search_for_karma_position
    header
    competitors = Student.all.select do |student|
        student.karma if !(student.karma.nil? )
      end
    search_name = nil
    competitors.sort_by!{|student| student.karma}
    puts "_________________________KARMA SEARCH_______________________________"
    puts ""
    puts "Enter your first and last name"
    sleep 1
    puts "If your name is not put down correctly no result will show"
    search_name = gets.strip.downcase
    competitors.reverse.each_with_index do |student,index| 
      if search_name == student.name.downcase
        header
        puts ""
        puts " You are in position #{index.to_i.next}!"
      end
    end
    sleep 1
    continue_or_quit
    end
end