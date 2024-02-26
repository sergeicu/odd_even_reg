# splits a volume into odd-even components and register them together
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
}



# run this function in parallel on ALL available volumes on any machines that are ubuntu - ganymede, io, eurus, coffee, izmir, gamakichi, rayan 
for i in {1..9} 
do
    c=$(printf "%04d" $i)
    echo $c
    reg_odd_even $i data/log_anima_${c}_e_o.log 2>&1  & # register  
done 




