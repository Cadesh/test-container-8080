[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)   ![Python](https://img.shields.io/badge/python-3.12-blue.svg)   ![build status](https://codebuild.ca-central-1.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiUHZtSUI2M3h0YjdBWlFLbUtGam9MK1JVNE1aTWdhcS8yNjVTTTJKWjYwaUdvTlVqa0kvRHlRNzI5ejZlN3ZNVHc5Z2dSUThVbmowaXpJcldxMEo0UkpzPSIsIml2UGFyYW1ldGVyU3BlYyI6Ikd5UUhaYWQvVndGbmJjKzUiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=main)


# Test-Containter-8080

This Image was created to test CodeBuild integration with GitHub.

To make this work you must: 

1 - Create the CodeBuild Role as defiend in the folder IAM_Role_For_CodeBuild

2 - Create the CodeBuild Project 

3 - Create the ECR Repo for Image

4 - Create Secrets: Github_Token, GitHub_User, AWS_Account_ID

You will be able to run the CodeBuild manually and push the Image to ECR. 


References:
https://aws.amazon.com/blogs/devops/build-a-continuous-delivery-pipeline-for-your-container-images-with-amazon-ecr-as-source/
https://www.learnaws.org/2022/11/18/aws-codebuild-secrets-manager/


