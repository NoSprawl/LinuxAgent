module NoSPrint
  class Config
    class << self
      def load_drivers
        Dir.entries(File.dirname(__FILE__) + "/drivers").each do |file|
          require_relative "drivers/%s" % file if file[0] != "."
        end
    
      end
      
      def package_manager_name
        package_manager_bridge.name
      end
      
      def operating_system_info
        RUBY_PLATFORM
      end
      
      def package_manager_bridge
        # Check for homebrew
        if !%x("brew").nil?
          @@package_manager_name = "homebrew"
          return HomebrewPackageManagerBridge
        end
        
      end
      
    end
    
  end
  
  class Package
    def initialize name
      @name = name
    end
    
    def name
      @name
    end
    
    def installed_version
      Config.package_manager_bridge.version self
    end
    
    def latest_version
      Config.package_manager_bridge.latest_version self
    end
    
  end
  
  class PackageManagerBridge
    class << self
      def name
        "N/A - Base Implementation"
      end
      
      def allPackages
        []
      end
    
      def version package
        ""
      end
    
      def latest_version package
        ""
      end
    
    end
    
  end
  
end