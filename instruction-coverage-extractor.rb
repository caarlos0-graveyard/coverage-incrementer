require 'nokogiri'

class Pom
  def initialize(doc)
    @doc = doc
    @doc.remove_namespaces!
  end

  def line_rate
    @doc.xpath("//coverage.line.rate").text.to_f
  end

  def branch_rate
    @doc.xpath("//coverage.branch.rate").text.to_f
  end

  def missed
    @doc.xpath("//coverage.missclasses").text.to_i
  end

  def to_s
    "line rate=#{line_rate}, branch rate=#{branch_rate}, missed=#{missed}"
  end
end

class Jacoco
  def initialize(doc)
    @doc = doc
  end

  def line_rate
    node = @doc.at_xpath('//report/counter[@type="INSTRUCTION"]')
    missed = node.attributes["missed"].value.to_f
    covered = node.attributes["covered"].value.to_f
    (covered / (missed + covered)).round(2)
  end

  def branch_rate
    node = @doc.at_xpath('//report/counter[@type="BRANCH"]')
    missed = node.attributes["missed"].value.to_f
    covered = node.attributes["covered"].value.to_f
    (covered / (missed + covered)).round(2)
  end

  def missed
    node = @doc.at_xpath('//report/counter[@type="CLASS"]')
    node.attributes["missed"].value.to_i
  end

  def to_s
    "line rate=#{line_rate}, branch rate=#{branch_rate}, missed=#{missed}"
  end
end

doc = Nokogiri::XML(File.open(ARGV[1]))
if ARGV[0].eql? "-jacoco"
  puts Jacoco.new(doc)
elsif ARGV[0].eql? "-pom"
  puts Pom.new(doc)
end
