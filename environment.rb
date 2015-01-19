class Environment < Marsys::Environment

	def to_json(options = {})
    {
      grid:       					@grid.map{|line| line.map{ |square|
                  					  square.content ? square.content.class.to_s.downcase : nil
                  					}},
      iteration:  					@iteration,
      global_similar_rate: 	global_similar_rate,
      stop_condition:				options[:stop_condition]
    }.to_json
  end

  def display
    super
    display_globlal_segregation_rate
  end

  def display_globlal_segregation_rate
    puts "Global segregation rate : #{global_similar_rate}"
    puts "Number of iterations : #{@iteration}"
  end

  def global_similar_rate
    agents.inject(0.0){ |sum,agent| sum .+ agent.similar_rate } ./ agents.count
  end
end