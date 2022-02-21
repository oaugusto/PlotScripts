#! /usr/bin/env python

import sys
import os
import numpy
import math

#projects = ["cbnet", "cbnetAdapt", "seqcbnet", "displaynet", "splaynet", "simplenet", "optnet"]
projects = ["cbnet", "rand2", "rand4", "rand8", "rand16", "semisplaynet", "simplenet", "optnet"]
numberOfNodes = [128, 256, 512, 1024]
numberOfSimulations = 10

#x = [0.2, 0.4, 0.8, 1]
#y = [0.2, 0.4, 0.8, 1]
x = [1]
y = [0.4]

input_dir = "../../../Data/skewed"
output_file = "../../csv_data/skewed/total_work.csv"

pr_file = open(output_file, "w")
pr_file.write("project,x,y,size,operation,mean,std\n")

for idx_1 in x:
    for idx_2 in y:
        for project in projects:
            for n in numberOfNodes:
                
                rotation = []
                routing = []
   
                for i in range(1, numberOfSimulations + 1):
                    rot_path = "{}/{}-{}/{}/{}/{}/rotations_per_splay.txt".format(input_dir, idx_1, idx_2, project, n, i)
                    rou_path = "{}/{}-{}/{}/{}/{}/routing_per_splay.txt".format(input_dir, idx_1, idx_2, project, n, i)

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
                pr_file.write("{},{},{},{},{},{},{}\n".format(project, idx_1, idx_2, n, "rotation", m, std))

                m = numpy.mean(routing)
                std = numpy.std(routing)
                pr_file.write("{},{},{},{},{},{},{}\n".format(project, idx_1, idx_2, n, "routing", m, std))
        
                total = [x + y for x, y in zip(rotation, routing)]
                m = numpy.mean(total)
                std = numpy.std(total)
                pr_file.write("{},{},{},{},{},{},{}\n".format(project, idx_1, idx_2, n, "total", m, std))

pr_file.close()
