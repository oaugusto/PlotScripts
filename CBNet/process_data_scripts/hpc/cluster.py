#! /usr/bin/env python

import sys
import os
import numpy

projects = ["cbnet", "cbnetAdapt", "seqcbnet", "displaynet", "splaynet"]
datasets = ["cesar_mocfe", "cesar_nekbone", "cns_nospec", "multigrid"]

input_dir = "../../../Data/hpc"
output_file = "../../csv_data/hpc/cluster.csv"

pr_file = open(output_file, "w")
pr_file.write("project,dataset,value\n")

for project in projects:
    for dataset in datasets:
        cluster_path = "{}/{}/{}/clusters.txt".format(input_dir, project, dataset)
        
        with open(cluster_path) as f:
            content = f.readlines()

        content = [int(x.strip()) for x in content]
        
        for value in content:
            pr_file.write("{},{},{}\n".format(project, dataset, value))
        
pr_file.close()