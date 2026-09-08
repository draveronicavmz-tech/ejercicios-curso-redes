#!/bin/bash

# ============================================================
# PREPROCESAMIENTO rs-fMRI CON AFNI
# Curso de Redes
#
# Uso:
#   ./preprocesamiento_rsFMRI.sh sub-115
#
# Cambiar DATA_ROOT si la carpeta data_00_basic cambia de lugar.
# ============================================================

SUBJ=$1

DATA_ROOT="/Users/neurovonnie/Downloads/data_00_basic"
WORK_DIR="/Users/neurovonnie/Downloads/AFNI_preproc/AFNI_01_SSWarp"

cd "$WORK_DIR" || exit

# ------------------------------------------------------------
# 1. Preprocesamiento con afni_proc.py
# Requiere haber ejecutado previamente @SSwarper
# ------------------------------------------------------------

afni_proc.py \
-subj_id ${SUBJ} \
-script proc.${SUBJ} \
-scr_overwrite \
-out_dir ${SUBJ}.results \
-blocks despike tshift align tlrc volreg blur mask scale regress \
-copy_anat ${SUBJ}_anat_warped/anatSS.${SUBJ}.nii \
-anat_has_skull no \
-dsets ${DATA_ROOT}/${SUBJ}/ses-01/func/${SUBJ}_ses-01_task-rest_run-01_bold.nii.gz \
-tlrc_base MNI152_2009_template_SSW.nii.gz \
-tlrc_NL_warp \
-tlrc_NL_warped_dsets \
    ${SUBJ}_anat_warped/anatQQ.${SUBJ}.nii \
    ${SUBJ}_anat_warped/anatQQ.${SUBJ}.aff12.1D \
    ${SUBJ}_anat_warped/anatQQ.${SUBJ}_WARP.nii \
-align_opts_aea -cost lpc+ZZ -giant_move -check_flip \
-volreg_align_to MIN_OUTLIER \
-volreg_align_e2a \
-volreg_tlrc_warp \
-volreg_warp_dxyz 2.5 \
-blur_size 4 \
-mask_epi_anat yes \
-regress_motion_per_run \
-regress_apply_mot_types demean deriv \
-regress_censor_motion 0.2 \
-regress_censor_outliers 0.05 \
-regress_bandpass 0.01 0.1 \
-regress_run_clustsim no \
-regress_est_blur_epits \
-regress_est_blur_errts \
-html_review_style pythonic

# ------------------------------------------------------------
# 2. Ejecutar el script generado por afni_proc.py
# ------------------------------------------------------------

tcsh -xef proc.${SUBJ} 2>&1 | tee output.proc.${SUBJ}

# ------------------------------------------------------------
# 3. Abrir el reporte de control de calidad
# ------------------------------------------------------------

open_apqc.py -infiles ${SUBJ}.results/QC_${SUBJ}/index.html
