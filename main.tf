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

# Start the application container
resource "docker_container" "app_container" {
  image = "my-local-app:latest"
  name  = "production-app"
  
  ports {
    internal = 80
    external = 8081
  }
}
