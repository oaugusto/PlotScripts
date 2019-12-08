#! /usr/bin/env python

import sys
import os
import numpy
import math

projects = ["cbnet", "displaynet", "splaynet", "simplenet", "optnet"]
datasets = ["cesar_mocfe", "cesar_nekbone", "cns_nospec", "multigrid"]

input_dir = "../../../Data/hpc"
output_file = "../../csv_data/hpc/total_work.csv"

pr_file = open(output_file, "w")
pr_file.write("project,dataset,operation,value\n")

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

pr_file.close()