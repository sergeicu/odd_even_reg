# a function that splits a volume into odd-even components and register them together
reg_odd_even() {

    # input volume 
    vol_index=$1

    # prints which volume we are registering 
    c=$(printf "%04d" $vol_index)
    echo Volume $c

    # reorder slices correctly based on .json file 
    python reorder_slices.py data/vol_${c}.nii.gz 

    # run anim non rigid registration 
    docker run --rm -v $PWD/data/:/data sergeicu/anima sh -c "/anima/animaDenseSVFBMRegistration --sp 1 --bs 3 -o /data/vol_${c}_even_to_odd.nii.gz -r /data/vol_${c}_odd_lin.nii.gz -m /data/vol_${c}_even_lin.nii.gz > /data/log_anima_${c}_e_o.log 2>&1"

    # average 
    python add.py data/vol_${c}_odd_lin.nii.gz data/vol_${c}_even_to_odd.nii.gz -o data/vol_${c}_lin_odd_even_merged.nii.gz 

    # log success 
    echo "Created output file data/vol_${c}_lin_odd_even_merged.nii.gz " > data/FINISHED_VOL_${c}.log
}



# run this function for ALL volumes
    # currently it loops for 10 volumes (from 0 to 9)
    # volumes should be labelled as 'vol_XXXX.nii.gz', where X is a number. 
    # input files will be placed in 'data' directory, 
    # output files will be called 'vol_XXXX_lin_odd_even_merged.nii.gz'
for i in {0..9} 
do
    c=$(printf "%04d" $i)
    echo $c
    reg_odd_even $i data/log_anima_${c}_e_o.log 2>&1  & # run for volume 
done 




