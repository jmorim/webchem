#' Get record details from Chemical Translation Service (CTS)
#'
#' Get record details from CTS, see \url{http://cts.fiehnlab.ucdavis.edu/}
#' @import jsonlite
#' @importFrom stats rgamma
#' @importFrom stats setNames
#' @param inchikey character; InChIkey.
#' @param verbose logical; should a verbose output be printed on the console?
#' @return a list of lists (for each supplied inchikey):
#' a list of 7. inchikey, inchicode, molweight, exactmass, formula, synonyms and externalIds
#' @author Eduard Szöcs, \email{eduardszoecs@@gmail.com}
#'
#' @references Wohlgemuth, G., P. K. Haldiya, E. Willighagen, T. Kind, and O. Fiehn 2010The Chemical Translation Service
#' -- a Web-Based Tool to Improve Standardization of Metabolomic Reports. Bioinformatics 26(20): 2647–2648.
#' @export
#' @examples
#' \donttest{
#' # might fail if API is not available
#' out <- cts_compinfo("XEFQLINVKFYRCS-UHFFFAOYSA-N")
#' # = Triclosan
#' str(out)
#' out[[1]][1:5]
#'
#' ### multiple inputs
#' inchikeys <- c("XEFQLINVKFYRCS-UHFFFAOYSA-N","BSYNRYMUTXBXSQ-UHFFFAOYSA-N" )
#' out2 <- cts_compinfo(inchikeys)
#' str(out2)
#' # a list of two
#' # extract molecular weight
#' sapply(out2, function(y) y$molweight)
#' }
cts_compinfo <- function(inchikey, verbose = TRUE){
  # inchikey <- 'XEFQLINVKFYRCS-UHFFFAOYSA-N'
  foo <- function(inchikey, verbose) {
    if (!is.inchikey(inchikey)) {
      stop('Input is not a valid inchikey!')
    }
    baseurl <- "http://cts.fiehnlab.ucdavis.edu/service/compound"
    qurl <- paste0(baseurl, '/', inchikey)
    if (verbose)
      message(qurl)
    Sys.sleep( rgamma(1, shape = 15, scale = 1/10))
    out <- try(fromJSON(qurl), silent = TRUE)
    if (inherits(out, "try-error")) {
      warning('Not found... Returning NA.')
      return(NA)
    }
    return(out)
  }
  out <- lapply(inchikey, foo, verbose = verbose)
  out <- setNames(out, inchikey)
  class(out) <- c('cts_compinfo','list')
  return(out)
}


#' Convert Ids using Chemical Translation Service (CTS)
#'
#' Convert Ids using Chemical Translation Service (CTS), see \url{http://cts.fiehnlab.ucdavis.edu/}
#' @import RCurl jsonlite
#' @importFrom utils URLencode
#' @importFrom stats rgamma
#' @importFrom stats setNames
#' @param query character; query ID.
#' @param from character; type of query ID, e.g. \code{'Chemical Name'} , \code{'InChIKey'},
#'  \code{'PubChem CID'}, \code{'ChemSpider'}, \code{'CAS'}.
#' @param to character; type to convert to.
#' @param first deprecated.  Use choices = 1 instead.
#' @param choices to return only the first result, use 'choices = 1'.  To choose a result from an interative menu, provide a number of choices to choose from or "all".
#' @param verbose logical; should a verbose output be printed on the console?
#' @param ... currently not used.
#' @return a list of character vectors or if \code{choices} is used, then a single named vector.
#' @author Eduard Szöcs, \email{eduardszoecs@@gmail.com}
#' @details See also \url{http://cts.fiehnlab.ucdavis.edu/}
#' for possible values of from and to.
#'
#' @seealso \code{\link{cts_from}} for possible values in the 'from' argument and
#' \code{\link{cts_to}} for possible values in the 'to' argument.
#'
#' @references Wohlgemuth, G., P. K. Haldiya, E. Willighagen, T. Kind, and O. Fiehn 2010The Chemical Translation Service
#' -- a Web-Based Tool to Improve Standardization of Metabolomic Reports. Bioinformatics 26(20): 2647–2648.
#' @export
#' @examples
#' \donttest{
#' # might fail if API is not available
#' cts_convert("triclosan", "Chemical Name", "inchikey")
#'
#' ### multiple inputs
#' comp <- c("triclosan", "hexane")
#' cts_convert(comp, "Chemical Name", "cas")
#' }
cts_convert <- function(query, from, to, first = FALSE, choices = NULL, verbose = TRUE, ...){
  if(!missing("first"))
    stop('"first" is deprecated.  Use "choices = 1" instead.')
  if (length(from) > 1 | length(to) > 1) {
    stop('Cannot handle multiple input or output types.  Please provide only one argument for `from` and `to`.')
  }

  foo <- function(query, from, to , first, verbose){
    if (is.na(query)) return(NA)
    baseurl <- "http://cts.fiehnlab.ucdavis.edu/service/convert"
    qurl <- paste0(baseurl, '/', from, '/', to, '/', query)
    qurl <- URLencode(qurl)
    if (verbose)
      message(qurl)
    Sys.sleep( rgamma(1, shape = 15, scale = 1/10))
    out <- try(fromJSON(qurl), silent = TRUE)
    if (inherits(out, "try-error")) {
      warning('Not found... Returning NA.')
      return(NA)
    }
    if (length(out$result[[1]]) == 0) {
        message("Not found. Returning NA.")
        return(NA)
    }
    out <- out$result[[1]]
    # if (first)
    #   out <- out[1]
    out <- chooser(out, choices)
    return(out)
  }
  out <- lapply(query, foo, from = from, to = to, first = first, verbose = verbose)
  out <- setNames(out, query)
  # if (first)
  if(!is.null(choices))
    out <- unlist(out)
  return(out)
}


#' Return a list of all possible ids
#'
#' Return a list of all possible ids that can be used in the 'from' argument
#' @import jsonlite
#' @param verbose logical; should a verbose output be printed on the console?
#' @return a character vector.
#' @author Eduard Szöcs, \email{eduardszoecs@@gmail.com}
#' @details See also \url{http://cts.fiehnlab.ucdavis.edu/services}
#'
#' @seealso \code{\link{cts_convert}}
#'
#' @references Wohlgemuth, G., P. K. Haldiya, E. Willighagen, T. Kind, and O. Fiehn 2010The Chemical Translation Service
#' -- a Web-Based Tool to Improve Standardization of Metabolomic Reports. Bioinformatics 26(20): 2647–2648.
#' @export
#' @examples
#' \donttest{
#' cts_from()
#' }
cts_from <- function(verbose = TRUE){
  fromJSON('http://cts.fiehnlab.ucdavis.edu/service/conversion/fromValues')
}


#' Return a list of all possible ids
#'
#' Return a list of all possible ids that can be used in the 'to' argument
#' @import jsonlite
#' @param verbose logical; should a verbose output be printed on the console?
#' @return a character vector.
#' @author Eduard Szoecs, \email{eduardszoecs@@gmail.com}
#' @details See also \url{http://cts.fiehnlab.ucdavis.edu/services}
#'
#' @seealso \code{\link{cts_convert}}
#'
#' @references Wohlgemuth, G., P. K. Haldiya, E. Willighagen, T. Kind, and O. Fiehn 2010The Chemical Translation Service
#' -- a Web-Based Tool to Improve Standardization of Metabolomic Reports. Bioinformatics 26(20): 2647–2648.
#' @export
#' @examples
#' \donttest{
#' cts_from()
#' }
cts_to <- function(verbose = TRUE){
  fromJSON('http://cts.fiehnlab.ucdavis.edu/service/conversion/toValues')
}
