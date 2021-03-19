#!/bin/sh 

## this script makes links to FV3GFS (GFSv15.1) nemsio files under /public and copies over GFS analysis file for verification
##   /scratch4/BMC/rtfim/rtfuns/FV3GFS/FV3ICS/YYYYMMDDHH/gfs
##     gfs.tHHz.sfcanl.nemsio -> /scratch4/BMC/public/data/grids/gfs/nemsio/YYDDDHH00.gfs.tHHz.sfcanl.nemsio
##     gfs.tHHz.atmanl.nemsio -> /scratch4/BMC/public/data/grids/gfs/nemsio/YYDDDHH00.gfs.tHHz.atmanl.nemsio
##
## if not on /public, also check under EMC's directory: /scratch1/NCEPDEV/rstprod/com/gfs/prod
##      gfs.YYYYMMDD/HH/
##         gfs.t00z.atmanl.nemsio
##         gfs.t00z.sfcanl.nemsio
##

echo
echo "CDATE = $CDATE"
echo "CDUMP = $CDUMP"
echo "ICSDIR = $ICSDIR"
echo "PUBDIR = $PUBDIR"
echo "RETRODIR = $RETRODIR"
echo "GDASDIR = $GDASDIR"
echo "ROTDIR = $ROTDIR"
echo "PSLOT = $PSLOT"
echo

## initialize
yyyymmdd=`echo $CDATE | cut -c1-8`
hh=`echo $CDATE | cut -c9-10`
yyddd=`date +%y%j -u -d $yyyymmdd`
fv3ic_dir=$ICSDIR/${CDATE}/${CDUMP}/$CDUMP.$yyyymmdd/$hh

## EMC archive on disk
##    /scratch1/NCEPDEV/rstprod/com/gfs/prod
##         gfs.t00z.atmanl.nemsio
##         gfs.t00z.sfcanl.nemsio
##
EMCDIR=/scratch1/NCEPDEV/rstprod/com/gfs/prod

## create links in FV3ICS directory
mkdir -p $fv3ic_dir
cd $fv3ic_dir
echo "making link to nemsio files under $fv3ic_dir"

pubsfc_file=${yyddd}${hh}00.${CDUMP}.t${hh}z.sfcanl.nemsio 
sfc_file=`echo $pubsfc_file | cut -d. -f2-`
pubatm_file=${yyddd}${hh}00.${CDUMP}.t${hh}z.atmanl.nemsio 
atm_file=`echo $pubatm_file | cut -d. -f2-`

echo "pubsfc_file:  $pubsfc_file"
echo "pubatm_file:  $pubatm_file"

if [[ -f $PUBDIR/${pubsfc_file} ]]; then
  echo "linking $PUBDIR...."
  ln -fs $PUBDIR/${pubsfc_file} $sfc_file 
  ln -fs $PUBDIR/${pubatm_file} $atm_file 
elif  [[ -f $RETRODIR/${pubsfc_file} ]]; then
  echo "linking $RETRODIR...."
  ln -fs $RETRODIR/${pubsfc_file} $sfc_file
  ln -fs $RETRODIR/${pubatm_file} $atm_file 
elif  [[ -f $EMCDIR/${pubsfc_file} ]]; then
  echo "linking $EMCDIR...."
  ln -fs $EMCDIR/${sfc_file} $sfc_file
  ln -fs $EMCDIR/${atm_file} $atm_file 
else
  echo "missing input files!"
  exit 1
fi

echo "YYYYMMDDHH:  ${yyyymmdd}${hh}"
gdasfile=$GDASDIR/${yyddd}${hh}00.gdas.t${hh}z.atmanl.nemsio

if [[ -f $gdasfile ]]
then
  ln -fs $gdasfile gdas.t${hh}z.atmanl.nemsio
fi

echo $GDASDIR
echo $gdasfile