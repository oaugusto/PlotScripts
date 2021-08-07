#! /usr/bin/env python

import sys
import os
import numpy
import math

projects = ["displaynet", "splaynet"]

input_dir = "../../../Data/facebook"
output_file = "../../csv_data/facebook/total_time.csv"

pr_file = open(output_file, "w")
pr_file.write("project,work\n")

for project in projects:
    
    total_time_path = "{}/{}/total_time.txt".format(input_dir, project)

    with open(total_time_path) as f:
        first_line = f.readline()

    time = int(first_line.strip())

    pr_file.write("{},{}\n".format(project, time))

pr_file.close()