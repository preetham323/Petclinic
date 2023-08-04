pipeline {
    agent any
    tools {
        maven "maven3"
    }
    environment {
        registryCredentials = 'ecr:us-east-2:aws_credential'
        appRegistry = "346141603601.dkr.ecr.us-east-2.amazonaws.com/petclinic"
        petclinicRegistry = "https://346141603601.dkr.ecr.us-east-2.amazonaws.com"
    }
    stages {
        stage ('fetch code') {
            steps {
                git branch: 'main' url:  
            }
        }
        stage ('test') {
            steps {
                sh 'mvn test'
            }
        }
        stage ('code analysis with checkstyle') {
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
            post {
                success {
                    echo 'General analysis report'
                }
            }
        }
        stage ('build & Sonarqube analysis') {
            environment {
                ScannerHome = tool 'sonarcloud'
            }
            steps {
                withSonarQubeEnv('sonar') {
                 sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=petclinic \
                   -Dsonar.projectName=petclinic \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                }
            }
        }
        stage ('Quality gate') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage ('build app image') {
            steps {
                script {
                    dockerImage=docker.build(appRegistry + ":$BUILD_NUMBER",".")
                }
            }
        }
        stage ('upload App Image') {
            steps {
                script {
                    docker.withRegidtry(petclinicRegistry, registryCredentials) {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push('latest') 
                    }
                }
            }
        }
    }
}