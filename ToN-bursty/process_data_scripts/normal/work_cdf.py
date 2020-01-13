#! /usr/bin/env python

import sys
import os
import numpy

projects = ["displaynet", "splaynet", "simplenet", "optnet"]
numberOfNodes = [128, 1024]
std_sim = [0.2, 0.8, 1.6, 3.2, 6.4]
numberOfSimulations = 1

input_dir = "../../raw_data/normal"
output_file_rot = "../../csv_data/normal/work_cdf.csv"

pr_file = open(output_file_rot, "w")
pr_file.write("project,size,std,value\n")

for project in projects:        
    for n in numberOfNodes:
        for s in std_sim:
            for i in range(1, numberOfSimulations + 1):
                    
                rot_path = "{}/{}/{}/{}/rotations_per_splay.txt".format(input_dir, project, n, s)
                rou_path = "{}/{}/{}/{}/routing_per_splay.txt".format(input_dir, project, n, s)

                with open(rot_path) as f:
                    content = f.readlines()

                rotations = [int(x.strip()) for x in content]
            
                with open(rou_path) as f:
                    content = f.readlines()

                routing = [int(x.strip()) for x in content]
            
                work = [x + y for x, y in zip(rotations, routing)]

                for value in work:
                    pr_file.write("{},{},{},{}\n".format(project, n, s, value))
        

pr_file.close()