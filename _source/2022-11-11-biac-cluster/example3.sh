#!/bin/sh
 
# --- BEGIN GLOBAL DIRECTIVE --
#$ -S /bin/sh
#$ -o $HOME/$JOB_NAME.$JOB_ID.out
#$ -e $HOME/$JOB_NAME.$JOB_ID.out
#$ -m ea
# -- END GLOBAL DIRECTIVE --
 
# -- BEGIN PRE-USER --
#Name of experiment whose data you want to access
EXPERIMENT=${EXPERIMENT:?"Experiment not provided"}
 
EXPERIMENT=`findexp $EXPERIMENT`
EXPERIMENT=${EXPERIMENT:?"Returned NULL Experiment"}
 
if [ $EXPERIMENT = "ERROR" ]
then
        exit 32
else
#Timestamp
echo "----JOB [$JOB_NAME.$JOB_ID] START [`date`] on HOST [$HOSTNAME]----"
# -- END PRE-USER --
# **********************************************************
 
# -- BEGIN USER DIRECTIVE --
# Send notifications to the following address
#$ -M sh389xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx@duke.edu
 
# -- END USER DIRECTIVE --
 
# -- BEGIN USER SCRIPT --
# User script goes here

OUTDIR=${OUTDIR:-$EXPERIMENT/Scripts/tutorial/example3_output}

cd ${EXPERIMENT}/Scripts/tutorial/
echo "running sub-${SUB} sess-${SESS}"
matlab -nodesktop -nojvm -r "example3(${SUB}, ${SESS})"
echo "completed sub-${SUB} sess-${SESS}"  
 
 
# -- END USER SCRIPT -- #
 
# **********************************************************
# -- BEGIN POST-USER --
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----"
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER--