#! /usr/bin/env python

import sys
import os
import numpy
import math

output_file = "../../csv_data/facebook_pfab/total_time.csv"

pr_file = open(output_file, "w")
pr_file.write("project,dataset,value\n")

projects = ["cbnet", "seqcbnet", "displaynet", "splaynet"]
datasets = ["trace_0_1", "trace_0_5", "trace_0_8"]

input_dir = "../../../Data/pfab"

for project in projects:
    for dataset in datasets:
        
        total_time_path = "{}/{}/{}/total_time.txt".format(input_dir, project, dataset)

        with open(total_time_path) as f:
            first_line = f.readline()

        value = int(first_line.strip())

        pr_file.write("{},{},{}\n".format(project, dataset, value))

projects = ["cbnet", "seqcbnet", "displaynet", "splaynet"]
input_dir = "../../../Data/facebook"

for project in projects:
        
    total_time_path = "{}/{}/total_time.txt".format(input_dir, project)

    with open(total_time_path) as f:
        first_line = f.readline()

    value = int(first_line.strip())

    pr_file.write("{},{},{}\n".format(project, "facebook", value))

pr_file.close()