pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        AWS_PROFILE = 'catalog-admin'
        AWS_REGION = 'ap-south-2'
        AWS_DEFAULT_REGION = 'ap-south-2'
        AWS_SDK_LOAD_CONFIG = '1'
        TF_IN_AUTOMATION = 'true'
        TF_VAR_alert_email = credentials('sns-alert-email')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Format') {
            steps {
                sh 'terraform fmt -check -recursive terraform'
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform/environments/dev') {
                    sh 'terraform init -input=false'
                    sh 'terraform validate'
                }
            }
        }

        stage('Checkov Scan') {
            steps {
                sh 'checkov --directory terraform --framework terraform'
            }
        }

                stage('Build and Push Image') {
            steps {
                script {
                    env.IMAGE_TAG = sh(
                        script: 'git rev-parse --short=12 HEAD',
                        returnStdout: true
                    ).trim() + "-${env.BUILD_NUMBER}"

                    env.TF_VAR_image_tag = env.IMAGE_TAG
                }

                dir('terraform/environments/dev') {
                    script {
                        env.ECR_REPOSITORY_URL = sh(
                            script: 'terraform output -raw container_image_repository_url',
                            returnStdout: true
                        ).trim()
                    }
                }

                sh '''
                    set -eu
                    ECR_REGISTRY="${ECR_REPOSITORY_URL%%/*}"

                    aws ecr get-login-password --region "$AWS_REGION" \
                      | docker login --username AWS --password-stdin "$ECR_REGISTRY"

                    docker build \
                      -f application/Dockerfile \
                      -t "$ECR_REPOSITORY_URL:$IMAGE_TAG" \
                      application

                    docker push "$ECR_REPOSITORY_URL:$IMAGE_TAG"
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform/environments/dev') {
                    sh 'terraform plan -input=false -out=tfplan'
                }
            }
        }

        stage('Approve Apply') {
            steps {
                timeout(time: 20, unit: 'MINUTES') {
                    input message: 'Review the Terraform plan in the build log. Approve applying it to AWS?', ok: 'Apply'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform/environments/dev') {
                    sh 'terraform apply -input=false -auto-approve tfplan'
                }
            }
        }
    }

    post {
        always {
            dir('terraform/environments/dev') {
                sh 'rm -f tfplan'
            }
        }
    }
}
