args = commandArgs(trailingOnly=TRUE)

url  = args[1]
dir  = args[2]

file = basename(url)
download.file(url, file, quiet = TRUE)

ext = tolower(tools::file_ext(file))

if (ext == "zip") {
  unzip(file, exdir = dir)
} else if (ext == "bz2") {
  system2("tar", paste("xj","-C",dir,"-f",file), FALSE)
} else if (ext == "gz") {
  system2("tar", paste("xz","-C",dir,"-f",file), FALSE)
} else if (ext == "tar") {
  system2("tar", paste("x","-C",dir,"-f",file), FALSE)
} else {
  stop("Unknown file type")
}

unlink(file)