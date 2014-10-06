require 'grape'
require 'elasticsearch'
require 'cgi'

module Shakespeare
  class Play
    attr_accessor :results
    
    def initialize(client, title)
      foo = client.search index: "shakespeare", body: { query: { match: { play_name: CGI::unescape(title) } }, size: 10000 }
      @results=foo["hits"]["hits"].map {|line| line["_source"]}.sort {|a,b| a["line_id"] <=> b["line_id"]}
    end

    def to_json
      @results
    end

    def to_txt
      speaker=""
      @results.map do |line| 
        if (speaker != line["speaker"])
          "\n#{speaker=line["speaker"]}: #{line["text_entry"]}"
        else
          line["text_entry"]
        end
      end.join("\n")
    end
  end

  class API < Grape::API
    client = Elasticsearch::Client.new log: true
    prefix 'api'
    rescue_from :all 
    version 'v1', using: :path, vendor: 'nimblestratus'
    format :json
    default_format :json
    content_type :txt, "text/plain"
    default_error_formatter :txt

    resource :play do
      desc "Return the list of plays"
      get do
        # return the list of plays
        plays=client.search index: "shakespeare", body: { size: 0, aggs: { plays: {  terms: { size: 0, field: :play_name } } } }
        plays["aggregations"]["plays"]["buckets"].map {|play| play["key"]}
      end

      desc "Return an individual play"
      params do
        requires :title, type: String, desc: "Title of a play"
      end
      route_param :title do
        get do 
          Play.new(client, params[:title])
        end
      end
    end
  end
end
