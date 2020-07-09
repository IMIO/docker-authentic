#!/usr/bin/env groovy
@Library('jenkins-pipeline-scripts') _

pipeline {
    agent none
    triggers {
        cron('* 5 * * 1') // every monday at 5 am
    }
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
            when {
               branch 'master'
               expression {
                   currentBuild.result == null || currentBuild.result == 'SUCCESS'
               }
            }
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
                branch 'master'
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                deployToStaging (
                    env.BUILD_ID,
                    "wc/sso",
                    "/^staging.imio.be/",
                    "systemctl restart sso_staging"
                )
            }
        }
    }
}
