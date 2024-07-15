#!/bin/bash

set -x

vllmPath="/opt/ml-platform/third_party/vllm-0.5.0.post1"

model70b=/root/softwares/models/llama3
model7b=/root/softwares/Llama-2-7b-hf
models="$model7b $model70b"
tps="1 2 4 8"
inputlens="256 512 1024 2048 4096 3072"

for model in $models; do
    for tp in $tps; do
        for inputlen in $inputlens; do
            python3 $vllmPath/benchmarks/benchmark_throughput.py --output-len 1 \
            --distributed-executor-backend ray \
            --model $model \
            --input-len $inputlen --tensor-parallel-size $tp;
        done
    done
done
