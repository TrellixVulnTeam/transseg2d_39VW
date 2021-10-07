#!/bin/bash
#SBATCH --job-name=pytorch_stl10     # job name
#SBATCH --ntasks=8                   # number of MP tasks
#SBATCH --ntasks-per-node=4          # number of MPI tasks per node
#SBATCH --gres=gpu:4                 # number of GPUs per node
#SBATCH --cpus-per-task=10           # number of cores per tasks
#SBATCH --hint=nomultithread         # we get physical cores not logical
#SBATCH --time=00:35:00              # maximum execution time (HH:MM:SS)
#SBATCH --output=pytorch_stl10%j.out # output file name
#SBATCH --error=pytorch_stl10%j.err  # error file name

set -x

module purge
module load cuda/10.1.2

CONFIG="configs/swin/upernet_swin_base_patch4_window7_512x512_160k_ade20k.py"
GPUS=8
PORT=${PORT:-29500}

PYTHONPATH="$(dirname $CONFIG)/..":$PYTHONPATH \
srun python -m torch.distributed.launch --nproc_per_node=$GPUS --master_port=$PORT \
    $(dirname "$0")/train.py $CONFIG --launcher pytorch ${@:3}
