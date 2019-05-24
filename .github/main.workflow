workflow "Test" {
  on = "push"
  resolves = ["bash"]
}

action "bash" {
  uses = "actions/bin/sh@master"
  needs = "apt install wget"
  args = ["bash ChemAutoInstaller.sh -A"]
}

action "apt install wget" {
  uses = "actions/bin/sh@master"
  args = ["apt update && apt install wget -y"]
}
