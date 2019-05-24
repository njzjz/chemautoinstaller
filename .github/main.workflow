workflow "Test" {
  on = "push"
  resolves = ["bash"]
}

action "bash" {
  uses = "docker://centos:latest"
  runs = "/bin/bash"
  args = "ChemAutoInstaller.sh -A"
}
