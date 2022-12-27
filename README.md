# ColumnQuantificationCode
Deep Learning Toolbox is necessary. 
'bfmatlab' is necessary to import Zeiss lsm format image files.
https://docs.openmicroscopy.org/bio-formats/5.3.4/users/matlab/index.html
Add 'bfmatlab' folder to your MATLAB path. 
'LSMdata' folder contains lsm format image files. 'nnPCP' folder contains the neural network used for column detection.

Run 'eval_columnPCP_GUI.m' to detect columns. 
From 'Select a neural network', you can slect a neural network. 'net210601_4class_BakNew.mat' is used in the paper.
From 'Select a LSM file', you can slect a lsm format image file. 

'Z section' indicates your location along the Z axis. You can move to the other Z section using the slider. The confocal image along the specified Z section is shown in the right panel. A 3D image through 'Z start' to 'Z end' will be analyzed. 
'ROI' specifies a Region Of Interest indicated by the red color. 'Vertices' specifies the number of vertices to specify the ROI. 

'Detection Threshold' specifies the threshold value used to detect columns. Smaller is more sensitive to detect columns. Default is 0.5. 
'Overlap Threshold' specifies the possible overlap rate between neighboring columns. Larger is more sensitive to detect columns. Default is 0.4.
'Enhance Contrast' specifies the persentage of the saturated pixels. Larger is brighter. Default is 0.3. 

'Magnification' specifies the magnification of the ROI. Default is 1. The magnified ROI image is shown in the image panel at the bottom in an actual size. You may change magnification to adjust the magnified ROI image with the reference column images shown in the left panels. 
'rot90' rotates the entire image in a counter-clockwise manner.

'Fmi channel' specifies the RGB channel that contains Fmi signals to be quantified.
'GFP channel' specifies the RGB channel that contains GFP signals. Not used. 
'Stride' specifies the scanning stride to sequentially crop 32x32 pixel images to be classified according to the CNN. Default is 2 pixels. 

'Run' starts column detection using the CNN. 
'Norm/Gap/Nohole' classifies the column images using the CNN. 
'PDratio/Circularity' classifies the column images according to PDratio and calculates Smoothness and Roughness. 

'Save data' save the quantified results in Excel format.
'Save movie' save a movie file showing the Z-series in mp4 format.
