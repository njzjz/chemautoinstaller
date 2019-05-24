workflow "Test" {
  on = "push"
  resolves = ["bash"]
}

action "bash" {
  uses = "docker://ubuntu@latest"
  runs = "bash ChemAutoInstaller.sh -A"
}
