require 'elasticsearch'
require 'elasticsearch/model'
require 'elasticsearch/persistence'

# Elasticsearch::Model.client = Elasticsearch::Client.new log: true


module Shakespeare
  class Play
    attr_reader :attributes

    def initialize(attributes={})
      @attributes = attributes
    end

    def to_hash
      @attributes
    end

    def method_missing(method_name, *arguments, &block)
      attributes.respond_to?(method_name) ? attributes.__send__(method_name, *arguments, &block) : super
    end

    def respond_to?(method_name, include_private=false)
      attributes.respond_to?(method_name) || super
    end

    def tags; attributes.tags || []; end

  end

  class PlayRepository
    include Elasticsearch::Persistence::Repository
    client Elasticsearch::Client.new url: ENV['ELASTICSEARCH_URL'], log: true

    index :shakespeare
    type :play

    
    mapping do
      indexes :line_id, type: 'integer'
      indexes :play_name,  analyzer: 'snowball'
      indexes :speech_number, type: 'integer'
      indexes :line_number, analyzer: 'snowball'
      indexes :speaker,  analyzer: 'snowball'
      indexes :text_entry,  analyzer: 'snowball'
    end




  end #unless defined?(PlayRepository)
end
