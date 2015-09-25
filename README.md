## Setlistr

Companion app for cover bands. Easily manage your setlist, add media files to songs (lyrics, tabs, 
anything), create concerts and decide which songs to play there, suggest new songs and generate 
statistics to help the band stay dynamic.

### Versions
The app was developed using Ruby 2.1.1 and Rails 4.2.4.

### System dependencies
Dependencies are managed by Bundler. Among the great stuff used there's [rspec-rails](https://github.com/rspec/rspec-rails), [rails-assets](https://github.com/rails-assets/rails-assets/), [bootstrap](twitter.github.com/bootstrap/), [zocial](https://github.com/smcllns/css-social-buttons) and [omniauth-facebook](https://github.com/mkdynamic/omniauth-facebook).

### Configuration
Login is done via Facebook so you need to have a FB app properly configured and export two environment variables: `SETLISTR_FB_APP_ID` and `SETLISTR_FB_APP_SECRET`.

### Tests
The goal of this projects was to get used to BDD in Rails, so expect tons of feature tests using rspec!
