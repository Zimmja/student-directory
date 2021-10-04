def print_header
  puts "The students of Villains Academy\n-------------"   
end

def print_names(students)
  students.each { |s| puts s }    
end

def print_footer(students)
  puts "Overall, we have #{students.count} great students"  
end

def input_students
  puts "Enter student names into the directory here"
  puts "Hit return twice to finish"
  students = []
  loop do
    input = gets.chomp
    break if input.empty?
    students << input
    puts "There #{(sc = students.count) == 1? "is" : "are"} #{sc} student#{sc == 1? "" : "s"} in the directory."
  end
  students
end

students = input_students
print_header
print_names(students)
print_footer(students)

=begin
    {:name => "Dr. Hannibal Lecter", :cohort => :october},
    {:name => "Darth Vader", :cohort => :october},
    {:name => "Nurse Ratched", :cohort => :october},
    {:name => "Michael Corleone", :cohort => :october},
    {:name => "Alex DeLarge", :cohort => :october},
    {:name => "The Wicked Witch of the West", :cohort => :october},
    {:name => "Terminator", :cohort => :october},
    {:name => "Freddy Krueger", :cohort => :october},
    {:name => "The Joker", :cohort => :october},
    {:name => "Joffrey Baratheon", :cohort => :october},
    {:name => "Norman Bates", :cohort => :october},
    {:name => "Sauron", :cohort => :october}]
=end