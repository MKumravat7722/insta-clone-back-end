pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/MKumravat7722/insta-clone-back-end.git'
            }
        }

        stage('Install Bundler') {
            steps {
                sh 'gem install bundler'
            }
        }

        stage('Install dependencies') {
            steps {
                sh 'bundle install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'bundle exec rspec spec/simple_test_spec.rb'
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
