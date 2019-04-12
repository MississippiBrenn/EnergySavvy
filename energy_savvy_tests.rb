require 'minitest/autorun'
require_relative 'energy_savvy.rb'

class Energy_savvy_tests < Minitest::Test


  def test_returns_an_object
    query_start = EnergyQuery.new
    assert query_start != nil
  end

  def test_gets_data
    @testData = CSV.read("example_homes_data.csv", headers:true)
    assert @testData != nil
  end

  def test_returns_correct_peak_usage
  
    peak_usage_result = EnergyQuery.peak_usage("white_museum", @testData)
    assert peak_usage_result == "peak_usage white_museum 7.797688 19:00"
  end

end
