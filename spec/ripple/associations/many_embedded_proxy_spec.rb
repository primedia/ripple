require 'spec_helper'

describe Ripple::Associations::ManyEmbeddedProxy do
  let(:user){ User.new(:email => "riak@ripple.com") }
  let(:address){ Address.new }
  let(:addr){ Address.new(:street => '123 Somewhere') }
  let(:note){ Note.new }

  it "should not have children before any are set" do
    user.addresses.should == []
  end

  it "should be able to set and get its children" do
    user.addresses = [address]
    user.addresses.should == [address]
  end

  it "should set the parent document on the children when assigning" do
    user.addresses = [address]
    address._parent_document.should == user
  end

  it "should return the assignment when assigning" do
    rtn = user.addresses = [address]
    rtn.should == [address]
  end

  it "should set the parent document on the children when accessing" do
    user.addresses = [address]
    user.addresses.first._parent_document.should == user
  end

  it "should be able to replace its children with different children" do
    user.addresses = [address]
    user.addresses.first.street.should be_blank
    user.addresses = [addr]
    user.addresses.first.street.should == '123 Somewhere'
  end

  it "should be able to add to its children" do
    user.addresses = [address]
    user.addresses << addr
    user.addresses.should == [address, addr]
  end

  it "should be able to chain calls to adding children" do
    user.addresses = [address]
    user.addresses << address << address << address
    user.addresses.should == [address, address, address, address]
  end

  it "should set the parent document when adding to its children" do
    user.addresses << address
    user.addresses.first._parent_document.should == user
  end

  it "should be able to count its children" do
    user.addresses = [address, address]
    user.addresses.count.should == 2
  end

  it "should be able to build a new child" do
    user.addresses.build.should be_kind_of(Address)
  end

  it "should assign a parent to the children created with instantiate_target" do
    address._parent_document.should be_nil
    user.addresses.build._parent_document.should == user
  end

  it "should validate the children when saving the parent" do
    user.valid?.should be_truthy
    user.addresses << address
    address.valid?.should be_falsey
    user.valid?.should be_falsey
  end

  it "should not save the root document when a child is invalid" do
    user.addresses << address
    user.save.should be_falsey
  end

  it "should allow embedding documents in embedded documents" do
    user.addresses << address
    address.notes << note
    note._root_document.should   == user
    note._parent_document.should == address
  end

  it "should allow assiging child documents as an array of hashes" do
    user.attributes = {'addresses' => [{'street' => '123 Somewhere'}]}
    user.addresses.first.street.should == '123 Somewhere'
  end

  it "should return an array from to_ary" do
    user.addresses << address
    user.addresses.to_ary.should == [address]
  end

  it "should refuse assigning documents of the wrong type" do
    lambda { user.addresses = nil }.should raise_error
    lambda { user.addresses = address }.should raise_error
    lambda { user.addresses = [note] }.should raise_error
    lambda { user.addresses << Company.new }.should raise_error
  end

  it "should allow adding previously embedded objects of the right type" do
    user.primary_mailing_address = address
    user.addresses << user.primary_mailing_address
    user.addresses.should == [address]
  end

  it "should not add the associated validator multiple times" do
    # TODO: the validator is added lazily on first instantiation of
    # the proxy. This is a code smell!
    user.addresses
    User.validators_on(:addresses).count.should eq(1)
  end
end
