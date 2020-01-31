#! /usr/bin/env python

import sys
import os
import numpy

projects = ["displaynet", "splaynet", "simplenet", "optnet"]
numberOfNodes = [128, 256, 512, 1024]
numberOfSimulations = 10

x = [0.2, 0.4, 0.8, 1]
y = [0.2, 0.4, 0.8, 1]

input_dir = "../../../Data/bursty"
output_file = "../../csv_data/bursty/work_cdf.csv"

pr_file = open(output_file, "w")
pr_file.write("project,x,y,size,value\n")

for idx_1 in x:
    for idx_2 in y:
        for project in projects:
            for n in numberOfNodes:        
                for i in range(1, numberOfSimulations + 1):
                        
                    rot_path = "{}/{}-{}/{}/{}/{}/rotations_per_splay.txt".format(input_dir, idx_1, idx_2, project, n, i)
                    rou_path = "{}/{}-{}/{}/{}/{}/routing_per_splay.txt".format(input_dir, idx_1, idx_2, project, n, i)

                    with open(rot_path) as f:
                        content = f.readlines()

                    rotations = [int(x.strip()) for x in content]
                    
                    with open(rou_path) as f:
                        content = f.readlines()

                    routing = [int(x.strip()) for x in content]
                    
                    work = [x + y for x, y in zip(rotations, routing)]
                
                    for value in work:
                        pr_file.write("{},{},{},{},{}\n".format(project, idx_1, idx_2, n, value))


pr_file.close()