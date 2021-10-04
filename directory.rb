def input_students
  puts "Enter student details into the directory here"
  students = []
  loop do
    new_student = input_a_student
    students << {:name => new_student[0], :cohort => new_student[1].downcase.to_sym, :hobby => new_student[2]}
    puts "Student added. There #{(sc = students.count) == 1? "is" : "are"} #{sc} student#{sc == 1? "" : "s"} in the directory."
    print "Add another student? (y/n) "
    yn_input = gets.chomp
    break if yn_input.downcase == "n"
  end
  students
end

def input_a_student
  loop do
    nam_input = input_student_details("Name", "none")
    coh_input = input_student_details("Cohort", "October")
    hob_input = input_student_details("Hobby", "none")
    
    while nam_input == "none"
      print "You must enter a name for each student. "
      nam_input = input_student_details("Name", "none")
    end
    
    while coh_input == "none"
      print "You must enter a cohort for each student. "
      coh_input = input_student_details("Cohort", "October")  
    end
    
    print "CONFIRM (y/n) Name: #{nam_input}, Cohort: #{coh_input}, Hobby: #{hob_input} "
    yn_input = gets.chomp
    return [nam_input,coh_input,hob_input] if yn_input.downcase == "y"
  end
end

def input_student_details(detail, default)
  print "#{detail}: "
  input = gets.chomp
  if input.empty?
    return default
  else
    return input 
  end
end

def print_header
  puts "The students of Middle Earth School of Performing Arts\n-------------"   
end

def print_names(students, s_char, u_twelve, by_cohort)
  if s_char != ""
    students.select! { |s| s[:name].chr.downcase == s_char.downcase }
  end
  if u_twelve
    students.select! { |s| s[:name].size < 12 }  
  end
  if !by_cohort
    students.each_with_index { |s, i| puts "#{i+1}. #{s[:name]}, cohort: #{s[:cohort].capitalize}. Hobby: #{s[:hobby]}" }
  else
    all_cohorts = students.map { |s| s[:cohort] }.uniq
    all_cohorts.each do |cohort|
      puts "#{cohort.to_s.capitalize} cohort:"
      students.select { |s| s[:cohort] == cohort }.each_with_index { |x, i| puts "#{i+1}. #{x[:name]}" }
    end
  end
end

def print_footer(students)
  if (sc = students.count) > 0
    puts "In total, we have #{sc} student#{sc == 1? "" : "s"}"
  else
    puts "No students this time." 
  end
end

students = [
    {:name => "Sauron", :cohort => :october, :hobby => "domination"},
    {:name => "Sauruman", :cohort => :october, :hobby => "power"},
    {:name => "Durin's Bane", :cohort => :october, :hobby => "napping"},
    {:name => "Grima Wormtongue", :cohort => :december, :hobby => "lechery"},
    {:name => "Shelob", :cohort => :october, :hobby => "eating"},
    {:name => "Gollum", :cohort => :december, :hobby => "fishing"},
    {:name => "Lurtz", :cohort => :december, :hobby => "jogging"}]
#students = input_students

print_header
print_names(students, "", false, true)
print_footer(students)