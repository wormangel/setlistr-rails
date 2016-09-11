# Use the barebones version of Ruby 2.2.3.
FROM ubuntu:16.10

# Install dependencies:
RUN apt-get update \
 && apt-get install -y graphicsmagick \
 && apt-get install -y build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev git libpq-dev wget nodejs

# Install Ruby 2.1.1
RUN cd /tmp \
 && wget https://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.1.tar.gz \
 && tar -xvzf ruby-2.1.1.tar.gz \
 && cd ruby-2.1.1/ \
 && ./configure --prefix=/usr/local \
 && make \
 && make install \
 && gem install bundler

# Set an environment variable to store where the app is installed to inside
# of the Docker image.
ENV INSTALL_PATH /setlistr
RUN mkdir -p $INSTALL_PATH

# This sets the context of where commands will be ran in and is documented
# on Docker's website extensively.
WORKDIR $INSTALL_PATH

# Ensure gems are cached and only get updated when they change. This will
# drastically increase build times when your gems do not change.
COPY Gemfile* ./
RUN bundle install

# Copy in the application code from your work station at the current directory
# over to the working directory.
COPY .env .env
COPY . .

# Provide dummy data to Rails so it can pre-compile assets.
#RUN bundle exec rake RAILS_ENV=production assets:precompile

# Expose a volume so that nginx will be able to read in assets in production.
#VOLUME ["$INSTALL_PATH/public"]

EXPOSE 3000

# The default command that gets ran will be to start the Unicorn server.
CMD bundle exec rails server -b 0.0.0.0
