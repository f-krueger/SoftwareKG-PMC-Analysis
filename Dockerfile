FROM jupyter/r-notebook:latest

LABEL maintainer="frank.krueger@uni-rostock.de"


# Set user to Jupyter Notebook user
USER ${NB_UID}

# Change working directory to volume mount point
WORKDIR /home/$NB_USER/work


RUN mamba install --quiet --yes \
    'r-SPARQL' \
    'r-tictoc' \
    'r-xtable' \
    'r-gridExtra' && \
     mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"