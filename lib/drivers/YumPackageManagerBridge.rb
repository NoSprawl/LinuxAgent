class YumPackageManagerBridge < NoSPrint::PackageManagerBridge
  class << self
    def name
      "yum"
    end

    def allPackages info = false
      native = []
      raw_yum_by_line = `yum list installed`.split("\n")
      raw_yum_by_line.each do |line|
        version_info_items = /^(\S+)\s+(\S+)\s+(\S+)/.match(line)
        next if version_info_items.nil?
        package_name = version_info_items[0].split(".")[0]
        package_architecture = version_info_items[0].split(".")[1]
        package_version = version_info_items[1].split(".")[0]
        package_meta = (verion_info_items[1].split(".")[1] rescue "")
        native << NoSPrint::Package.new(package_name) unless info
        native << {package_name: package_name,
                   package_architecture: package_architecture,
                   package_version: package_version,
                   package_meta: package_meta} if info
      end
      
      return native
    end
    
    def version package
      allPackages(true).each do |package_listing|
        if package_listing[:package_name] == package
          return package_listing[:package_version]
        end

      end

    end

    def latest_version package
      version package
    end

  end

end
