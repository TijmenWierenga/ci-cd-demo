pipeline {
    agent {
        label 'docker'
    }

    environment {
        COMPOSE_PROJECT_NAME = "${env.JOB_NAME}_${env.BUILD_NUMBER}"
        TAG="1.${env.BUILD_NUMBER}"
    }

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t xs4all/app:${TAG} .'
            }
        }

        stage('Test') {
            steps {
                sh 'docker run --rm xs4all/app:${TAG} bin/phpunit'
            }
        }
    }
}
