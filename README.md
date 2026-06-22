# Single-View Metric Reconstruction of a Cylindrical Vault 🏛️📷

[![MATLAB](https://img.shields.io/badge/MATLAB-Image%20Processing-blue.svg)]()
[![Geometry](https://img.shields.io/badge/Math-Single--View%20Geometry-success.svg)]()

## Overview
This repository contains a complete pipeline for extracting structural geometric information from a single uncalibrated photograph[cite: 2]. The project focuses on applying single-view geometry tools to estimate the camera's intrinsic parameters, rectify a vertical plane affected by projective distortion, and mathematically reconstruct a portion of a cylindrical vault[cite: 2]. 

All computations rely solely on geometric cues visible within the image, such as known orthogonal architectural directions, vanishing points, and the regularity of the cylindrical structure[cite: 2]. 

## ✨ Key Features
* **Feature Extraction**: Implements Canny edge detection and the Hough transform to identify strong structural elements like columns, cornices, and ribs while suppressing noise[cite: 2].
* **Vanishing Point & Line Computation**: Estimates three mutually orthogonal vanishing points (vertical, white horizontal, and cylinder axis directions) to construct the vanishing line at infinity[cite: 2].
* **Intrinsic Camera Calibration**: Calculates the Image of the Absolute Conic (IAC) using zero-skew assumptions and orthogonal scene directions to estimate the camera's focal length and principal point[cite: 2].
* **Affine & Metric Rectification**: Computes rectifying homographies to remove projective distortion from vertical planes, upgrading the image to Euclidean geometry up to a global similarity[cite: 2].
* **Metric 3D Reconstruction**: Fits a circular section to the structural diagonal arcs of the vault and uses Ray-Cylinder intersections to project metric coordinates[cite: 2].

## 🛠️ Pipeline Architecture
The MATLAB script (`main_vault.m`) runs the following processing steps[cite: 2]:

1. **Input Normalization**: Converts the original image (`SanMaurizio.jpg`) to a double precision grayscale format[cite: 2].
2. **Line Detection**: Extracts structural straight lines using Canny edge maps and the Hough transform[cite: 2].
3. **Manual Geometric Selection**: Allows the user to select specific architectural lines corresponding to the vertical, horizontal, and axis-parallel families[cite: 2].
4. **Projective-to-Euclidean Upgrade**: Computes the homographies ($H_A$ and $H_R$) to warp the targeted plane into a fronto-parallel view[cite: 2].
5. **Scale Fixing & Pose Estimation**: Scales the reconstruction using a known metric distance (e.g., adjacent diagonal arcs distance $d=1$) and computes the camera rotation matrix relative to the scene[cite: 2].

## 📊 Summary of Extracted Geometric Data
By running the pipeline on the sample image, the system successfully extracts[cite: 2]:
* Estimated Intrinsic Matrix ($K$)[cite: 2].
* World-to-Camera Rotation Matrix ($R_{cw}$)[cite: 2].
* Metric properties of the vault, including the circular arc center and radius ($R \approx 2.3667$ units)[cite: 2].

## 📦 Requirements
* **MATLAB** (Tested on recent releases)
* Image Processing Toolbox (for `edge`, `hough`, `imwarp`, `projective2d`)
