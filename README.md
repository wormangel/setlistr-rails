## Setlistr

Companion app for cover bands. Easily manage your setlist, add media files to songs (lyrics, tabs, 
anything), create concerts and decide which songs to play there, suggest new songs and generate 
statistics to help the band stay dynamic.

### Versions
The app was developed using Ruby 2.1.1 and Rails 4.2.4.

### System dependencies overview
Setlistr uses:
- Postgres as a database
- Sidekiq to process concurrent jobs
- Redis as the datastore for sidekiq
- Graphicsmagick for some image processing
- Facebook for logging in
- Spotify for logging in and metadata discovery
- Youtube and Vagalume for metadata discovery
- Amazon S3 for file storage
 
### Setting up external services
1. Configure a Facebook app (for login). Don't forget to allow the app root URL under OAuth authorized callbacks (for example, `http://localhost:3000/` for DEV environment)
2. Configure a Amazon S3 bucket (for file uploads store - if you don't want to use that the changes you'll need should be simple enough thanks to [carrierwave](https://github.com/carrierwaveuploader/carrierwave)). 
3. Configure a Spotify app (for login and API access). Don't forget to allow the app root URL under OAuth authorized callbacks (for example, `http://localhost:3000/` for DEV environment)
4. Configure a Vagalume app (for API access).

### Installing - Common steps
1. Clone the repository. `git clone git@github.com:wormangel/setlistr-rails.git`
2. Setup the `.env` file (template below).

### A) Running the Dockerized version
#### Installing dependencies

1. Build the Docker image. `docker build -t setlistr:0.1 .`
2. Init the db. `docker-compose run setlistr rake db:create` and `docker-compose run setlistr rake db:migrate`

#### Running

1. Start all containers. `docker-compose up`

All done. Hit `http://localhost:3000` to access the website.

### B) Running manually
#### Installing dependencies
1. Install dependencies. `bundle install`
2. Download and install [GraphicsMagick](http://www.graphicsmagick.org/) - (For OSX users: [Yay!](http://macappstore.org/graphicsmagick/))
3. Install Postgres if you don't have it (or change the db settings to use sqlite3)
4. You need a redis server for Sidekiq to work. To install it locally you can use Homebrew `brew install redis`
5. Create the db `rake db:create`
6. Run migrations `rake db:migrate`

#### Running
1. Make sure redis is running (locally I do `redis-server /usr/local/etc/redis.conf`)
2. Execute Sidekiq `bundle exec sidekiq`
3. Make sure Postgres is running.
4. Start app `rails server`

All done. Hit `http://localhost:3000` to access the website.

### .env file template
```
SETLISTR_FB_APP_ID="" # Self-explanatory
SETLISTR_FB_APP_SECRET="" # Self-explanatory
SETLISTR_FB_REDIRECT_URL="" # This should be the rails root path of the application
SETLISTR_INVITE_SALT="" # Any string you want, to make the band invite codes unique to your setup
SETLISTR_S3_BUCKET="" # Self-explanatory
SETLISTR_S3_ACCESS_KEY="" # Self-explanatory
SETLISTR_S3_SECRET_KEY="" # Self-explanatory
SETLISTR_S3_REGION="" # Self-explanatory
SETLISTR_S3_ENDPOINT="" # Self-explanatory - Make sure it matches the S3 region
SETLISTR_YOUTUBE_API_KEY="" # Self-explanatory
SETLISTR_YOUTUBE_APP_NAME="" # Self-explanatory
REDIS_PROVIDER="REDIS_URL" # Necessary for Sidekiq
REDIS_URL="" # The URL for the Redis server
SETLISTR_SPOTIFY_ID="" # Self-explanatory
SETLISTR_SPOTIFY_SECRET="" # Self-explanatory```
