#!/usr/bin/env groovy
@Library('be.imio.Generic')
@Library('be.imio.Make')


pipeline {
    agent any
    options {
        // Only keep the 50 most recent builds
        buildDiscarder(logRotator(numToKeepStr:'50'))
    }
    stages {
        stage('Build') {
            steps {
                sh 'make docker-prod-image'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker tag authentic:latest docker-staging.imio.be/authentic:$yyyymmdd-$buildout_build_number'
                sh 'docker tag authentic:latest docker-staging.imio.be/authentic:latest'
                sh 'docker push docker-staging.imio.be/authentic'
                sh 'docker rmi -f authentic:latest'
                sh 'docker rmi -f docker-staging.imio.be/authentic:$yyyymmdd-$buildout_build_number'
                sh 'docker rmi -f docker-staging.imio.be/authentic:latest'
            }
        }
    }
}
