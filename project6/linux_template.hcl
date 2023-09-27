source "amazon-ebs" "ubuntu" {
  ami_name      = "ubuntu-image-aws"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami_filter {
    filters = {
      name             = "ubuntu/images/*ubuntu-xenial-16.04-amd-server-*"
      root-device-type = "ebs"
      virtualization   = "hvm"
    }
    most_recent = true
    owners      = ["124345656554"]
  }
  ssh_username = "ubuntu"
}
build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "file" {
    destination = "/tmp"
    source      = "files"
  }
  provisioner "shell" {
    script = "scripts/setup.sh"
  }
  provisioner "shell" {
    inline = ["echo ${var.deployment_version} > ~/DEPLOYMENT_VERSION"]
  }
  post-processor "shell-local" {
    inline = ["rm /tmp/script.sh"]
  }
}