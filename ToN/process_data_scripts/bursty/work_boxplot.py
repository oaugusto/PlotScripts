#! /usr/bin/env python

import sys
import os
import numpy

projects = ["displaynet"]
numberOfNodes = [128, 256, 512, 1024]
numberOfSimulations = 1

x = [0.2, 0.4, 0.8, 1]
y = [0.2, 0.4, 0.8, 1]

input_dir = ["bursty", "bursty_new"]
output_file = "../../csv_data/bursty/work_boxplot.csv"

pr_file = open(output_file, "w")
pr_file.write("project,x,y,size,value\n")

for inp in input_dir:
    for idx_1 in x:
        for idx_2 in y:
            for project in projects:
                for n in numberOfNodes:
                    cluster_path = "{}/{}-{}/{}/{}/{}/rotations_per_splay.txt".format("../../../Data/" + inp, idx_1, idx_2, project, n, numberOfSimulations)
                    
                    with open(cluster_path) as f:
                        content = f.readlines()

                    content = [int(x.strip()) for x in content]
                    
                    for value in content:
                        pr_file.write("{},{},{},{},{}\n".format(inp, idx_1, idx_2, n, value))
        
pr_file.close()