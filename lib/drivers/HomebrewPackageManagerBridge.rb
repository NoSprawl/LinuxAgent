class HomebrewPackageManagerBridge < NoSPrint::PackageManagerBridge
  class << self
    def name
      "homebrew"
    end
    
    def allPackages
      result = `brew list`
      result = result.split "\n"
      native = []
      result.each do |package_name|
        native << NoSPrint::Package.new(package_name)
      end
      
      native
    end
    
    def version package
      result = `brew info #{package.name}`
      result.split("\n").first.split(" ").last
    end
    
    def latest_version package
      result = `brew outdated`
      ret = nil
      result.split("\n").each do |raw_pkg|
        columns = raw_pkg.split(' ')
        if columns.first == package.name
          ret = columns.last
        end
        
      end
      
      return package.installed_version if ret.nil?
      return ret
    end
    
  end
  
end
