#!/bin/sh

# This is an example shell script located on the Munin server 
# and demonstrates a few simple functionalities.  


# conditional statement
if [ -e example1_output ]
	# if a folder named 'example1_output' exists
then
	# remove directory with contents
    rm -rf example1_output
    
    # make directory named 'example1_output'
    mkdir example1_output

    # print something to terminal
    echo "delete old output dir; create new output dir \n"
fi

# change directory into the output directory
cd example1_output

# for loop: iterating over i = 1 2 3 4 5
for (( i = 1; i < 6; i++ )); 
do
	echo $i
	echo `date`
	echo
done

# print statement to txt file
echo 'test text 12345' >> test.txt

# copy text file
cp test.txt test_copy.txt

# print directory contents
echo `ls`

# get to the parent directory
cd ..
