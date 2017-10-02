module Smashrun
  class Client
    OAUTH_URLS = { site:          'https://api.smashrun.com',
                   authorize_url: 'https://secure.smashrun.com/oauth2/authenticate',
                   token_url:     'https://secure.smashrun.com/oauth2/token'
    }
    
    def initialize(access_token)
      client = OAuth2::Client.new(client_id, client_secret, OAUTH_URLS)
      
      @token = OAuth2::AccessToken.new(client, access_token)
    end
    
    def get_refresh_token(token)
      @token.refresh_token = token
      @token.refresh!.to_hash
    end
    
    def get_activities()
      Oj.load(@token.get("v1/my/activities").body)
    end
    
    # Filter activities, valid options are: *fromDateUTC*, *page* and *count*
    def search_activities(params={})
      Oj.load(@token.get("v1/my/activities/search", params).body)
    end
    
    # Returns the first 100 smashrun run ids.
    def latest_activities_ids
      Oj.load(@token.get("v1/my/activities/search/ids").body)
    end
    
    # Returns an array of json objects containing the runId, startTime, distance (in kilometers), and duration
    def latest_activities_briefs
      Oj.load(@token.get("v1/my/activities/search/briefs").body)
    end
    
    # To retrieve a Google encoded polyline of a run route to easily draw a route map in Google maps.
    def activity_polyline(activity_id)
      Oj.load(@token.get("v1/my/activities/#{activity_id}/polyline").body)
    end
  
    # To retrieve an SVG polyline of a run route.
    def activity_svg_polyline(activity_id)
      Oj.load(@token.get("v1/my/activities/#{activity_id}/polyline/svg").body)
    end
    
    # To retrieve a GeoJSON representation a run route.
    def activity_geojson(activity_id)
      Oj.load(@token.get("v1/my/activities/#{activity_id}/polyline/geojson").body)
    end

    # To retrieve a detail of single activity.
    def activity_detail(activity_id)
      Oj.load(@token.get("v1/my/activities/#{activity_id}").body)
    end

    def activity_splits(activity_id, unit)
      unless ['km', 'mi'].include?(unit)
        raise "Invalid distance unit"
      end
      
      Oj.load(@token.get("v1/my/activities/#{activity_id}/splits/#{unit}").body)
    end
    
    def profile_info
      Oj.load(@token.get("/v1/my/userinfo").body)
    end
  end
end