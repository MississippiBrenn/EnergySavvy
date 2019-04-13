
The Task
Write a program that reads a CSV containing energy usage data for a particular day, and lets the user access a summary of the data from the command line.
The Prompt
The script your program provides should be callable from the command line and should allow the user to make a few queries on the data. To begin with, it should support two types of queries for a particular home: “peak_usage” and “expected_savings”.
The peak_usage query
A user should be able to query for the peak (maximum) usage on a particular home in the data set. Here’s what an interactive session with your code could look like, including the responses that your script should provide given the example input CSV below:

> [name of your program] [name of input file] peak_usage blue_house
74.5 kWh at 13:00
> [name of your program] [name of input file] peak_usage white_house
3 kWh at 14:00
> [name of your program] [name of input file] peak_usage eiffel_tower
“eiffel_tower” not in data set!

The expected_savings query
Our theoretical customer, SavvyUtility, is replacing buildings’ air conditioners with more efficient ones to reduce energy consumption. Let’s pretend that replacing an A/C unit has been shown to save 30% of a building’s energy usage during the afternoon (12 p.m. to 6 p.m.), with no effect the rest of the time.
The expected_savings query should provide the daily savings we’d expect from installing an energy-efficient AC in that building, based on the data in the input data set. For example, if the blue_house used 100 kWh in the periods between 12 p.m. and 6 p.m. in the input data, the savings would be 30 kWh:

> [name of your program] [name of input file] expected_savings blue_house
30 kWh
The Input Data
The input file will be a CSV (comma-separated-values) describing the hourly usage for a group of buildings during a single day. A larger example file is available here, and a sample will look something like this:

building_id,hour,kwh_usage
white_house,12,0.2
white_house,13,0.14
blue_house,12,0.1
white_house,14,3
blue_house,13,74.5
blue_house,14,0.3
...
Fields
building_id: identifier of the building where the energy usage occurred
hour: End time of the period when this energy usage occurred. All periods are 1 hour in length.
kwh_
