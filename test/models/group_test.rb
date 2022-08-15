require "test_helper"

class GroupTest < ActiveSupport::TestCase
  def setup
    @group = Group.new(name: "Examle group", password: "aaa123", password_confirmation: "aaa123")
  end

  test "set-up group should be valid" do
    assert @group.save, "did not save set-up group"
  end

  test "should not save group without name" do
    @group.name = ""
    assert_not @group.save, "saved group without name"
  end

  test "pw and pw_confirmation should be idnetical" do
    @group.password_confirmation = "aaa1234"
    assert_not @group.save, "saved group with not identical pw and pw_conf"
  end

  test "password should not be less than 6 chars" do
    @group.password = ("a" * 4) + "1"
    assert_not @group.save, "saved group with 5-letter-password"
  end

  test "password should not consist of only alphabets" do
    @group.password = "a" * 6
    assert_not @group.save, "saved group with password which does not contain numbers"
  end

  test "password should not consist of only numbers" do
    @group.password = "1" * 6
    assert_not @group.save, "saved group with password which does not contain alphabets"
  end
end
