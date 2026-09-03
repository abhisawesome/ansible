terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.5.0"
    }
  }
}

provider "docker" {
  host = var.docker_host
}


variable "docker_host" {

}
variable "docker_image" {
  default = "ubuntu:22.04"
}

variable "servers" {
  type = map(object({
    name          = string
    internal_port = number
    external_port = number
  }))
  default = {
    webserver1 = {
      name          = "webserver1"
      internal_port = 80
      external_port = 9006
    }
    webserver2 = {
      name          = "webserver2"
      internal_port = 80
      external_port = 9007
    }
  }
}



resource "docker_container" "webservers" {
  for_each = var.servers
  name     = each.value.name
  image    = var.docker_image
  command  = ["sleep", "infinity"]
  ports {
    internal = each.value.internal_port
    external = each.value.external_port
    protocol = "tcp"
  }
}
