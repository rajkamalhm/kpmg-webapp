variable "vpc_cidr" {
  description = "The CIDR Block for hn-vpc"
  default     = "10.0.0.0/16"
}

variable "public_cidrs" {
  description = "Public Subnet CIDR Blocks"
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

variable "flask_app_image" {
  description = "Dockerhub image for flask-app"
  default = "docker.io/rajkamalhm/flask_docker:latest"
}

variable "flask_app_port" {
  description = "Port exposed by the flask application"
  default = 8080
}

variable "flask_env" {
  description = "FLASK ENV variable"
  default = "production"
}

variable "flask_app" {
  description = "FLASK APP variable"
  default = "app"
}