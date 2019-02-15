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
