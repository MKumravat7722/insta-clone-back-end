FROM ruby:3.2-alpine

# Install system dependencies
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    postgresql-client \
    git \
    tzdata \
    linux-headers

WORKDIR /app

# Copy Gemfile and Gemfile.lock first for better caching
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application
COPY . .

EXPOSE 3000

# Simple startup command
CMD ["rails", "server", "-b", "0.0.0.0"]