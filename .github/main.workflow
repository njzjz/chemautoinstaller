workflow "Test and deploy" {
  on = "push"
  resolves = [
    "push",
  ]
}

action "bash" {
  uses = "actions/bin/sh@master"
  args = ["apt update && apt install wget bzip2 -y && bash ChemAutoInstaller.sh -A"]
}

action "GitHub Action for Docker" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "build -t chemautoinstaller ."
}

action "Filters for GitHub Actions" {
  uses = "actions/bin/filter@3c0b4f0e63ea54ea5df2914b4fabf383368cd0da"
  needs = ["GitHub Action for Docker", "bash"]
  args = "branch master"
}

action "login" {
  uses = "actions/docker/login@master"
  needs = "Filters for GitHub Actions"
  secrets = [
    "DOCKER_USERNAME",
    "DOCKER_PASSWORD",
  ]
  env = {
    DOCKER_REGISTRY_URL = "docker.pkg.github.com"
  }
}

action "tag" {
  needs = ["login"]
  uses = "actions/docker/tag@master"
  env = {
    IMAGE_NAME = "chemautoinstaller"
    CONTAINER_REGISTRY_PATH = "docker.pkg.github.com/njzjz/chemautoinstaller"
  }
  args = ["$IMAGE_NAME", "$CONTAINER_REGISTRY_PATH/$IMAGE_NAME"]
}

action "push" {
  needs = ["tag"]
  uses = "actions/docker/cli@master"
  env = {
    IMAGE_NAME = "chemautoinstaller"
    CONTAINER_REGISTRY_PATH = "docker.pkg.github.com/njzjz/chemautoinstaller"
  }
  args = ["push", "$CONTAINER_REGISTRY_PATH/$IMAGE_NAME"]
}
