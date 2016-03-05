namespace :bloom_group do
  desc "Delete Crashed CallOutLists"
  task :delete_crashed_lists => [:environment] do |t, args|
    lists = EmployeeCallOutList.incomplete
    puts "Removing #{lists.count} lists"
    lists.destroy_all
    puts "Done!"
  end
  
  desc "Quickly clean up shifts"
  task :clear_all_shifts => [:environment] do |t,args|
    #raise "Only run in Development" if !Rails.env.development?

    Shift.destroy_all
    EmployeeShift.destroy_all
    EmployeeCallOutList.destroy_all
    EmployeeCallOut.destroy_all

  end
end
