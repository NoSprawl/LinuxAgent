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
      /[0-9]+\.[0-9]+([\.][0-9])*/.match(result.split("\n").first)[0] rescue result.split("\n").first
    end
    
    def latest_version package
      result = `brew outdated`
      ret = nil
      result.split("\n").each do |raw_pkg|
        puts result
        columns = raw_pkg.split(' ')
        if columns.first == package.name
          ret = columns.last.split(" \< ")[0][1..-1]
        end
        
      end
      
      return package.installed_version if ret.nil?
      return ret
    end
    
  end
  
end
