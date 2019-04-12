require 'csv'

class EnergyQuery

  #  "example_homes_data.csv"

  def self.query_start(userInput, queryBuilding)
    if userInput.include? "peak_usage"
      self.peak_usage(queryBuilding)
    elsif userInput.include? "expected_savings"
      self.expected_savings(queryBuilding)
    end
  end


  def self.peak_usage(building, data = nil )
    maxUsage = [0.0, 1]
    @data.each do |entry|
      puts(entry)
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

  def self.expected_savings(building)
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


  if ARGV.length == 3
    @inputfilename = ARGV[0]
    @userInput = ARGV[1]
    @queryBuilding = ARGV[2]
    @data = CSV.read("#{@inputfilename}", headers:true)
    self.query_start(@userInput, @queryBuilding)
  end
end
