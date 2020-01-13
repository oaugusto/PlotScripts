#! /usr/bin/env python

import sys
import os
import numpy
import math

projects = ["displaynet", "splaynet", "simplenet", "optnet"]
numberOfNodes = [128, 1024]
std_sim = [0.2, 0.8, 1.6, 3.2, 6.4]
numberOfSimulations = 1

input_dir = "../../raw_data/normal"
output_file = "../../csv_data/normal/total_work.csv"

pr_file = open(output_file, "w")
pr_file.write("project,size,std_par,mean,std\n")

for project in projects:
    for n in numberOfNodes:
        for s in std_sim:
            
            work = []

            for i in range(1, numberOfSimulations + 1):
                rot_path = "{}/{}/{}/{}/rotations_per_splay.txt".format(input_dir, project, n, s)
                rou_path = "{}/{}/{}/{}/routing_per_splay.txt".format(input_dir, project, n, s)

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
            pr_file.write("{},{},{},{},{}\n".format(project, n, s, m, std))


pr_file.close()