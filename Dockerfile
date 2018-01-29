FROM jupyter/all-spark-notebook

USER root

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    gfortran \
    gcc && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_USER

# R packages
RUN conda install --quiet --yes \
    'r-base=3.3.2' \
    'r-irkernel=0.7*' \
    'r-plyr=1.8*' \
    'r-devtools=1.12*' \
    'r-tidyverse=1.0*' \
    'r-shiny=0.14*' \
    'r-rmarkdown=1.2*' \
    'r-forecast=7.3*' \
    'r-rsqlite=1.1*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=0.2*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-randomforest=4.6*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR

RUN conda install -c cyclus java-jdk  --quiet --yes && conda clean -tipsy && fix-permissions $CONDA_DIR
RUN conda install -c terradue r-rhdfs r-rgdal --quiet --yes && conda clean -tipsy && fix-permissions $CONDA_DIR

RUN conda install --quiet --yes \
    'r-rjava' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR

USER root

RUN mkdir -p /opt
RUN curl -L http://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-2.7.5/hadoop-2.7.5.tar.gz |  tar -xz -C /opt/
RUN mv /opt/hadoop-2.7* /opt/hadoop


USER $NB_USER


RUN conda install nb_conda --quiet --yes && conda clean -tipsy && fix-permissions $CONDA_DIR

RUN conda install --quiet --yes 'r-doParallel'  && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR

RUN conda install --quiet -c bioconda --yes 'r-mixomics'  && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR

RUN conda create -n python2 python=2.7 anaconda && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR
