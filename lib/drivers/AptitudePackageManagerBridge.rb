class AptitudePackageManagerBridge < NoSPrint::PackageManagerBridge
  class << self
    def name
      "aptitude"
    end
    
    def allPackages
      result = `aptitude search '~i'`
      result = result.split "\n"
      native = []
      result.each do |package_name|
        native << NoSPrint::Package.new(package_name[0].split("-")[0].split(" ")[-1])
      end
      
      native
    end
    
    def version package
      result = `apt-cache policy #{package.name}`
      /Installed: (.*)/.match(result)[1]
      result.split("\n").first.split(" ").last
    end
    
    def latest_version package
      result = `apt-cache policy #{package.name}`
      /Candidate: (.*)/.match(result)[1]
      result.split("\n").first.split(" ").last
    end
    
  end
  
end
