require "test_helper"

class StudentTest < ActiveSupport::TestCase
  def setup
    @group = Group.create(name: "Example group", password:"aaaaa1", password_confirmation:"aaaaa1")
    @student = @group.students.new(name:"Example student")
  end

  test "set-up students should be valid" do
    assert @student.save, "did not save set-up student"
  end
end
