

ped <- read.csv('pedigree_details.csv')
ann <- read.csv('VEP_21-annotations.csv')
geno <- read.csv('VEP_21-genotypes.csv')

mother <- na.omit(ped[,'Mother'])
father <- na.omit(ped[,'Father'])
affected <- ped[ped$Affection,'ID']

by( geno , ann$SYMBOL, function(x) {
rbind( mother=table(x[,mother]=='0|1'), father=table(x[,father]=='0|1'), child=table(x[,affected]=='0|1'))
})


by( geno , ann$SYMBOL, function(x) {
x[,mother]=='0|1' & x[,father]=='0|1' & x[,affected]=='1|0'
})

X <- do.call('rbind',as.list(by( geno , ann$SYMBOL, function(x) {
#rbind( mother=table(x[,mother]>0), father=table(x[,father]>0), child=table(x[,affected]>0))
mum <- length(x[,mother]>0)
dad <- length(x[,father]>0)
child <- length(x[,affected]>0)
return(child>mum&child>dad)
})))



# no crossovers?
table( geno[,mother]=='0|1' & geno[,father]=='0|1' & geno[,affected]=='1|0' )
table( geno[,mother]=='1|0' & geno[,father]=='1|0' & geno[,affected]=='0|1' )


geno[which( geno[,mother]=='1|0' & geno[,father]=='1|0' ),affected]




