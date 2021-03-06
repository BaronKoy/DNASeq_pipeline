getArgs <- function() {
  myargs.list <- strsplit(grep("=",gsub("--","",commandArgs()),value=TRUE),"=")
  myargs <- lapply(myargs.list,function(x) x[2] )
  names(myargs) <- lapply(myargs.list,function(x) x[1])
  return (myargs)
}

release <- 'June2016'
rootODir<-'/SAN/vyplab/UCLex/data'

myArgs <- getArgs()

if ('rootODir' %in% names(myArgs))  rootODir <- myArgs[[ "rootODir" ]]
if ('release' %in% names(myArgs))  release <- myArgs[[ "release" ]]

######################

#oDir <- paste0(rootODir, "/UCLex_", release, "/")
oDir<-paste0(rootODir,'/') 
print(oDir)
onekgpositions <- read.table('/SAN/vyplab/UCLex/data/filteredPurcell_final.012.pos', header = FALSE, col.names = c('CHROM', 'POS'))
onekg <- read.table('/SAN/vyplab/UCLex/data/filteredPurcell_final.012', header = FALSE, sep = '\t')[,-1]
ids<- read.table("/SAN/vyplab/UCLex/data/OneKG_sample_ids.tab",header=T,sep="\t") 
rownames(onekg)<-ids[,1]
colnames(onekg)<-paste(onekgpositions[,1],onekgpositions[,2],sep="_") 
#save.image(file="prep_info.RData") 

bim<-read.table(paste0(oDir,"allChr_snpStats_out.bim"),header=F,sep="\t") 
bim.snps<-bim[,2]
bim$SNP<-paste(bim[,1],bim[,4],sep="_") 

fam<-read.table(paste0(oDir,"allChr_snpStats_out.fam"),header=F,sep=" ") 
onekg.samples.in.ucl<-fam[grep('One',fam[,1]),1]
write.table(data.frame(onekg.samples.in.ucl,onekg.samples.in.ucl),paste0(oDir,"onekg.samples.in.ucl"),col.names=F,row.names=F,quote=F,sep="\t")

matching.snps.shortname<-bim$SNP[bim$SNP %in% colnames(onekg)]
matching.snps.fullname<-bim$V2[bim$SNP %in% colnames(onekg)]

onekg.filt<-onekg[,matching.snps.shortname] 

one.bim<-bim[bim$SNP %in% matching.snps.shortname,]
one.fam<-data.frame(ids,ids,0,0,1,1)

write.table(matching.snps.fullname,paste0(oDir,"SNPs_for_pca"),col.names=F,row.names=F,quote=F,sep="\t") 
write.table(t(onekg.filt),paste0(oDir,"onekg_calls_for_uclex_snps.sp"),col.names=F,row.names=F,quote=F,sep="\t") 
write.table(one.bim[,1:6],paste0(oDir,"onekg_calls_for_uclex_snps.bim"),col.names=F,row.names=F,quote=F,sep="\t") 
write.table(one.fam,paste0(oDir,"onekg_calls_for_uclex_snps.fam"),col.names=F,row.names=F,quote=F,sep="\t") 

#system("sh ../PCA/getPCAsnps_UCLex.sh")
#system("/share/apps/R/bin/R CMD BATCH ../PCA/plot_pca.R")




write.table('4-Ancestry_PCA',paste0(oDir,'Check'), col.names=F,row.names=F,quote=F,sep='\t',append=TRUE) 


