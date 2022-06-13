require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@gmail.com", password: "password123")
  end

  test "user info should be like this" do
    assert @user.save, "did not saved set-up user"
  end

  test "should not save user without name" do
    @user.name = ""
    assert_not @user.save, "saved user without name"
  end

  test "should not save user without email" do
    @user.email = ""
    assert_not @user.save, "saved user without email"
  end

  test "should not save user without valid email" do
    @user.email = "thisisemail"
    assert_not @user.save, "saved user without valid email"
  end

  test "email should unique" do
    dup_user = @user.dup
    dup_user.email = @user.email.upcase
    @user.save
    assert_not dup_user.save, "saved user with un-unique email"
  end

  test "password should not be less than 6 chars" do
    @user.password = "a" * 4 + "1"
    assert_not @user.save, "saved user with 5-letter-password"
  end

  test "password should not consist of only alphabets" do
    @user.password = "a" * 6
    assert_not @user.save, "saved user with password which does not contain numbers"
  end

  test "password should not consist of only numbers" do
    @user.password = "1" * 6
    assert_not @user.save, "saved user with password which does not contain alphabets"
  end  
end
