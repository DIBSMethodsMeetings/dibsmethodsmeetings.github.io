#!/bin/sh

# This is an example shell script located on the Munin server 
# and demonstrates a few simple functionalities.  

# call MATLAB to run example2.m in desktop mode
matlab -r "example2"

# call MATLAB to run example2.m in terminal mode
matlab -nodesktop -r "example2"

# # if another version of MATLAB is preferred, specify its path
# /usr/local/packages/MATLAB/R2021a/bin/matlab -nodesktop -r "example2"
