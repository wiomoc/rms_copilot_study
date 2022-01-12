#!/bin/sh

Rscript ./quant_faker.R $1
python ./quality_faker.py $1