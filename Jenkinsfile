pipeline {
    agent any
    stages{
        stage('Terraform plan'){
            steps{
                sh "terraform init"
                sh "terraform plan"
            }
        }
        stage('Terraform apply'){
            steps{
                sh "terraform apply --auto-approve"
                echo "done!"
            }
        }
        stage('Terraform destroy'){
            steps{
                sh "terraform destroy --auto-approve"
                echo "done!"
            }
        }
    }
}