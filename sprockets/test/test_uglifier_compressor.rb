require 'sprockets_test'
require 'sprockets/uglifier_compressor'

class TestUglifierCompressor < Sprockets::TestCase
  test "compress javascript" do
    input = {
      content_type: 'application/javascript',
      data: "function foo() {\n  return true;\n}",
      cache: Sprockets::Cache.new
    }
    output = "function foo(){return!0}"
    assert_equal output, Sprockets::UglifierCompressor.call(input)
  end
end
