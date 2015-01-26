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
      lines = result.split("\n")
      matched_line = nil
      line_index = 0
      until !matched_line.nil?
        matched = nil
        
        begin
          matched = /[\w][\/]([[\d[\w]]|[\.|\_]]+[\d|[\.|\_]|])\s/.match(lines[line_index])
        rescue e
          matched = /[\/]([[\d[\w]]|[\.|\_]]+[\d|[\.|\_]|])\s\(.+\)\s[*]/.match(lines[line_index])
        end
        
        if !matched.nil?
          matched_line = matched[1]
          return matched_line
        end
        
        line_index += 1
        
        if line_index == lines.length
          matched_line = false
        end
        
      end
      
      return "UNPARSABLE"
    end
    
    def latest_version package
      result = `brew outdated --verbose` # shout out to skip wilson
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
