# SoftwareKG-PMC-Analysis

Code to create and analyze SoftwareKG, a Knowledge Graph of Software Mentions over PMC articles.

This repository contains the code to analyse PMC-SoftwareKG. 
Please note that the PMC-SoftwareKG dataset publication does only contain data shared under Open Access license.
Data from PubMedKG (http://er.tacc.utexas.edu/datasets/ped) is not included.

Clone this repository by running `git clone --recurse-submodules https://github.com/f-krueger/SoftwareKG-PMC-Analysis`

# Necessary Resources to Re-Create SoftwareKG

* PubMed Central Open Access Dump via https://www.ncbi.nlm.nih.gov/pmc/tools/openftlist/
* PubMedKG (PKG2020S4 (1781-Dec. 2020), Version 4) via http://er.tacc.utexas.edu/datasets/ped

# Code for Software mention and related metadata extraction

* All code is available via https://github.com/dave-s477/SoMeNLP/tree/softwarekg
* The particular version used for the construction of Software KG is bound as submodule into this repository in folder `SoMeNLP`

# How to re-run analyses on SoftwareKG

* Download SoftwareKG-PMC JSON-LD data files from Zenodo via 
 [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5553738.svg)](https://doi.org/10.5281/zenodo.5553738)


* Load into triple store of your choice with SPARQL end point, for instance from https://hub.docker.com/r/tenforce/virtuoso/
* Build and start docker environment
  * build: `docker build -t softwarekg_analysis`
  * run: `docker run --rm --name=SoftwareKG_Jupyter-R -p 8899:8888 -v "$PWD":/home/jovyan/work --user root -e NB_UID=$(id -u) -e NB_GID=$(id -g) softwarekg_analysis`
* Start browser and connect via http://locahost:8899
* Adjust URL of sparql endpoint
* Click Kernel -> Restart & Run all