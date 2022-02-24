#!/bin/bash
echo "ECS_CLUSTER=pirum-tech-demo-cluster" >> /etc/ecs/ecs.config
echo "ECS_INSTANCE_ATTRIBUTES = {\"type\": \"node\"}" >> /etc/ecs/ecs.config