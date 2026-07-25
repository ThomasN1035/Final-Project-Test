terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Reference the image built by Jenkins
resource "docker_image" "app_image" {
  name         = "my-local-app:latest"
  keep_locally = true
}

# Start the application container
resource "docker_container" "app_container" {
  image = docker_image.app_image.image_id
  name  = "production-app"
  
  ports {
    internal = 80
    external = 8081
  }
}
