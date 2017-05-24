# Introduction

This repository includes bash scripts that use [Generic Mapping Tools (Wessel et al., 2013)](http://gmt.soest.hawaii.edu/projects/gmt) to plot teconic velocities and parameters of strain tensors

<!-- [![Build Status](https://api.travis-ci.org/kks32/phd-thesis-template.svg)](https://travis-ci.org/kks32/phd-thesis-template) -->
[![License GPL-3.0](http://img.shields.io/badge/license-GPL-brightgreen.svg)](LICENSE)
[![Version](http://img.shields.io/badge/version-1.0-brightgreen.svg)](https://github.com/demanasta/gpsvel/releases/latest)

----------
**main scripts**

 1. gpsvelstr.sh : plots velocities and parameters of strain tensor

**input files**

 1. default-param : default parameters for paths, input files and region configuration
 2. input file for velocities (example test.vel)
 3. input file for strain tensor (test.str)

# Documentation


 - Be sure that gmt is installed on your computer
 - Configure file *default-param*.

If you'd like to use topography, you can download world DEM from [here](https://www.ngdc.noaa.gov/mgg/global/global.html)

```
# //////////////////
# Set PATHS parameters
pth2dems=${HOME}/Map_project/dems
inputTopoL=${pth2dems}/ETOPO1_Bed_g_gmt4.grd
inputTopoB=${pth2dems}/ETOPO1_Bed_g_gmt4.grd
pth2logos=$HOME/Map_project/logos
pth2faults=$HOME/Map_project/faults/NOAFaults_v1.0.gmt

#///////////////////
# Set default REGION for GREECE
west=19
east=30.6
south=33
north=42
projscale=6000000
frame=2

# ////////////////////////////////////////////////////////////////
# scale position parameters for velocities
vsclon=20.2 
vsclat=34 
vscmagn=20

VSC=0.05
STRSC=50
strsclon=20.2
strsclat=34


```
For main script help function run:
```
  $> ./gpsvelstr.sh -h 
``` 
**INPUT FILES**
 - input file for velocitiew, use mm for velocities and uncertenties
```
code lat lon alt vN svN vE svE vU svU
```
 - input file for straintensor parameters, K in μstrain and Az in degrees
```
code lat lon Kmax sKmax Kmin sKmin Az sAz E sE gtot sgtot
```
(do not use a seperator!)



**MAIN SCRIPT: gpsvelstr.sh**
---------------

**MAIN OPTIONS**

 Usage   : plot_eq.sh -r west east south north projscale frame| -topo | -o [output] | -jpg

 - r      [:= region] region to plot west east south north (default Greece) use: -r west east south north projscale frame
 - mt     [:= map title] title map default none use quotes
 - topo   [:= topography] use DEM topography
 - faults [:= faults] plot NOA fault database
 
**PLOT VELOCITIES**
 - vhor (input_file)[:= horizontal velocities] 
 - vver (input_file)[:= vertical velocities]
 - vsc [:=velocity scale] change vElocity scale default (0.05)

**PLOT STRAIN TENSOR PARAMETERS**
 - str (input file)[:= strains] Plot strain rates
 - strsc [:=strain scale]

**OTHER OPRTIONS**
 - o    [:= output] name of output files
 - l    [:=labels] plot labels
 - leg  [:=legend] insert legends
 - logo [:=logo] plot logo
 - jpg : convert eps file to jpg
 - h    [:= help] help menu
 

 Exit Status:    1 -> help message or error
 Exit Status: >= 0 -> sucesseful exit

## Example:
```
$ ./gpsvelstr.sh -topo -faults -jpg -logo
```
![Example1](https://raw.githubusercontent.com/demanasta/gpsvel/master/Example1.jpg)

plot velocity test file

```
$ ./gpsvelstr.sh  -jpg -topo -vhor test.vel -logo
```
![Example 2](https://raw.githubusercontent.com/demanasta/gpsvel/master/Example2.jpg)

plot strain rates from test file

```
$ ./gpsvelstr.sh -jpg -topo -str test.str -logo
```
![Example 3](https://raw.githubusercontent.com/demanasta/gpsvel/master/Example3.jpg)
----------


# Updates

- 20 Jan 2016: First release gpsvelstr script.

# References

Ganas Athanassios, Oikonomou Athanassia I., and Tsimi Christina, 2013. NOAFAULTS: a digital database for active faults in Greece. Bulletin of the Geological Society of Greece, vol. XLVII and Proceedings of the 13th International Congress, Chania, Sept. 2013.

Wessel, P., W. H. F. Smith, R. Scharroo, J. F. Luis, and F. Wobbe, Generic Mapping Tools: Improved version released, EOS Trans. AGU, 94, 409-410, 2013.

# Contact

Demitris Anastasiou, danast@mail.ntua.gr

Xanthos Papanikolaou, xanthos@mail.ntua.gr


