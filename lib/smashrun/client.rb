module Smashrun
  class Client
    OAUTH_URLS = { site:          'https://api.smashrun.com',
                   authorize_url: 'https://secure.smashrun.com/oauth2/authenticate',
                   token_url:     'https://secure.smashrun.com/oauth2/token'
    }.freeze
    
    def initialize(access_token)
      client = OAuth2::Client.new(Smashrun.client_id, Smashrun.client_secret, OAUTH_URLS)
      
      @token = OAuth2::AccessToken.new(client, access_token)
    end
    
    def refresh_token(token)
      @token.refresh_token = token
      @token.refresh!.to_hash
    end
    
    # Filter activities, valid options are: *fromDateUTC*, *page* and *count*
    def activities(params={})
      uri = params.present? ? "/v1/my/activities/search" : "/v1/my/activities"
      request uri, params
    end
    
    # Returns the first 100 smashrun run ids.
    def latest_activities_ids
      request "/v1/my/activities/search/ids"
    end
    
    # Returns an array of json objects containing the runId, startTime, distance (in kilometers), and duration
    def latest_activities_briefs
      request "/v1/my/activities/search/briefs"
    end
    
    # To retrieve a Google encoded polyline of a run route to easily draw a route map in Google maps.
    def activity_polyline(activity_id)
      request "/v1/my/activities/#{activity_id}/polyline"
    end
    
    # To retrieve an SVG polyline of a run route.
    def activity_svg_polyline(activity_id)
      request "/v1/my/activities/#{activity_id}/polyline/svg"
    end
    
    # To retrieve a GeoJSON representation a run route.
    def activity_geojson(activity_id)
      request "/v1/my/activities/#{activity_id}/polyline/geojson"
    end
    
    # To retrieve a detail of single activity.
    def activity_detail(activity_id)
      request "/v1/my/activities/#{activity_id}"
    end
    
    # Retrive activity splits
    def activity_splits(activity_id, unit)
      unless ['km', 'mi'].include?(unit)
        raise ArgumentError.new("Invlaid distance unit for splits. Valid units are km or mi")
      end

      request "/v1/my/activities/#{activity_id}/splits/#{unit}"
    end
    
    def athlete
      request "/v1/my/userinfo"
    end
    
    protected
    def request(uri, params={})
      Oj.load @token.get(uri, params).body
    end
  end
end