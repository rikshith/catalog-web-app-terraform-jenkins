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
