task :import => :environment do 
  require 'roo'
  
  ss = Excel.new("/Users/brads/Documents/Schoolwork/Senior\ Seminar/Project\ Files/Query1.xls")
  
  (ss.first_row+1..ss.last_row).each do |row_n|
    person_id = ss.cell(row_n, 1)
    last_name = ss.cell(row_n, 2)
    first_name = ss.cell(row_n, 3)
    course_title = ss.cell(row_n, 4)
    course_completed_date = ss.cell(row_n, 5)
    course_expiration_date = ss.cell(row_n, 6)
    bu_code = ss.cell(row_n, 7)
    
    # Just for now, delete all the instances of this person
    #deleteable = Person.find(:all, :conditions => {:first_name => first_name, :last_name => last_name})
    #deleteable.each do |person|
    #  person.destroy
    #end
    
    # Does the person exist in the DB currently?
    person = Person.find(:first, :conditions => { :hrid => person_id })
    if(person.nil?)
      person = Person.new( :hrid => person_id, 
                              :first_name => first_name, 
                              :last_name => last_name)
      if(person.save!)
        puts "New Person: #{first_name} #{last_name}"
      else
        puts "Couldn't create new person '#{first_name} #{last_name}'"
      end
    else 
      puts "Found #{first_name} #{last_name}"
    end
  end
end