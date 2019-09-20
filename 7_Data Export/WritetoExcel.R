## To export our a dataframe into excel sheet
## Use Openxlsx

#################################################
library(openxlsx)
options("openxlsx.minWidth" = 3)
options("openxlsx.maxWidth" = 300) ## 
## create a workbook and add a worksheet
wb <- createWorkbook()

##This will only create one excel sheet, if want more, need to duplicate the lines
addWorksheet(wb, "Sheet1")
hs1 <- createStyle(fgFill = "#4F81BD", halign = "CENTER", textDecoration = "Bold", fontColour = "white", border = "Bottom")
writeData(wb, 1, all.files, startRow = 1, startCol = 1, headerStyle = hs1,
          borders = "surrounding", borderStyle = "medium")
setColWidths(wb, "Sheet1", cols = 1:ncol(all.files), widths = "auto")
##

saveWorkbook(wb, "nameofexcelworkbook.xlsx", TRUE)

#------------------------------------------------------------------#
## Free style edit of the output excel sheet: 
#FREESTYLE
library(openxlsx)
options("openxlsx.minWidth" = 3)
options("openxlsx.maxWidth" = 300) 

## create a workbook and add a worksheet
wb <- createWorkbook()
addWorksheet(wb, "Name of Sheet")

#modify header style
hs1 <- createStyle(fgFill = "#4F81BD", 
                   halign = "CENTER", 
                   textDecoration = "Bold", 
                   fontColour = "white", 
                   fontName = "Calibri",
                   border = "Bottom")

## modify base font to size 10 Calibri in red
modifyBaseFont(wb, fontSize = 10, fontColour = "#FF0000", fontName = "Calibri")
writeData(wb, 1, all.files, startRow = 1, startCol = 1, 
          headerStyle = hs1,
          borders = "surrounding", 
          borderStyle = "medium")
setColWidths(wb, "Receipt", cols = 1:ncol(all.files), widths = "auto")

saveWorkbook(wb, "Excel_List.xlsx", TRUE)