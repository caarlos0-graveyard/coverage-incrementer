require 'nokogiri'

class Pom
  def initialize(doc)
    @doc = doc
    @doc.remove_namespaces!
  end

  def instructions
    @doc.xpath("//coverage.it.rate").text.to_f
  end

  def missed
    @doc.xpath("//coverage.it.missclasses").text.to_i
  end

  def to_s
    "instruction=#{instructions}, missed=#{missed}"
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

  def missed
    node = @doc.at_xpath('//report/counter[@type="CLASS"]')
    node.attributes["missed"].value.to_i
  end

  def to_s
    "instruction=#{instructions}, missed=#{missed}"
  end
end

doc = Nokogiri::XML(File.open(ARGV[1]))
if ARGV[0].eql? "-jacoco"
  puts Jacoco.new(doc)
elsif ARGV[0].eql? "-pom"
  puts Pom.new(doc)
end
