Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/noble64"
  config.vm.hostname = "homelab"

  config.vm.network "forwarded_port",
    guest: 80,
    host: 8080,
    host_ip: "127.0.0.1",
    auto_correct: true

  config.vm.provider "virtualbox" do |vb|
    vb.name = "linux-homelab"
    vb.memory = 2048
    vb.cpus = 2
  end

  config.vm.provision "shell",
    path: "provision/bootstrap.sh",
    privileged: true

  config.vm.provision "file",
    source: "docker/docker-compose.yml",
    destination: "/tmp/docker-compose.yml"

  config.vm.provision "file",
    source: "docker/nginx/index.html",
    destination: "/tmp/index.html"

  config.vm.provision "file",
    source: "scripts/health-check.sh",
    destination: "/tmp/health-check.sh"

  config.vm.provision "shell", inline: <<-SHELL
    set -e

    mkdir -p /opt/homelab/nginx
    mv /tmp/docker-compose.yml /opt/homelab/docker-compose.yml
    mv /tmp/index.html /opt/homelab/nginx/index.html

    mv /tmp/health-check.sh /usr/local/bin/homelab-health
    chmod +x /usr/local/bin/homelab-health

    cd /opt/homelab
    docker compose up -d
  SHELL
end
