#!/bin/bash
while (( $# > 1 ))
do
    case $1 in
        -pos) position_files="$2";; # i.e. ../CPG2/CPG2-AB
        -head) head="$2";; # head threshold, pdb numbering, optional
        -tail) tail="$2";; # tail threshold, pdb numbering, optional
        -linker) linker="$2";; # i.e. ../pAaF/pAaF-product
        -cst_suffix) cst_suffix="$2";; # optional
        -nbh) neighborhood="$2";; # optional
        -n) decoys="$2";; # optional
        -mem) memory="$2";;
        *) break;
    esac
    shift 2
done

if ! [ -z "${cst_suffix}" ]
then
    enzdes_cst_suffix=_${cst_suffix}.cst
else
    enzdes_cst_suffix=.cst
fi

if ! [ -z "${neighborhood}" ]
then
    neighborhood="-nbh "${neighborhood}
fi

if [ -z "${decoys}" ]
then
    decoys="-n 50"
else
    decoys="-n "${decoys}
fi

# if ! [ -z "${memory}" ]
# then
#     memory="--mem ${memory}"
# fi

params_files="-params"
for params_file in `ls ${linker}/*.params`
do
    params_files=${params_files}" ../../../"${params_file}
done
path_to_protein=${position_files%/*}
for params_file in `ls ${path_to_protein}/*.params`
do
    params_files=${params_files}" ../../../"${params_file}
done

for symmetry in `ls ${path_to_protein}/*.symm`
do
    symmetry="-symm ../../../"${symmetry}
    break
done

scaffold=${position_files##*/}
substrate=${linker##*/}
cd ${scaffold}_${substrate}

for variant in `ls`
do
    if [[ ${variant} != ${scaffold}_* ]] && [[ ${variant} != *_deprecated ]] && [ ! -d "${variant}/design" ]
    then
        x=${variant%Z*}
        x_index=${x:1}
        z_index=${variant#*Z}
        if ! [ -z "${head}" ] && ! [ -z "${tail}" ] && ( [ ${x_index} -lt ${head} ] && [ ${z_index} -gt ${tail} ] ) || ( [ ${x_index} -gt ${head} ] && [ ${z_index} -lt ${tail} ] )
        then
            cd ${variant}
            mkdir design
            cd design
            slurmit.py --job ${variant} --mem ${memory} --command \
                "python ../../../../../scripts-design/fast_design.py ../${variant}.pdb \
                ${params_files} ${symmetry} -sf ref2015_cst \
                --score_terms fa_intra_rep_nonprotein:0.545 fa_intra_atr_nonprotein:1 \
                -enzdes_cst ../../../${linker}/${substrate}${enzdes_cst_suffix} \
                -enzdes -no_cys -nataa 1.5 ${neighborhood} ${decoys};"
            cd ../..
            sleep 0.05
        fi
    fi
done
cd ..
