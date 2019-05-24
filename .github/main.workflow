workflow "Test" {
  on = "push"
  resolves = ["bash"]
}

action "bash" {
  uses = "actions/bin/sh@master"
  args = ["apt update && apt install wget bzip2 -y && bash ChemAutoInstaller.sh -A"]
}
