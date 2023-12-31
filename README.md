# Photogrammetric Computer Vision: Affine Deformation

## Overview
This project focuses on the geometric alignment of distorted greyscale images using affine deformation models in photogrammetric computer vision.

## Objective
The goal is to re-align distorted images to their original state using grey value differences.

## Methodology
- **Affine Transformation**: Applied to a small, well-textured greyscale image.
- **Least Squares Correlation**: Implemented in Octave/MATLAB, solving linearized inhomogeneous equations.
- **Parameter Analysis**: Comparison of estimated and initial deformation parameters.
- **Testing**: Various target images tested under different iterations and image area sizes.
- **Theory Exploration**: Discussion on least squares matching in stereo matching and 2D affine transformation.

## Results
The project includes an analysis of geometric adjustment effects and parameter estimation accuracy.

## Usage
- `geotrans.m`: For image transformations.
- `gradient.m`: To compute image gradients for correlation functions.

