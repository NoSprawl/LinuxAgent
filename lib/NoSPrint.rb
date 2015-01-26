require 'socket'
require 'pry'

module NoSPrint
  class Config
    class << self
      def load_drivers
        Dir.entries(File.dirname(__FILE__) + "/drivers").each do |file|
          require_relative "drivers/%s" % file if file[0] != "." && !file.include?('~')
        end
    
      end
      
      def package_manager_name
        package_manager_bridge.name
      end
      
      def operating_system_info
        RUBY_PLATFORM
      end
      
      def package_manager_bridge
        begin
          `brew`
          @@package_manager_name = "homebrew"
          return HomebrewPackageManagerBridge
        rescue
          begin
            `aptitude`
            @@package_manager_name = "aptitude"
            return AptitudePackageManagerBridge
          rescue
            begin
              `yum --version`
              @@package_manager_name = "yum"
              return YumPackageManagerBridge
            rescue
              # quick hack to kill the whole app.
              exec 'echo If you got here we don\'t support your package manager'
            end

          end

        end
        
      end
      
    end
    
  end
  
  class Package
    def initialize name, version = nil
      @name = name
      @version = version
    end
    
    def name
      @name
    end

    def version
      @version
    end
    
    def safe
      {:name => name,
       :installed_version => installed_version,
       :latest_version => latest_version}
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
