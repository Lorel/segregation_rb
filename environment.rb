class Environment < Marsys::Environment
  attr_accessor :blue_population, :green_population

  def initialize(agents_type=[], options={})
    super(agents_type, options)

    @agents_type.each do |type|
      self.send("#{type}_population=",Marsys::Settings.params["#{type}_population".to_sym]||Marsys::Settings.params[:population])
    end
    @global_population = agents.count
    similar_rate_methods_initialize
  end

  def add_hash_to_json
    hash = { global_similar_rate:   global_similar_rate }
    @agents_type.each do |type|
      hash[type.pluralize] = self.send(type.pluralize)                                  # add collection of agents of this type
      hash["#{type}s_similar_rate".to_sym] = self.send("#{type}s_similar_rate".to_sym)  # add census informations for agents of this type
    end
    hash
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
    puts @global_population
    agents.inject(0.0){ |sum,agent| sum .+ agent.similar_rate } ./ @global_population
  end

  private
    def similar_rate_methods_initialize
      @agents_type.each do |type|
        # Create method #{type.pluralize}_census which return an Array
        # with population of type for each age range
        self.class.send( :define_method, "#{type.pluralize}_similar_rate", Proc.new{
          specific_agents = self.send(type.pluralize)
          specific_agents.inject(0.0){ |sum,agent| sum .+ agent.similar_rate } ./ self.send("#{type}_population")
        })
      end
    end

end