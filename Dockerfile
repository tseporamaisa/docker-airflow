# VERSION 1.10.11
# AUTHOR: Swapnil Gusani
# DESCRIPTION: Basic Airflow container
# BUILD: docker build --rm -t swapniel99/docker-airflow .
# SOURCE: https://github.com/swapniel99/docker-airflow

FROM apache/airflow:1.10.11

USER root

##Install packages
RUN pip install beautifulsoup4==4.9.3 \
    && pip install --user --upgrade -e git+https://github.com/twintproject/twint.git@origin/master#egg=twint

# Copy Config Files
COPY script/entrypoint_wrapper.sh /entrypoint_wrapper.sh
COPY config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

# Make airflow user owner
RUN chown -R airflow: ${AIRFLOW_HOME}

EXPOSE 5555 8793

USER airflow
ENTRYPOINT ["/entrypoint_wrapper.sh"]
