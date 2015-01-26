class NoSCache
  class << self
    def command str
      if !@@run_commands.keys.include?(str)
        @@run_commands[str] = `#{str}`
      end
      
      return @@run_commands[str]
    end
    
  end
  
end