require 'spec_helper'
require "cancan/matchers"

describe Ability do
  let(:user) {build_stubbed(:user)}
  let(:other_user) {build_stubbed(:user)}
  subject {Ability.new(user)}

  before :each do
    user.add_role role_name
  end

  context "administrator" do
    let(:role_name) {"administrator"}
    it {should be_able_to(:manage, User)}
    it {should be_able_to(:disable, User.new)}
    it {should_not be_able_to(:enable, user)}
    it {should_not be_able_to(:disable, user)}
    it "should not be able to disabled a disabled user" do
      other_user.stub(:enabled?) {false}
      subject.should_not be_able_to(:disable, other_user)
      subject.should be_able_to(:enable, other_user)
    end
    it "should not be able to enable an enabled user" do
      other_user.stub(:enabled?) {true}
      subject.should_not be_able_to(:enable, other_user)
      subject.should be_able_to(:disable, other_user)
    end
  end

  context "user" do
    let(:role_name) {"user"}
    it {should_not be_able_to(:read, User.new)}
    it {should_not be_able_to(:update, User.new)}
    it {should_not be_able_to(:update, other_user)}
    it {should_not be_able_to(:read, other_user)}
    it {should be_able_to(:read, user)}
    it {should be_able_to(:update, user)}
  end

end
