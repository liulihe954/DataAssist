library(Hmisc);library(tidyverse)
options(stringsAsFactors = FALSE) # prevent converting to factors
dat <- read.csv('0-12M_gene-Month_correlation.csv')

# set a baseline to compare with and set a index for all gene names
Month = seq(0,12,by = 3);all_gene = dat[,1] 
# set a container for output
out = data.frame()

# loop around each gene
for (i in seq_along(rownames(dat))){
  tmp = as.numeric(dat[i,2:6])
  r <- cor.test(Month,tmp,method='pearson')
  out = rbind(out, c(all_gene[i],r$estimate,r$p.value))
}
colnames(out) = c('Gene','Cor','pval')

# filter out less informative ones
thres1 = 0.8  # subject to change
pval_thres = 0.05  # subject to change
qval_thres = 0.1 # subject to change

out_final = out %>% 
  #mutate(qval = p.adjust(Cor,'fdr')) %>% # maybe later you need to use qvalue
  dplyr::filter(Cor != 'NA',pval !='NA') %>% 
  dplyr::filter(Cor > thres1,
                pval < pval_thres)

# output format
write.csv(out, "CorOut_all.csv",row.names = F,quote = F)
write.csv(out_final, "CorOut_0.8_0.05.csv",row.names = F,quote = F)
