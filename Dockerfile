# VERSION 1.10.11
# AUTHOR: Swapnil Gusani
# DESCRIPTION: Basic Airflow container
# BUILD: docker build --rm -t swapniel99/docker-airflow .
# SOURCE: https://github.com/swapniel99/docker-airflow

FROM apache/airflow:1.10.11

USER root

##System upgrade
RUN set -ex \
    && buildDeps=' \
        git \
    ' \
    # Upgrade packages
    && apt-get update -yqq \
    && apt-get upgrade -yqq \
    && apt-get install -yqq --no-install-recommends \
        $buildDeps \
    && apt-get install -yqq sudo \
    && pip install --upgrade pip \
    && pip install beautifulsoup4==4.9.3 \
    # Cleanup
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /root/.cache/pip \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

# Copy Config Files
COPY script/entrypoint_wrapper.sh /entrypoint_wrapper.sh
COPY config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

# Make airflow user owner
RUN chown -R airflow: ${AIRFLOW_HOME} \
&& mkdir -p $HOME/data \
# Add airflow user to sudoers group
&& echo "airflow:airflow" | chpasswd \
&& adduser airflow sudo


EXPOSE 5555 8793

USER airflow
ENTRYPOINT ["/entrypoint_wrapper.sh"]
