class Schedule < ApplicationRecord
  belongs_to :doctor
  before_save :change_to_utc

  def change_to_utc
    local_date = Date.parse(num_to_day_mapper(self.day_identifier))
    Time.zone = Time.find_zone(self.doctor.time_zone_field)
    # for ensuring consistency, params can be changed to time here instead
    timing = Time.zone.parse(start_time.strftime("%H:%M"))
    utc_start_time = DateTime.new(local_date.year,local_date.month,local_date.day, timing.hour, timing.min, 0,timing.zone).utc
    self.day_identifier = day_to_num_mapper(utc_start_time.strftime("%A"))
    self.start_time = utc_start_time
  end

  private

    def num_to_day_mapper(num)
      day = %w[monday tuesday wednesday thursday friday saturday sunday]
      day[num-1].capitalize
    end

    def day_to_num_mapper(day)
      day_array = %w[monday tuesday wednesday thursday friday saturday sunday]
      day_array.index(day.downcase)+1
    end
end
