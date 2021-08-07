#! /usr/bin/env python

import sys
import os
import numpy

projects = ["displaynet", "splaynet"]

input_dir = "../../../Data/facebook"
output_file = "../../csv_data/facebook/cluster.csv"

pr_file = open(output_file, "w")
pr_file.write("project,value\n")

for project in projects:
    cluster_path = "{}/{}/clusters.txt".format(input_dir, project)
    
    with open(cluster_path) as f:
        content = f.readlines()

    content = [int(x.strip()) for x in content]
    
    for value in content:
        pr_file.write("{},{}\n".format(project, value))
        
pr_file.close()