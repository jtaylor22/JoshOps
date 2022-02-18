#!/bin/bash

sudo yum update -y
sudo yum install java-1.8.0-openjdk -y

sudo mkdir /var/jenkins

sudo aws s3 cp s3://test-joshops-bucket/agent.jar /var/jenkins

sudo java -jar /var/jenkins/agent.jar -jnlpUrl https://jenkins.joshdevops.co.uk/computer/slave%5F1/jenkins-agent.jnlp -secret 10eedc6fe3b188b7a50a43ac8c0577e1426929c8a82bfec8ce9aefba3db89b80 -workDir "/var/jenkins"
