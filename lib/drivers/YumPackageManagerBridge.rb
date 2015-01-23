class YumPackageManagerBridge < NoSPrint::PackageManagerBridge
  class << self
    def name
      "yum"
    end

    def allPackages info = false, ret = :currently_installed_version
      native = []
      if ret == :currently_installed_version
        raw_yum_by_line = `yum list installed`.split("\n")
      elsif ret == :latest_available_version
        raw_yum_by_line = `yum list available`.split("\n")
      end

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
    
    def version package, latest = false
      res = nil
      if !latest
        res = allPackages true
      else
        res = allPackages true, :latest_available_version
      end

      res.each do |package_listing|
        if package_listing[:package_name] == package
          return package_listing[:package_version]
        end

      end

    end

    def latest_version package
      version package, true
    end

  end

end
