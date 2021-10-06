$students = [
    {:name => "Sauron", :cohort => :october, :hobby => "domination"},
    {:name => "Sauruman", :cohort => :october, :hobby => "power"},
    {:name => "Durin's Bane", :cohort => :october, :hobby => "napping"},
    {:name => "Grima Wormtongue", :cohort => :december, :hobby => "lechery"},
    {:name => "Shelob", :cohort => :october, :hobby => "eating"},
    {:name => "Gollum", :cohort => :december, :hobby => "fishing"},
    {:name => "Lurtz", :cohort => :december, :hobby => "jogging"}
    ]
    
def input_students(reset)
  print_header(reset ? "reset directory" : "add to directory")
  students = (reset ? [] : $students)
  puts directory_count_statement(students)
  
  loop do
    print "Add a new student? (y/n) "
    yn_input = gets.chomp
    break if yn_input.downcase == "n"
    if yn_input == "y"
      new_student = input_a_student
      if new_student
        students << {:name => new_student[0], :cohort => new_student[1].downcase.to_sym, :hobby => new_student[2]}
        puts "\nStudent added. #{directory_count_statement(students)}\n "
      else
        puts "\nInput cancelled. #{directory_count_statement(students)}\n "
      end
    else
      puts "ERROR: invalid input. Please choose 'y' or 'n'"
    end
  end
  students
end

def directory_count_statement(students)
  "There #{(sc = students.count) == 1? "is" : "are"} #{sc} student#{sc == 1? "" : "s"} in the directory."
end

def input_a_student
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
    
  print "CONFIRM ENTRY (y/n) Name: #{nam_input}, Cohort: #{coh_input}, Hobby: #{hob_input} "
  loop do
    yn_input = gets.chomp
    break if yn_input.downcase == "n"
    if yn_input.downcase == "y"
      return [nam_input,coh_input,hob_input]
    elsif yn_input.downcase != "n"
      puts "ERROR: invalid input. Please choose 'y' or 'n'"
    end
  end
end

def input_student_details(detail, default)
  print "#{detail}: "
  det_input = gets[0...-1]
  if det_input.empty?
    return default
  else
    return det_input 
  end
end

def delete_students
  print_header("remove from directory")
  loop do
    delete_i_max = $students.count
    puts "Please enter a student number between 1 and #{delete_i_max} to delete them from the directory\nOR leave blank and press ENTER to return to menu"
    print_names($students, "", false, false)
    delete_input = gets.chomp
    break if delete_input == ""
    
    if (delete_i = delete_input.to_i) == 0 || delete_i > delete_i_max
      puts "\nERROR: invalid input."
    else
      puts "\n#{$students[delete_i - 1][:name]} removed from directory\n "
      $students.delete_at(delete_i - 1)
    end
  end 
end

def print_header(header)
  puts "#{"-"*40}\n#{header.upcase}\n#{"-"*40}"   
end

def print_names(students, s_char, u_twelve, by_cohort)
  if s_char != ""
    students.select! { |s| s[:name].chr.downcase == s_char.downcase }
  end
  if u_twelve
    students.select! { |s| s[:name].size < 12 }  
  end
  if !by_cohort
    students.each_with_index { |s, i| puts "  #{i+1}. #{s[:name]}, cohort: #{s[:cohort].capitalize}. Hobby: #{s[:hobby]}" }
  else
    all_cohorts = students.map { |s| s[:cohort] }.uniq
    all_cohorts.each do |cohort|
      puts "#{cohort.to_s.capitalize} cohort:"
      students.select { |s| s[:cohort] == cohort }.each_with_index { |x, i| puts "  #{i+1}. #{x[:name]}" }
    end
  end
end

def print_footer(students)
  if (sc = students.count) > 0
    puts "In total, we have #{sc} student#{sc == 1? "" : "s"}\nPress ENTER to return to menu "
    gets
  else
    puts "There are no students in the directory\nPress ENTER to return to menu"
    gets
  end
end

def menu
  loop do
    print_menu
    menu_choice(choice = gets.chomp)
    break if choice == "4"
  end
end

def print_menu
  print_header("directory menu")
  puts " (0) Reset directory\n (1) Add students to directory\n (2) Remove students from directory\n (3) View list of students\n (4) Exit"  
end

def menu_choice(choice)
  case choice
     when "0" then $students = input_students(true)
     when "1" then $students = input_students(false)
     when "2" then delete_students
     when "3" then view_students
  end
end

def view_students
  print_header("list of students")
  print_names($students, "", false, true)
  print_footer($students)  
end

menu