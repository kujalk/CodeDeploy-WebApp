//Code Deploy
resource "aws_codedeploy_app" "demo-deploy" {
  compute_platform = "Server"
  name             = "demo-deploy"
}


resource "aws_codedeploy_deployment_group" "demo-prod-deploy-group" {
  app_name              = aws_codedeploy_app.demo-deploy.name
  deployment_group_name = "demo-prod-deploy-group"
  service_role_arn      = aws_iam_role.code-deploy.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Env"
      type  = "KEY_AND_VALUE"
      value = "Prod-CICD"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}

//Code PipeLine
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "demo-test-pipeline-bucket-vue-app-unique"
  acl           = "private"
  force_destroy = true
}

resource "aws_codepipeline" "codepipeline" {
  name     = var.Pipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        OAuthToken           = var.Github_token
        Owner                = var.Github_owner
        Repo                 = var.Github_repo
        Branch               = var.Github_branch
        PollForSourceChanges = "true"
      }
    }

  }

  stage {
    name = "Deploy-Prod"

    action {
      name            = "Deploy-Prod-EC2"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ApplicationName     = aws_codedeploy_app.demo-deploy.name
        DeploymentGroupName = aws_codedeploy_deployment_group.demo-prod-deploy-group.deployment_group_name
      }
    }
  }
}