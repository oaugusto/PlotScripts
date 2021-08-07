#! /usr/bin/env python

import sys
import os
import numpy

projects = ["displaynet", "splaynet", "simplenet", "optnet"]

input_dir = "../../../Data/facebook"
output_file = "../../csv_data/facebook/work_cdf.csv"

pr_file = open(output_file, "w")
pr_file.write("project,value\n")

for project in projects:        
            
    rot_path = "{}/{}/rotations_per_splay.txt".format(input_dir, project)
    rou_path = "{}/{}/routing_per_splay.txt".format(input_dir, project)

    with open(rot_path) as f:
        content = f.readlines()

    rotations = [int(x.strip()) for x in content]
        
    with open(rou_path) as f:
        content = f.readlines()

    routing = [int(x.strip()) for x in content]
        
    work = [x + y for x, y in zip(rotations, routing)]
       
    for value in work:
        pr_file.write("{},{}\n".format(project, value))

pr_file.close()