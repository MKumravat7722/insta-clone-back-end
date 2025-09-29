pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/MKumravat7722/insta-clone-back-end.git'
            }
        }

        stage('Check Ruby & Bundler') {
            steps {
                sh 'ruby -v'
                sh 'gem -v'
                sh 'bundler -v'
            }
        }

        stage('Install dependencies') {
            steps {
                sh '''
                    bundle config set path 'vendor/bundle'
                    bundle install
                '''
            }
        }

        stage('Run Rubocop') {
            steps {
                sh 'bundle exec rubocop app/controllers app/models spec/'
            }
        }

        stage('Run Tests with Coverage') {
            steps {
                sh 'bundle exec rspec spec/'
            }
            post {
                always {
                    publishHTML([
                        allowMissing: false,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: 'coverage',
                        reportFiles: 'index.html',
                        reportName: 'Test Coverage Report'
                    ])
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
