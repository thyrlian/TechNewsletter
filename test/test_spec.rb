require_relative 'helper'

class TestSpec < Minitest::Test
  def setup
    @spec = Spec.new
  end

  def test_constructor
    assert_equal({}, @spec.instance_variable_get(:@tree))
  end

  def test_insert_to_empty_tree
    tree = {}
    tag = 'Draft'
    data = 'Lorem ipsum'
    indent = 1
    @spec.send(:insert, tree, tag, data, indent)
    assert_equal({tag=>{:data=>data, :indent=>indent}}, tree)
  end

  def test_insert_to_children
    tag = 'Draft'
    data = 'Lorem ipsum'
    indent = 1
    tree = {'Content'=>{:data=>nil, :indent=>0, :children=>{}}}
    new_tree = Marshal.load(Marshal.dump(tree))
    @spec.send(:insert, new_tree['Content'], tag, data, indent)
    assert_equal({tag=>{:data=>data, :indent=>indent}}, new_tree['Content'][:children])
    tree = {'Content'=>{:data=>nil, :indent=>0, :children=>{'Forgery'=>{:data=>'Fake data...', :indent=>1}}}}
    new_tree = Marshal.load(Marshal.dump(tree))
    @spec.send(:insert, new_tree['Content'], tag, data, indent)
    assert_equal({'Forgery'=>{:data=>'Fake data...', :indent=>1}, tag=>{:data=>data, :indent=>indent}}, new_tree['Content'][:children])
  end

  def test_insert_with_equivalent_indent
    tree = {'Whatever'=>{:data=>'Anything', :indent=>1}, 'Last'=>{:data=>'Mock', :indent=>1}}
    new_tree = Marshal.load(Marshal.dump(tree))
    tag = 'ToInsert'
    data = 'Lorem ipsum'
    indent = 1
    @spec.send(:insert, new_tree, tag, data, indent)
    assert_equal(tree['Whatever'], new_tree['Whatever'])
    assert_equal(tree['Last'], new_tree['Last'])
    assert_equal({:data=>data, :indent=>indent}, new_tree[tag])
  end

  def test_insert_with_one_level_more_indent
    tree = {'Whatever'=>{:data=>'Anything', :indent=>1}, 'Last'=>{:data=>'Mock', :indent=>1}}
    new_tree = Marshal.load(Marshal.dump(tree))
    tag = 'ToInsert'
    data = 'Lorem ipsum'
    indent = 2
    @spec.send(:insert, new_tree, tag, data, indent)
    assert_equal(tree['Whatever'], new_tree['Whatever'])
    assert_equal({:data=>'Mock', :indent=>1, :children=>{tag=>{:data=>data, :indent=>indent}}}, new_tree['Last'])
  end

  def test_insert_with_deeper_indent
    tree = {'Whatever'=>{:data=>'Anything', :indent=>1}, 'Last'=>{:data=>'Mock', :indent=>1, :children=>{'Forgery'=>{:data=>'Fake data...', :indent=>2}}}}
    new_tree = Marshal.load(Marshal.dump(tree))
    tag = 'ToInsert'
    data = 'Lorem ipsum'
    indent = 3
    @spec.send(:insert, new_tree, tag, data, indent)
    assert_equal(tree['Whatever'], new_tree['Whatever'])
    assert_equal({:data=>'Mock', :indent=>1, :children=>{'Forgery'=>{:data=>'Fake data...', :indent=>2, :children=>{tag=>{:data=>data, :indent=>indent}}}}}, new_tree['Last'])
  end

  def test_insert_to_parent_with_children
    tree = {'Name'=>{:data=>'Unit Testing', :indent=>0}, 'Content'=>{:data=>nil, :indent=>0, :children=>{'Forgery'=>{:data=>'Fake data...', :indent=>1}}}}
    new_tree = Marshal.load(Marshal.dump(tree))
    tag = 'Post'
    data = 'Lorem ipsum'
    indent = 1
    @spec.send(:insert_to_parent, new_tree['Content'], tag, data, indent)
    assert_equal(tree['Name'], new_tree['Name'])
    assert_equal({:data=>nil, :indent=>0, :children=>{'Forgery'=>{:data=>'Fake data...', :indent=>1}, tag=>{:data=>data, :indent=>indent}}}, new_tree['Content'])
  end

  def test_insert_to_parent_with_empty_children
    tree = {'Name'=>{:data=>'Unit Testing', :indent=>0}, 'Content'=>{:data=>nil, :indent=>0, :children=>{}}}
    new_tree = Marshal.load(Marshal.dump(tree))
    tag = 'Post'
    data = 'Lorem ipsum'
    indent = 1
    @spec.send(:insert_to_parent, new_tree['Content'], tag, data, indent)
    assert_equal(tree['Name'], new_tree['Name'])
    assert_equal({:data=>nil, :indent=>0, :children=>{tag=>{:data=>data, :indent=>indent}}}, new_tree['Content'])
  end

  def test_insert_to_parent_without_children
    tree = {'Name'=>{:data=>'Unit Testing', :indent=>0}, 'Content'=>{:data=>nil, :indent=>0}}
    new_tree = Marshal.load(Marshal.dump(tree))
    tag = 'Post'
    data = 'Lorem ipsum'
    indent = 1
    @spec.send(:insert_to_parent, new_tree['Content'], tag, data, indent)
    assert_equal(tree['Name'], new_tree['Name'])
    assert_equal({:data=>nil, :indent=>0, :children=>{tag=>{:data=>data, :indent=>indent}}}, new_tree['Content'])
  end

  def test_insert_child_with_unique
    tree = {'Name'=>{:data=>'Unit Testing', :indent=>0}, 'Dummy'=>{:data=>nil, :indent=>0, :children=>{'Forgery'=>{:data=>'Fake data...', :indent=>1}}}, 'Content'=>{:data=>nil, :indent=>0}}
    tag = 'TestTag'
    data = 'Test Data one two three'
    indent = 1
    @spec.instance_variable_set(:@tree, Marshal.load(Marshal.dump(tree)))
    @spec.send(:insert_child, @spec.instance_variable_get(:@tree)['Content'], tag, data, indent)
    new_tree = @spec.instance_variable_get(:@tree)
    assert_equal(tree['Name'], new_tree['Name'])
    assert_equal(tree['Dummy'], new_tree['Dummy'])
    assert_equal({:data=>nil, :indent=>0, tag=>{:data=>data, :indent=>indent}}, new_tree['Content'])
  end

  def test_insert_child_with_duplicate
    tree = {'Name'=>{:data=>'Unit Testing', :indent=>0}, 'Dummy'=>{:data=>nil, :indent=>0, :children=>{'Forgery'=>{:data=>'Fake data...', :indent=>1}}}, 'Content'=>{:data=>nil, :indent=>0}}
    tag = 'TestTag'
    data = 'Test Data - One'
    data1 = 'Test Data - Another One'
    data2 = 'Test Data - Yet Another One'
    indent = 1
    @spec.instance_variable_set(:@tree, Marshal.load(Marshal.dump(tree)))
    @spec.send(:insert_child, @spec.instance_variable_get(:@tree)['Content'], tag, data, indent)
    @spec.send(:insert_child, @spec.instance_variable_get(:@tree)['Content'], tag, data1, indent)
    @spec.send(:insert_child, @spec.instance_variable_get(:@tree)['Content'], tag, data2, indent)
    new_tree = @spec.instance_variable_get(:@tree)
    assert_equal(tree['Name'], new_tree['Name'])
    assert_equal(tree['Dummy'], new_tree['Dummy'])
    assert_equal({:data=>nil, :indent=>0, tag=>{:data=>data, :indent=>indent}, "#{tag}1"=>{:data=>data1, :indent=>indent}, "#{tag}2"=>{:data=>data2, :indent=>indent}}, new_tree['Content'])
  end
end
