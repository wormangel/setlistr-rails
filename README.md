## Setlistr

Companion app for cover bands. Easily manage your setlist, add media files to songs (lyrics, tabs, 
anything), create concerts and decide which songs to play there, suggest new songs and generate 
statistics to help the band stay dynamic.

### Versions
The app was developed using Ruby 2.1.1 and Rails 4.2.4.

### System dependencies
Dependencies are managed by Bundler. Among the great stuff used there's [rails-assets](https://github.com/rails-assets/rails-assets/), [bootstrap](twitter.github.com/bootstrap/), [zocial](https://github.com/smcllns/css-social-buttons) and [omniauth-facebook](https://github.com/mkdynamic/omniauth-facebook).

This project was done so I could get a grasp in BDD in Rails. I've used [rspec-rails](https://github.com/rspec/rspec-rails), [factory-girl](https://github.com/thoughtbot/factory_girl), [rspec-autotest](https://github.com/rspec/rspec-autotest) and [capybara](https://github.com/jnicklas/capybara).

### Installing and Running
1. Clone the repository. `git clone git@github.com:wormangel/setlistr-rails.git`
2. Install dependencies. `bundle install`
3. Download and install [GraphicsMagick](http://www.graphicsmagick.org/) - (For OSX users: [Yay!](http://macappstore.org/graphicsmagick/))
4. Configure a Facebook app (for login). Don't forget to allow the app root URL under OAuth authorized callbacks (for example, `http://localhost:3000/` for DEV environment)
5. Configure a Amazon S3 bucket (for file uploads store - if you don't want to use that the changes you'll need should be simple enough thanks to [carrierwave](https://github.com/carrierwaveuploader/carrierwave)). 
6. Create a `.env` file in the root of the app with the following variables:

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
        SETLISTR_SPOTIFY_SECRET="" # Self-explanatory

7. Install Postgres if you don't have it (or change the db settings to use sqlite3)
8. You need a redis server for Sidekiq to work. To install it locally you can use Homebrew `brew install redis`
9. Create the db `rake db:create`
10. Run migrations `rake db:migrate`
11. Make sure redis is running (locally I do `redis-server /usr/local/etc/redis.conf`)
12. Execute Sidekiq `bundle exec sidekiq`
13. Start app `rails server`

### Tests
Expect tons of feature tests using rspec! Try running ```bundle exec rspec```
