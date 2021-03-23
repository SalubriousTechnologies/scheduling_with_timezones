require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  # We will have the following process, a doctor while being created can setup their 
  # schedule, now the schedule is provided in local time obviously. At the time of
  # storing the data in the database, before saving it the following steps will be done
  # 1. Change the provided time and day to instead be a Time object that is of the
  #     nearest day, then we change it be of UTC format in GMT time zone, now we check
  #     which day is this time, this is the time schedule of the doctor in GMT/UTC time
  #     zone. Now all queries against the doctor's schedule need to be run against the
  #     UTC date and time which will automatically ensure that we are always searching
  #     and making bookings in the same time zone. 
  
  test "doctor exists" do
    assert_equal Doctor.count, 2
  end

  test "Add doctor and their schedule" do
    assert_difference 'Doctor.count', 1 do
      Doctor.create(name: "new doctor", time_zone_field: "Karachi")
    end
    assert_difference 'Schedule.count', 1 do
      Schedule.create(doctor: Doctor.last, day_identifier: 1, start_time: "15:00", end_time: "18:00")
    end
    assert_equal Schedule.last.day_identifier, 1
  end

  test "Doctors schedule accounts for time_zone differences" do
    Schedule.create(doctor: doctors(:doctor_in_pakistan), day_identifier: 1, start_time: "3:00", end_time: "4:00")
    assert_equal Schedule.last.day_identifier, 7
  end

end
