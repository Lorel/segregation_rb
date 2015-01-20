class Environment < Marsys::Environment

  def initialize(agents=[], options={})
    super(agents, options)
    similar_rate_methods_initialize
  end

  def to_json(options = {})
    json = {
      grid:                 @grid.map{|line| line.map{ |square|
                              square.content ? square.content.class.to_s.downcase : nil
                            }},
      iteration:            @iteration,
      global_similar_rate:   global_similar_rate,
      stop_condition:        options[:stop_condition]
    }
    @agents_type.each do |type|
      json[type.pluralize] = self.send(type.pluralize)                                  # add collection of agents of this type
      json["#{type}s_similar_rate".to_sym] = self.send("#{type}s_similar_rate".to_sym)  # add census informations for agents of this type
    end

    json.to_json
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

  private
    def similar_rate_methods_initialize
      @agents_type.each do |type|
        # Create method #{type.pluralize}_census which return an Array
        # with population of type for each age range
        self.class.send( :define_method, "#{type.pluralize}_similar_rate", Proc.new{
          specific_agents = self.send(type.pluralize)
          specific_agents.inject(0.0){ |sum,agent| sum .+ agent.similar_rate } ./ specific_agents.count
        })
      end
    end

end