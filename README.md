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

# Data Usage Manual (update)

The data is now also published in n-triple format `.n3` under 
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7400022.svg)](https://doi.org/10.5281/zenodo.7400022)

This facilitates the import and makes it easy to load into a Virtuoso triple store.
The exact process is described in the following: 

1. Start a docker running Virtuoso, for instance, with this command:
```
docker run \
    --name softwarekg2_virtuoso3 \
    -p 8890:8890 -p 1111:1111 \
    -e DBA_PASSWORD=dba -e SPARQL_UPDATE=true \
    -e DEFAULT_GRAPH=http://data.gesis.org/softwarekg2 \
    --user=root \
    -v ${PWD}/data:/data \
    tenforce/virtuoso
```

This will create a new folder `data` in the current working directory. To change this behavior, update the argument under `-v ${PWD}/data:/data`. 

The location you provide will be mounted in the Virtuoso docker. 

2. Download the data from Zenodo and extract all `.n3` files into the created folder `${PWD}/data`.

3. Update the Virtuoso configuration under `virtuoso.ini` that will be created in `${PWD}/data` after first start of the docker. 

Update to the available memory (as more than 300M triples are loaded), as recommended in the `virtuoso.ini` file:
```
;; Uncomment next two lines if there is 16 GB system memory free
NumberOfBuffers          = 1360000
MaxDirtyBuffers          = 1000000
```
and uncommenting the default setting. Dependent on how much memory is available you can adjust the values to your system. 

Update the entry of `ResultSetMaxRows` under `[SPARQL]`. A recommended value is at least `1000000` because this number is required to get the software names, however, be aware that this can lead to query time outs. You might need to restart the docker so this change takes effect. 

4. Load the data in the Virtuoso store. 

For this you need to go into the docker instance and load the data. To get a shell connection to the docker you can run:
```
docker exec -it softwarekg2_virtuoso3 bash
```
Within this shell you can now open an SQL shell by running:
```
isql-v 1111
```
from which you can then load the data with the following command: 

This will give you access to the database. By running "isql-v 1111" you can open the SQL shell of the virtuoso store and add the files, by running:
```
ld_dir('./', '*.n3', 'http://data.gesis.org/softwarekg2/');
```
Make sure that your working directory does contain the data or switch the path from `./`. 

Now the data can be actually loaded by running: 
```
rdf_loader_run();
```
within the SQL shell. Be aware that this is a large data import and can take some time. 

Parallel data imports are possible as described in https://vos.openlinksw.com/owiki/wiki/VOS/VirtBulkRDFLoader

A simple bash script for running 8 parallel imports can look like this: 
```
#!/bin/bash

#. /usr/local/virtuoso-opensource/bin/virtuoso-t
isql-v 1111 dba dba exec="rdf_loader_run();" & 
isql-v 1111 dba dba exec="rdf_loader_run();" & 
isql-v 1111 dba dba exec="rdf_loader_run();" & 
isql-v 1111 dba dba exec="rdf_loader_run();" & 
isql-v 1111 dba dba exec="rdf_loader_run();" & 
isql-v 1111 dba dba exec="rdf_loader_run();" & 
isql-v 1111 dba dba exec="rdf_loader_run();" & 
isql-v 1111 dba dba exec="rdf_loader_run();" & 

wait 
isql-v 1111 dba dba exec="checkpoint;"
```

5. Confirm that the data was loaded correctly by accessing the SPARQL-Endpoint through the web interface:
```
http://localhost:8890
```
and navigating to "SPARQL Endpoint".

Run the simples possible query:
```
SELECT 
    COUNT(*) as ?Triples
FROM 
    <http://data.gesis.org/softwarekg2/>
WHERE 
{ 
    ?s ?p ?o 
}
```

or just

```
SELECT 
    COUNT(*) as ?Triples
WHERE 
{ 
    ?s ?p ?o 
}
```
Dependent on your default graph configuration.

The result should be `280,400,934`. (Note that this is fewer triples as in the analyses, because some data available from Scimago could not be published due to copyright, but the corresponding information is publicly available.)

6. Run the notebook. 

## Troubleshooting

If the number of triples is 0 make sure the graph name is correct. All available graph names can be listed by: 
```
SELECT DISTINCT ?g 
   WHERE  { GRAPH ?g {?s ?p ?o} } 
ORDER BY  ?g
```

