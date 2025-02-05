#!/bin/sh
awk 'BEGIN {FS="\t"} /^#CHROM/ {print; next} $0 !~ /^#/ && $7=="PASS"' filtered_snps_FR07_t100_N1_lane1.vcf > passed_variants.vcf
awk 'BEGIN {FS="\t"} !/^#/ { split($10, a, ":"); print a[2] ":" a[3] }' passed_variants.vcf > d3.vcf

awk 'BEGIN {FS="\t"} 
     !/^#/ {
         split($10, a, ":");
         split(a[2], ad, ",");
         vaf = ad[2] / a[3]; 
         print vaf 
     }' passed_variants.vcf > d4.vcf

awk 'BEGIN { OFS="\t" }
     FNR==NR { vaf[FNR] = $0; next }
     /^#/ { next }
     { print $1, $2, vaf[++i] }
    ' d4.vcf passed_variants.vcf > vaf_values

