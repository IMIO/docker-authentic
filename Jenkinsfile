#!/usr/bin/env groovy
@Library('jenkins-pipeline-scripts') _

pipeline {
    agent any
    options {
        // Only keep the 10 most recent builds
        buildDiscarder(logRotator(numToKeepStr:'50'))
    }
    stages {
        stage('Build') {
            agent any
            steps {
                sh 'make build'
            }
        }
        stage('Push image to registry') {
            agent any
            steps {
                pushImageToRegistry (
                    env.BUILD_ID,
                    "wc/sso"
                )
            }
        }
        stage('Deploy to staging') {
            agent any
            when {
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                sh "mco shell run 'docker pull docker-staging.imio.be/wc/sso:latest' -I /^staging.imio.be/"
                sh "mco shell run 'systemctl restart sso_staging' -t 1200 --tail -I /^staging.imio.be/"
            }
        }
    }
}
