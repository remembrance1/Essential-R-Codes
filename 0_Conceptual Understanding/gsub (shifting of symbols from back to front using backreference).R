#### To shift symbols from back to front using gsub####

strings <- c("^ab", "ab", "abc", "-abd", "abe-", "ab 12")

gsub("(ab)", "\\1 34", strings) #first capture group (in parenthesis)
#[1] "^ab 34"   "ab 34"    "ab 34c"   "ab 34d"   "ab 34e"   "ab 34 12"

gsub("(ab)(d)", "\\2+\\1", strings) #2nd capture group (in parenthesis)
#[1] "^ab"   "ab"    "abc"   "d+ab"  "abe"   "ab 12"

gsub("(.*)-$", "-\\1", strings) #selects all entires with - at the back

gsub("^-(.*)", "\\1-", strings) #selects all entires with - at the front and shift to the back
