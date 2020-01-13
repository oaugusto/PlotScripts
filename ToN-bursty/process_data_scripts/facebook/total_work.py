#! /usr/bin/env python

import sys
import os
import numpy
import math

projects = ["displaynet", "splaynet", "simplenet", "optnet"]

input_dir = "../../../Data/facebook"
output_file = "../../csv_data/facebook/total_work.csv"

pr_file = open(output_file, "w")
pr_file.write("project,work\n")

for project in projects:
    
    rot_path = "{}/{}/rotations_per_splay.txt".format(input_dir, project)
    rou_path = "{}/{}/routing_per_splay.txt".format(input_dir, project)

    with open(rot_path) as f:
        content = f.readlines()

    content = [int(x.strip()) for x in content]
    rotations = sum(content)

    with open(rou_path) as f:
        content = f.readlines()
                
    content = [int(x.strip()) for x in content]
    routing = sum(content)
            
    total = rotations + routing

    pr_file.write("{},{}\n".format(project, total))

pr_file.close()