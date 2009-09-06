namespace("liquibase") do
  
  def rails_environment
    ENV['RAILS_ENV'] || RAILS_ENV || 'development'
  end
  
  def current_environment(rails_env = rails_environment)
    ActiveRecord::Base.configurations[rails_env]
  end
  
  task(:prereq).enhance(:environment) do
    puts "Including Liquibase's .jar"
    require 'java'
    require 'lib/jar/liquibase-1.9.1.jar'
  end

  task("drop" => :prereq).enhance do
    Liquibase.for(current_environment).run do
      and_do dropAll
    end
  end
  
  task("update" => :prereq).enhance do
    Liquibase.for(current_environment).run do
      with changeLogFile "db/schema/master.xml"
      and_do update
    end
  end
  
  task(:dump => :prereq).enhance do
    Liquibase.for(current_environment).run do
      and_do generateChangeLog
    end
  end
  
end
