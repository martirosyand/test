pipeline {
    agent {
		label 'docker_agent'
	}

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds') // Jenkins credentials with DockerHub username & password
        GIT_COMMIT_SHORT = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
    }

    stages {
        stage('Checkstyle') {
            when { not { branch 'main' } }
            steps {
                sh 'mvn clean checkstyle:checkstyle'
				archiveArtifacts artifacts: 'target/checkstyle-result.xml', fingerprint: true, followSymlinks: false                
            }
        }

        stage('Test') {
            when { not { branch 'main' } }
            steps {
                sh 'mvn test'
            }
        }

        stage('Build') {
            when { not { branch 'main' } }
            steps {
                sh 'mvn package -DskipTests'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    sh 'mvn package -DskipTests'

                    def repo = (env.BRANCH_NAME == 'main') ? 'main' : 'mr'
                    def image = "${DOCKERHUB_CREDENTIALS_USR}/${repo}:spring-petclinic-${GIT_COMMIT_SHORT}"

                    sh "docker build -t ${image} ."
                    sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                    sh "docker push ${image}"
                }
            }
        }
    }
}

