FROM hashicorp/terraform:light
# https://hub.docker.com/r/hashicorp/terraform/

COPY app.tf /
COPY run.sh /
COPY install_app.sh /

ENTRYPOINT ["/run.sh"]
