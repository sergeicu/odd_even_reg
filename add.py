import nibabel as nib
import numpy as np
import argparse 

def add_nifti_files(filenames, output_filename):
    sum_image = None
    
    for filename in filenames:
        img = nib.load(filename)
        img_data = img.get_fdata()
        
        if sum_image is None:
            sum_image = np.zeros_like(img_data)
        
        sum_image += img_data
        
    sum_image /= len(filenames)
    
    sum_img_nifti = nib.Nifti1Image(sum_image, img.affine)
    nib.save(sum_img_nifti, output_filename)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Add multiple NIfTI files together.')
    parser.add_argument('filenames', nargs='+', help='Filenames of NIfTI files to add')
    parser.add_argument('-o', '--output', default='summed_image.nii.gz', help='Output filename')
    
    args = parser.parse_args()
    
    add_nifti_files(args.filenames, args.output)

