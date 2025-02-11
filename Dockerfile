FROM debian:stable-slim


ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8


# -- Install utilities
RUN apt-get update --fix-missing --no-install-recommends && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# -- Anaconda home setup
ENV CONDA_HOME /opt/conda
ENV PATH $CONDA_HOME/bin:$PATH


# -- Python version
ARG python_version=3.9


# -- Install Miniconda python
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/conda.sh && \
    /bin/bash ~/conda.sh -b -p $CONDA_HOME && \
    rm ~/conda.sh && \
    conda install -y python=${python_version} && \
    $CONDA_HOME/bin/conda clean -tipsy


# -- Install project dependencies
ADD requirements.txt /opt/autoguru/requirements.txt
RUN pip install -U --no-cache-dir -r /opt/autoguru/requirements.txt


# -- Install the project
ADD README.md /opt/autoguru/README.md
ADD MANIFEST.in /opt/autoguru/MANIFEST.in
ADD setup.py /opt/autoguru/setup.py
ADD setup.cfg /opt/autoguru/setup.cfg
ADD autoguru /opt/autoguru/autoguru/
RUN pip install -e /opt/autoguru/


# -- Launch project on run
ENTRYPOINT ["autoguru"]
