# smashrun

Ruby gem for [Smashrun api](https://api.smashrun.com/v1/documentation)

Register your application for getting client id and secret: https://api.smashrun.com/register

## Usage

### Authentication

```ruby
Smashrun.configure do |config|
  config.client_id = 'your app client id'
  config.client_secret = 'your app client secret'
end

client = Smashrun::Client.new(user_access_token)
```

### Refresh user's access token
Smashrun tokens are valid for 12 weeks, you can refresh access tokens using user's refresh token. 

```ruby
client.refresh_token(refresh_token)
```
You better save new access token and refresh token.


### Fetching activities

```ruby
client.activities # => list of recent activities
```
You can also use **fromDateUTC**, **page** or **count** for filtering and paginating activities list

```ruby
client.activities page: 1, count: 100

client.activities fromDateUTC: 2.days.ago.to_i, page: 2
```

If you want to minimize download size or need to quickly check for new activities, use following api methods instead.
```ruby
client.latest_activities_briefs # retrive activities with minimal info( id, startTime, distance and duration)

client.latest_activities_ids    # or just ids
````


### Fetching single activity detail

```ruby
client.activity_detail activity_id        # full activity detail 
client.activity_svg_polyline activity_id  # retrive SVG polyline for route of activity
client.activity_geojson activity_id       # retrive activity route in GeoJSON format
client.activity_splits activity_id, 'distance_unit'        # retrive splits of an activity in specified unit ( mi for mile and km for kilometer)
````

### Fetching user detail
```ruby
client.athlete
```

### Posting new activities 

Pending...
 

## Copyright

Copyright (c) 20117 Naveed Ahmad. See LICENSE.txt for further details.

