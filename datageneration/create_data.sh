#!/bin/sh

echo "Creating Data..."
Rscript ./data_faker.R $@
echo "Printing..."
python ./plotter.py
echo "Done."