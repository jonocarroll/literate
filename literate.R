process_literate <- function(fun_name) {
  
  #%{checkinput}{check that the input is not empty and ...}{extract}
  stopifnot(nchar(fun_name) > 0)
  
  #%{extract}{extract the literate programming comments. Note that body() strips comments}{}
  all_lines <- capture.output(eval(parse(text=fun_name)))
  lit_lines <- grep("#%", all_lines)
  lit_runs  <- split(lit_lines, cumsum(seq_along(lit_lines) %in% (which(diff(lit_lines) > 1) + 1)))
  if (length(lit_runs) > 0) {
    
    lit_block <- lapply(lit_runs, function(x) all_lines[x])
    
    lit_object <- list()
    
    for (iblock in seq_along(lit_block)) {
    
      start_of_block  <- lit_runs[[iblock]][1]
      end_of_block    <- lit_runs[[iblock]][length(lit_runs[[iblock]])]
      recombine_block <- paste(lit_block[[iblock]], collapse="\n")
      split_tags      <- strsplit(recombine_block, split = "[}{]")[[1]]
      stopifnot(length(split_tags) == 6) ## needs #%, this, "", content, "", next
      this_tag <- split_tags[2]
      content_tag <- gsub("#%","<br />#%",split_tags[4])
      next_tag <- split_tags[length(split_tags)]
     
      lit_object[[iblock]] <- data.frame(start_of_block, end_of_block, this_tag, content_tag, next_tag)
       
    }
    
  }
  
  #%{buildhtml}{generate the hyperlinked HTML page with the function}{return}
  raw_func <- gsub("[ ]","&nbsp;", all_lines)
  raw_func[1] <- paste0(fun_name, " <- ", raw_func[1])
  for (iblock in seq_along(lit_object)) {
    
    this_block <- lit_object[[iblock]]
    ## delete the block
    raw_func[this_block$start_of_block] <- ""
    if (this_block$end_of_block - this_block$start_of_block > 1 ) raw_func[(this_block$start_of_block + 1):this_block$end_of_block] <- ""
    ## just put the content back
    raw_func[this_block$start_of_block] <- paste0("<br />#%&nbsp;<a id=",this_block$this_tag,"><b><emph>",this_block$this_tag,"</emph></b></a>",
                                                  "<br />#%&nbsp;",this_block$content_tag,
                                                  "&nbsp;<a href=#",this_block$next_tag,"> next block </a>","&nbsp;<br />")
    
  }
  
  
  htmlpage <- paste0("<html><br /><title=",fun_name,"><br /><body><br />",paste0(raw_func, collapse = "<br />"),"</body><br /></html>", collapse = "\n")
  
  ## go back through and find more links
  htmlpagelinked <- gsub("%%([A-Za-z0-9]*)","<a href=#\\1>\\1</a>", htmlpage)
  
  tmphtml <- tempfile(pattern=fun_name, fileext=".html")
  cat(htmlpagelinked, file=tmphtml)
  
  browseURL(tmphtml)
  
  #%{return}{finally, return the output}{end}
  return(invisible(NULL))
}