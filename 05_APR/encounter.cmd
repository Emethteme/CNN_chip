#######################################################
#                                                     
#  Encounter Command Logging File                     
#  Created on Tue Jan 16 10:47:08 2018                
#                                                     
#######################################################

#@(#)CDS: Encounter v14.24-s039_1 (64bit) 04/28/2015 11:46 (Linux 2.6.18-194.el5)
#@(#)CDS: NanoRoute v14.24-s029 NR150421-2040/14_24-UB (database version 2.30, 264.6.1) {superthreading v1.25}
#@(#)CDS: CeltIC v14.24-s017_1 (64bit) 04/17/2015 04:49:06 (Linux 2.6.18-194.el5)
#@(#)CDS: AAE 14.24-s007 (64bit) 04/28/2015 (Linux 2.6.18-194.el5)
#@(#)CDS: CTE 14.24-s019_1 (64bit) Apr 24 2015 04:06:27 (Linux 2.6.18-194.el5)
#@(#)CDS: CPE v14.24-s029
#@(#)CDS: IQRC/TQRC 14.2.2-s217 (64bit) Wed Apr 15 23:10:24 PDT 2015 (Linux 2.6.18-194.el5)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
setImportMode -keepEmptyModule 0
loadNetlist -i verilog CHIP_SYN.v
setTopCell CHIP
