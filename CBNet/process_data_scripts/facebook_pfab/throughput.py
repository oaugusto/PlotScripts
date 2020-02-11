#! /usr/bin/env python

import sys
import os
import numpy

output_file = "../../csv_data/facebook_pfab/throughput.csv"

pr_file = open(output_file, "w")
pr_file.write("project,dataset,value\n")

projects = ["cbnet", "seqcbnet", "displaynet", "splaynet"]
datasets = ["trace_0_1", "trace_0_5", "trace_0_8"]

input_dir = "../../../Data/pfab"

for project in projects:
    for dataset in datasets:
        cluster_path = "{}/{}/{}/throughput.txt".format(input_dir, project, dataset)
        
        with open(cluster_path) as f:
            content = f.readlines()

        content = [int(x.strip()) for x in content]
        
        for value in content:
            pr_file.write("{},{},{}\n".format(project, dataset, value))
        
projects = ["cbnet", "seqcbnet", "displaynet", "splaynet"]
input_dir = "../../../Data/facebook"

for project in projects:
    cluster_path = "{}/{}/throughput.txt".format(input_dir, project)
    
    with open(cluster_path) as f:
        content = f.readlines()

    content = [int(x.strip()) for x in content]
    
    for value in content:
        pr_file.write("{},{},{}\n".format(project, "facebook", value))
            
pr_file.close()