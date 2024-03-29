#! /usr/bin/env python

import sys
import os
import numpy

#projects = ["cbnet", "cbnetAdapt", "seqcbnet", "displaynet", "splaynet"]
projects = ["cbnet", "rand2", "rand4", "rand8", "rand16", "semisplaynet"]
numberOfNodes = [128, 256, 512, 1024]
numberOfSimulations = 1

input_dir = "../../../Data/projector/newTor"
output_file = "../../csv_data/projector/throughput.csv"

pr_file = open(output_file, "w")
pr_file.write("project,size,value\n")

for project in projects:
    for n in numberOfNodes:
        cluster_path = "{}/{}/{}/{}/throughput.txt".format(input_dir, project, n, numberOfSimulations)
        
        with open(cluster_path) as f:
            content = f.readlines()

        content = [int(x.strip()) for x in content]
        
        for value in content:
            pr_file.write("{},{},{}\n".format(project, n, value))
        
pr_file.close()