require "test_helper"

class ClassAvailabilityTest < ActiveSupport::TestCase
  def setup
    @from = Time.zone.local(2022, 8, 1, 12, 0, 0)
    @to = Time.zone.local(2022, 8, 1, 13, 0, 0)
    @group = groups(:one)
    @student = students(:one)
    @class_availabilities = ClassAvailability.new(from: @from, to: @to, group: @group, student: @student)
  end

  test "set-up class availability should save" do
    assert @class_availabilities.save, "set-up class availability did not save"
  end

  test "class availability should have from information" do
    @class_availabilities.from = nil
    assert_not @class_availabilities.save, "class availability saved without from"
  end

  test "class availability should have to information" do
    @class_availabilities.to = nil
    assert_not @class_availabilities.save, "class availabilityu saved without to"
  end

  test "class availability should have group information" do
    @class_availabilities.group = nil
    assert_not @class_availabilities.save, "class availability saved without group"
  end

  test "student info should be optional" do
    @class_availabilities.student = nil
    assert @class_availabilities.save, "class availability did not save without student"
  end
end
