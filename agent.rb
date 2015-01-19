class Agent < Marsys::Agent

  def initialize(environment, square = nil)
    @satisfaction_rate = Marsys::Settings.params[:satisfaction_rate]
    super
  end

  # def to_json(options = {})
  #   super
  # end

  def move
    super if similar_rate < @satisfaction_rate
  end

  def turn
    super
  end

  def similar_rate
    # return 0 if agent has not any neighboor
    return 0.0 if [@environment.squares_around_with_blue(@square),@environment.squares_around_with_green(@square)].flatten.count == 0
    @environment.send("squares_around_with_#{self.class.to_s.downcase}", @square).count .* 100.0 ./ ([@environment.squares_around_with_blue(@square),@environment.squares_around_with_green(@square)].flatten.count)
  end
end

class Blue < Agent
  def initialize(environment, square = nil)
    super(environment, square)
    @color = :blue
  end
end

class Green < Agent
  def initialize(environment, square = nil)
    super(environment, square)
    @color = :green
  end
end

class Red < Agent
  def initialize(environment, square = nil)
    super(environment, square)
    @color = :red
  end
end