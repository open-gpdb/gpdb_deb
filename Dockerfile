FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moskow 
COPY . /root
WORKDIR /root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN ls -al .
RUN ls -al gpdb
RUN ls -al gpdb/*

RUN echo 'deb http://dist.yandex.ru/mdb-jammy-secure stable/all/' | tee -a /etc/apt/sources.list &&\
    echo 'deb http://dist.yandex.ru/mdb-jammy-secure stable/amd64/' | tee -a /etc/apt/sources.list &&\
    apt-get update -o Acquire::AllowInsecureRepositories=true &&\
    apt-get install -y --no-install-recommends --allow-unauthenticated libmdblocales1 libmdblocales-dev

RUN cd gpdb && ln -snf /usr/share/zoneinfo/Europe/London /etc/localtime && echo Europe/London > /etc/timezone \
&& sed -i "s/archive.ubuntu.com/mirror.yandex.ru/g" /etc/apt/sources.list \
&& apt-get update -o Acquire::AllowInsecureRepositories=true && apt-get install -y --no-install-recommends --allow-unauthenticated \
  build-essential libssl-dev gnupg \
  openssl debhelper debootstrap devscripts \
  make equivs bison ca-certificates-java ca-certificates \
  cmake curl cgroup-tools flex gcc-11 g++-11 g++-11-multilib \
  git krb5-multidev libapr1-dev libbz2-dev libcurl4-gnutls-dev \
  libpstreams-dev \
  libevent-dev libkrb5-dev libldap2-dev libperl-dev libreadline-dev \
  libssl-dev libxml2-dev libyaml-dev libzstd-dev libaprutil1-dev \
  libpam0g-dev libpam0g libcgroup1 libyaml-0-2 libldap-2.5-0 libssl3 \
  ninja-build python-setuptools quilt unzip wget zlib1g-dev libuv1-dev \
  libgpgme-dev libgpgme11 python2.7 python2.7-dev \
&& apt-get clean && rm -rf /var/lib/apt/lists/* \
&& git clone https://github.com/boundary/sigar.git -b master \
&& wget -c https://archive.apache.org/dist/xerces/c/3/sources/xerces-c-3.1.1.tar.gz -O - | tar -xz \
&& wget -c https://github.com/greenplum-db/gpbackup/releases/download/1.27.0/gpbackup \
&& wget -c https://github.com/greenplum-db/gpbackup/releases/download/1.27.0/gpbackup_helper \
&& wget -c https://github.com/greenplum-db/gpbackup/releases/download/1.27.0/gprestore \
&& mv greenplum-build/debian ./ && mv greenplum-yandex-patches/gp_patches/6 ./debian/patches

RUN ls -al .
RUN ls -al gpdb
RUN ls -al gpdb/*

RUN ln -s /usr/bin/python2.7 /usr/bin/python

ENV DEB_CFLAGS_APPEND=-fno-omit-frame-pointer
ENV DEB_CPPFLAGS_APPEND=-fno-omit-frame-pointer
ENV DEB_CXXFLAGS_APPEND=-fno-omit-frame-pointer

ENTRYPOINT ["./make_deb.sh"]
