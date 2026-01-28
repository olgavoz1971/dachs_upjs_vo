#!/bin/bash

for field in blg lmc smc gd gal misc; do
  echo $field
  dachs limits $field
  dachs limits -d $field > limits_$field
done
