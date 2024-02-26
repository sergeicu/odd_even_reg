# this is a bash function that splits a volume into odd-even components and register them together
reg_odd_even() {

    # input volume 
    vol_index=$1

    # prints which volume we are registering 
    c=$(printf "%04d" $vol_index)
    echo Processing Volume $c. Output will be called data/vol_${c}_lin_odd_even_merged.nii.gz. Check data/log_anima_${c}_e_o.log for intermediate results.
    echo ""
    echo ""

    # reorder slices correctly for interleaved acquisition
    python reorder_slices.py data/vol_${c}.nii.gz 

    # run anima non rigid registration 
    docker run --rm -v $PWD/data/:/data sergeicu/anima sh -c "/anima/animaDenseSVFBMRegistration --sp 1 --bs 3 -o /data/vol_${c}_even_to_odd.nii.gz -r /data/vol_${c}_odd_lin.nii.gz -m /data/vol_${c}_even_lin.nii.gz > /data/log_anima_${c}_e_o.log 2>&1"

    # average 
    python add.py data/vol_${c}_odd_lin.nii.gz data/vol_${c}_even_to_odd.nii.gz -o data/vol_${c}_lin_odd_even_merged.nii.gz 

}



# run 'reg_odd_even' function for ALL volumes in 'data' directory 
    # volumes should be labelled as 'vol_XXXX.nii.gz', where X is a number. 
    # volumes must be placed in 'data' directory, 
    # output files will be called 'vol_XXXX_lin_odd_even_merged.nii.gz'
    # below we loop through the first 10 volumes (0..9) -> CHANGE it accordingly 
for i in {0..9} 
do
    c=$(printf "%04d" $i)
    reg_odd_even $i  & # run for volume 
done 




