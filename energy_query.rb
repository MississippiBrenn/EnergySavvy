require 'csv'

class EnergyQuery

  def initialize(input, query_type, building, appliance)
    @input = input
    @query_type = query_type
    @building = building
    @appliance = appliance
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
      generic_savings(@appliance, @building)
      #expected_savings(@building)
    elsif @query_type.include? "best_program"
      best_savings(@building)
    elsif @query_type.include? "best_for_grid"
      best_for_grid(@data)
    end
  end

  def best_for_grid(grid)

    refrigerator_sum = 0
    aircon_sum = 0
    heater_sum = 0

    buildingDictionary = {}

    grid.each do |entry|
      if buildingDictionary[entry["building_id"]] == nil
        buildingDictionary[entry["building_id"]] = 0
      end
    end

    buildingDictionary.each do |k,v|
      building =  k
      refrigerator_sum +=  generic_savings("refrigerator", building)
      aircon_sum +=  generic_savings("airconditioner", building)
      heater_sum +=  generic_savings("heater", building)
    end

    grid_savings_hash = {refrigerator: refrigerator_sum, aircon: aircon_sum, heater: heater_sum}

    puts(grid_savings_hash.to_s)
    best_program_for_grid = grid_savings_hash.max_by{|k,v| v}

    puts("#{best_program_for_grid}")
  end

  def best_savings(building)
    savings_array=[]

    savings_array << [generic_savings("refrigerator", building), "refrigerator"]
    savings_array <<  [generic_savings("airconditioner", building), "airconditioner"]
    savings_array << [generic_savings("heater", building), "heater"]

    maxValue = [savings_array[0][0], savings_array[0][1]]

    savings_array.each do |subArray|
      if subArray[0] > maxValue[0]
        maxValue = [subArray[0], subArray[1]]
      end
    end
    puts("#{maxValue.to_s}")
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



  def generic_savings(appliance, building)
    if appliance == "refrigerator"
      startingTime = 0
      endingTime = 23
      percentSaved = 0.10
    elsif appliance == "airconditioner"
      startingTime = 13
      endingTime = 18
      percentSaved = 0.30
    elsif appliance == "heater"
      startingTime = 23
      endingTime = 5
      percentSaved = 0.10
    end
    #refrigerator replacement would save 10% of a households usage at all times
    #how much would a households save
    #would a household save more by installing  a new airconditioner or a new refrigerator
    range = startingTime..endingTime
    totalUsage = 0

    if startingTime > endingTime
      altStartingTime = 0
      endingTime = endingTime
      highrange = altStartingTime..endingTime

      firstStartingTime = startingTime
      endingTime = 23
      lowrange = firstStartingTime..endingTime

      @data.each do |entry|
        if entry["building_id"] == building && (((highrange).include? entry["hour"].to_f) || ((lowrange).include? entry["hour"].to_f))
          totalUsage += entry["kwh_usage"].to_f
        end
      end

    else

      @data.each do |entry|
        if entry["building_id"] == building && ((range).include? entry["hour"].to_f)
          totalUsage += entry["kwh_usage"].to_f
        end
      end
    end

    savings = totalUsage * percentSaved
    return savings
    puts ("expected_savings for #{appliance} #{building} #{savings} kWh")
  end
end
#generic_savings(.10, 0, 23, white_house)


if ARGV.length == 4 || ARGV.length == 3
  input = ARGV[0]
  query_type = ARGV[1]
  building = ARGV[2]
  appliance = ARGV[3]

  EnergyQuery.new(input, query_type, building, appliance = nil ).query

elsif ARGV.length == 2
  input = ARGV[0]
  query_type = ARGV[1]

  EnergyQuery.new(input, query_type, building = nil, appliance = nil).query
end
