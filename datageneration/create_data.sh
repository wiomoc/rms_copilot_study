#!/bin/sh

echo "Creating Quantitative Data..."
Rscript ./quant_faker.R $@
echo "Creating Qualitative Data..."
python ./quality_faker.py $@
echo "Printing..."
python ./plotter.py
echo "Done."