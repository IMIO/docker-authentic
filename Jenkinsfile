#!/usr/bin/env groovy
@Library('jenkins-pipeline-scripts') _

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
        stage('Deploy on staging') {
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
