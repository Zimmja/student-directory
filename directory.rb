$students = []
$cohorts = []

#----------------------------------------
# INTERACTIVE MENU 
#----------------------------------------
def interactive_menu # This menu will continue to loop until a blank choice is selected.
  im_show_options
  im_chose_something = im_choice(STDIN.gets.chomp.upcase)
  interactive_menu if im_chose_something # Run this method again if user entered anything other than a blank choice
end

def im_show_options
  print_header("directory menu")
  puts " (V) List students
 (A) Add students to cohort
 (C) Add cohort to directory
 (D) Delete students from directory
 (E) Export list
 (I) Import list
 (S) Source code
 Press ENTER without choosing an option to exit"   
end

def im_choice(choice)
  case choice
    when "A" then input_students
    when "C" then choice_add_cohort
    when "D" then choice_delete_students
    when "V" then choice_view_students
    when "E" then export_list
    when "I" then import_list
    when "S" then view_source
    when "" then return false
    else invalid_input("Please choose from the listed options")
  end
  return true # Returns true to signal that a choice was made
end

#----------------------------------------
# GENERIC MESSAGES
#----------------------------------------

def invalid_input(to_do)
  puts "\nERROR: INVALID INPUT. #{to_do}.\n "
end

def print_header(header)
  puts "#{dashes = "-"*40}\n#{header.upcase}\n#{dashes}"   
end

def print_footer
  puts "#{directory_count_statement}\nPress ENTER to return to menu"
  STDIN.gets # This is here so the user has to press ENTER to proceed; gives user a moment to achknowledge this statement before proceeding
end

def directory_count_statement # e.g. "There is 1 student in the directory.""
  "There #{(sc = $students.count) == 1? "is" : "are"} #{sc} student#{sc == 1? "" : "s"} in the directory."
end

#----------------------------------------
# VIEWING STUDENTS
#----------------------------------------

def choice_view_students
  print_header("list of students")
  print_names($students)
  print_footer
end

def print_names(students, by_cohort=true, s_char="", u_twelve=false)
  sort_students
  students.select! { |s| s[:name].chr.downcase == s_char.downcase } if s_char != "" # If s_char is specified, proceeds only with students whose name begins with s_char
  students.select! { |s| s[:name].size < 12 } if u_twelve # If u_twelve is true, proceeds only with students whose names are less that 12 characters
  by_cohort ? print_names_by_cohort(students) : print_names_by_list(students)
end

def print_names_by_cohort(students)
  update_cohorts
  $cohorts.each do |cohort|
    puts "#{cohort.to_s} cohort:"
    cohort_students = students.select { |s| s[:cohort] == cohort } # Creates a list of students in the cohort
    cohort_students.count == 0 ? (puts "  This cohort is empty") : cohort_students.each_with_index { |x, i| puts "  #{i+1}. #{x[:name]}" }
  end
end

def print_names_by_list(students)
  (students.map { |s| "#{s[:name]}, cohort: #{s[:cohort]}. Hobby: #{s[:hobby]}" }).sort.each_with_index { |st, i| puts "  #{i+1}. #{st}" } # An alphabetical list of students, with cohort and hobbies listed
end

def sort_students # Sorts the $students global into alphabetical order
  $students.sort_by! { |student| student[:name]}
end

def update_cohorts
  student_cohorts = ($students.map { |s| s[:cohort] }).uniq # Returns an array listing all cohorts contained in the hashes within $students
  $cohorts << student_cohorts
  $cohorts.flatten!
  $cohorts.uniq!
end

#----------------------------------------
# DELETE STUDENTS
#----------------------------------------

def choice_delete_students
  print_header("delete students from directory")
  loop do
    s_count = $students.count
    puts "Please enter a student number between 1 and #{s_count} to delete them from the directory\nOR leave blank and press ENTER to return to menu"
    print_names($students, false) # This uses the function from the VIEWING STUDENTS section, but with a false second parameter
    break if check_delete_choice(STDIN.gets.chomp, s_count) == false # Call check_delete_choice, and breaks this loop if the method returns false (i.e. no students chosen for deletion)
  end 
end

def check_delete_choice(choice, s_count)
  return false if choice == ""
  choice_i = choice.to_i - 1 # e.g. If choosing student "1.", the index we'll need to delete is 0
  valid_choice = (0...s_count).include?(choice_i) # True if the chosen number is between 1 and the number of students in the directory
  valid_choice ? delete_student(choice_i) : invalid_input("Please choose a number between 1 and #{s_count}")
end

def delete_student(i)
  sort_students
  puts "\n#{$students[i][:name]} removed from directory\n "
  $students.delete_at(i)
end

#----------------------------------------
# ADD COHORT
#----------------------------------------

def choice_add_cohort
  update_cohorts # Double-check the cohorts are up to date
  print_header("add cohort to directory")
  loop do
    puts "Cohorts:"
    $cohorts.each_with_index {|c, i| puts "  #{i+1}. #{ c}"}
    puts "Enter a new cohort below\nOR leave blank and press ENTER to return to menu"
    break if check_cohort_choice(STDIN.gets.chomp) == false # Call check_cohort_choice, and breaks this loop if the method returns false (i.e. no new cohorts added)
  end
end

def check_cohort_choice(choice)
  return false if choice == ""
  $cohorts.include?(choice.to_sym) ? invalid_input("There is already a cohort named '#{choice}'") : confirm_cohort_choice(choice)
end

def confirm_cohort_choice(choice)
  puts "\nAre you sure you want to add a new cohort named '#{choice}'?\nEnter 'n' to cancel, or press any other key to confirm."
  confirmed = STDIN.gets.chomp.downcase != "n"
  $cohorts << choice.to_sym if confirmed
end

#----------------------------------------
# ADD STUDENTS
#----------------------------------------

def input_students
  print_header("add to directory")
  puts directory_count_statement($students)
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

def try_startup_import(is_csv=false)
  filename = (ARGV[0].nil? ? "cohort_hp.csv" : ARGV[0]) # default added
  import_list(filename, is_csv) if File.file?(filename)
end

def import_list(filename=nil, is_csv)
  filename = check_import(filename)
  if File.file?(filename)
    is_csv ? import_file_content(CSV.foreach(filename), true) : File.open("#{filename}", "r") { |file| import_file_content(file.readlines) }
    puts "File imported#{is_csv ? " (csv)" : ""}: #{filename}"
  else
    puts "ERROR: file not found"
  end
end

def check_import(filename)
  return filename if filename
  print "Import file: "
  STDIN.gets.chomp
end

def import_file_content(content, is_csv=false)
  content.each_with_index do |line, i|
    if i != 0
      name, hobby = (is_csv ? line : line.chomp.split(","))
      $students << {:name => name, :cohort => (is_csv ? content.first[0] : content[0].chomp).to_sym, :hobby => hobby}
    end
  end
end

def view_source
  File.open(__FILE__, "r") { |file| file.readlines.each { |x| puts x } }
end

require "csv"
try_startup_import(true)
interactive_menu