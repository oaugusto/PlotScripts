#! /usr/bin/env python

import sys
import os
import numpy

projects = ["cbnet", "cbnetAdapt", "seqcbnet", "displaynet", "splaynet"]
numberOfNodes = [128, 256, 512, 1024]
numberOfSimulations = 10

#x = [0.2, 0.4, 0.8, 1]
#y = [0.2, 0.4, 0.8, 1]
x = [1]
y = [0.4]

input_dir = "../../../Data/skewed"
output_file = "../../csv_data/skewed/total_time.csv"

pr_file = open(output_file, "w")
pr_file.write("project,x,y,size,mean,std\n")

for idx_1 in x:
    for idx_2 in y:
        for project in projects:
            for n in numberOfNodes:
                
                time = []

                for i in range(1, numberOfSimulations + 1):
                    total_time_path = "{}/{}-{}/{}/{}/{}/total_time.txt".format(input_dir, idx_1, idx_2, project, n, i)

                    with open(total_time_path) as f:
                        first_line = f.readline()

                    content = int(first_line.strip())
                    time.append(content)


                m = numpy.mean(time)
                std = numpy.std(time)
                pr_file.write("{},{},{},{},{},{}\n".format(project, idx_1, idx_2, n, m, std))

pr_file.close()
