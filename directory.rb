students = ["Dr. Hannibal Lecter","Darth Vader","Nurse Ratched","Michael Corleone","Alex DeLarge","The Wicked Witch of the West",
"Terminator","Freddy Krueger","The Joker","Joffrey Baratheon","Norman Bates","Sauron"]

def print_header
  puts "The students of Villains Academy\n-------------"   
end

def print_names(students)
  students.each { |stud| puts stud }    
end

def print_footer(students)
  puts "Overall, we have #{students.count} great students"  
end

print_header
print_names(students)
print_footer(students)