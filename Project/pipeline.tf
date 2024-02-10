resource "aws_s3_bucket" "pipline_artifacts" {
  bucket = "codepipeline-us-east-1-1234-batch15-tf"
  acl    = "private"
}

resource "aws_codecommit_repository" "code_commit_repo" {
  repository_name = var.code_commit_repo
  description     = "This is the Code commit Repository created by terraform"
}

resource "aws_codebuild_project" "my_project" {
  name           = "projectbatchfifteen-tf"
  description    = "This code build project is created by terraform"
  build_timeout  = "60"
  queued_timeout = "480"

  service_role = "arn:aws:iam::686766985335:role/service-role/mycodebuild1"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "NO_CACHE"

  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  logs_config {
    cloudwatch_logs {
      status      = "ENABLED"
      group_name  = "mycodebuildlogs"
      stream_name = "mycodebuildlogs-stream"
    }

    s3_logs {
      status              = "ENABLED"
      location            = "mys3bucketzzzz/cb-tf"
      encryption_disabled = false
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/codecommit-tf-batchfifteen"
    git_clone_depth = 1
    buildspec       = file("buildspec.yml")
  }

}

resource "aws_codepipeline" "codepipeline" {
  name     = "projectbatchfifteenpipeline-tf"
  role_arn = "arn:aws:iam::686766985335:role/service-role/AWSCodePipelineServiceRole-us-east-1-pipelinetest"

  artifact_store {
    location = aws_s3_bucket.pipline_artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        "PollForSourceChanges" = "false",
        "RepositoryName"       = "codecommit-tf-batchfifteen",
        "BranchName"           = "master",
        "OutputArtifactFormat" = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.my_project.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
        ClusterName = "my-batchfifteencluster-tf",
        ServiceName = "mysvc",
        FileName    = "imagedefinitions.json"
      }
    }
  }
  stage {
    name = "Deploy_Prod"

    action {
      name            = "Deploy_Prod"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
        ClusterName = "ecs-ec2-cluster",
        ServiceName = "mysvcec2",
        FileName    = "imagedefinitions.json"
      }
    }
  }
}