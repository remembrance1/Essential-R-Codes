## Compare string in one column against another. 
## This is a partial string seach from ref to df.
## As long as string partially appears in df, it will reflect as true

df <- data.frame(Name = c('hisas', 'myjafs', 'namegaefi'))
ref <- data.frame(Name = c('john', 'hello', 'his', 'name', 'random'))

df$Test <- sapply(df$Name, function(s) any(sapply(ref$Name, grepl,  x=s, fixed=TRUE)))
