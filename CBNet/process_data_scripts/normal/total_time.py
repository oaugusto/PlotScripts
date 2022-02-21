#! /usr/bin/env python

import sys
import os
import numpy

projects = ["cbnet", "cbnetAdapt", "seqcbnet", "displaynet", "splaynet"]
numberOfNodes = [128, 1024]
std_sim = [0.2, 0.8, 1.6, 3.2, 6.4]
numberOfSimulations = 1

input_dir = "../../../Data/normal"
output_file = "../../csv_data/normal/total_time.csv"

pr_file = open(output_file, "w")
pr_file.write("project,size,std_par,mean,std\n")

for project in projects:
    for n in numberOfNodes:
        for s in std_sim:
        
            time = []

            for i in range(1, numberOfSimulations + 1):
                total_time_path = "{}/{}/{}/{}/1/total_time.txt".format(input_dir, project, n, s)

                with open(total_time_path) as f:
                    first_line = f.readline()

                content = int(first_line.strip())
                time.append(content)


            m = numpy.mean(time)
            std = numpy.std(time)
            pr_file.write("{},{},{},{},{}\n".format(project, n, s, m, std))

pr_file.close()