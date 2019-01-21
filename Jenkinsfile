#!/usr/bin/env groovy
@Library('jenkins-pipeline-scripts') _

pipeline {
    agent any
    triggers {             
		pollSCM('*/3 * * * *')
    }
    options {
        // Only keep the 50 most recent builds
        buildDiscarder(logRotator(numToKeepStr:'50'))
    }
    stages {
        stage('Build') {
            steps {
                sh 'make docker-image'
            }
        }
        stage('Deploy on staging') {
            steps {
                sh 'docker tag authentic:latest docker-staging.imio.be/authentic:`date +%Y%m%d`-$BUILD_NUMBER'
                sh 'docker tag authentic:latest docker-staging.imio.be/authentic:latest'
                sh 'docker push docker-staging.imio.be/authentic'
                sh 'docker rmi -f authentic:latest'
                sh 'docker rmi -f docker-staging.imio.be/authentic:`date +%Y%m%d`-$BUILD_NUMBER'
                sh 'docker rmi -f docker-staging.imio.be/authentic:latest'
                sh 'mco shell run "/srv/docker_scripts/authentic/restart.sh" -I /^staging.imio.be$/'
            }
        }
    }
}
