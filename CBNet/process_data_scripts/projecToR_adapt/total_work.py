#! /usr/bin/env python

import sys
import os
import numpy
import math

projects = ["cbnet", "cbnetAdapt30", "cbnetAdapt100", "cbnetAdapt500", "cbnetAdapt1000", "displaynet", "simplenet", "optnet"]
datasets = [2, 4]
#datasets = [1, 2, 4]

input_dir = "../../../Data/projector_adapt"
output_file = "../../csv_data/projector_adapt/total_work.csv"

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

        pr_file.write("{},ProjecToR x{},{},{}\n".format(project, dataset, "rotation", rotation))
        pr_file.write("{},ProjecToR x{},{},{}\n".format(project, dataset, "routing", routing))

pr_file.close()