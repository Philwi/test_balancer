require "nokogiri"

class TestBalancer::ExecutionTimeXmlParser
  private

  attr_reader :xml_file_path

  public

  def initialize(xml_file_path:)
    @xml_file_path = xml_file_path
  end

  # this format is expected:
  # <?xml version="1.0" encoding="UTF-8"?>
  # <testsuites>
  #   <testsuite name="AddressTest" filepath="test/models/address_test.rb" skipped="0" failures="0" errors="0" tests="3" assertions="14" time="0.5505493701202795">
  #     <testcase name="foo" lineno="23" classname="AddressTest" assertions="5" time="0.42076598305720836" file="test/models/address_test.rb">
  #     </testcase>
  #     <testcase name="bar" lineno="33" classname="AddressTest" assertions="1" time="0.05898271000478417" file="test/models/address_test.rb">
  #     </testcase>
  #     <testcase name="baz" lineno="8" classname="AddressTest" assertions="8" time="0.07080067705828696" file="test/models/address_test.rb">
  #     </testcase>
  #   </testsuite>
  # </testsuites>
  # return Hash { test_path: 'test/first_test.rb', execution_time: 0.1 }
  def call
    doc = Nokogiri::XML(File.open(xml_file_path))
    relevant_xpath = doc.xpath("//testsuite")
    file_path = relevant_xpath.attribute("filepath").value
    execution_time = relevant_xpath.attribute("time").value.to_f

    { test_path: file_path, execution_time: }
  end
end
