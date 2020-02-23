require_relative 'helper'

class TestParser < Minitest::Test
  def test_constructor_with_nonexistent_file
    assert_raises RuntimeError do
      Parser.analyze('test/xyz.slm') {}
    end
  end

  def test_constructor_with_empty_file
    parser = Parser.analyze('test/empty.slm') {}
    assert(parser.spec.instance_variable_get(:@tree).empty?)
  end

  def test_constructor
    parser = Parser.analyze('test/test.slm') {}
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
    assert_equal("Foobar", Parser.normalize("Foobar"))
    assert_equal(" Foobar", Parser.normalize(" Foobar"))
    assert_equal("  Foobar", Parser.normalize("  Foobar"))
    assert_equal("  Foobar", Parser.normalize("\tFoobar"))
    assert_equal("    Foobar", Parser.normalize("\t\tFoobar"))
    assert_equal("      Foobar", Parser.normalize("\t\t\tFoobar"))
    assert_equal("Foo  Bar", Parser.normalize("Foo  Bar"))
    assert_equal("Foo\tBar", Parser.normalize("Foo\tBar"))
    assert_equal("Foo\t\tBar", Parser.normalize("Foo\t\tBar"))
  end

  def test_is_at_root_positive
    assert(Parser.is_at_root?('Article'))
    assert(Parser.is_at_root?('⇥Article⇤'))
    assert(Parser.is_at_root?(' ⇥Article⇤'))
  end

  def test_is_at_root_negative
    refute(Parser.is_at_root?('  ⇥Article⇤'))
    refute(Parser.is_at_root?('   ⇥Article⇤'))
    refute(Parser.is_at_root?('    ⇥Article⇤'))
  end
end
