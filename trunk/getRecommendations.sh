#!/bin/bash

for i in `cat OMXN40SymbolsReuters.csv`; do ./parseRecommendation.pl $i > "$i.txt"; done;
