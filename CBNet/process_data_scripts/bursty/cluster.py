#! /usr/bin/env python

import sys
import os
import numpy

projects = ["cbnet", "cbnetAdapt", "seqcbnet", "displaynet", "splaynet"]
numberOfNodes = [128, 256, 512, 1024]
numberOfSimulations = 1

#x = [0.2, 0.4, 0.8, 1]
#y = [0.2, 0.4, 0.8, 1]
x = [0.4]
y = [1]

input_dir = "../../../Data/bursty"
output_file = "../../csv_data/bursty/cluster.csv"

pr_file = open(output_file, "w")
pr_file.write("project,x,y,size,value\n")

for idx_1 in x:
    for idx_2 in y:
        for project in projects:
            for n in numberOfNodes:
                cluster_path = "{}/{}-{}/{}/{}/{}/clusters.txt".format(input_dir, idx_1, idx_2, project, n, numberOfSimulations)
                
                with open(cluster_path) as f:
                    content = f.readlines()

                content = [int(x.strip()) for x in content]
                
                for value in content:
                    pr_file.write("{},{},{},{},{}\n".format(project, idx_1, idx_2, n, value))
        
pr_file.close()