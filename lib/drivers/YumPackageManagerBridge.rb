class YumPackageManagerBridge < NoSPrint::PackageManagerBridge
  class << self
    def name
      "yum"
    end

    def sanitize_version_number version_number
      if version_number.include?('amzn1')
        return version_number
      else
        return version_number
      end

    end

    def allPackages
      collection = []
      `yum list installed`.scan(/^([\S]+)\.[\S]+[\s]+([\S|\.]+)/).each do |pair|
        version_number = pair.last
        version_number = sanitize_version_number version_number

        product_name = pair.first
        collection << NoSPrint::Package.new(product_name, version_number)
      end

      return collection
    end
    
    def version package
      `yum list available`.scan(/^([\S]+)\.[\S]+[\s]+([\S|\.]+)/).each do |pair|
        version_number = pair.last
        version_number = sanitize_version_number version_number

        package_version_number = package.version
        package_version_number = sanitize_version_number package.version

        if package.name == pair.first
          return package.version
        end

      end

      return "unknown"

    end

    def latest_version package
      version package
    end

  end

end
