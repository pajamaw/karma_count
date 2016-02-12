require 'nokogiri'
class Student
  attr_accessor :name, :location, :profile_url, :github_url, :karma

  STUDENTS =[]

  def initialize(attributes)
    attributes.each do |k, v|
      self.send(("#{k}="), v)
    end
    STUDENTS << self
  end

  def self.create_from_collection(students_array)
    students_array.each do |student|
     Student.new(student)
   end
 end

  def add_student_attributes(attributes_hash)
    attributes_hash.each do |k,v|
      self.send(("#{k}="), v)
    end
  end

   

  def self.all
    STUDENTS
  end

end
