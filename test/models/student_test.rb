require "test_helper"

class StudentTest < ActiveSupport::TestCase
  def setup
    @group = groups(:one)
    @student = @group.students.new(name: "Example student")
  end

  test "set-up students should be valid" do
    assert @student.save, "did not save set-up student"
  end

  test "student should not save without group" do
    @student.group = nil
    assert_not @student.save, "student saved without group"
  end

  test "student should not save without name" do
    @student.name = nil
    assert_not @student.save, "student saved without name"
  end
end
