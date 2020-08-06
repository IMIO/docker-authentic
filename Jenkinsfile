#!/usr/bin/env groovy
@Library('jenkins-pipeline-scripts') _

pipeline {
    agent any
    triggers {
        cron('0 5 * * 1') // every monday at 5 am
    }
    options {
        // Only keep the 20 most recent builds
        buildDiscarder(logRotator(numToKeepStr:'20'))
    }
    stages {
        stage('Build testing env'){
            steps {
                sh 'make testing-env'
            }
        }
        stage('Tests'){
            steps {
                echo "Running build ${env.BUILD_ID} on ${env.JENKINS_URL}"
                sh 'make run-cypress'
            }
        }
        stage('Push image to registry') {
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
    post {
        regression{
            mail to: 'benoit.suttor+jenkins@imio.be',
                 subject: "Broken Pipeline: ${currentBuild.fullDisplayName}",
                 body: "The pipeline ${env.JOB_NAME} ${env.BUILD_NUMBER} is broken (${env.BUILD_URL})"
        }
        fixed{
            mail to: 'benoit.suttor+jenkins@imio.be',
                 subject: "Fixed Pipeline: ${currentBuild.fullDisplayName}",
                 body: "The pipeline ${env.JOB_NAME} ${env.BUILD_NUMBER} is back to normal (${env.BUILD_URL})"
        }
        failure{
            mail to: 'benoit.suttor+jenkins@imio.be',
                 subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
                 body: "The pipeline${env.JOB_NAME} ${env.BUILD_NUMBER} failed (${env.BUILD_URL})"
        }
        cleanup{
            sh 'docker-compose -f docker-compose.yml -f docker-compose.test.yml rm -s -f'
            sh 'git update-index --assume-unchanged data/authentic2-multitenant/agents.wc.localhost/hobo.json data/authentic2-multitenant/usagers.wc.localhost/hobo.json data/combo/backoffice-agents.wc.localhost/hobo.json data/combo/backoffice-usagers.wc.localhost/hobo.json  data/combo/combo-agents.wc.localhost/hobo.json data/combo/combo-usagers.wc.localhost/hobo.json data/hobo/hobo-agents.wc.localhost/hobo.json data/hobo/hobo-usagers.wc.localhost/hobo.json data/combo/backoffice-agents.wc.localhost/idp-metadata-1.xml data/combo/backoffice-usagers.wc.localhost/idp-metadata-1.xml data/combo/combo-agents.wc.localhost/idp-metadata-1.xml data/combo/combo-usagers.wc.localhost/idp-metadata-1.xml data/hobo/hobo-agents.wc.localhost/idp-metadata-1.xml data/hobo/hobo-usagers.wc.localhost/idp-metadata-1.xml'
            //deleteDir()
        }
    }
}
