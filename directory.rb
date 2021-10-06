$students = [
    {:name => "Sauron", :cohort => :october, :hobby => "domination"},
    {:name => "Sauruman", :cohort => :october, :hobby => "power"},
    {:name => "Durin's Bane", :cohort => :october, :hobby => "napping"},
    {:name => "Grima Wormtongue", :cohort => :december, :hobby => "lechery"},
    {:name => "Shelob", :cohort => :october, :hobby => "eating"},
    {:name => "Gollum", :cohort => :december, :hobby => "fishing"},
    {:name => "Lurtz", :cohort => :december, :hobby => "jogging"}
    ]

def interactive_menu
  loop do
    print_im
    break if im_choice(gets.chomp) == false
  end
end

def print_im
  print_header("directory menu")
  puts " (0) Reset directory\n (1) Add students to directory\n (2) Remove students from directory\n (3) View list of students\n (4) Exit"  
end

def im_choice(choice)
  case choice
     when "0" then input_students(true)
     when "1" then input_students(false)
     when "2" then delete_students
     when "3" then view_students
     when "4" then return false
  end
end

def view_students
  print_header("list of students")
  print_names($students, "", false, true)
  print_footer($students)  
end

def print_header(header)
  puts "#{"-"*40}\n#{header.upcase}\n#{"-"*40}"   
end

def print_footer(students)
  puts "#{directory_count_statement(students)}\nPress ENTER to return to menu"; gets
end

def directory_count_statement(students) # e.g. "There is 1 student in the directory.""
  "There #{(sc = students.count) == 1? "is" : "are"} #{sc} student#{sc == 1? "" : "s"} in the directory."
end

def print_names(students, s_char, u_twelve, by_cohort)
  students.select! { |s| s[:name].chr.downcase == s_char.downcase } if s_char != ""
  students.select! { |s| s[:name].size < 12 } if u_twelve  
  by_cohort ? print_names_by_cohort(students) : print_names_by_list(students)
end

def print_names_by_cohort(students)
  (students.map { |s| s[:cohort] }.uniq).each do |cohort|
    puts "#{cohort.to_s.capitalize} cohort:"
    students.select { |s| s[:cohort] == cohort }.each_with_index { |x, i| puts "  #{i+1}. #{x[:name]}" }
  end
end

def print_names_by_list(students)
  students.each_with_index { |s, i| puts "  #{i+1}. #{s[:name]}, cohort: #{s[:cohort].capitalize}. Hobby: #{s[:hobby]}" }
end

def delete_students
  print_header("remove from directory")
  loop do
    s_count = $students.count
    puts "Please enter a student number between 1 and #{s_count} to delete them from the directory\nOR leave blank and press ENTER to return to menu"
    print_names($students, "", false, false)
    break if delete_choice(gets.chomp, s_count) == false
  end 
end

def delete_choice(choice, s_count)
  return false if choice == ""
  puts (valid = (0...s_count).include?(choice_i = choice.to_i - 1)) ? "\n#{$students[choice_i][:name]} removed from directory\n " : "\nERROR: invalid input." 
  $students.delete_at(choice_i) if valid
end

def input_students(reset)
  print_header(reset ? "reset directory" : "add to directory")
  puts directory_count_statement($students = (reset ? [] : $students))
  add_offer
end

def add_offer
  loop do
    print "Add a new student? (y/n) "
    break if add_choice(gets.chomp.downcase) == false
  end
end

def add_choice(choice)
  return false if choice == "n"
  choice == "y" ? add_student_to_directory : invalid_yn_choice
end

def invalid_yn_choice
  puts "ERROR: invalid input. Please choose 'y' or 'n'"
end

def add_student_to_directory
  if new_student = input_a_student
    $students << {:name => new_student[0], :cohort => new_student[1].downcase.to_sym, :hobby => new_student[2]}
    puts "\nStudent added. #{directory_count_statement($students)}\n "
  else
    puts "\nInput cancelled. #{directory_count_statement($students)}\n "
  end
end

def input_a_student
  nam_input = input_student_details("Name", "")
  coh_input = input_student_details("Cohort", "October")
  hob_input = input_student_details("Hobby", "none")
    
  print "\nCONFIRM ENTRY (y/n)\nName: #{nam_input}, Cohort: #{coh_input}, Hobby: #{hob_input} "
  loop do
    break if (choice = gets.chomp.downcase) == "n"
    choice == "y" ? (return [nam_input,coh_input,hob_input]) : invalid_yn_choice
  end
end

def input_student_details(detail, default)
  loop do
    print "#{detail}#{ "(default: #{default})" if default != "" && default != "none"}: "
    det_input = gets.chomp
    default == "" && det_input == "" ? (puts "\nYou must enter a #{detail.downcase} for each student.") : (return det_input.empty? ? default : det_input)
  end
end

interactive_menu