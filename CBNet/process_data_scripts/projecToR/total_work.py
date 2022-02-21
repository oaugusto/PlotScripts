#! /usr/bin/env python

import sys
import os
import numpy
import math

projects = ["cbnet", "rand2", "rand4", "rand8", "rand16", "semisplaynet", "simplenet", "optnet"]
#projects = ["cbnet", "seqopticalnet2048", "opticalnet2048", "simplenet", "optnet"]
#projects = ["cbnet", "splaynet", "displaynet", "simplenet", "optnet"]
#projects = ["cbnet", "cbnetAdapt", "seqcbnet", "displaynet", "splaynet", "simplenet", "optnet"]
#numberOfNodes = [128, 1024]
numberOfNodes = [128, 256, 512, 1024]
#numberOfSimulations = 1
numberOfSimulations = 10

input_dir = "../../../Data/projector/newTor"
output_file = "../../csv_data/projector/total_work.csv"

pr_file = open(output_file, "w")
pr_file.write("project,size,operation,mean,std\n")

for project in projects:
    for n in numberOfNodes:
        
        rotation = []
        routing = []

        for i in range(1, numberOfSimulations + 1):
            rot_path = "{}/{}/{}/{}/rotations_per_splay.txt".format(input_dir, project, n, i)
            rou_path = "{}/{}/{}/{}/routing_per_splay.txt".format(input_dir, project, n, i)

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
        pr_file.write("{},{},{},{},{}\n".format(project, n, "rotation", m, std))

        m = numpy.mean(routing)
        std = numpy.std(routing)
        pr_file.write("{},{},{},{},{}\n".format(project, n, "routing", m, std))
        
        total = [x + y for x, y in zip(rotation, routing)]
        m = numpy.mean(total)
        std = numpy.std(total)
        pr_file.write("{},{},{},{},{}\n".format(project, n, "total", m, std))

pr_file.close()
