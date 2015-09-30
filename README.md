## Setlistr

Companion app for cover bands. Easily manage your setlist, add media files to songs (lyrics, tabs, 
anything), create concerts and decide which songs to play there, suggest new songs and generate 
statistics to help the band stay dynamic.

### Versions
The app was developed using Ruby 2.1.1 and Rails 4.2.4.

### System dependencies
Dependencies are managed by Bundler. Among the great stuff used there's [rails-assets](https://github.com/rails-assets/rails-assets/), [bootstrap](twitter.github.com/bootstrap/), [zocial](https://github.com/smcllns/css-social-buttons) and [omniauth-facebook](https://github.com/mkdynamic/omniauth-facebook).

This project was done so I could get a grasp in BDD in Rails. I've used [rspec-rails](https://github.com/rspec/rspec-rails), [factory-girl](https://github.com/thoughtbot/factory_girl), [rspec-autotest](https://github.com/rspec/rspec-autotest) and [capybara](https://github.com/jnicklas/capybara).

### Configuration
Login is done via Facebook so you need to have a FB app properly configured and export two environment variables: `SETLISTR_FB_APP_ID` and `SETLISTR_FB_APP_SECRET`.

### Tests
Expect tons of feature tests using rspec! Try running ```bundle exec rspec```
