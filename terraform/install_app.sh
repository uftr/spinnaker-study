#! /bin/bash
sudo apt-get update
wget http://nexus.mygurukulam.org:8081/repository/mild-temper-microservice/pool/s/spinnaker-study/spinnaker-study_1.27_all.deb
sudo dpkg -i spinnaker-study_1.27_all.deb || true
sudo apt-get install -f -y
