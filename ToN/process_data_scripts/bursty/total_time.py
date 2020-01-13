#! /usr/bin/env python

import sys
import os
import numpy

projects = ["displaynet", "splaynet"]
numberOfNodes = [128, 256, 512, 1024]
numberOfSimulations = 30

input_dir = "../../../Data/bursty"
output_file = "../../csv_data/bursty/total_time.csv"

pr_file = open(output_file, "w")
pr_file.write("project,size,mean,std\n")

for project in projects:
    for n in numberOfNodes:
        
        time = []

        for i in range(1, numberOfSimulations + 1):
            total_time_path = "{}/{}/{}/{}/total_time.txt".format(input_dir, project, n, i)

            with open(total_time_path) as f:
                first_line = f.readline()

            content = int(first_line.strip())
            time.append(content)


        m = numpy.mean(time)
        std = numpy.std(time)
        pr_file.write("{},{},{},{}\n".format(project, n, m, std))

pr_file.close()