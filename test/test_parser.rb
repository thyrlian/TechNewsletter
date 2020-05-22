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

  def test_obtain_clean_match_content_returns_object
    assert_equal('ABC!@#', SLMParser.send(:obtain_clean_match_content, /^(.*)\$/, 'ABC!@#$123'))
  end

  def test_obtain_clean_match_content_returns_object_with_space_trimmed_off
    assert_equal('ABC', SLMParser.send(:obtain_clean_match_content, /^(.*)\$/, '  ABC $123'))
  end

  def test_obtain_clean_match_content_returns_nil_because_no_match
    assert_nil(SLMParser.send(:obtain_clean_match_content, /^(.*)\$\$/, 'ABC$123'))
  end

  def test_obtain_clean_match_content_returns_nil_because_only_space
    assert_nil(SLMParser.send(:obtain_clean_match_content, /^(.*)\$/, '   $12345'))
  end

  def test_get_tag_positive
    assert_equal('Test', SLMParser.get_tag('⇥Test⇤ eins zwei drei'))
    assert_equal('TestTada', SLMParser.get_tag('⇥TestTada⇤ eins zwei drei'))
    assert_equal('Test Yeah', SLMParser.get_tag('⇥Test Yeah⇤ eins zwei drei'))
  end

  def test_get_tag_negative
    assert_nil(SLMParser.get_tag('<Test> eins zwei drei'))
  end

  def test_get_data_positive
    assert_equal('eins zwei drei, oh la la!', SLMParser.get_data('⇥Test⇤ eins zwei drei, oh la la!'))
  end

  def test_get_data_negative
    assert_nil(SLMParser.get_data('<Test> whatever'))
  end

  def test_get_indent_none
    assert_equal(0, SLMParser.get_indent('⇥Test⇤ test eins zwei drei'))
  end

  def test_get_indent_one_with_spaces
    assert_equal(1, SLMParser.get_indent('  ⇥Test⇤ test'))
  end

  def test_get_indent_one_with_tab
    assert_equal(1, SLMParser.get_indent('  ⇥Test⇤ test'))
  end

  def test_get_indent_more_with_spaces
    assert_equal(2, SLMParser.get_indent('    ⇥Test⇤ test'))
  end

  def test_get_indent_more_with_tabs
    assert_equal(3, SLMParser.get_indent('      ⇥Test⇤ test'))
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
