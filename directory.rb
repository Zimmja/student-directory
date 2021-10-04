students = ["Dr. Hannibal Lecter","Darth Vader","Nurse Ratched","Michael Corleone","Alex DeLarge","The Wicked Witch of the West",
"Terminator","Freddy Krueger","The Joker","Joffrey Baratheon","Norman Bates","Sauron"]
# Begin by printing the fill list of students
puts "The students of Villains Academy\n-------------"
students.each { |stud| puts stud }
# Finish by printining the total numbers of students
puts "Overall, we have #{students.count} great students"