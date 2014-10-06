shakespeare_server
==================

Restful API/Server for Interacting with Shakespeare Text.

This server is the example server for the [Avoid Screaming Customer Management Protocol and Get More Sleep](https://github.com/aetherical/avoid-scmp-and-get-more-sleep) presented at [Columbus Code Camp 2014](http://columbuscodecamp.com).

It has a simple API, enabling the text of Shakespeare to be retrieved from an ElasticSearch container.

## Setup

The server uses [Grape](http://intridea.github.io/grape/) running under [rack](http://rack.github.io/).

The backend is [Elastic Search](http://elasticsearch.org). The data is
from the
[Kibana 10 Minute Walk Through](http://www.elasticsearch.org/guide/en/kibana/current/using-kibana-for-the-first-time.html).

The following assumes that ElasticSearch is accessible at port 9200 on
localhost. Adjust your configuration accordingly.

1. Download the data in a bulk import format:
   [shakespeare.json](http://www.elasticsearch.org/guide/en/kibana/current/snippets/shakespeare.json).

2. The following commands are used to create an index:

    curl -XPUT http://localhost:9200/shakespeare -d '
    {
     "mappings" : {
      "_default_" : {
       "properties" : {
        "speaker" : {"type": "string", "index" : "not_analyzed" },
        "play_name" : {"type": "string", "index" : "not_analyzed" },
        "line_id" : { "type" : "integer" },
        "speech_number" : { "type" : "integer" }
       }
      }
     }
    }
    ';

3. Import the data: `curl -XPUT localhost:9200/_bulk --data-binary
   @shakespeare.json` into elasticsearch.

## API

### Get List of Plays

`http://$HOST:$PORT/api/v1/plays`

### Get Text of Play

`http://$HOST:$PORT/api/v1/plays/$TITLE`

`$TITLE` is URLEncoded since many of the plays have multiple words.

'Henry IV' is requested like `http://$HOST:$PORT/api/v1/plays/Henry+IV`.

## Versions

This app is designed to show progression of logging and capturing metrics.

### V1

"Plain" application.

### V2

New Relic support added.  In order to use it, the environment variable
`NEW_RELIC_API_KEY` needs to be set.
