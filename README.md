# SoftwareKG-PMC-Analysis

Code to create and analyze SoftwareKG, a Knowledge Graph of Software Mentions over PMC articles.

This repository contains the code to analyse PMC-SoftwareKG. 
Please note that the PMC-SoftwareKG dataset publication does only contain data shared under Open Access license.
Data from PubMedKG (http://er.tacc.utexas.edu/datasets/ped) is not included.
s
# How to re-run analyses

* Download SoftwareKG-PMC data files from Zenodo into triple store with SPARQL end point
* Build and start docker environment
  * build: `docker build -t softwarekg_analysis`
  * run `docker run --rm --name=SoftwareKG_Jupyter-R -p 8899:8888 -v "$PWD":/home/jovyan/work --user root -e NB_UID=$(id -u) -e NB_GID=$(id -g) softwarekg_analysis`
* Start browser and connect via http://locahost:8899


