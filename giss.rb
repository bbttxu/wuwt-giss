#!/usr/bin/env ruby
require 'rubygems'
require 'gruff'
# require 'json'
# require 'set'
require 'LinearRegression'

@years, @all_years, @temps, @all_temps = [], [], [], []

def get_annual input
  values = input.split ' '
  if ( values[0].to_f != 0.0) 
    
    if (values[17] != '999.90')
      @years << values[0].to_f
      @temps << values[17].to_f
      @all_temps << values[17].to_f
    else
      @all_temps << nil
    end
    @all_years << values[0].to_f
  end
end

def do_regression( years, temps)
  lr = LinearRegression.new( years, temps )
  fitted_array = lr.fit
  span_years = years[-1] - years[0]
  slope = lr.slope
  d_t = lr.slope * span_years
  puts "#{years[0]}\t#{years[-1]}\t#{slope}\t#{span_years}\t#{d_t}"
end


IO.foreach ARGV[0] do |line|
	line_data = get_annual line
end

@span = ARGV[1].to_i || @years.size

n = 0

while ( n < ( @years.size - @span ) ) do
  do_regression( @years[n, @span], @temps[n, @span] )
  n += 1
end

year_labels = Hash.new
n = 0

@all_years.each do |x| 
  year_labels.store(n, x)
  n += 1
end

# puts year_labels

g = Gruff::Line.new
g.title = "My Graph" 

g.data("temp", @all_temps )
g.labels = { 0 => '1888', 2 => '1890', 102 => '1990', 12 => '1990', 62 => '1950' }
# g.labels = year_labels
# g.write "output.png"