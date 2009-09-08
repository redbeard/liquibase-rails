require 'rake'

namespace("liquibase") do

  def rails_environment
    ENV['RAILS_ENV'] || RAILS_ENV || 'development'
  end

  def current_environment(rails_env = rails_environment)
    ActiveRecord::Base.configurations[rails_env]
  end

  task(:prereq).enhance([:environment]) do
    begin
      require 'java'
      require 'liquibase/jar/liquibase-1.9.1.jar'
    rescue LoadError
      puts "Could not load liquibase's jar"
    end
  end

  task("drop" => :prereq).enhance do
    Liquibase.for(current_environment).run do
      and_do dropAll
    end
  end

  task("update" => :prereq).enhance do
    Liquibase.for(current_environment).run do
      with changeLogFile "#{RAILS_ROOT}/db/schema/master.xml"
      and_do update
    end
  end

  task(:dump => :prereq).enhance do
    Liquibase.for(current_environment).run do
      and_do generateChangeLog
    end
  end

end
