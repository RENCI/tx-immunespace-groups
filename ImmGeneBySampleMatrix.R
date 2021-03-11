#!/usr/local/bin/Rscript
#
# usage: ImmGeneBySampleMatrix.R -g <participantGroupName> -o <output_dir> [-u <immunespace-base-url> ] < -a <immunespace-apikey> | -u <immunespace-email> -p <immunospace-password> >
#
# e.g.
#   ./ImmGeneBySampleMatrix.R -g cellfie_group2 -a <mask> > out.csv 2> out.err
#
# Purpose: retrieve Immunespace group and write a geneBySampleMatrix 
# Output: csv gene matrix with sample names on the columns
# Description: 
#   1. Register on Immunespace
#   2. Use the filters to select one or more studies with at least one expression matrices
#   3. Save as <participantGroupName>
#   4. Run this program

# ---- Parse args ===
library(optparse)
option_list = list(
    make_option(c("-o", "--output_dir"), type="character", default=NULL,
              help="container (transient) output directory, omit for stdout", metavar="character"),
    make_option(c("-g", "--group"), type="character", default="cellfie_group2", 
              help="user-defined participant groupname created on Immunespace [default= %default]", metavar="character"),
    make_option(c("-a", "--api_key"), type="character", default=NULL,
              help="base url of the Immport website to use", metavar="character"),
    make_option(c("-b", "--base_URL"), type="character", default="www.immunespace.org",
              help="base url of the Immport website to use", metavar="character"),
    make_option(c("-u", "--username"), type="character", default="txscience@lists.renci.org",
              help="Immunespace username (email) [default= %default]", metavar="character"),
    make_option(c("-p", "--passwd"), type="character", default=NULL,
              help="Immunespace password", metavar="character")
); 
opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);
if (is.null(opt$passwd) && is.null(opt$api_key)){
  print_help(opt_parser)
  stop("Must supply password or api key.n", call.=FALSE)
}
# ---- Variables ---
participantGroupName <- opt$group
outputDir <- opt$output_dir
passWord <- opt$passwd
userName <- opt$user
immBaseURL <- opt$base_URL
apiKey <- opt$api_key
# ---- Initialization ---
outputFilename <- participantGroupName
if (is.null(outputDir)){
   outputPath <- ""
} else {
   outputPath <- paste0(outputDir, "/", outputFilename, ".csv")
}
library(Rlabkey)
   labkey.setDefaults(baseUrl=immBaseURL)#"https://www.immunespace.org/")
if (is.null(apiKey)){
   # xxx not working right now, immunespace needs a .netrc file
   labkey.setDefaults(email=userName)
   labkey.setDefautls(password=passWord)
} else {
   labkey.setDefaults(apiKey=apiKey)
}

# ---- Main ---
library(ImmuneSpaceR)
if (immBaseURL == "test.immunespace.org"){
  con <- CreateConnection("", onTest = TRUE)
} else {
  con <- CreateConnection("")
}
pgrps <- con$listParticipantGroups()
immcellfie_group <- pgrps[ pgrps$group_name == participantGroupName ]

# find a group_id
eset=con$getParticipantGEMatrix(group=immcellfie_group$group_id)

# one matrix per cohort discovered and then combined
# No cross-cohort or cross-study normalization is done

# this is an array? class MIAME?
experimentData <- Biobase::experimentData(eset)
# phenotype label descriptions, if they exist
phenoMetadata <- Biobase::varMetadata(eset)
# phenotypic data 
phenoDataMatrix <- Biobase::pData(eset)
# featurenames
featureNames <- Biobase::featureNames(eset)
# expression counts/intensities
geneBySampleMatrix <- Biobase::exprs(eset)

library(readr)
# Genes are standardized across studies using HUGO symbols
# BiosampleIds are standardized and deidentified via ImmPort
if (is.null(outputDir)){
  cat("===\n")  
  print(experimentData)
  cat("===\n")  
  print(phenoMetadata)
  cat("===\n")  
  cat(format_csv(as.data.frame(phenoDataMatrix)))
  cat("===\n")  
  cat(format_csv(as.data.frame(featureNames)))
  cat("===\n")  
  cat(format_csv(as.data.frame(geneBySampleMatrix)))
} else {
  #  write.csv(geneBySampleMatrix, file = outputPath)
  write.csv(phenoDataMatrix, file = outputPath)
}
