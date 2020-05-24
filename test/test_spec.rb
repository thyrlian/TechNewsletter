require_relative 'helper'

class TestSpec < Minitest::Test
  def setup
    @spec = Spec.new
  end

  def test_constructor
    assert_equal({}, @spec.instance_variable_get(:@tree))
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
