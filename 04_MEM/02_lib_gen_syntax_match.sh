#!/bin/sh
#rm -f RA1SH*
mv RA1SH.v RA1SH_backup.v
cat RA1SH_backup.v | sed 's/\([ \t]*\$setuphold[^,]\+,\)[ \t]*\(.*\)/\1posedge \2\n\1negedge \2/g' \
| sed "s/\([ \t]*\)(\([A-Z]\+ => \)\([^)]\+\)\(.*\)/\1(posedge \2(\3:1\'bx)\4/g" > RA1SH.v

lc_shell -f lc_shell.tcl