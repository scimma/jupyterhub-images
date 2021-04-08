# 2021-03-04
FROM jupyter/scipy-notebook:d990a62010ae

# Packages installed as joyvan (who owns conda)
USER $NB_UID

# notebook environment and utilities
RUN conda install -c defaults nb_conda_kernels
RUN conda install -c defaults -c conda-forge nbgitpuller

# install additional general data science and astronomy conda packages
RUN conda install -c defaults -c conda-forge munch tqdm pv
RUN conda install -c defaults -c conda-forge astropy aplpy astroml
RUN pip install funcx
# Alert Streaming
RUN conda install -c defaults -c conda-forge python-confluent-kafka fastavro python-avro

# Hopskotch
RUN pip install hop-client

# Hide system kernels from nb_conda_kernels
# Place user-defined conda environments into the user's directory
RUN printf '\
    \n\
    c.CondaKernelSpecManager.env_filter = r"^/opt/.*$" \n\
    c.CondaKernelSpecManager.name_format = "Conda env '"{1}"' ({0})" \n'\
    >> /etc/jupyter/jupyter_notebook_config.py

RUN printf '\
    envs_dirs:\n\
    - $HOME/.conda-envs\n\
    ' >> /opt/conda/.condarc
