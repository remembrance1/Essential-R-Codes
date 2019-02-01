setwd("C:/Users/zm679xs/Desktop/Project Hail/Phase 2/NCE Market Price/(01) Jan 2018")

file.list <- list.files()
all.files <- lapply(file.list, function(x){
  filename1<- basename(x)
  filesize1<- round((file.size(x) / 1000),3) #obtain file size in KB
  fileinfo<-file.info(x)
  data.frame(Filename=filename1, Filesize=filesize1, Fileinfo=fileinfo)
}) #list

all.files <- plyr::rbind.fill(all.files)

#dropping irrelevant columns
all.files <- all.files[,-c(3:4)]

###########################EXCEL .XLSX##################################

#extract out .xlsx files
library(readxl)
excel.list <- list.files(pattern='*.xlsx') #obtained name of all the files in directory
excel.files <- lapply(excel.list, function(x){
  filename1<- basename(x)
  sheetnames <- excel_sheets(x) 
  data.frame(filename=filename1,sheetnames=sheetnames)
}) #list
names(excel.files) <- excel.list

excel.file.list <- plyr::rbind.fill(excel.files)

# read excel sheets

full.list <- list()

for (i in 1:length(excel.list)){
  sheets <- excel_sheets(excel.list[i])
  lst <- lapply(sheets, function(x){ 
    data.frame(read_excel(excel.list[i], sheet = x))
  })
  names(lst) <- paste(sheets, "_",excel.list[i], sep='')
  full.list[[length(full.list)+1]] <- lst #obtained the full list already
}

####### get nrow

test.list <- list()
df <- data.frame(matrix(ncol = 1, nrow = 0))
x <- c("nrow")
colnames(df) <- x

for (i in 1:length(full.list)){
  for (k in 1:length(full.list[[i]])){
    df[k,1] <- nrow(data.frame(full.list[[i]][k]))
  }
  test.list[i] <- df
}

noofrows <- data.frame(noofrows = matrix(unlist(test.list)))

###### get ncol

test.list <- list()
df <- data.frame(matrix(ncol = 1, nrow = 0))
x <- c("ncol")
colnames(df) <- x

for (i in 1:length(full.list)){
  for (k in 1:length(full.list[[i]])){
    df[k,1] <- ncol(data.frame(full.list[[i]][k]))
  }
  test.list[i] <- df
}

noofcols <- data.frame(noofcol = matrix(unlist(test.list)))

#combine excel.file.list + noofcols + noofrows

excel.file.list$noofcol <- noofcols$noofcol
excel.file.list$noofrow <- noofrows$noofrows 

#then do a join to match the filename of the main data (all.files)
all.files <- merge(all.files, excel.file.list, by.x="Filename", by.y="filename", all.x=T)

#remove excel files
rm(excel.file.list, excel.files, full.list, lst, noofcols, noofrows, test.list, df, excel.list, i, k, sheets, x)

refvec <- c("File Name", "File Size in KB", "File Modified Date", 
            "File Created Date", "File Accessed Date", "Executable File", "Sheet Names", "No. of Columns", "No. of Rows")

all.files <- all.files[,-3]

colnames(all.files) <- refvec
##########################################
#get file type
library(tools)
library(dplyr)
all.files$Category <- file_ext(all.files$`File Name`) #obtain category

all.files %>% mutate(Category = ifelse(Category == "txt" | Category == "docx" , "Text", 
                                       ifelse(Category == "JPG" | Category == "png", "Image", 
                                              ifelse(Category == "pdf" | Category == "pptx", "Document", 
                                                     ifelse(Category == "csv" | Category == "xlsx", "Data", 
                                                            ifelse(Category == "", "Folder", "Unlabelled")))))) -> all.files

all.files$`Sheet Names` <- as.character(all.files$`Sheet Names`)
all.files[is.na(all.files)] <- ''
all.files$`No. of Rows` <- as.numeric(all.files$`No. of Rows`)
all.files$`No. of Columns` <- as.numeric(all.files$`No. of Columns`)

#####################################################
#write dataframe into .xlsx file

#################################################
#FREESTYLE
library(openxlsx)
options("openxlsx.minWidth" = 3)
options("openxlsx.maxWidth" = 300) ## 
## create a workbook and add a worksheet
wb <- createWorkbook()
addWorksheet(wb, "Receipt")
hs1 <- createStyle(fgFill = "#4F81BD", halign = "CENTER", textDecoration = "Bold", fontColour = "white", border = "Bottom")
writeData(wb, 1, all.files, startRow = 1, startCol = 1, headerStyle = hs1,
          borders = "surrounding", borderStyle = "medium")
setColWidths(wb, "Receipt", cols = 1:ncol(all.files), widths = "auto")

saveWorkbook(wb, "Excel_List.xlsx", TRUE)

