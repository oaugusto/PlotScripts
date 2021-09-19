#! /usr/bin/env python

import sys
import os
import numpy
import math

projects = ["cbnet", "cbnetAdapt30", "cbnetAdapt100", "cbnetAdapt500", "cbnetAdapt1000", "displaynet"]
datasets = [1, 2, 4]

input_dir = "../../../Data/projector_adapt"
output_file = "../../csv_data/projector_adapt/total_time.csv"

pr_file = open(output_file, "w")
pr_file.write("project,dataset,value\n")

for project in projects:
    for dataset in datasets:
        
        total_time_path = "{}/{}/{}/total_time.txt".format(input_dir, project, dataset)

        with open(total_time_path) as f:
            first_line = f.readline()

        value = int(first_line.strip())

        pr_file.write("{},{},{}\n".format(project, dataset, value))

pr_file.close()