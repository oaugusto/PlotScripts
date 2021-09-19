#! /usr/bin/env python

import sys
import os
import numpy

projects = ["cbnet", "cbnetAdapt30", "cbnetAdapt100", "cbnetAdapt500", "cbnetAdapt1000", "displaynet"]
datasets = [1, 2, 4]

input_dir = "../../../Data/projector_adapt"
output_file = "../../csv_data/projector_adapt/throughput.csv"

pr_file = open(output_file, "w")
pr_file.write("project,dataset,value\n")

for project in projects:
    for dataset in datasets:
        cluster_path = "{}/{}/{}/throughput.txt".format(input_dir, project, dataset)
        
        with open(cluster_path) as f:
            content = f.readlines()

        content = [int(x.strip()) for x in content]
        
        for value in content:
            pr_file.write("{},{},{}\n".format(project, dataset, value))
        
pr_file.close()