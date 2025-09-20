pipeline {
  agent {
    docker { image 'ruby:3.1' }
  }

  environment {
    RAILS_ENV = 'test'
    DATABASE_HOST = 'postgres'
    DATABASE_USERNAME = 'postgres'
    DATABASE_PASSWORD = 'postgres'
  }

  services {
    postgres: {
      image: 'postgres:15'
      env: [
        POSTGRES_USER=postgres,
        POSTGRES_PASSWORD=postgres,
        POSTGRES_DB=insta_clone_back_end_test
      ]
      ports: ['5432:5432']
    }
  }

  stages {
    stage('Setup DB') {
      steps {
        sh 'bundle install'
        sh 'rails db:create db:migrate'
      }
    }

    stage('Run Tests') {
      steps {
        sh 'bundle exec rspec'
      }
    }
  }
}
