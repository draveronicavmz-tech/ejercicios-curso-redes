#!/bin/bash

# ============================================================
# SSWARPER - PREPROCESAMIENTO DE ANATOMÍA T1
# Curso de Redes
#
# Uso:
#   ./01_SSwarper.sh sub-115
#
# Este paso debe realizarse ANTES de afni_proc.py
# ============================================================

SUBJ=$1

DATA_ROOT="/Users/neurovonnie/Downloads/data_00_basic"
WORK_DIR="/Users/neurovonnie/Downloads/AFNI_preproc/AFNI_01_SSWarp"

cd "$WORK_DIR" || exit

@SSwarper \
-input ${DATA_ROOT}/${SUBJ}/ses-01/anat/${SUBJ}_ses-01_run-01_T1w.nii.gz \
-base MNI152_2009_template_SSW.nii.gz \
-subid ${SUBJ} \
-odir ${SUBJ}_anat_warped
