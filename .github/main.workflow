workflow "Test" {
  on = "push"
  resolves = ["bash"]
}

action "bash" {
  uses = "actions/bin/sh@master"
  args = ["bash ChemAutoInstaller.sh -A"]
}
