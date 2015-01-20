class Core < Marsys::Core
  def initialize(options={})
    @agents = [:blue, :green]
    @environment = Environment.new(@agents,options)
    super(options)
  end

  def add_hash_to_json
    { stop_condition: stop_condition? }
  end

  def stop_condition?
    super || @environment.agents.all? { |agent| agent.similar_rate >= Marsys::Settings.params[:satisfaction_rate] }
  end
end