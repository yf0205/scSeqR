# scSeqR v0.99.0

Authors: [Alireza Khodadadi-Jamayran](http://library.med.nyu.edu/api/publications?name=khodadadi-Jamayran&format=html&sort=newest) and [Aristotelis Tsirigos](https://med.nyu.edu/faculty/aristotelis-tsirigos).

We hope to have an official release with stable functions and complete documentation in october!

For citation please use this link (our manuscript is in preparation): https://github.com/rezakj/scSeqR

### Single Cell Sequencing R package (scSeqR)

<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/out1.gif" width="400"/>
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/out2.gif" width="400"/>
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/out3.gif" width="400"/>
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/out4.gif" width="400"/> 
<img src="https://github.com/rezakj/scSeqR/blob/master/doc/out10.gif" /> 
</p>




scSeqR (Single Cell Sequencing R package) is an interactive R package to works with high-throughput single cell sequencing technologies (i.e [scRNA-seq, scVDJ-seq and CITE-seq](https://en.wikipedia.org/wiki/Single_cell_sequencing#Single-cell_RNA_sequencing_(scRNA-seq))). As some research studies require a more attuned forms of normalization or **spike-in normalization** in some cases, scSeqR allows the users to chose from **multiple normalization methods** and **correcting for dropouts** (nonzero events counted as zero). Because some of the cell types are more challenging to work with, scSeqR also allows the users to choose from **different clustering algorithms (i.e. ward.D, kmeans, ward.D2, hierarchical, etc.)** and **indexing methods (i.e. silhouette, ccc, kl, gap-stats, etc.)** to adjust for sensitivity and stringency in order to find less or more subpopulations of cell types to design both unsupervised and supervised models to best suit your research. scSeqR provides **2D and 3D interactive visualizations**, **differential expression analysis**, filters based on cells and genes, cell helth and cell cycle, merging, normalizing for dropouts and **batch differences**, **gating** (mainly used for CITE-seq), pathway analysis, **cell type prediction** and tools to find marker genes for clusters and conditions. scSeqR inputs single cell data in  **10X format**, large numeric **matrix files** or standard **data frames**.

<p align="center">
<img src="https://github.com/rezakj/scSeqR/blob/master/doc/workflow.jpg" /> 
</p>

***
## How to install scSeqR
        
```r
library(devtools)
install_github("rezakj/scSeqR")
```

## Download a sample data

- Download and unzip a publicly available sample [PBMC](https://en.wikipedia.org/wiki/Peripheral_blood_mononuclear_cell) scRNA-Seq data.

```r
# set your working directory 
setwd("/your/download/directory")

# save the URL as an object
sample.file.url = "https://s3-us-west-2.amazonaws.com/10x.files/samples/cell/pbmc3k/pbmc3k_filtered_gene_bc_matrices.tar.gz"

# download the file
download.file(url = sample.file.url, 
     destfile = "pbmc3k_filtered_gene_bc_matrices.tar.gz", 
     method = "auto")  

# unzip the file. 
untar("pbmc3k_filtered_gene_bc_matrices.tar.gz")    
```

***
# How to use scSeqR for analyzing scRNA-seq data

To run a test sample follow these steps:

- Go to the R environment load the scSeqR package and the PBMC sample data that you downloaded.

```r
library("scSeqR")
my.data <- load10x("filtered_gene_bc_matrices/hg19/",gene.name = "geneSymbol")
```

To see the help page for each function use question mark as: 

```r
?load10x
```

- Aggregate data
     
Conditions in scSeqR are set in the header of the data and are separated by an underscore (_). Let's say you want to merge multiple datasets and run scSeqR in aggregate mode. Here’s an example: I divided this sample into three sets and then aggregate them into one matrix. 

```r
dim(my.data)
# [1] 32738  2700

# divide your sample into three samples for this example 
  sample1 <- my.data[1:900]
  sample2 <- my.data[901:1800]
  sample3 <- my.data[1801:2700]
  
# merge all of your samples to make a single aggregated file.    
my.data <- data.aggregation(samples = c("sample1","sample2","sample3"), 
	condition.names = c("WT","KO","Ctrl"))
```

- Check the head of your file.

```r
# here is how the head of the first 2 cells in the aggregated file looks like.	
head(my.data)[1:2]
#         WT_AAACATACAACCAC-1 WT_AAACATTGAGCTAC-1
#A1BG                       0                   0
#A1BG.AS1                   0                   0
#A1CF                       0                   0
#A2M                        0                   0
#A2M.AS1                    0                   0

# as you see the header has the conditions now
```


- Make an object of class scSeqR.

```r
my.obj <- make.obj(my.data)
my.obj
#[1] "An object of class scSeqR version: 0.99.0"                                     
#[2] "Raw/original data dimentions (rows,columns): 32738,2700"                       
#[3] "Data conditions in raw data: Ctrl,KO,WT (900,900,900)"                         
#[4] "Columns names: WT_AAACATACAACCAC.1,WT_AAACATTGAGCTAC.1,WT_AAACATTGATCAGC.1 ..."
#[5] "Row names: A1BG,A1BG.AS1,A1CF ..."   
```

- Perform some QC 

```r
my.obj <- qc.stats(my.obj)
``` 

- Plot QC

By default all the plotting functions would create interactive html files unless you set this parameter: interactive = FALSE.

```r
# plot UMIs, genes and percent mito all at once and in one plot. 
# you can make them individually as well, see the arguments ?stats.plot.
stats.plot(my.obj,
	plot.type = "all.in.one",
	out.name = "UMI-plot",
	interactive = FALSE,
	cell.color = "slategray3", 
	cell.size = 1, 
	cell.transparency = 0.5,
	box.color = "red",
	box.line.col = "green")
```

<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/stats.png" />
</p>

```r  
# Scatter plots
stats.plot(my.obj, plot.type = "point.mito.umi", out.name = "mito-umi-plot")
stats.plot(my.obj, plot.type = "point.gene.umi", out.name = "gene-umi-plot")
```
<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/out5.gif" width="400"/>
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/out6.gif" width="400"/>
</p>

- Filter cells. 

scSeqR allows you to filter based on library sizes (UMIs), number of genes per cell, percent mitochondrial content, one or more genes, and cell ids.

```r
my.obj <- cell.filter(my.obj,
	min.mito = 0,
	max.mito = 0.05,
	min.genes = 200,
	max.genes = 2400,
	min.umis = 0,
	max.umis = Inf)
	
#[1] "cells with min mito ratio of 0 and max mito ratio of 0.05 were filtered."
#[1] "cells with min genes of 200 and max genes of 2400 were filtered."
#[1] "No UMI number filter"
#[1] "No cell filter by provided gene/genes"
#[1] "No cell id filter"
#[1] "filters_set.txt file has beed generated and includes the filters set for this experiment."	

# more examples 
# my.obj <- cell.filter(my.obj, filter.by.gene = c("RPL13","RPL10")) # filter our cell having no counts for these genes
# my.obj <- cell.filter(my.obj, filter.by.cell.id = c("WT_AAACATACAACCAC.1")) # filter our cell cell by their cell ids.

# chack to see how many cells are left.  
dim(my.obj@main.data)
#[1] 32738  2637
```
- Down sampling 

This step is optional and is for having the same number of cells for each condition. 

```r
# optional
# my.obj <- down.sample(my.obj)
#[1] "From"
#[1] "Data conditions: Ctrl,KO,WT (877,877,883)"
#[1] "to"
#[1] "Data conditions: Ctrl,KO,WT (877,877,877)"
```

- Normalize data

You have a few options to normalize your data based on your study. You can also normalize your data using tools other than scSeqR and import your data to scSeqR. We recommend "ranked.glsf" normalization for most single cell studies. This normalization is great for fixing matrixes with lots of zeros and because it's geometric it is great for fixing for batch effects, as long as all the data is aggregated into one file (to aggregate your data see "aggregating data" section above). 

```r
my.obj <- norm.data(my.obj, 
     norm.method = "ranked.glsf",
     top.rank = 500) # best for scRNA-Seq

# more examples
#my.obj <- norm.data(my.obj, norm.method = "ranked.deseq", top.rank = 500)
#my.obj <- norm.data(my.obj, norm.method = "deseq") # best for bulk RNA-Seq 
#my.obj <- norm.data(my.obj, norm.method = "global.glsf") # best for bulk RNA-Seq 
#my.obj <- norm.data(my.obj, norm.method = "rpm", rpm.factor = 100000) # best for bulk RNA-Seq
#my.obj <- norm.data(my.obj, norm.method = "spike.in", spike.in.factors = NULL)
#my.obj <- norm.data(my.obj, norm.method = "no.norm") # if the data is already normalized
```

- Perform second QC 

```r
my.obj <- qc.stats(my.obj,which.data = "main.data")

stats.plot(my.obj,
	plot.type = "all.in.one",
	out.name = "UMI-plot",
	interactive = F,
	cell.color = "slategray3", 
	cell.size = 1, 
	cell.transparency = 0.5,
	box.color = "red",
	box.line.col = "green",
	back.col = "white")
``` 

<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/master/doc/stats2.png" />
</p>

- Scale data

```r
my.obj <- data.scale(my.obj)
```

- Gene stats

```r
my.obj <- gene.stats(my.obj, which.data = "main.data")

head(my.obj@gene.data[order(my.obj@gene.data$numberOfCells, decreasing = T),])
#       genes numberOfCells totalNumberOfCells percentOfCells  meanExp
#30303 TMSB4X          2637               2637      100.00000 38.55948
#3633     B2M          2636               2637       99.96208 45.07327
#14403 MALAT1          2636               2637       99.96208 70.95452
#27191 RPL13A          2635               2637       99.92416 32.29009
#27185  RPL10          2632               2637       99.81039 35.43002
#27190  RPL13          2630               2637       99.73455 32.32106
#               SDs condition
#30303 7.545968e-15       all
#3633  2.893940e+01       all
#14403 7.996407e+01       all
#27191 2.783799e+01       all
#27185 2.599067e+01       all
#27190 2.661361e+01       all
```

- Make a gene model for clustering

It's best to always to avoid global clustering and use a set of model genes. In bulk RNA-seq data it is very common to cluster the samples based on top 500 genes ranked by base mean, this is to reduce the noise. In scRNA-seq data, it's great to do so as well. This coupled with our ranked.glsf normalization is good for matrices with a lot of zeros. You can also use your set of genes as a model rather than making one. 

```r
make.gene.model(my.obj, 
	dispersion.limit = 1.5, 
	base.mean.rank = 500, 
	no.mito.model = T,
	no.cell.cycle = T,
	mark.mito = T, 
	interactive = T,
	out.name = "gene.model")
```
To view an the html intractive plot click on this links: [Dispersion plot](https://rawgit.com/rezakj/scSeqR/dev/doc/gene.model.html)


<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/gene.model.png" width="800" height="800" />
</p>


- Perform PCA

```r
# PCA
my.obj <- run.pca(my.obj, clust.method = "gene.model", gene.list = "my_model_genes.txt")

opt.pcs.plot(my.obj)
my.obj@opt.pcs
```        

<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/Opt_Number_Of_PCs.png" />
</p>


- Cluster the data

Here we cluster the first 10 dimensions of the data which is converted to principal components. You have the option of clustering your data based on the following methods: "ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid", "kmeans"

 For the distance calculation used for clustering, you have the following options: "euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski" or "NULL"

 With the following indexing methods: "kl", "ch", "hartigan", "ccc", "scott", "marriot", "trcovw", "tracew", "friedman", "rubin", "cindex", "db", "silhouette", "duda", "pseudot2", "beale", "ratkowsky", "ball", "ptbiserial", "gap", "frey", "mcclain", "gamma", "gplus", "tau", "dunn", "hubert", "sdindex", "dindex", "sdbw"

We recomand to use the defult options as below:

```r
my.obj <- run.clustering(my.obj, 
	clust.method = "ward.D",
	dist.method = "euclidean",
	index.method = "kl",
	max.clust = 25,
	dims = 1:10)
	
# If you want to manually set the number of clusters, and not used the predicted optimal number, set the minimum and maximum to the number you want:
#my.obj <- run.clustering(my.obj, 
#	clust.method = "ward.D",
#	dist.method = "euclidean",
#	index.method = "ccc",
#	max.clust = 8,
#	min.clust = 8,
#	dims = 1:10)

# more examples 
#my.obj <- run.clustering(my.obj, 
#	clust.method = "kmeans", 
#	dist.method = "euclidean",
#	index.method = "silhouette",
#	max.clust = 25,
#	dims = 1:10)

#my.obj <- run.clustering(my.obj, 
#	clust.method = "kmeans", 
#	dist.method = "euclidean",
#	index.method = "ccc",
#	max.clust = 12,
#	dims = 1:my.obj@opt.pcs)
```

- Perform tSNE

You have two options here. One is to run tSNE on PCs (faster) and the other is to run it based on main data. They both should look similar if they are running in default mode, however, they each can each be very useful in different study designs. For example if you decide to run tSNE on a different gene set to change the spacing of the cells the second option might be useful. 

```r
# tSNE
my.obj <- run.pc.tsne(my.obj, dims = 1:10)
# or 
# my.obj <- run.tsne(my.obj, clust.method = "gene.model", gene.list = "my_model_genes.txt")
```

- Visualize conditions

As we artificially made 3 conditions by randomly dividing the sample into 3. All the conditions should be looking similar.

```r
# tSNE
cluster.plot(my.obj,
	plot.type = "tsne",
	col.by = "conditions",
	clust.dim = 2,
	interactive = F)
# pca 
cluster.plot(my.obj,
	plot.type = "pca",
	col.by = "conditions",
	clust.dim = 2,
	interactive = F)
```

<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/tSNE_conds.png" width="400"/>
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/PCA_conds.png" width="400"/>      
</p>

- Visualize clusters

```r
# 2D
cluster.plot(my.obj,
	cell.size = 1,
	plot.type = "tsne",
	cell.color = "black",
	back.col = "white",
	col.by = "clusters",
	cell.transparency = 0.5,
	clust.dim = 2,
	interactive = F)

# 3D
cluster.plot(my.obj,
	plot.type = "tsne",
	col.by = "clusters",
	clust.dim = 3,
	interactive = F,
	density = F,
	angle = 100)
	
# intractive 2D
cluster.plot(my.obj,
	plot.type = "tsne",
	col.by = "clusters",
	clust.dim = 2,
	interactive = T,
	out.name = "tSNE_2D_clusters")

# intractive 3D
cluster.plot(my.obj,
	plot.type = "tsne",
	col.by = "clusters",
	clust.dim = 3,
	interactive = T,
	out.name = "tSNE_3D_clusters")

# Density plot for clusters 
cluster.plot(my.obj,
	plot.type = "pca",
	col.by = "clusters",
	interactive = F,
	density=T)

# Density plot for conditions 
cluster.plot(my.obj,
	plot.type = "pca",
	col.by = "conditions",
	interactive = F,
	density=T)
```
## To see the above made interactive plots click on these links: [2Dplot](https://rawgit.com/rezakj/scSeqR/dev/doc/tSNE_2D_clusters.html) and [3Dplot](https://rawgit.com/rezakj/scSeqR/dev/doc/tSNE_3D_clusters.html)
        
<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/tSNE_2D_clusters.png" width="400"/>
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/tSNE_3D.png" width="400"/> 
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/density_conditions.png" width="400"/>
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/density_clusters.png" width="400"/> 	
</p>


- Cell frequencies in clusters and conditions

Remember that these are not normalized for the total number of cells in each condition. You can normalize based on the number of the cells in each condition using the clust_cond_freq_info.tsv file that is generated and re-plot them in R or in excel sheet.

```r
clust.cond.info(my.obj, plot.type = "bar")
# [1] "clust_cond_freq_info.txt file has beed generated."

clust.cond.info(my.obj, plot.type = "pie")
# [1] "clust_cond_freq_info.txt file has beed generated."
```
<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/bar.png" width="400"/>
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/pie.png" width="400"/> 	
</p>

- Avrage expression per cluster

```r
my.obj <- clust.avg.exp(my.obj)

head(my.obj@clust.avg)
#     gene   cluster_1   cluster_2   cluster_3 cluster_4   cluster_5   cluster_6  cluster_7
#1     A1BG 0.074805398 0.083831677 0.027234682         0 0.088718322 0.026671084 0.04459271
#2 A1BG.AS1 0.013082859 0.012882983 0.005705715         0 0.003077574 0.000000000 0.01498637
#3     A1CF 0.000000000 0.000000000 0.000000000         0 0.000000000 0.000000000 0.00000000
#4      A2M 0.002350504 0.000000000 0.003284837         0 0.000000000 0.006868043 0.00000000
#5  A2M.AS1 0.009734684 0.006208601 0.000000000         0 0.041558965 0.055534823 0.00000000
#6    A2ML1 0.000000000 0.000000000 0.000000000         0 0.000000000 0.000000000 0.00000000
```

- Save your object

```r
save(my.obj, file = "my.obj.Robj")
```        

- Find marker genes

```r
marker.genes <- find.markers(my.obj,
	fold.change = 2,
	padjval = 0.1)

dim(marker.genes)
# [1] 1070   17

head(marker.genes)
#             baseMean     baseSD AvExpInCluster AvExpInOtherClusters foldChange log2FoldChange
#WNT7A     0.010229718 0.10242607     0.02380399         0.0006494299   36.65368       5.195886
#KRT1      0.020771859 0.18733189     0.04765674         0.0017973688   26.51473       4.728722
#TSHZ2     0.048409666 0.26309988     0.11075764         0.0044064635   25.13527       4.651641
#ANKRD55   0.008418143 0.09648853     0.01920420         0.0008056872   23.83580       4.575058
#LINC00176 0.067707756 0.29517298     0.15445793         0.0064822618   23.82778       4.574573
#MAL       0.193626263 1.08780664     0.42990647         0.0268672596   16.00113       4.000102
#                  pval         padj clusters      gene  cluster_1   cluster_2   cluster_3 cluster_4
#WNT7A     1.258875e-06 2.772043e-03        1     WNT7A 0.02380399 0.000000000 0.000000000         0
#KRT1      1.612082e-07 3.577209e-04        1      KRT1 0.04765674 0.000000000 0.000000000         0
#TSHZ2     3.647481e-18 8.341790e-15        1     TSHZ2 0.11075764 0.009321206 0.007981973         0
#ANKRD55   3.871894e-05 8.409755e-02        1   ANKRD55 0.01920420 0.000000000 0.000000000         0
#LINC00176 2.439482e-27 5.620565e-24        1 LINC00176 0.15445793 0.003689827 0.003429306         0
#MAL       2.417583e-15 5.500001e-12        1       MAL 0.42990647 0.021592215 0.010139857         0
#            cluster_5  cluster_6   cluster_7
#WNT7A     0.002806920 0.00000000 0.000000000
#KRT1      0.005251759 0.00000000 0.002596711
#TSHZ2     0.000000000 0.00000000 0.002297921
#ANKRD55   0.003482284 0.00000000 0.000000000
#LINC00176 0.013798598 0.00910279 0.003420015
#MAL       0.041585770 0.03214897 0.026263849
```

- Markers Batch Spacing Correction (MBSC)

We believe that batch correction should be done at the normalization level and scSeqR uses a geometric normalization for doing so as well as correcting for drop outs by excluding the genes with low count reads in the normalization step. However, in some cases one might need to also perform a cell spacing correction. This helps the same cell types in different samples come closer together in tSNE or lay on top of each other. For example, B cell in two sets of samples would be closer to each other and won't look like as if they should be two separate clusters. This step is optional.

```r
# optional
# MyGenes <- top.markers(marker.genes, topde = 50, min.base.mean = 0.2)
# MyGenes <- unique(MyGenes)
# write.table((MyGenes),file="my_DE_model_genes.txt", row.names =F, quote = F, col.names = F)
# you can run tSNE angain or use "my_DE_model_genes.txt" for another PCA and clustering round. 
# my.obj <- run.tsne(my.obj, clust.method = "gene.model", gene.list = "my_DE_model_genes.txt")
```

- Plot genes

```r
# tSNE 2D
gene.plot(my.obj, gene = "MS4A1", 
	plot.type = "scatterplot",
	interactive = F,
	out.name = "scatter_plot")
# PCA 2D	
gene.plot(my.obj, gene = "MS4A1", 
	plot.type = "scatterplot",
	interactive = F,
	out.name = "scatter_plot",
	plot.data.type = "pca")
	
# tSNE 3D	
gene.plot(my.obj, gene = "MS4A1", 
	plot.type = "scatterplot",
	interactive = F,
	out.name = "scatter_plot",
	clust.dim = 3)
	
# Box Plot
gene.plot(my.obj, gene = "MS4A1", 
	box.to.test = 0, 
	box.pval = "sig.values",
	col.by = "clusters",
	plot.type = "boxplot",
	interactive = F,
	out.name = "box_plot")
	
# Bar plot (to visualize fold changes)	
gene.plot(my.obj, gene = "MS4A1", 
	col.by = "clusters",
	plot.type = "barplot",
	interactive = F,
	out.name = "bar_plot")
```

<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/MS4A1_tSNE.png" width="400"/>
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/MS4A1_PCA.png" width="400"/> 
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/MS4A1_box.png" width="400"/> 
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/MS4A1_bar.png" width="400"/>
</p>


- Multiple plots

```r
genelist = c("PPBP","LYZ","MS4A1","GNLY","LTB","NKG7","IFITM2","CD14","S100A9")
###
library(gridExtra)
for(i in genelist){
	MyPlot <- gene.plot(my.obj, gene = i, 
		plot.type = "scatterplot",
		interactive = F,
		out.name = "Cebpb_scatter_plot")
	eval(call("<-", as.name(i), MyPlot))
}
### plot 
grid.arrange(PPBP,LYZ,MS4A1,GNLY,LTB,NKG7,IFITM2,CD14,S100A9)
```

<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/list1.png" width="800" height="800" />
</p>

- Heatmap

```r
# find top genes
MyGenes <- top.markers(marker.genes, topde = 10, min.base.mean = 0.2)
MyGenes <- unique(MyGenes)
# plot
heatmap.gg.plot(my.obj, gene = MyGenes, interactive = T, out.name = "plot", cluster.by = "clusters")
# or 
heatmap.gg.plot(my.obj, gene = MyGenes, interactive = F, cluster.by = "clusters")
```

<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/heatmap.png" />
</p>

 - Cell type prediction using ImmGen
 
Note that ImmGen is mouse genome data and the sample data here is human. For 157 ULI-RNA-Seq samples use this meta data: [metadata](https://github.com/rezakj/scSeqR/blob/dev/doc/uli_RNA_metadat.txt). 

```r
Cluster = 7
MyGenes <- top.markers(marker.genes, topde = 40, min.base.mean = 0.2, cluster = Cluster)
# plot 
imm.gen(immgen.data = "rna", gene = MyGenes, plot.type = "point.plot")
# and
imm.gen(immgen.data = "uli.rna", gene = MyGenes, plot.type = "point.plot", top.cell.types = 50)
# or 
imm.gen(immgen.data = "rna", gene = MyGenes, plot.type = "heatmap")
# and
imm.gen(immgen.data = "uli.rna", gene = MyGenes, plot.type = "heatmap")

# And finally check the genes in the cells and find the common ones to predict
heatmap.gg.plot(my.obj, gene = MyGenes, interactive = F, cluster.by = "clusters")

# As you can see cluster 7 is most likely to be B-cells.   
```

<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/ImmGen_pointPlot_RNA_Cluster_7.png" />
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/ImmGen_pointPlot_ULI-RNA_Cluster_7.png" /> 
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/ImmGen_heatmap_RNA_Cluster_7.png" /> 
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/ImmGen_heatmap_ULI-RNA_Cluster_7.png" />
<img src="https://github.com/rezakj/scSeqR/blob/dev/doc/heatmap_Cluster_7.png" /> 	
</p>


 - Pathway analysis
 
```r
# Pathway  
# pathways.kegg(my.obj, clust.num = 7) 
# this function is being improved and soon will be available
```

<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/7_cluster_KEGGpathways.png" />    
</p>

- QC on clusters 

```r
clust.stats.plot(my.obj, plot.type = "box.mito", interactive = F)
clust.stats.plot(my.obj, plot.type = "box.gene", interactive = F)
```

<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/box.mito.clusters.png" width="400"/>
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/box.gene.clusters.png" width="400"/>      
</p>


- Differential Expression Analysis 

```r
diff.res <- diff.exp(my.obj, de.by = "clusters", cond.1 = c(1,4), cond.2 = c(2))
diff.res1 <- as.data.frame(diff.res)
diff.res1 <- subset(diff.res1, padj < 0.05)
head(diff.res1)
#             baseMean        1_4           2 foldChange log2FoldChange         pval
#AAK1       0.19554589 0.26338228 0.041792762 0.15867719      -2.655833 8.497012e-33
#ABHD14A    0.09645732 0.12708519 0.027038379 0.21275791      -2.232715 1.151865e-11
#ABHD14B    0.19132829 0.23177944 0.099644572 0.42991118      -1.217889 3.163623e-09
#ABLIM1     0.06901900 0.08749258 0.027148089 0.31029018      -1.688310 1.076382e-06
#AC013264.2 0.07383608 0.10584821 0.001279649 0.01208947      -6.370105 1.291674e-19
#AC092580.4 0.03730859 0.05112053 0.006003441 0.11743700      -3.090041 5.048838e-07
                   padj
#AAK1       1.294690e-28
#ABHD14A    1.708446e-07
#ABHD14B    4.636290e-05
#ABLIM1     1.540087e-02
#AC013264.2 1.950557e-15
#AC092580.4 7.254675e-03

# more examples 
# diff.res <- diff.exp(my.obj, de.by = "conditions", cond.1 = c("WT"), cond.2 = c("KO"))
# diff.res <- diff.exp(my.obj, de.by = "clusters", cond.1 = c(1,4), cond.2 = c(2))
# diff.res <- diff.exp(my.obj, de.by = "clustBase.condComp", cond.1 = c("WT"), cond.2 = c("KO"), base.cond = 1)
# diff.res <- diff.exp(my.obj, de.by = "condBase.clustComp", cond.1 = c(1), cond.2 = c(2), base.cond = "WT")
```

- Volcano and MA plots 

```r
# Volcano Plot 
volcano.ma.plot(diff.res,
	sig.value = "pval",
	sig.line = 0.05,
	plot.type = "volcano",
	interactive = F)

# MA Plot
volcano.ma.plot(diff.res,
	sig.value = "pval",
	sig.line = 0.05,
	plot.type = "ma",
	interactive = F)
```

<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/volc_plot.png" width="400"/>
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/MA_plot.png" width="400"/>      
</p>

 - Merging, resetting, renaming and removing clusters 
 
 ```r
# let's say you  want to merge cluster 3 and 2.
my.obj <- change.clust(my.obj, change.clust = 3, to.clust = 2)

# to reset to the original clusters run this.
my.obj <- change.clust(my.obj, clust.reset = T)

# you can also re-name the cluster numbers to cell types. Remember to reset after this so you can ran other analysis. 
my.obj <- change.clust(my.obj, change.clust = 7, to.clust = "B Cell")

# Let's say for what ever reason you want to remove acluster, to do so run this.
my.obj <- clust.rm(my.obj, clust.to.rm = 1)

# Remember that this would perminantly remove the data from all the slots in the object except frrom raw.data slot in the object. If you want to reset you need to start from the filtering cells step in the biginging of the analysis (using cell.filter function). 

# To re-position the cells run tSNE again 
my.obj <- run.tsne(my.obj, clust.method = "gene.model", gene.list = "my_model_genes.txt")

# Use this for plotting as you make the changes
cluster.plot(my.obj,
	cell.size = 1,
	plot.type = "tsne",
	cell.color = "black",
	back.col = "white",
	col.by = "clusters",
	cell.transparency = 0.5,
	clust.dim = 2,
	interactive = F)
```

<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/tSNE_2D_a.png" width="400"/>
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/tSNE_2D_b.png" width="400"/>    
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/tSNE_2D_c.png" width="400"/>
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/tSNE_2D_d.png" width="400"/>  
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/tSNE_2D_e.png" width="400"/>
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/tSNE_2D_f.png" width="400"/>  
</p>

 - Pseudo-time analysis
 
 ```r
 my.obj <- run.diff.st(my.obj, dist.method = "euclidean")
 cluster.plot(my.obj,
	cell.size = 1,
	plot.type = "dst",
	cell.color = "black",
	back.col = "white",
	col.by = "clusters",
	cell.transparency = 0.5,
	clust.dim = 2,
	interactive = F)
 ```
<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/dst.png" />
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/dst_2D.png" />
</p>


 - Optional manual clustering or renaming the clusters 
 
 You also have the option of manual hirarchical clustering or renaming the clusters. It is highly recomanded to not use this method as the above method is much more accurate. 

```r
##### Find optimal number of clusters for hierarchical clustering
#opt.clust.num(my.obj, max.clust = 10, clust.type = "tsne", opt.method = "silhouette")
##### Manual clustering 
#my.obj <- man.assign.clust(my.obj, clust.num = 7)
```

<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/optim_clust_num1.png" width="800" />
</p>

# How to analyze CITE-seq data using scSeqR

<p align="center">
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/list3.png" />
  <img src="https://github.com/rezakj/scSeqR/blob/dev/doc/list5.png" />
</p>


