def print_header
  puts "The students of Villains Academy\n-------------"   
end

def print_names(students, s_char, u_twelve)
  if s_char != ""
    students.select! { |s| s[:name].chr.downcase == s_char.downcase }
  end
  if u_twelve
    students.select! { |s| s[:name].size < 12 }  
  end
  students.each_with_index { |s, i| puts "#{i+1}. #{s[:name]}, cohort: #{s[:cohort].capitalize}. Hobby: #{s[:hobby]}" }
=begin
  i = 0
  while i < students.count
    puts "#{i+1}. #{students[i]}"
    i += 1
  end
=end
end

def print_footer(students)
  if (sc = students.count) > 0
    puts "Overall, we have #{sc} student#{sc == 1? "" : "s"}"
  else
    puts "No students this time. There's always next month!" 
  end
end

def input_students
  puts "Enter student names into the directory here"
  puts "Hit return twice to finish"
  students = []
  loop do
    input = gets.chomp
    break if input.empty?
    students << {:name => input, :cohort => :october}
    puts "Any hobbies (press return if none)?"
    input = gets.chomp
    input.empty? ? students[-1][:hobby] = "none" : students[-1][:hobby] = input
    puts "There #{(sc = students.count) == 1? "is" : "are"} #{sc} student#{sc == 1? "" : "s"} in the directory."
  end
  students
end

students = [
    {:name => "Sauron", :cohort => :october, :hobby => "domination"},
    {:name => "Sauruman", :cohort => :october, :hobby => "power"},
    {:name => "Durin's Bane", :cohort => :october, :hobby => "napping"},
    {:name => "Grima Wormtongue", :cohort => :october, :hobby => "lechery"},
    {:name => "Shelob", :cohort => :october, :hobby => "eating"},
    {:name => "Gollum", :cohort => :october, :hobby => "fishing"},
    {:name => "Lurtz", :cohort => :october, :hobby => "jogging"}]
students = input_students

print_header
print_names(students, "", false)
print_footer(students)