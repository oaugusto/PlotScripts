#! /usr/bin/env python

import sys
import os
import numpy
import math

#projects = ["cbnet", "cbnetAdapt", "seqcbnet", "displaynet", "splaynet", "simplenet", "optnet"]
projects = ["cbnet", "rand2", "rand4", "rand8", "rand16", "semisplaynet", "simplenet", "optnet"]
numberOfNodes = [128, 256, 512, 1024]
std_sim = [0.2, 0.8, 1.6, 3.2, 6.4]
numberOfSimulations = 10

input_dir = "../../../Data/normal"
output_file = "../../csv_data/normal/total_work.csv"

pr_file = open(output_file, "w")
pr_file.write("project,size,std_par,operation,mean,std\n")

for project in projects:
    for n in numberOfNodes:
        for s in std_sim:
            rotation = []
            routing = []

            for i in range(1, numberOfSimulations + 1):
                rot_path = "{}/{}/{}/{}/1/rotations_per_splay.txt".format(input_dir, project, n, s)
                rou_path = "{}/{}/{}/{}/1/routing_per_splay.txt".format(input_dir, project, n, s)

                with open(rot_path) as f:
                    content = f.readlines()

                content = [int(x.strip()) for x in content]
                rotation.append(sum(content))

                with open(rou_path) as f:
                    content = f.readlines()
                    
                content = [int(x.strip()) for x in content]
                routing.append(sum(content))

            m = numpy.mean(rotation)
            std = numpy.std(rotation)
            pr_file.write("{},{},{},{},{},{}\n".format(project, n, s, "rotation", m, std))

            m = numpy.mean(routing)
            std = numpy.std(routing)
            pr_file.write("{},{},{},{},{},{}\n".format(project, n, s, "routing", m, std))
            
            total = [x + y for x, y in zip(rotation, routing)]
            m = numpy.mean(total)
            std = numpy.std(total)
            pr_file.write("{},{},{},{},{},{}\n".format(project, n, s, "total", m, std))
            
            
pr_file.close()