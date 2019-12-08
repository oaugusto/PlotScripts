#! /usr/bin/env python

import sys
import os
import numpy
import math

projects = ["displaynet", "splaynet", "simplenet", "optnet"]
numberOfNodes = [128, 256, 512, 1024]
numberOfSimulations = 30

input_dir = "../../../Data/projector"
output_file = "../../csv_data/projector/total_work.csv"

pr_file = open(output_file, "w")
pr_file.write("project,size,mean,std\n")

for project in projects:
    for n in numberOfNodes:
        
        work = []

        for i in range(1, numberOfSimulations + 1):
            rot_path = "{}/{}/{}/{}/rotations_per_splay.txt".format(input_dir, project, n, i)
            rou_path = "{}/{}/{}/{}/routing_per_splay.txt".format(input_dir, project, n, i)

            with open(rot_path) as f:
                content = f.readlines()

            content = [int(x.strip()) for x in content]
            rotations = sum(content)

            with open(rou_path) as f:
                content = f.readlines()
                
            content = [int(x.strip()) for x in content]
            routing = sum(content)
            
            total = rotations + routing
            work.append(total)


        m = numpy.mean(work)
        std = numpy.std(work)
        pr_file.write("{},{},{},{}\n".format(project, n, m, std))

pr_file.close()