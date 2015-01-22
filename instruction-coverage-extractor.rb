require 'nokogiri'

def jacoco(doc)
  node = doc.at_xpath('//report/counter[@type="INSTRUCTION"]')
  missed = node.attributes["missed"].value.to_f
  covered = node.attributes["covered"].value.to_f
  (covered / (missed + covered)).round 2
end

def pom(doc)
  doc.remove_namespaces!
  doc.xpath("//coverage.it.rate").text.to_f
end

doc = Nokogiri::XML(File.open(ARGV[1]))
if ARGV[0].eql? "-jacoco"
  puts jacoco(doc)
elsif ARGV[0].eql? "-pom"
  puts pom(doc)
end
