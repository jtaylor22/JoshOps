#!/bin/bash

sudo yum update -y
sudo yum install java-1.8.0-openjdk -y

sudo mkdir /var/jenkins

sudo aws s3 cp s3://test-joshops-bucket/agent.jar /var/jenkins

sudo java -jar /var/jenkins/agent.jar -jnlpUrl https://jenkins.joshdevops.co.uk/computer/slave%5F1/jenkins-agent.jnlp -secret 555d59eca2bab4abfeeced2afc50dd27c47eb35ba8b2a1172abe0952e82cbb61 -workDir "/va
r/jenkins"
