# odd_even_reg

Run install.sh, then see example.sh 


Important:  
```
    # 3D volumes should be labelled as 'vol_XXXX.nii.gz', where X is a number. 
    # 3D volumes must be placed in 'data' directory, 
    # 3D output files will be called 'vol_XXXX_lin_odd_even_merged.nii.gz' in 'data' directory
    # change the counter in example.sh to loop through ALL volumes - 
        currently it only grabs the first 10 files - "for i in {0..9} "
```