#! /usr/bin/env python

import sys
import os
import numpy

projects = ["cbnet", "seqcbnet", "displaynet", "splaynet"]
numberOfNodes = [128, 1024]
std_sim = [0.2, 0.8, 1.6, 3.2, 6.4]
numberOfSimulations = 1

input_dir = "../../../Data/normal"
output_file = "../../csv_data/normal/cluster.csv"

pr_file = open(output_file, "w")
pr_file.write("project,size,std,value\n")

for project in projects:
    for n in numberOfNodes:
        for s in std_sim:
            cluster_path = "{}/{}/{}/{}/1/clusters.txt".format(input_dir, project, n, s)
            
            with open(cluster_path) as f:
                content = f.readlines()

            content = [int(x.strip()) for x in content]
            
            for value in content:
                pr_file.write("{},{},{},{}\n".format(project, n, s, value))
        
pr_file.close()