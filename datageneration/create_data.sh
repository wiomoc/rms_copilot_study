#!/bin/sh

if ! [ -z "$1" ]
then
    sed -i 's/seed = 42/seed = '$1'/g' quant_faker.R
    sed -i 's/seed = 42/seed = '$1'/g' quality_faker.py
fi

Rscript ./quant_faker.R

python -m pip install -r ./requirements.txt
python ./quality_faker.py