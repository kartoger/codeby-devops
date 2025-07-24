pipeline {
    agent any
    environment {
        CHANGED_FILES = ""
    }

    stages {
        stage('Detect Changes') {
            steps {
                script {
                    def previousCommit = env.GIT_PREVIOUS_SUCCESSFUL_COMMIT ?: "HEAD~1"
                    echo "Comparing commits: ${previousCommit} -> ${env.GIT_COMMIT}"
                    CHANGED_FILES = sh(
                        script: """
                            git diff --name-only ${previousCommit} ${env.GIT_COMMIT} || true
                        """,
                        returnStdout: true
                    ).trim()

                    echo "Changed files raw:\n${CHANGED_FILES}"
                    CHANGED_FILES.readLines().each { echo "Changed: $it" }
                }
            }
        }

        stage('Build & Test') {
            parallel {
                stage('HelloWorld') {
                    when {
                        expression { 
                            return CHANGED_FILES.tokenize('\n').any { it.startsWith('simple-java-maven-app/') } 
                        }
                    }
                    steps {
                        dir('simple-java-maven-app') { sh 'mvn clean package' }
                    }
                }
                stage('HelloJenkins') {
                    when {
                        expression { 
                            return CHANGED_FILES.tokenize('\n').any { it.startsWith('simple-java-maven-app-Jenkins/') } 
                        }
                    }
                    steps {
                        dir('simple-java-maven-app-Jenkins') { sh 'mvn clean package' }
                    }
                }
                stage('HelloDevops') {
                    when {
                        expression { 
                            return CHANGED_FILES.tokenize('\n').any { it.startsWith('simple-java-maven-app-Devops/') } 
                        }
                    }
                    steps {
                        dir('simple-java-maven-app-Devops') { sh 'mvn clean package' }
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
