require 'csv'

class EnergyQuery

def initialize(input, query_type, building)
  @input = input
  @query_type = query_type
  @building = building
end
  #  "example_homes_data.csv"

  def read_file
 @data = CSV.read("#{@input}", headers:true)
  end

#remove self
  def query
    read_file
    if @query_type.include? "peak_usage"
      peak_usage(@building)
    elsif @query_type.include? "expected_savings"
      expected_savings(@building)
    end
  end


  def peak_usage(building)
    maxUsage = [0.0, 1]
    @data.each do |entry|
      if entry["building_id"] == building
        if entry["kwh_usage"].to_f > maxUsage[0].to_f
          maxUsage = [entry["kwh_usage"], entry["hour"]]
        end
      end
    end

    if maxUsage == [0.0, 1]
      puts ("#{building} is not in the data set!")
    else
      puts ("peak_usage #{building} #{maxUsage[0]} #{maxUsage[1]}:00")
    end

  end

  def expected_savings(building)
    totalUsage = 0
    startPeakTime = 12
  endPeakTime = 18
    @data.each do |entry|
      if entry["building_id"] == building && ((startPeakTime...endPeakTime).include? entry["hour"].to_f)
        totalUsage += entry["kwh_usage"].to_f
      end
    end

    percentSaved = 0.3
    savings = totalUsage * percentSaved

    puts ("expected_savings #{building} #{savings} kWh")
  end



end

if ARGV.length == 3
  input = ARGV[0]
  query_type = ARGV[1]
  building = ARGV[2]

  EnergyQuery.new(input, query_type, building).query
end
