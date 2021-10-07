#!/usr/bin/env bash
# ThermodX Zipper Script
# Author: UsiF (UsiFX @ github)
# Credits: LOOPER (iamlooper @ github)
echo "[*] Give me version name. "
read name 
zip -r9T "ThermodX_${name}.zip" . -x zipper.sh -x *.git*
echo "[*] Done! "
