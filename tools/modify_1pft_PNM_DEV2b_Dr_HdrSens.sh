#! /bin/bash

#module load intel openmpi
#module load mkl
#module load intel ncview
#module load python
#module load netcdf
#module load nco
#module load ncl
#module purge
#module load gcc/4.8.5
#module load mvapich2/2.3.1

# ============This file is compied from modify_1pft_Pasoh_DEV2b.sh
# Vcmax, SLA, Wooddensity. Kmax and vulnarability curve pars are updated using PNM deciduous values (median)
# the rest parameters are remain the same


### where are all the things?
# param_file_dir=~/datasets/fates_param_files/CA_PFTs
# srcdir=~/Documents/model_source/ctsm/src/fates/
# scriptdir=$srcdir/tools/
param_file_dir=/pscratch/sd/j/jdingoxy/E3SM_JDhydro_pheno/components/elm/src/external_models/fates/parameter_files
srcdir=/pscratch/sd/j/jdingoxy/E3SM_JDhydro_pheno/components/elm/src/external_models/fates
scriptdir=$srcdir/tools


### give the resulting file a name that incorporates both the hash, the descriptor, and the date
orig_fname=$param_file_dir/fates_params_default.nc
mod_fname=$param_file_dir/fates_params_dtrimDr_1pft_PNM_deciduous.nc

mod_fnameD=$param_file_dir/fates_params_dtrimDr_1pft_PNM_deciduousHydroSen

### generate the netcdf binary from the cdl file
ncgen -o $orig_fname $srcdir/parameter_files/fates_params_default.cdl

### extract the relevant PFTs
#$scriptdir/FatesPFTIndexSwapper.py --pft-indices=2,2,6,7,12 --fin=$orig_fname --fout=$mod_fname
#$scriptdir/FatesPFTIndexSwapper.py --pft-indices=2,2,7,12 --fin=$orig_fname --fout=$mod_fname
#$scriptdir/FatesPFTIndexSwapper.py --pft-indices=2,2,12 --fin=$orig_fname --fout=$mod_fname
$scriptdir/FatesPFTIndexSwapper.py --pft-indices=1 --fin=$orig_fname --fout=$mod_fname
#$scriptdir/FatesPFTIndexSwapper.py --pft-indices=2,2 --fin=$orig_fname --fout=$mod_fname


pftid=1


$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_alloc_storage_cushion --val 3
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_mort_scalar_cstarvation --val 0.02
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_grperc --val 0.35   # CUE fix: growth respiration (0.85 -> ~0.62), matches phenology script

# set the the maximum fraction of storage carbon used for growing leaves
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_phenflush_fraction --val 0.15

# inhibit new-patch creation: zero the treefall disturbance fraction so spawn_patches transfers no area (single-patch diagnostic run). scalar var -> NO --pft
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --var fates_mort_disturb_frac --val 0

# this parameter control how fast respiration will be reduced when NSC get low so that carbon starvation mortality can be lowed, 1 highly curvature (mr reduces quick with NSC), 0 - linear (mr does not change) ,default is 0.02
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_maintresp_reduction_curvature  --val 1  

$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_mort_hf_flc_threshold --val 0.5  # hydraulic failure 

#=== current use default allometry for tropical trees
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_amode --val 2 
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_agb1 --val 0.2338 
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_agb2 --val 2.2533 
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_agb3 --val -999.9 
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_agb4 --val -999.9 
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_lmode --val 2
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_d2bl1 --val 0.0928   
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_d2bl2 --val 1.73  
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_d2bl3 --val -999.9 
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_d2ca_coefficient_max --val 0.17 
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_d2ca_coefficient_min --val 0.17
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_blca_expnt_diff --val 0  


#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_hmode --val 3 
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_d2h1 --val 1.9 
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_d2h2 --val 0.65 
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_d2h3 --val -999.9 
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_la_per_sa_int --val 0.2 
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_fire_bark_scaler --val 0.079 
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_leaf_stomatal_slope_ballberry --val 8   # old bbslope

# set stoma model
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --var fates_leaf_stomatal_model --val 5


$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_fmode --val 1  #constant fine root untrimed 
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_l2fr --val 2
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_hydr_srl --val 60

$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --var fates_hydr_kmax_rsurf1 --val 520
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_leaf_stomatal_intercept --val 10000   # old bbopt
  
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_leaf_diameter --val 0.004
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_leaf_vcmax25top --val 51 #  old value 51 
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_leaf_long --val 5  # default is 1.5
  
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_leaf_slamax --val 0.0126 
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_leaf_slatop --val 0.0186 
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_leaf_stor_priority --val 0.7 
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_mort_freezetol --val -15 
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_mort_scalar_coldstress --val 0

$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_mort_bmort --val 0.0002
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --var fates_mort_understorey_death --val 0

$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_seed_dbh_repro_threshold --val 10
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_seed_alloc_mature --val 0.1
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_seed_alloc --val 0.05

$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_recruit_hgt_min --val 2
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_recruit_initd --val 0.2
 

$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_wood_density --val 0.43 # 0.642 for Pasoh  0.57 for panama evergreen
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_z0mr --val 0.025

# set the plant p-v and vulnarability curve mode for each organ: 2 - Van Genuchten 
$scriptdir/modify_fates_paramfile.py --O --all --fin $mod_fname --fout $mod_fname --var fates_hydr_htftype_node --val "2,2,2,2"
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_fnrt_prof_mode --val 3   # root profile mode 2- 2par exponential

# set dynamic max rooting depth based on DBH
# fates_allom_zroot_min_z  
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_zroot_min_z --val 1
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_allom_zroot_min_dbh --val 5

# set added parameters for DEV2 , use default for Pasoh because no salinity 
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_hydr_frt_loss_salcr --val 6   # 
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_hydr_frt_loss_salk --val 0.0001   #
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_hydr_vg_dn_sal --val -0.05780406434   # 
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_hydr_vg_da_sal --val -0.0115485807   # root 
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_hydr_PSU_vg_init --val 4   # 

## modify hydraulic parameters 
## define wood density and related hydraulic parameters that depend on wood density
wood_density=0.43
# 0.64935 = 1/1.54
hydr_thetas_node="$(echo "1-$wood_density*0.64935" | bc)"   #$(expr $ID + 1) expr only work with integer, for decimal using bc e.g. "$(echo "$LAT + $D" | bc)"
hydr_resid_node="0.02,0.12,0.12,0.12"

hydr_pinot_node="$(echo "0.52-4.16*$wood_density" | bc)"
#echo $wood_density
#echo $hydr_thetas_node
#echo $hydr_pinot_node  

#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --var fates_wood_density --val ${wood_density} 
#echo "replace thetas_node" and resid_node

$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_hydr_thetas_node --val "$hydr_thetas_node,$hydr_thetas_node,$hydr_thetas_node,$hydr_thetas_node"
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var  fates_hydr_resid_node --val ${hydr_resid_node} # "$hydr_pinot_node,$hydr_pinot_node,$hydr_pinot_node,$hydr_pinot_node"

#echo "replacing pinot"
$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${pftid} --var fates_hydr_pinot_node --val "$hydr_pinot_node" # "$hydr_pinot_node,$hydr_pinot_node,$hydr_pinot_node,$hydr_pinot_node"

pfts=(1)  # define an array of pfts

# nitrogen content as N:C ratio, leaf, fine roots, sapwood, structure
nitrp1=("0.01,0.001,1e-08,0.0047" "0.01,0.0005,1e-08,0.0047" "0.02,0.0005,1e-08,0.0047" ) #  


roota=(0.5 0.5 1)   # roota rootb  
rootb=(0.5 1 5)

#p50node=("-2.80,-2.80,-2.80,-2.80" "-4.87,-4.87,-4.87,-4.87" ) #P50node fates_hydr_p50_node 

p50gs=("-3" "-3.5" "-2.5") # "-1.454"   5/21/2025: based on output, under estimate ET, so make p5ogs to be more negative (more open)
gsmax=("500000" "500000" "500000")  # for gs model 3
gsmin=("9080" "9080" "9080")  # for gs model 3 


avulgs=("3"  "6.0" "2.0")

kmaxnode=("4.34"  "3.5" "5.5") # need to be paired with p50x
# fates_hydr_avuln_node is calculated from p50x
## loop through all combinitions and generate corresponding parameter files

# change new parameters for van Gen using oak's value for grass
m_vg=(0.3819 0.8 0.8)  #
n_vg=(4.893 1.25 1.22)  # 
alpha_vg=(0.12 0.07113 0.17782)  # alpha value is computed for P50=-3 and -2 for pine and oak  # [0] 0.2151->0.12 to match case43 phenology baseline
k_lwp=(1 3 3)  # [0] 3->1 to match case43 phenology baseline

## update the parameter values 
for idx in `seq 0 1 0`; do  

  Theroota=${roota[$idx]}
  Therootb=${rootb[$idx]}
  Thep50node=${p50node[$idx]}
  Thep50gs=${p50gs[$idx]}
  Thegsmax=${gsmax[$idx]}  
  Thegsmin=${gsmin[$idx]}  
  Thekmaxnode=${kmaxnode[$idx]}
  Theavulgs=${avulgs[$idx]}
  Thenitrp1=${nitrp1[$idx]}
  Thepft=${pfts[$idx]}
  Thealpha=${alpha_vg[$idx]}
  TheM=${m_vg[$idx]}
  TheN=${n_vg[$idx]}
  Theklwp=${k_lwp[$idx]}


  $scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${Thepft} --var fates_prt_nitr_stoich_p1 --val ${Thenitrp1} 

  $scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${Thepft} --var fates_fnrt_prof_a --val ${Theroota}   # old roota
  $scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${Thepft} --var fates_fnrt_prof_b --val ${Therootb}     # old rootb
#  $scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${Thepft} --var fates_hydr_p50_node --val ${Thep50node}
              
  #assign p50gs the same value as p50node
  $scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${Thepft} --var fates_hydr_p50_gs --val ${Thep50gs}
  $scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${Thepft} --var fates_leaf_gs_max --val ${Thegsmax}  
  $scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${Thepft} --var fates_leaf_gs_min --val ${Thegsmin}
    
  $scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${Thepft} --var fates_hydr_kmax_node --val ${Thekmaxnode}
  # now set avulgs to be the same as avulnnode, since we set p50gs to be the same as p50node, according to Brad, avulgs is calculated using same formula avulnnode is calculated from p50node
  $scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${Thepft} --var fates_hydr_avuln_gs --val ${Theavulgs}
 
  # set hydro parameter for van Genuchten model
  $scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${Thepft} --var fates_hydr_vg_alpha_node --val ${Thealpha}
  $scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${Thepft} --var fates_hydr_vg_m_node --val ${TheM}
  $scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${Thepft} --var fates_hydr_vg_n_node --val ${TheN}

  $scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --pft ${Thepft} --var  fates_hydr_k_lwp --val ${Theklwp} # "$hydr_pinot_node,$hydr_pinot_node,$hydr_pinot_node,$hydr_pinot_node"
done
  ## T11: finalize pgs, ags and increased nitrogen content of leaf and wood a by 50% 

# adjustment of vulnarability curve
#dn_sal=(-0.05780406434 -0.1221929055 0)  # use second set id=1
#da_sal=(-0.0115485807 -0.006515815626 0)
# avulgs and bbslope 

# Pars to vary for deciduouos of PNM: median, min, max
WD=("" "0.43" "0.38" "0.51")
SLA=("" "0.012" "0.0154" "0.0087")
LL=("" "1.5" "2.5" "3.5")  # leaf longivity 

  
# p50gs and avulgs pair of -3.0 and 5 look good from T9, use this pair
# because python strats index from 0, but elm_nl multi run id starts from 1, so make first record to be empty
#p50gs=("" "-2.0" )   
#gsMax=("" "29080" )   
#gsMin=("" "9080" )   

NSC=("" "1.5" "1.5" "1.5") # fates_alloc_storage_cushion  "" "1.2" "1.5" "1.7"

cmort=(0 3 3 3)   # the maximum mortality of carbon starvation as n/n/year
# life span for 60 n/n/yr is 1/60 year = (1/60)*365 days = 6.1 days


# drought deciduouus leaf trim LWP threshold
# LWPcr=("" "-1.0" "-1.5" "-2.5")  old values for the first test simulations

LWPcr=("" "-2.25" "-2.5" "-2.75" "-3.0" "-5.0")   # index 5 (ID=5) = case43 LWP_cr=-5.0

# fates_hydr_psi_cr , the parameter define the critical leas Psi, above which plant does not experience drought stress, used to control leaf on
# I set it to be LWPcr + 1
psicr=("" "-2" "-2.5" "-4.5" )  # index 3 (ID2=3) = case43 psi_cr=-4.5
RID=0

for ID in `seq 5 1 5`; do  

    Thepwd=${WD[$ID]}
    TheSLA=${SLA[$ID]}
    TheLL=${LL[$ID]}
    TheNSC=${NSC[$ID]}    
    TheLWPcr=${LWPcr[$ID]}   

    for ID2 in `seq 3 1 3`; do
      Thepsicr=${psicr[$ID2]}
      for pgid in `seq 0 1 2`; do
        TheP50gs=${p50gs[$pgid]}
        
        for kid in `seq 0 1 2`; do
          Thekmaxnode=${kmaxnode[$kid]}
          
          for rtid in `seq 0 1 2`; do    
               Theroota=${roota[$rtid]}
               Therootb=${rootb[$rtid]}
          
               RID=$(expr $RID + 1)
               expstr=$(printf %04d $RID)
              
               
            #   $scriptdir/modify_fates_paramfile.py --var fates_alloc_storage_cushion --val ${TheNSC} --pft 1 --fin $mod_fname --fout ${mod_fnameD}${expstr}.nc --O                
           #    $scriptdir/modify_fates_paramfile.py --var fates_wood_density --val ${Thewd} --pft 1 --fin ${mod_fnameD}${expstr}.nc --fout ${mod_fnameD}${expstr}.nc --O                
           #    $scriptdir/modify_fates_paramfile.py --var fates_hydr_p50_gs --val ${TheP50gs} --pft 1 --fin ${mod_fnameD}${expstr}.nc --fout ${mod_fnameD}${expstr}.nc --O  
           #    $scriptdir/modify_fates_paramfile.py --var fates_leaf_slamax --val ${TheSLA} --pft 1 --fin ${mod_fnameD}${expstr}.nc --fout ${mod_fnameD}${expstr}.nc --O                
           #    $scriptdir/modify_fates_paramfile.py --var fates_leaf_slatop --val ${TheSLA} --pft 1 --fin ${mod_fnameD}${expstr}.nc --fout ${mod_fnameD}${expstr}.nc --O  
           #    $scriptdir/modify_fates_paramfile.py --var fates_leaf_long --val ${TheLL} --pft 1 --fin ${mod_fnameD}${expstr}.nc --fout ${mod_fnameD}${expstr}.nc --O  

               $scriptdir/modify_fates_paramfile.py --var fates_hydr_LWP_cr --val ${TheLWPcr} --pft 1 --fin $mod_fname --fout ${mod_fnameD}${expstr}.nc --O
               $scriptdir/modify_fates_paramfile.py --var fates_hydr_stress_trim --val 1 --pft 1 --fin ${mod_fnameD}${expstr}.nc --fout ${mod_fnameD}${expstr}.nc --O  
               $scriptdir/modify_fates_paramfile.py --var fates_hydr_psi_cr --val ${Thepsicr} --pft 1 --fin ${mod_fnameD}${expstr}.nc --fout ${mod_fnameD}${expstr}.nc --O
               $scriptdir/modify_fates_paramfile.py --var fates_hydr_sigma_LWP --val 0.5 --pft 1 --fin ${mod_fnameD}${expstr}.nc --fout ${mod_fnameD}${expstr}.nc --O   # case43 sigma=0.5
               $scriptdir/modify_fates_paramfile.py --var fates_hydr_p50_gs --val ${TheP50gs} --pft 1 --fin ${mod_fnameD}${expstr}.nc --fout ${mod_fnameD}${expstr}.nc --O 
               
               $scriptdir/modify_fates_paramfile.py --var fates_fnrt_prof_a --val ${Theroota} --pft 1 --fin ${mod_fnameD}${expstr}.nc --fout ${mod_fnameD}${expstr}.nc --O  
               $scriptdir/modify_fates_paramfile.py --var fates_fnrt_prof_b --val ${Therootb} --pft 1 --fin ${mod_fnameD}${expstr}.nc --fout ${mod_fnameD}${expstr}.nc --O
               $scriptdir/modify_fates_paramfile.py --var fates_hydr_kmax_node --val ${Thekmaxnode} --pft 1 --fin ${mod_fnameD}${expstr}.nc --fout ${mod_fnameD}${expstr}.nc --O                
               
               


          done    
        done
      done
   done
done

RID=$(expr $RID + 1)
expstr=$(printf %04d $RID)
$scriptdir/modify_fates_paramfile.py --var fates_hydr_stress_trim --val 0 --pft 1 --fin $mod_fname --fout ${mod_fnameD}${expstr}.nc --O

#

# =============  following codes will not run ======================= 
# 
: << 'SKIP_CODES'

if [ condition ]; then
    # commands to run if condition is true
elif [ another_condition ]; then
    # commands if the first is false but this is true
else
    # commands if none of the above are true
fi

#==============

avulgs=("3.5" "5" "6.0"  "8" "11")  
# T10c -> p50gs = -2.5 and ags = 5 pair works well
# 

salex=(0.5 0.75 0.98)   # from T9 -> use 0.75,   0.98 is too much
# root reduction from salinity
frsalredk=(0.0000075 0 0.00001 0.00005 ) # T4 use 0.00005 , root mortality seems too high at CP sites, so change to 0.00003


hfthr=(0.25 0.35 0.5)  # lower threshold, more mortality in first year
maxhmort=(1 10 60) #fates_mort_scalar_hydrfailure

grperc=(0.35 0.5)

lsPri=(0.02 0.05 0.1 0.3) # fates_leaf_stor_priority, don't set it be higher than (scalar_cstarvation-1)/sclar_cstarvation, otherwise, tree might die during pre-exposure
# nitrp1=("0.02,0.0005,1e-08,0.0047" "0.02,0.0005,1e-08,0.0047" "0.02,0.00005,1e-08,0.0047" "0.01,0.0005,1e-08,0.0047" "0.01,0.0001,1e-08,0.0047" "0.01,0.00005,1e-08,0.0047")
nitrp1=("0.02,0.0005,1e-08,0.0047" "0.02,0.0005,1e-04,0.0047" "0.02,0.0005,3e-04,0.0047" "0.01,0.0005,1e-08,0.0047" "0.01,0.0005,1e-04,0.0047")  # T6c change structure nitrogen

Vcsala=(0.17 0)  #fates_hydr_vcmax_loss_sal_a  , fitted is 0.17, when set to 0, Vcmax does not change with leaf salinity

Site=2

if [ "${Site}" == "1" ]; then 
nsal=22
mod_fnameO=$param_file_dir/fates_params_mod_1pft_BCSpruce_T18DEV2
fi

if [ "${Site}" == "2" ]; then 
nsal=3
mod_fnameO=$param_file_dir/fates_params_mod_1pft_BCSpruceCPms_T18DEV2
fi

if [ "${Site}" == "3" ]; then 
nsal=3
mod_fnameO=$param_file_dir/fates_params_mod_1pft_BCSpruceCPgwi_T18DEV2
fi
# parameter set 18 is copied from set 16, two changes are made
# 1. use p50gs to be 2.0 instead of 2.5, 
# 2. set root salinity mortality threshold to be 2psu and rate k to be 0.000001

# set the salinity file name for CP money stump and goodwin island
#mod_fnameCPms=$param_file_dir/fates_params_mod_1pft_BCSpruceCPms_T14DEV2
#mod_fnameCPgwi=$param_file_dir/fates_params_mod_1pft_BCSpruceCPgwi_T14DEV2
# note the structure nitrogen content has no effect the 4th values in nitrp1 

# to make high hmort at first year but 
  
# fates_sal_fid
#$scriptdir/modify_fates_paramfile.py --O --fin $mod_fname --fout $mod_fname --var 

#================================ sal file 1=========================================
ID=0
#echo rid, salex, hf, Nitrogenid, cmort, leaf_store_Pri, bbslp , P50gs, ags,vg_dn, vg_da, rid
for vcaid in `seq 0 1 0`; do  
  TheVcsala=${Vcsala[$vcaid]}
  for rid in `seq 0 1 0`; do  
     Theroota=${roota[$rid]}
     Therootb=${rootb[$rid]}
     for salid in `seq 1 1 1`; do
        Thesalex=${salex[$salid]}  
        for cmid in `seq 0 1 0`; do
           Thecmort=${cmort[$cmid]}
           for hfid in `seq 0 1 0`; do
              Thehf=${hfthr[$hfid]}
              for nid in `seq 2 1 2`; do
                 Thenitrp1=${nitrp1[$nid]}  
                 for lspid in `seq 0 1 1`; do
                   ThelsPri=${lsPri[$lspid]} 
                   for bbid in `seq 1 1 1`; do
                     # use bbslope = 8
                     Thebbslp=${bbslope[$bbid]}
                     for pgsid in `seq 1 1 1`; do
                       # choose p50gs = 2 
                       TheP50gs=${p50gs[$pgsid]}  
                       for agsid in `seq 1 1 1`; do
                        # ags = 11 
                         Theags=${avulgs[$agsid]}
                         for hmid in `seq 0 1 0`; do
                            Thehmortmax=${maxhmort[$hmid]}
                            for greid in `seq 1 1 1`; do
                               Thegre=${grperc[$greid]}
  
                               for frredid in `seq 0 1 1` ; do
                                 Thefrsalredk=${frsalredk[$frredid]}  
                               
                                  for dvgid in `seq 1 1 2`; do  
                                  Thedn=${dn_sal[$dvgid]}
                                  Theda=${da_sal[$dvgid]}
                                  
                                  ID=$(expr $ID + 1)
                                  expstr=$(printf %04d $ID)
          #                       echo $mod_fnameO${expstr}.nc
                                  echo , $rid, $Thesalex, $Thehf, $nid, $Thecmort, ${ThelsPri}, ${Thebbslp} ,${TheP50gs},${Theags},${Thedn}, ${Theda}, ${Thehmortmax},${Thegre},${Thefrsalredk},$expstr
          #      ./modify_fates_paramfile.py --var fates_roota_par --allPFT --val ${a} --fin fates_params_2pft_CZ2_AlloParDefault_1PFT-PINE-MultiRun.nc --fout fates_params_2pft_CZ2_AlloParDefault_1PFT-PINE-MultiRun${expstr}.nc --O
                         # stoma    
          #                       $scriptdir/modify_fates_paramfile.py --var fates_leaf_slamax --val ${Thesla} --pft 1 --fin $mod_fname --fout $mod_fnameO${expstr}.nc --O
          #                       $scriptdir/modify_fates_paramfile.py --var fates_leaf_slatop --val ${Thesla} --pft 1 --fin $mod_fnameO${expstr}.nc --fout $mod_fnameO${expstr}.nc --O
                                  # set salinity file id and stoma mode
                                  # for BC, 22 sal cases, CP 3 cases
                                  # for sfid in `seq 0 1 $nsal`; do  
                                     # choose stoma model: JD Ball-berry mode, mode 3
                                  #   for stomd in `seq 3 1 3`; do         
                                      #  $scriptdir/modify_fates_paramfile.py --var fates_hydr_k_salex --val ${Thesalex} --pft 1 --fin $mod_fname --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O
                                      # $scriptdir/modify_fates_paramfile.py --var fates_mort_hf_flc_threshold --val ${Thehf} --pft 1 --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O
                                      # $scriptdir/modify_fates_paramfile.py --var fates_fnrt_prof_a --val ${Theroota} --pft 1 --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O
                                      # $scriptdir/modify_fates_paramfile.py --var fates_fnrt_prof_a --val ${Therootb} --pft 1 --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O 
                                      # $scriptdir/modify_fates_paramfile.py --var fates_prt_nitr_stoich_p1 --val ${Thenitrp1} --pft 1 --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O 
                                      # $scriptdir/modify_fates_paramfile.py --var fates_mort_scalar_cstarvation --val ${Thecmort} --pft 1 --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O 
                                       $scriptdir/modify_fates_paramfile.py --var fates_leaf_stor_priority --val ${ThelsPri} --pft 1 --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O                
                                       $scriptdir/modify_fates_paramfile.py --var fates_leaf_stomatal_slope_ballberry --val ${Thebbslp} --pft 1 --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O                
                                       $scriptdir/modify_fates_paramfile.py --var fates_hydr_p50_gs --val ${TheP50gs} --pft 1 --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O    
                                      # $scriptdir/modify_fates_paramfile.py --var fates_leaf_gs_min --val ${ThegsMin} --pft 1 --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O                                          
                                     #  $scriptdir/modify_fates_paramfile.py --var fates_leaf_gs_max --val ${TheP50gsMax} --pft 1 --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O               
                                       
                                                                              
                                      # $scriptdir/modify_fates_paramfile.py --var fates_hydr_avuln_gs --val ${Theags} --pft 1 --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O                
                                      # $scriptdir/modify_fates_paramfile.py --var fates_hydr_vg_dn_sal --val ${Thedn} --pft 1 --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O                
                                      # $scriptdir/modify_fates_paramfile.py --var fates_hydr_vg_da_sal --val ${Theda} --pft 1 --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O                
                                      # $scriptdir/modify_fates_paramfile.py --var fates_mort_scalar_hydrfailure --val ${Thehmortmax} --pft 1 --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O     
                                      # $scriptdir/modify_fates_paramfile.py --var fates_hydr_vcmax_loss_sal_a --val ${TheVcsala} --pft 1 --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O     
                                            
                                       # root mortality rate 
                                      # $scriptdir/modify_fates_paramfile.py --var fates_hydr_frt_loss_salk --val ${Thefrsalredk} --pft 1 --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O                
                                       
                                       # increase the root mortality threshold
                                       #if [ "${Site}" == "2" ]; then    for ms site 
                                      # $scriptdir/modify_fates_paramfile.py --var fates_hydr_frt_loss_salcr --val 3.5 --pft 1 --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O                
                                       
                                       #fi
                                       
                                       # increase growth respiration a little in version T11DEV2c 
                                      # $scriptdir/modify_fates_paramfile.py --O --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --pft 1 --var fates_grperc --val ${Thegre}    
  
                                       # set the salinity file site id 
                                     #  $scriptdir/modify_fates_paramfile.py --O --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --var fates_sal_sid --val ${Site}    
              
                                   # set the salinity file id and stoma mode
                                   # note, stoma mode 3 works , mode 1 does not work (can't tune WUE)
                                     #  $scriptdir/modify_fates_paramfile.py --var fates_sal_fid --val ${sfid} --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O 
                                      # $scriptdir/modify_fates_paramfile.py --var fates_leaf_stomatal_model --val ${stomd} --fin ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --fout ${mod_fnameO}Sto${stomd}S${sfid}${expstr}.nc --O 
                                   
            
                                     done
                                  done
                               done  # dn, da
                             done # root reduction due to salinity
                          done # growth respiration
                       done      
                   done # avulgs
                 done # P50gs
               done  # bbslope
             done  # nitr
           done
        done
      done
    done  
  done
done # modification of parameters
SKIP_CODES

     