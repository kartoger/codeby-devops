pipeline {
    agent any
    tools {
        maven 'M3'
    }
    environment {
        CHANGED_FILES = ""
    }

    stages {
        stage('Detect Changes') {
            steps {
                script {
                    def previousCommit = env.GIT_PREVIOUS_SUCCESSFUL_COMMIT ?: "HEAD~1"
                    CHANGED_FILES = sh(script: "git diff --name-only ${previousCommit} ${env.GIT_COMMIT} || true", returnStdout: true).trim()
                    echo "Changed files raw:\n${CHANGED_FILES}"
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    script {
                        if (CHANGED_FILES.tokenize('\n').any { it.startsWith('simple-java-maven-app/') }) {
                            sh 'mvn sonar:sonar -f simple-java-maven-app/pom.xml -Dsonar.projectKey=HelloWorld -Dsonar.host.url=$SONAR_HOST_URL'
                        }
                        if (CHANGED_FILES.tokenize('\n').any { it.startsWith('simple-java-maven-app-Jenkins/') }) {
                            sh 'mvn sonar:sonar -f simple-java-maven-app-Jenkins/pom.xml -Dsonar.projectKey=HelloJenkins -Dsonar.host.url=$SONAR_HOST_URL'
                        }
                        if (CHANGED_FILES.tokenize('\n').any { it.startsWith('simple-java-maven-app-Devops/') }) {
                            sh 'mvn sonar:sonar -f simple-java-maven-app-Devops/pom.xml -Dsonar.projectKey=HelloDevops -Dsonar.host.url=$SONAR_HOST_URL'
                        }
                    }
                }
            }
        }

        stage('Quality Gate') {
          steps {
            script {
              sleep 5
              timeout(time: 10, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
            }
        }
    }
}
        stage('Build & Test') {
            parallel {
                stage('HelloWorld') {
                    when { expression { CHANGED_FILES.tokenize('\n').any { it.startsWith('simple-java-maven-app/') } } }
                    steps {
                        dir('simple-java-maven-app') {
                            sh 'mvn clean verify'
                        }
                    }
                }
                stage('HelloJenkins') {
                    when { expression { CHANGED_FILES.tokenize('\n').any { it.startsWith('simple-java-maven-app-Jenkins/') } } }
                    steps {
                        dir('simple-java-maven-app-Jenkins') {
                            sh 'mvn clean verify'
                        }
                    }
                }
                stage('HelloDevops') {
                    when { expression { CHANGED_FILES.tokenize('\n').any { it.startsWith('simple-java-maven-app-Devops/') } } }
                    steps {
                        dir('simple-java-maven-app-Devops') {
                            sh 'mvn clean verify'
                        }
                    }
                }
            }
        }

        

        stage('Deploy') {
            steps {
                echo "Deploy only changed apps"
            }
        }
    }
}
