require 'test/unit'
require 'dsc'

class TestDscCommand < Test::Unit::TestCase

  def test_timesfilter_last_hour
    command = Dsc::Command.new()
    assert_equal DeepSecurity::TimeFilter.last_hour, command.parse_time_filter("last_hour")
  end

  def test_timesfilter_last_24_hours
    command = Dsc::Command.new()
    assert_equal DeepSecurity::TimeFilter.last_hour, command.parse_time_filter("last_hour")
  end

  def test_timesfilter_last_7_days
    command = Dsc::Command.new()
    assert_equal DeepSecurity::TimeFilter.last_7_days, command.parse_time_filter("last_7_days")
  end

  def test_timesfilter_last_day
    command = Dsc::Command.new()
    assert_equal DeepSecurity::TimeFilter.last_day, command.parse_time_filter("last_day")
  end


  def test_timesfilter_timestamp
    command = Dsc::Command.new()
    time = Time.new(2002, 10, 31, 2, 2, 2, "+02:00")
    command.parse_time_format("%Y-%m-%d %H:%M-%S %z")
    assert_equal "2002-10-31 02:02:02 +0200", command.to_display_string(time)
  end

end
