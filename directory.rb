$students = []

def interactive_menu
  loop do
    print_im
    break if im_choice(STDIN.gets.chomp.upcase) == false
  end
end

def print_im
  print_header("directory menu")
  puts " (R) Reset directory
 (A) Add students to directory
 (D) Delete students from directory
 (V) View list of students
 (E) Export list
 (I) Import list
 Press ENTER without choosing an option to exit"   
end

def im_choice(choice)
  case choice
    when "R" then input_students(true)
    when "A" then input_students(false)
    when "D" then delete_students
    when "V" then view_students
    when "E" then export_list
    when "I" then import_list
    when "" then return false
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

require "csv"
try_startup_import(true)
interactive_menu

# Added a default import list for start-up
# Refactored import process
# Added csv