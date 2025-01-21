FROM gp-build-base:1.0

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moskow 
COPY . /root
WORKDIR /root

RUN ls -al .
RUN ls -al gpdb
RUN ls -al gpdb/*

RUN echo 'deb http://dist.yandex.ru/mdb-bionic-secure stable/all/' | tee -a /etc/apt/sources.list &&\
    echo 'deb http://dist.yandex.ru/mdb-bionic-secure stable/amd64/' | tee -a /etc/apt/sources.list &&\
    apt-get update -o Acquire::AllowInsecureRepositories=true &&\
    apt-get install -y --no-install-recommends --allow-unauthenticated libmdblocales1 libmdblocales-dev


RUN cd gpdb && ln -snf /usr/share/zoneinfo/Europe/London /etc/localtime && echo Europe/London > /etc/timezone \
&& sed -i "s/archive.ubuntu.com/mirror.yandex.ru/g" /etc/apt/sources.list \
&& apt-get clean && rm -rf /var/lib/apt/lists/* \
&& git clone https://github.com/boundary/sigar.git -b master \
&& wget -c https://archive.apache.org/dist/xerces/c/3/sources/xerces-c-3.1.1.tar.gz -O - | tar -xz \
&& mv greenplum-build/debian ./ && mv greenplum-yandex-patches/gp_patches/6 ./debian/patches

RUN ls -al .
RUN ls -al gpdb
RUN ls -al gpdb/*

ENV DEB_CFLAGS_APPEND=-fno-omit-frame-pointer
ENV DEB_CPPFLAGS_APPEND=-fno-omit-frame-pointer
ENV DEB_CXXFLAGS_APPEND=-fno-omit-frame-pointer

ENTRYPOINT ["./make_deb.sh"]
