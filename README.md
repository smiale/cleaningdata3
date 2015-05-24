# Getting and Cleaning Data Course Project Readme

There's only one script here, run_analysis.R. It was developed under Windows, but should run
on any OS. The ZIP file is downloaded into a temporary file and unzip'ed in place using unz.

Library dependencies include: data.table, plyr, reshape2

Note that the script has not been optimized, it was developed to meet the specifications
outlined in the project requirements; there's no doubt that it could be made faster but
performance is not an explicit requirement. I've tried to focus on readibility (e.g.
gradeability) instead.

Simply running the script by itself should do the operation and result in the data being
retrieved from the server, processed in a series of steps in the script, and output into
a variable called tidy_data before being written into 'gacCourseProject.txt'

Tidy_data in this case is long form.

