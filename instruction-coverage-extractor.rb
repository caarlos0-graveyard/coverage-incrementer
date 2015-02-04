require 'nokogiri'


class Pom
  def initialize(doc)
    @doc = doc
  end

  def instructions
    @doc.remove_namespaces!
    @doc.xpath("//coverage.it.rate").text.to_f
  end
end

class Jacoco
  def initialize(doc)
    @doc = doc
  end

  def instructions
    node = @doc.at_xpath('//report/counter[@type="INSTRUCTION"]')
    missed = node.attributes["missed"].value.to_f
    covered = node.attributes["covered"].value.to_f
    (covered / (missed + covered)).round(2)
  end
end

doc = Nokogiri::XML(File.open(ARGV[1]))
parser = if ARGV[0].eql? "-jacoco"
                  Jacoco.new(doc)
                elsif ARGV[0].eql? "-pom"
                  Pom.new(doc)
                end
puts parser.instructions
