import sys
import os
import shutil

# copy every .png from ../qualitative and ../quantitative to . using os.walk
def copy_files(src, dst):
    for root, dirs, files in os.walk(src):
        for file in files:
            if file.endswith(".png"):
                src_file = os.path.join(root, file)
                dst_file = os.path.join(dst, file)
                print("Copying {} to {}".format(src_file, dst_file))
                shutil.copy(src_file, dst_file)
                # os.system("cp {} {}".format(src_file, dst_file))
    
copy_files("../qualitative", ".")
copy_files("../quantitative", ".")
                
