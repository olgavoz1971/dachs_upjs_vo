#!/bin/bash

for field in blg lmc smc gd gal misc; do
  echo $field  
  dachs imp -v $field
done
