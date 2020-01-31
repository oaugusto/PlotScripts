#! /usr/bin/env python

import sys
import os
import numpy
import math

output_file = "../../csv_data/facebook_pfab/total_work.csv"

pr_file = open(output_file, "w")
pr_file.write("project,dataset,operation,value\n")

projects = ["cbnet", "displaynet", "splaynet", "simplenet", "optnet"]
datasets = ["trace_0_1", "trace_0_5", "trace_0_8"]

input_dir = "../../../Data/pfab"

for project in projects:
    for dataset in datasets:
        
        rot_path = "{}/{}/{}/rotations_per_splay.txt".format(input_dir, project, dataset)
        rou_path = "{}/{}/{}/routing_per_splay.txt".format(input_dir, project, dataset)

        with open(rot_path) as f:
            content = f.readlines()

        content = [int(x.strip()) for x in content]
        rotation = sum(content)

        with open(rou_path) as f:
            content = f.readlines()
            
        content = [int(x.strip()) for x in content]
        routing = sum(content)

        pr_file.write("{},{},{},{}\n".format(project, dataset, "rotation", rotation))
        pr_file.write("{},{},{},{}\n".format(project, dataset, "routing", routing))
        
        
projects = ["cbnet", "displaynet", "splaynet", "simplenet", "optnet"]
input_dir = "../../../Data/facebook"

for project in projects:
    rot_path = "{}/{}/rotations_per_splay.txt".format(input_dir, project)
    rou_path = "{}/{}/routing_per_splay.txt".format(input_dir, project)

    with open(rot_path) as f:
        content = f.readlines()

    content = [int(x.strip()) for x in content]
    rotation = sum(content)

    with open(rou_path) as f:
        content = f.readlines()
        
    content = [int(x.strip()) for x in content]
    routing = sum(content)

    pr_file.write("{},{},{},{}\n".format(project, "facebook", "rotation", rotation))
    pr_file.write("{},{},{},{}\n".format(project, "facebook", "routing", routing))

pr_file.close()