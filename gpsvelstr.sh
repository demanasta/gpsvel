#!/bin/bash
# //////////////////////////////////////////////////////////////////////////////
# HELP FUNCTION
function help {
	echo "/******************************************************************************/"
	echo " Program Name : gpsvelstr.sh"
	echo " Version : v-0.1"
	echo " Purpose : Plot velocities and strains"
	echo " Default param file: default-param"
	echo " Usage   :gpsvelstr.sh -r west east south north | -topo | -o [output] | -jpg "
	echo " Switches: "
        echo "           -r [:= region] region to plot west east south north (default Greece)"
        echo "                   use: -r west east south north projscale frame"
        echo "           -mt [:= map title] title map default none use quotes"
        echo "           -topo [:= update catalogue] title map default none use quotes"
        echo "           -faults [:= faults] plot NOA fault database"
	echo ""
	echo "/*** PLOT VELOCITIES **********************************************************/"
	echo "           -vhor (gmt_file)[:= horizontal velocities]  "
	echo "           -vver (gmt_file)[:= vertical velocities]  "
# 	echo "           -valign (gmt_file) plot tranverse & along velocities"
	echo ""
# 	echo "/*** PLOT STRAINS **********************************************************/"
# 	echo "           -str [:= strains] Plot strain rates "
# 	echo "           -r [:= rots] Plot rotational rates "
# 	echo "           -dil [:=dilatation] Plot dilatation and principal axes"
# 	echo ""
	echo ""
        echo "/*** OTHER OPRTIONS ************************************************************/"
	echo "           -o [:= output] name of output files"
	echo "           -l [:=labels] plot labels"
        echo "           -leg [:=legend] insert legends"
        echo "           -logo [:=logo] plot logo"
	echo "           -jpg : convert eps file to jpg"
	echo "           -h [:= help] help menu"
	echo " Exit Status:    1 -> help message or error"
	echo " Exit Status: >= 0 -> sucesseful exit"
	echo ""
	echo "run: ./plot_eq.sh -topo -faults -jpg -leg"
	echo "/******************************************************************************/"
	exit 1
}

# //////////////////////////////////////////////////////////////////////////////
# GMT parameters
gmt gmtset MAP_FRAME_TYPE fancy
gmt gmtset PS_PAGE_ORIENTATION portrait
gmt gmtset FONT_ANNOT_PRIMARY 10 FONT_LABEL 10 MAP_FRAME_WIDTH 0.12c FONT_TITLE 18p


# //////////////////////////////////////////////////////////////////////////////
# Pre-defined parameters for bash script
# REGION="greece"
TOPOGRAPHY=0
FAULTS=0
LABELS=0
LOGO=0
OUTJPG=0
LEGEND=0


VHORIZONTAL=0
VVERTICAL=0
# VALIGN=0


##//////////////////check default param
if [ ! -f "default-param" ]
then
	echo "default-param file does not exist"
	exit 1
else
	source default-param
fi


# //////////////////////////////////////////////////////////////////////////////
# GET COMMAND LINE ARGUMENTS
if [ "$#" == "0" ]
then
	help
fi

while [ $# -gt 0 ]
do
	case "$1" in
		-r)
			west=$2
			east=$3
			south=$4
			north=$5
			projscale=$6
			frame=$7
# 			REGION=$2
			shift
			shift
			shift
			shift
			shift
			shift
			shift
			;;
		-vhor)
			pth2vhor=${pth2inptf}/$2
			VHORIZONTAL=1
			shift
			shift
			;;
		-vver)
			pth2vver=${pth2inptf}/$2
			VVERTICAL=1
			shift
			shift
			;;
# 		-valign)
# 			pth2valong=${pth2inptf}/${2}_along.vel
# 			pth2vtranv=${pth2inptf}/${2}_tranv.vel
# 			VALIGN=1
# 			shift
# 			shift
# 			;;
# 		-str)
# 			pth2comp=${pth2inptf}/${2}.comp
# 			pth2ext=${pth2inptf}/${2}.ext
# 			STRAINS=1
# 			shift
# 			shift
# 			;;
		-topo)
#                       switch topo not used in server!
			TOPOGRAPHY=1
			shift
			;;
		-faults)
			FAULTS=1
			shift
			;;	
		-o)
			outfile=${2}.eps
			out_jpg=${2}.jpg
			shift
			shift
			;;
		-l)
			LABELS=1
			shift
			;;
		-leg)
			LEGEND=1
			shift
			;;
		-logo)
			LOGO=1
			shift
			;;
		-jpg)
			OUTJPG=1
			shift
			;;
		-h)
			help
			;;
	esac
done


# //////////////////////////////////////////////////////////////////////////////
# check if files exist

###check dems
if [ "$TOPOGRAPHY" -eq 1 ]
then
	if [ ! -f $inputTopoB ]
	then
		echo "grd file for topography toes not exist, var turn to coastline"
		TOPOGRAPHY=0
	fi
fi

##check inputfiles
if [ "$VHORIZONTAL" -eq 1 ]
then
	if [ ! -f $pth2vhor ]
	then
		echo "input file $pth2vhor does not exist"
		echo "please download it and then use this switch"
		VHORIZONTAL=0
		exit 1
	fi
fi

if [ "$VVERTICAL" -eq 1 ]
then
	if [ ! -f $pth2vver ]
	then
		echo "input file $pth2vver does not exist"
		echo "please download it and then use this switch"
		VVERTICAL=0
		exit 1
	fi
fi


###check NOA FAULT catalogue
if [ "$FAULTS" -eq 1 ]
then
	if [ ! -f $pth2faults ]
	then
		echo "NOA Faults database does not exist"
		echo "please download it and then use this switch"
		FAULTS=0
	fi
fi

###check LOGO file
if [ ! -f "$pth2logos" ]
then
	echo "Logo file does not exist"
	LOGO=0
fi





# //////////////////////////////////////////////////////////////////////////////
# SET REGION PROPERTIES
	#these are default for GREECE REGION
gmt	gmtset PS_MEDIA 22cx22c
	scale="-Lf20/33.5/36:24/100+l+jr"
	range="-R$west/$east/$south/$north"
	proj="-Jm24/37/1:$projscale"
	logo_pos="BL/6c/-1.5c/DSO[at]ntua"
	logo_pos2="-C16c/15.6c"
	legendc="-Jx1i -R0/8/0/8 -Dx18.5c/12.6c/3.6c/3.5c/BL"	
	maptitle=""




# ####################### TOPOGRAPHY ###########################
if [ "$TOPOGRAPHY" -eq 0 ]
then
	################## Plot coastlines only ######################	
gmt	psbasemap $range $proj $scale -B$frame:."$maptitle": -P -K > $outfile
gmt	pscoast -R -J -O -K -W0.25 -G195 -Df -Na -U$logo_pos >> $outfile
# 	pscoast -Jm -R -Df -W0.25p,black -G195  -U$logo_pos -K -O -V >> $outfile
# 	psbasemap -R -J -O -K --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p >> $outfile
fi
if [ "$TOPOGRAPHY" -eq 1 ]
then
	# ####################### TOPOGRAPHY ###########################
	# bathymetry
gmt	makecpt -Cgebco.cpt -T-7000/0/150 -Z > $bathcpt
gmt	grdimage $inputTopoB $range $proj -C$bathcpt -K > $outfile
gmt	pscoast $proj -P $range -Df -Gc -K -O >> $outfile
	# land
gmt	makecpt -Cgray.cpt -T-3000/1800/50 -Z > $landcpt
gmt	grdimage $inputTopoL $range $proj -C$landcpt  -K -O >> $outfile
gmt	pscoast -R -J -O -K -Q >> $outfile
	#------- coastline -------------------------------------------
gmt	psbasemap -R -J -O -K -B$frame:."$maptitle":  $scale >> $outfile
gmt	pscoast -J -R -Df -W0.25p,black -K  -O -U$logo_pos >> $outfile
fi


#////////////////////////////////////////////////////////////////
#  PLOT NOA CATALOGUE FAULTS Ganas et.al, 2013
if [ "$FAULTS" -eq 1 ]
then
	echo "plot NOA FAULTS CATALOGUE Ganas et.al, 2013 ..."
gmt	psxy $pth2faults -R -J -O -K  -W.5,204/102/0  >> $outfile
fi


#////////////////////////////////////////////////////////////////
### PLOT VELOCITIES GMT5 std must be zero to plot!!!!!

if [ "$VHORIZONTAL" -eq 1 ]
then
	awk '{print $3,$2}' $pth2vhor | gmt psxy -Jm -O -R -Sc0.15c -W0.005c -Gwhite -K >> $outfile

	awk '{print $3,$2,$7,$5,$8,$6,0,$1}' $pth2vhor | gmt psvelo -R -J -Se0.05/0.95/0 -W.3p,100 -A10p+e -Gblue -O -K -L -V >> $outfile  # 205/133/63.
	awk '{print $3,$2,$7,$5,$8,$6,0,$1}' $pth2vhor | gmt psvelo -R -J -Se0.05/0/0 -W2p,blue -A10p+e -Gblue -O -K -L -V >> $outfile  # 205/133/63.

	if [ "$LABELS" -eq 1 ]
	then
		 awk '{print $3,$2,9,0,1,"RB",$1}' $pth2vhor | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile
	fi

###scale
echo "$vsclon $vsclat $vscmagn 0 0 0 0 $vscmagn mm" | gmt psvelo -R -Jm -Se0.05/0.95/10 -W2p,blue -A10p+e -Gblue -O -K -L -V >> $outfile
fi



























# ///////////////// PLOT LEGEND //////////////////////////////////
if [ "$LEGEND" -eq 1 ]
then
gmt	pslegend .legend ${legendc} -C0.1c/0.1c -L1.3 -O -K >> $outfile
fi

#/////////////////PLOT LOGO DSO
if [ "$LOGO" -eq 1 ]
then
gmt	psimage $pth2logos -O $logo_pos2 -W1.1c -F0.4  -K >>$outfile
fi

#//////// close eps file
echo "9999 9999" | gmt psxy -J -R  -O >> $outfile

#################--- Convert to jpg format ----##########################################
if [ "$OUTJPG" -eq 1 ]
then
	gs -sDEVICE=jpeg -dJPEGQ=100 -dNOPAUSE -dBATCH -dSAFER -r300 -sOutputFile=$out_jpg $outfile
fi

# ///////////////// REMOVE TMP FILES //////////////////////////////////
rm .legend
rm *cpt

# NOA FAULTS reference
# Ganas Athanassios, Oikonomou Athanassia I., and Tsimi Christina, 2013. NOAFAULTS: a digital database for active faults in Greece. Bulletin of
#  the Geological Society of Greece, vol. XLVII and Proceedings of the 13th International Congress, Chania, Sept. 2013.

# historic eq papazachos reference
echo $?









