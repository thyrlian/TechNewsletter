require_relative 'helper'

class TestSLMParser < Minitest::Test
  def test_constructor_with_nonexistent_file
    assert_raises RuntimeError do
      SLMParser.analyze('test/xyz.slm') {}
    end
  end

  def test_constructor_with_empty_file
    parser = SLMParser.analyze('test/empty.slm') {}
    assert(parser.spec.instance_variable_get(:@tree).empty?)
  end

  def test_constructor
    parser = SLMParser.analyze('test/test.slm') {}
    tree = parser.spec.instance_variable_get(:@tree)
    assert_equal(['Name', 'Date', 'Masthead', 'Test', 'CheckItOut', 'Article', 'Imprint'], tree.keys)
    assert_equal([:data], tree['Name'].keys)
    assert_equal([:data], tree['Date'].keys)
    refute(tree['Name'][:data].empty?)
    assert_equal([:data, :children], tree['Masthead'].keys)
    assert(tree['Masthead'][:data].nil?)
    assert_equal(['Image', 'Link'], tree['Masthead'][:children].keys)
    assert_equal('I have some leading spaces, and trailing as well', tree['CheckItOut'][:data])
  end

  def test_normalize
    assert_equal("Foobar", SLMParser.normalize("Foobar"))
    assert_equal(" Foobar", SLMParser.normalize(" Foobar"))
    assert_equal("  Foobar", SLMParser.normalize("  Foobar"))
    assert_equal("  Foobar", SLMParser.normalize("\tFoobar"))
    assert_equal("    Foobar", SLMParser.normalize("\t\tFoobar"))
    assert_equal("      Foobar", SLMParser.normalize("\t\t\tFoobar"))
    assert_equal("Foo  Bar", SLMParser.normalize("Foo  Bar"))
    assert_equal("Foo\tBar", SLMParser.normalize("Foo\tBar"))
    assert_equal("Foo\t\tBar", SLMParser.normalize("Foo\t\tBar"))
  end

  def test_is_at_root_positive
    assert(SLMParser.is_at_root?('Article'))
    assert(SLMParser.is_at_root?('⇥Article⇤'))
    assert(SLMParser.is_at_root?(' ⇥Article⇤'))
  end

  def test_is_at_root_negative
    refute(SLMParser.is_at_root?('  ⇥Article⇤'))
    refute(SLMParser.is_at_root?('   ⇥Article⇤'))
    refute(SLMParser.is_at_root?('    ⇥Article⇤'))
  end
end
