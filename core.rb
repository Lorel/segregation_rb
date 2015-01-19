# require 'marsys'
# require 'pp'

# load "agent.rb"

class Core < Marsys::Core
  def initialize(options={})
    @agents = [:blue, :green, :red]
    super(options)
  end

  def display
    @environment.display_grid
    display_globlal_segregation_rate
  end

  def display_globlal_segregation_rate
    puts "Global segregation rate : #{global_similar_rate}"
    puts "Number of iterations : #{@iteration}"
  end

  def stop_condition
    @environment.agents.all? { |agent| agent.similar_rate >= Marsys::Settings.params[:satisfaction_rate] }
  end

  def global_similar_rate
    @environment.agents.inject(0.0){ |sum,agent| sum .+ agent.similar_rate } ./ @environment.agents.count
  end
end

# test = Core.new
# test.display
# test.run