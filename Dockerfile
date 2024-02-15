FROM jupyter/scipy-notebook:ubuntu-22.04

USER root
RUN apt-get update && apt-get install -y graphviz git

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get --yes install --no-install-recommends \
    bison \
    g++ \
    gfortran \
    git \
    libboost-python-dev \
    libboost-numpy-dev \
    vim

# Python3 requirements
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install astropy bdsf matplotlib wcsaxes wheel
RUN python3 -m pip install astroquery --index-url https://gitlab.com/api/v4/projects/53653803/packages/pypi/simple

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}/usr/local/lib
ENV PYTHONPATH=${PYTHONPATH}:/opt

COPY config/nsswitch.conf /etc


USER $NB_UID

ENV HOME=/arc/home/$NB_USER \
	NB_USER=$NB_USER \
	NB_UID=$NB_UID \
	NB_GID=$NB_GID \
	LC_ALL=en_US.UTF-8 \
	LANG=en_US.UTF-8

COPY ./scripts/ $HOME/scripts

#RUN scripts/fix-permissions $HOME/scripts

WORKDIR $HOME

