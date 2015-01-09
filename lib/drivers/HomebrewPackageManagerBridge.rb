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
      /[0-9]+\.[0-9]+([\.][0-9])*/.match(result.split("\n")[2])[0] rescue result.split("\n").first
    end
    
    def latest_version package
      result = `brew outdated --verbose`
      ret = nil
      result.split("\n").each do |raw_pkg|
        vsplit = raw_pkg.split(' < ')
        version = vsplit.last[0..(vsplit.last.size-2)]
        package_name = raw_pkg.split(' ')[0]
                
        if package_name == package.name
          ret = version
        end
        
      end
      
      return package.installed_version if ret.nil?
      return ret
    end
    
  end
  
end
