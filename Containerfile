#use rhel 9.5 bootc container image as base image
FROM registry.redhat.io/rhel9/rhel-bootc:9.5

ARG RHSM_USER

#setup subscription manager in ordre to dnf install software on your image
RUN --mount=type=secret,id=rhsm_password subscription-manager register --username "$RHSM_USER" --password "$(cat /run/secrets/rhsm_password)"

#install cloud-init and create symbolic link, then remove download cache
RUN dnf -y install cloud-init  && \
    ln -s ../cloud-init.target /usr/lib/systemd/system/default.target.wants && \
    rm -rf /var/{cache,log} /var/lib/{dnf,rhsm}

#install the lamp components: php, ngnix, clear cache
RUN dnf module enable -y php:8.2 nginx:1.22 && dnf clean all

#install httpd, mariadb and php
RUN dnf install -y httpd mariadb mariadb-server php-fpm php-mysqlnd

#enable httpd, mariadb and php to start automatically on boot
RUN systemctl enable httpd mariadb php-fpm

# create a mosquitto quadlet container
COPY ./mosquitto.container /etc/containers/systemd/

#create an awe inspiring homepage, add the buildtime of the image as reference
RUN echo '<h1 style="text-align:center;">Welcome to RHEL image mode - build time '$(date)' </h1> <?php phpinfo(); ?>' >> /var/www/html/index.php
