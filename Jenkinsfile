pipeline {
    agent any

    environment {
        RAILS_ENV = 'test'
        DATABASE_HOST = 'localhost'       // Or your PostgreSQL host
        DATABASE_USERNAME = 'postgres'
        DATABASE_PASSWORD = 'postgres'
        DATABASE_NAME = 'insta_clone_back_end_test'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/MKumravat7722/insta-clone-back-end'
            }
        }

        stage('Install dependencies') {
            steps {
                sh 'bundle install --jobs=4 --retry=3'
            }
        }

        stage('Setup DB') {
            steps {
                sh 'rails db:create db:migrate'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'bundle exec rspec'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
        }
        success {
            echo 'Tests passed ✅'
        }
        failure {
            echo 'Tests failed ❌'
        }
    }
}
