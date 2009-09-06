module Liquibase
  
  def self.for(config)
    self.configure do
      with data_directory "db/schema"
      with driver config["driver"]

      with username config["username"]
      and_with password config["password"]
      
      with url config["url"]

      with logLevel "warning"
    end
    
  end

  
  def self.configure(&block)
    CommandLine.new.configure(&block)
  end
  
  def self.run(&block)
    Liquibase.run(&block)
  end
  
  class CommandLine
    attr_reader :commands
    
    def help
      CommandProperty.new("help")
    end
    
    def method_missing(symbol, *args)
      if (args.length == 0) then 
        return CommandPart.new(symbol)
      end 
      
      if (args.length == 1) then 
        return CommandPart.new(symbol, *args)
      end
      
      super(symbol, *args)
    end
    
    def run(&block)
      configure(&block)
      execute
    end
    
    alias_method :configure, :instance_eval
    
    def initialize()
      @commands = []
    end
    
    def execute()
      args = @commands.map { | command | command.to_args }
      args_array = args.flatten.map { | arg | arg.to_s }
      # puts "Running liquibase with arguments: #{args_array.inspect}"
      Java::liquibase.commandline.Main.main( args_array.to_java(:string) )
    end
    
    def data_directory(data_dir)
      classpath data_dir
    end
    
    def with(command_part)
      @commands << verified_is_command_part(command_part).as_property
      self
    end
    
    alias_method(:and_with, :with)
    
    def and_do(command_part)
      @commands << verified_is_command_part(command_part).as_imperative
      self
    end
    
    private
    
    def verified_is_command_part(command_part)
      raise "#{command_part.inspect} is not a command part" unless command_part.kind_of? CommandPart
      command_part
    end
    
    class CommandPart
      attr_reader :name
      attr_accessor :value
      
      def initialize(name, value = nil)
        @name = name.to_sym 
        @value = value
      end
      
      def to_args
        raise "Subclass must implement"
      end
      
      def as_property
        CommandProperty.new(@name, @value)        
      end
      
      def as_imperative
        CommandImperative.new(@name, @value)
      end
      
    end
    
    class CommandProperty < CommandPart
      
      def value_s
        @value.nil? ? '' : "=#{@value}"
      end
      
      def to_args
        "--#{name.to_s}#{ value_s }"
      end
      
    end
    
    class CommandImperative < CommandPart 
      
      def value_s
        @value.nil? ? '' : " #{@value}"
      end
      
      def to_args
        "#{name.to_s}#{ value_s }"
      end
      
    end
    
  end
end