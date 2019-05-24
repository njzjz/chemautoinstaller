workflow "Test" {
  on = "push"
  resolves = ["bash"]
}

action "bash" {
  uses = "docker://ubuntu@latest"
  runs = "/bin/bash"
  args = "ChemAutoInstaller.sh -A"
}
