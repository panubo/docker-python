# Python Base

FROM centos:centos7

ENV PYTHON_VERSIONS=3.5.7

# 1. Update & Install
# 2. Required for virtualenv bootstrap / install
# 3. Base packages required for compiling popular Python packages
# 4. Base packages for compiling Python
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    yum -q -y update && \
    yum -q -y install curl mercurial git tar bzip2 python-jinja2 && \
    yum -q -y install gcc freetype ghostscript freetype-devel libpng libjpeg-turbo libpng-devel libjpeg-turbo-devel python-devel libxml2-devel libxslt-devel mariadb-devel && \
    yum -q -y install make openssl-devel sqlite-devel libffi-devel bzip2-devel && \
    yum -q clean all

# Compile & Install Python from source
# Check binary is sane
RUN for VERSION in ${PYTHON_VERSIONS}; do mkdir -p /tmp/build && cd /tmp/build && curl -O https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz && tar -xzf Python-${VERSION}.tgz && \
    cd /tmp/build/Python-${VERSION} && ./configure && make -j `nproc` && make install && rm -rf /tmp/build/Python-${VERSION}; /usr/local/bin/python${VERSION%.*} --version; done

# Clean up
# Also Remove links to indefinite Python versions (also prevents os Python from being overridden by accident)
RUN rm -rf /tmp/* /tmp/build/ /var/tmp/* && \
    find /usr/local/bin/ -type l -exec rm {} \; && \
    rm -rf /var/cache/yum/*
