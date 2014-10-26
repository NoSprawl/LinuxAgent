require 'pp'
require 'colorize'
require 'mongo'
require_relative '../lib/NoSPrint'

$mongo_client = Mongo::MongoClient.new("linus.mongohq.com", 10026)
$db = $mongo_client.db "nosprawl_vulnerabilities"
$db.authenticate "ruby", "shadowwood"
$collection = $db.collection "vulnerabilities"

NoSPrint::Config.load_drivers

puts "NoS Print 1.0.2".red
puts "System package fingerprinting by NoSprawl".red
puts "https://github.com/nosprawl".red
puts ""
print "Package manager: ".blue
print ("%s (%s)\n" % [NoSPrint::Config.package_manager_name,
                      NoSPrint::Config.operating_system_info]).yellow

$spinner_on = false
$spinner_frames = ["|", "/", "-", "\\"]
$spinner_index = 0

def startSpinner
  $spinner_on = true
  
  Thread.new do
    while $spinner_on
      print " Scanning for known vulnerabilities " + $spinner_frames[$spinner_index] + "\r"
      if $spinner_index < 3
        $spinner_index += 1
      else
        $spinner_index = 0
      end
      
      sleep 0.1
    end
    
  end
  
end

$updated = 0
$outofdate = 0
$total = 1
$all_packages = NoSPrint::Config.package_manager_bridge.allPackages
$all_packages_bare = []
$fulltotal = $all_packages.length

$all_packages.each do |package|
  print " Analyzing installed packages: ".blue
  $all_packages_bare << package.name
  print ((100 * $total / $fulltotal).to_s + "%").green + "\r"
  
  if package.installed_version != package.latest_version
    $outofdate += 1
  else
   $updated += 1
  end
  
  $total += 1
end

print "Installed packages: ".blue
print $total.to_s.green + "              \r"
puts ""

print "Running services: ".blue
print "0".green

puts ""
print "Up to date packages: ".blue
print $updated.to_s.green + "\n"
print "Out of date packages: ".blue
print $outofdate.to_s.red + "\n"

startSpinner

$vulnerabilities = 0

$all_packages.each do |package|
  $collection.find({'product' => package.name, 'version' => package.installed_version}).each do |document|
    puts "VULNERABILITY FOUND"
    $vulnerabilities += 1
  end
  
end

$spinner_on = false
puts ""

print "Vulnerable packages: ".blue
print $vulnerabilities.to_s.red + "     \r"
puts ""

if $outofdate == 0
  print "Your packages".green
  print " (#{$all_packages_bare.join(', ')}) "
  print "are all up to date.".green
end

puts ""