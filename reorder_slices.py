"""

Usage: 
    python reoder_slices.py vol.nii vol.json    
    
    
Reorders odd and even slices and linearly registers missing data.
We can then (separately) run anima nreg between them to combine them! 

"""

import sys 
import os    
import json
import numpy as np 
import nibabel as nb 
from scipy.interpolate import interpn



def interpolate_missing_slices(image_data, available_slices='even'):
    # Determine whether we are dealing with even or odd slices
    if available_slices == 'even':
        extracted_slices_data = image_data[:, :, ::2]
        original_indices = np.arange(0, extracted_slices_data.shape[2])
    elif available_slices == 'odd':
        extracted_slices_data = image_data[:, :, 1::2]
        original_indices = np.arange(0, extracted_slices_data.shape[2])
    else:
        raise ValueError("Parameter 'available_slices' must be 'even' or 'odd'")

    # Calculate the desired indices, representing all slices, including those to be interpolated
    desired_indices = np.linspace(0, original_indices[-1], image_data.shape[2])

    # Prepare the points and coordinates for interpolation
    x = np.arange(extracted_slices_data.shape[0])
    y = np.arange(extracted_slices_data.shape[1])
    z = original_indices
    points = (x, y, z)

    # Create the full meshgrid (not sparse) for new coordinates. Ensure the grid is made of floats
    X, Y, Z = np.meshgrid(x, y, desired_indices, indexing='ij')
    xi = np.vstack((X.ravel(), Y.ravel(), Z.ravel())).T  # This creates a (n, 3) array of coordinates

    # Perform the interpolation
    interp_slices = interpn(points, extracted_slices_data, xi, method='linear', bounds_error=False, fill_value=0)

    # Reshape the interpolated data to match the original image shape
    interp_slices = interp_slices.reshape(image_data.shape)

    return interp_slices
        
if __name__ == '__main__':
    

    # read input args
    nii=sys.argv[1]
    assert os.path.exists(nii)
    
    # load file 
    imo = nb.load(nii)
    im = imo.get_fdata()
    
    
    # create interleaved slice timing 
    indices= list(range(im.shape[-1]))
    even = indices[0::2]
    odd = indices[1::2]
    slicetiming = even + odd
    
    
    # find index 
    index  = np.argsort(slicetiming)
    assert im.shape[2] == len(index), f"# of slices in nifti does not match the slice ordering"

    
    # reorder 
    if im.ndim == 4:
        #newim = im[:,:,index,:]
        sys.exit("not implemented yet for 3d array - would need to copy all other functionality to this array size")
    elif im.ndim == 3:
        newim = im[:,:,index]
        


    ################## LINEAR INTERPOLATION ##################
    # Interpolate for even slices (use 'odd' for odd slices)
    odd = interpolate_missing_slices(im, available_slices='odd')  # or 'odd'
    even = interpolate_missing_slices(im, available_slices='even')  # or 'odd'
    
    
    # save doubled even and odd 
    ext = ".nii.gz"
    newimo1_exp = nb.Nifti1Image(odd, affine=imo.affine, header=imo.header)
    newimo2_exp = nb.Nifti1Image(even, affine=imo.affine, header=imo.header)
    savename1_exp = nii.replace(ext, "_odd_lin"+ ext)
    savename2_exp = nii.replace(ext, "_even_lin"+ ext)
    nb.save(newimo1_exp, savename1_exp)
    nb.save(newimo2_exp, savename2_exp)
    
    
    
    
    
    