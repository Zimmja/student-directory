$students = []

def interactive_menu
  loop do
    print_im
    break if im_choice(STDIN.gets.chomp) == false
  end
end

def print_im
  print_header("directory menu")
  puts " (0) Reset directory
 (1) Add students to directory
 (2) Remove students from directory
 (3) View list of students
 (4) Export list
 (5) Import list
 (6) Exit"  
end

def im_choice(choice)
  case choice
    when "0" then input_students(true)
    when "1" then input_students(false)
    when "2" then delete_students
    when "3" then view_students
    when "4" then export_list
    when "5" then import_list
    when "6" then return false
  end
end

def view_students
  puts "attempt print"
  print_header("list of students")
  print_names($students, "", false, true)
  print_footer($students)  
end

def print_header(header)
  puts "#{"-"*40}\n#{header.upcase}\n#{"-"*40}"   
end

def print_footer(students)
  puts "#{directory_count_statement(students)}\nPress ENTER to return to menu"; STDIN.gets
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
    puts "#{cohort.to_s} cohort:"
    students.select { |s| s[:cohort] == cohort }.each_with_index { |x, i| puts "  #{i+1}. #{x[:name]}" }
  end
end

def print_names_by_list(students)
  (students.map { |s| "#{s[:name]}, cohort: #{s[:cohort].capitalize}. Hobby: #{s[:hobby]}" }).sort.each_with_index { |st, i| puts "  #{i+1}. #{st}" }
end

def delete_students
  print_header("remove from directory")
  loop do
    s_count = $students.count
    puts "Please enter a student number between 1 and #{s_count} to delete them from the directory\nOR leave blank and press ENTER to return to menu"
    print_names($students, "", false, false)
    break if delete_choice(STDIN.gets.chomp, s_count) == false
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
    break if add_choice(STDIN.gets.chomp.downcase) == false
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
    $students << {:name => new_student[0], :cohort => new_student[1].upcase.to_sym, :hobby => new_student[2]}
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
    break if (choice = STDIN.gets.chomp.downcase) == "n"
    choice == "y" ? (return [nam_input,coh_input,hob_input]) : invalid_yn_choice
  end
end

def input_student_details(detail, default)
  loop do
    print "#{detail}#{ "(default: #{default})" if default != "" && default != "none"}: "
    det_input = STDIN.gets.chomp
    default == "" && det_input == "" ? (puts "\nYou must enter a #{detail.downcase} for each student.") : (return det_input.empty? ? default : det_input)
  end
end

def export_list
  print "Export name: "
  export_file = File.open("#{name = STDIN.gets.chomp}.csv", "w")
  $students.each { |student| export_file.puts "#{student[:name]}, #{student[:cohort]}, #{student[:hobby]}" }
  export_file.close
  puts "File exported: #{name}.csv\n "
end

def import_list(filename=nil)
  print_actions = (filename ? false : true)
  print "Import file: " if print_actions
  import_file = File.open("#{filename = (filename ? filename : STDIN.gets.chomp)}", "r")
  import_file_content(import_file.readlines)
  import_file.close
  puts "File imported: #{filename}\n " if print_actions
end

def import_file_content(content)
  content.each_with_index do |line, i|
    if i != 0
      name, hobby = line.chomp.split(", ")
      $students << {:name => name, :cohort => content[0].chomp.to_sym, :hobby => hobby}
    end
  end
end

def try_startup_import
  filename = ARGV[0]
  return if filename.nil?
  File.exists?(filename) ? import_list(filename) : exit
end

import_list("cohort_hp.csv")
try_startup_import
interactive_menu