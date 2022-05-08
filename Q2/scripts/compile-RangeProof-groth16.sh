#!/bin/bash

# [assignment] create your own bash script to compile RangeProofCurcuit.circom modeling after RangeProofCurcuit.sh below

cd contracts/circuits

mkdir RangeProofCurcuit

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "RangeProofCurcuit.circom..."

# compile circuit

circom RangeProofCurcuit.circom --r1cs --wasm --sym -o RangeProofCurcuit
snarkjs r1cs info RangeProofCurcuit/RangeProofCurcuit.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup RangeProofCurcuit/RangeProofCurcuit.r1cs powersOfTau28_hez_final_10.ptau RangeProofCurcuit/circuit_0000.zkey
snarkjs zkey contribute RangeProofCurcuit/circuit_0000.zkey RangeProofCurcuit/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey RangeProofCurcuit/circuit_final.zkey RangeProofCurcuit/verification_key.json

# generate solidity contract

snarkjs zkey export solidityverifier RangeProofCurcuit/circuit_final.zkey ../RangeProofCurcuit.sol

cd ../..