% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chemid.R
\name{ci_query}
\alias{ci_query}
\title{Retrieve information from ChemIDPlus}
\usage{
ci_query(
  query,
  type = c("name", "rn", "inchikey"),
  match = c("best", "first", "ask", "na"),
  verbose = TRUE
)
}
\arguments{
\item{query}{character; query string}

\item{type}{character; type of query string. \code{"rn"} for registry number
or \code{"name"} for common name or \code{"inchikey"} for inchikey as input.}

\item{match}{character; How should multiple hits be handeled? \code{"first"}
returns only the first match, \code{"best"} the best matching (by name) ID,
\code{"ask"} enters an interactive mode and the user is asked for input,
\code{"na"} returns NA if multiple hits are found.}

\item{verbose}{logical; should a verbose output be printed on the console?}
}
\value{
A list of 8 entries: name (vector), synonyms (vector), cas (vector),
inchi (vector), inchikey (vector), smiles(vector), toxicity (data.frame),
physprop (data.frame) and source_url.
}
\description{
Retrieve information from ChemIDPlus
\url{https://chem.nlm.nih.gov/chemidplus}
}
\note{
Please respect the Terms and Conditions of the National Library of
Medicine, \url{https://www.nlm.nih.gov/databases/download.html}.
}
\examples{
\dontrun{
# might fail if API is not available
# query common name
y1 <- ci_query(c('Formaldehyde', 'Triclosan'), type = 'name')
names(y1)
str(y1[['Triclosan']]) # lots of information inside
y1[['Triclosan']]$inchikey

# Query by CAS
y2 <- ci_query('50-00-0', type = 'rn', match = 'first')
y2[['50-00-0']]$inchikey

# query by inchikey
y3 <- ci_query('WSFSSNUMVMOOMR-UHFFFAOYSA-N', type = 'inchikey')
y3[[1]]$name

# extract lop-P
sapply(y1, function(y){
 if (length(y) == 1 && is.na(y))
   return(NA)
 y$physprop$Value[y$physprop$`Physical Property` == 'log P (octanol-water)']
 })
}
}
