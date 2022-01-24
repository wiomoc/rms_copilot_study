#!/bin/sh

Rscript -e 'install.packages(c("plyr", "distr", "optparse"), repos="https://cloud.r-project.org")'
python -m pip install -r ./requirements.txt