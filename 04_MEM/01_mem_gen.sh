test $# -ne 3 && echo 'give 3 inputs under the order:\n    number of words \n    number of bits \n    mux type(4|8|16)\n  ' && exit
/RAID2/EDA/memory/CBDK018_UMC_Artisan/orig_lib/aci/ra1sh_1/bin/ra1sh postscript verilog synopsys  vclef-fp lvs ascii -words $1 -bits $2 -mux $3
grep area RA1SH_slow_syn.lib | sed '1d'
