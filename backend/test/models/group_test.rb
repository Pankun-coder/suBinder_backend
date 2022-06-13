require "test_helper"

class GroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup 
    @group = Group.new(name: "group_name", password: "password", password_confirmation: "password")
  end

  test "set-up Group should be valid" do 
    assert @group.save, "didn't save set-up Group"
  end

  test "pw and pw_confirmation should be idnetical" do
    @group.password_confirmation = "passwor"
    assert_not @group.save, "saved Group with not identical pw and pw_conf"
  end

end
