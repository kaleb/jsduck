require "jsduck/class"

describe JsDuck::Class do

  describe "#members_hash" do

    before do
      @classes = {}
      @parent = JsDuck::Class.new({
          :name => "ParentClass",
          :method => [
            {:name => "baz"},
            {:name => "foo"},
            {:name => "frank", :private => true},
          ]
        }, @classes);
      @classes["ParentClass"] = @parent
      @child = JsDuck::Class.new({
          :name => "ChildClass",
          :extends => "ParentClass",
          :method => [
            {:name => "foo"},
            {:name => "bar"},
            {:name => "zappa", :private => true},
          ]
        }, @classes);
      @classes["ChildClass"] = @child
    end

    it "returns all public members in current class" do
      ms = @parent.members_hash(:method)
      ms.values.length.should == 2
      ms["foo"][:member].should == "ParentClass"
      ms["baz"][:member].should == "ParentClass"
    end

    it "also returns all public members in parent class" do
      ms = @child.members_hash(:method)
      ms.values.length.should == 3
      ms["foo"][:member].should == "ChildClass"
      ms["bar"][:member].should == "ChildClass"
      ms["baz"][:member].should == "ParentClass"
    end
  end

  describe "#inherits_from" do

    before do
      @classes = {}
      @parent = JsDuck::Class.new({
        :name => "Parent",
      }, @classes);
      @classes["Parent"] = @parent

      @child = JsDuck::Class.new({
        :name => "Child",
        :extends => "Parent",
      }, @classes);
      @classes["Child"] = @child

      @grandchild = JsDuck::Class.new({
        :name => "GrandChild",
        :extends => "Child",
      }, @classes);
      @classes["GrandChild"] = @grandchild
    end

    it "true when asked about itself" do
      @parent.inherits_from?("Parent").should == true
    end

    it "false when asked about class it's not inheriting from" do
      @parent.inherits_from?("Child").should == false
    end

    it "true when asked about direct parent" do
      @child.inherits_from?("Parent").should == true
    end

    it "true when asked about grandparent" do
      @grandchild.inherits_from?("Parent").should == true
    end
  end

end