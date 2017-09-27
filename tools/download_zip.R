args = commandArgs(trailingOnly=TRUE)

url  = args[1]
dir  = args[2]

file = basename(url)
download.file(url, file, quiet = FALSE)

ext = tolower(tools::file_ext(file))

switch(
  ext,
  { stop("Unknown file type: ", ext) },
  zip = { unzip(file, exdir = dir) },
  bz2 = { system2("tar", paste("xj","-C",dir,"-f",file), FALSE) },
  gz  = { system2("tar", paste("xz","-C",dir,"-f",file), FALSE) },
  tar = { system2("tar", paste("x", "-C",dir,"-f",file), FALSE) }
)

unlink(file)
