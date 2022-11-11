#!/bin/sh

#declare variables
EXPERIMENT=MemCFT.01

for SUB in 1 2 3 4 5 6 7 8 9 10 11 12 13; 
do  
	for SESS in 1 2;
	do
		#submit jobs with variables (needs to be comma separated without spaces), followed by shell script name
		qsub -v "EXPERIMENT=$EXPERIMENT,SUB=$SUB,SESS=$SESS" example3.sh
		curr_job="job submitted for sub-${SUB} sess-${SESS}"
		echo $curr_job
	done
done
