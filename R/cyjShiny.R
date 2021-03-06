#' @importFrom jsonlite toJSON fromJSON
#' @importFrom htmlwidgets createWidget shinyWidgetOutput shinyRenderWidget
#' @import shiny
#'
#' @title cyjShiny
#------------------------------------------------------------------------------------------------------------------------
#' cyjShiny
#'
#' @description
#' This widget wraps cytoscape.js, a full-featured Javsscript network library for visualization and analysis.
#'
#' @aliases cyjShiny
#' @rdname cyjShiny
#'
#' @param graph an R graphNEL instance (igraph support coming soon).
#' @param width integer  initial width of the widget.
#' @param height integer initial height of the widget.
#' @param elementId string the DOM id into which the widget is rendered, default NULL is best.
#'
#' @return a reference to an htmlwidget.
#'
#'
#' @examples
#' \dontrun{
#'   output$cyjShiny <- renderCyjShiny(cyjShiny(graph))
#' }
#'
#' @export


cyjShiny <- function(graph, width = NULL, height = NULL, elementId = NULL)
{
    x <- list(graph = graph)

    htmlwidgets::createWidget(
       name = 'cyjShiny',
       x,
       width = width,
       height = height,
                     package = 'cyjShiny',
       elementId = elementId
    )

} # cyjShiny constructor
#------------------------------------------------------------------------------------------------------------------------
#' Standard shiny ui rendering construct
#'
#' @param outputId the name of the DOM element to create.
#' @param width integer  optional initial width of the widget.
#' @param height integer optional initial height of the widget.
#'
#' @return a reference to an htmlwidget
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   mainPanel(cyjShinyOutput('cyjShiny'), width=10)
#' }
#'
#' @aliases cyjShinyOutput
#' @rdname cyjShinyOutput
#'
#' @export

cyjShinyOutput <- function(outputId, width = '100%', height = '400px')
{
    htmlwidgets::shinyWidgetOutput(outputId, 'cyjShiny', width, height, package = 'cyjShiny')
}
#------------------------------------------------------------------------------------------------------------------------
#' More shiny plumbing -  a cyjShiny wrapper for htmlwidget standard rendering operation
#'
#' @param expr an expression that generates an HTML widget.
#' @param env environment in which to evaluate expr.
#' @param quoted logical specifies whether expr is quoted ("useuful if you want to save an expression in a variable").
#'
#' @return not sure
#'
#' @aliases renderCyjShiny
#' @rdname renderCyjShiny
#'
#' @export

renderCyjShiny <- function(expr, env = parent.frame(), quoted = FALSE)
{
   if (!quoted){
      expr <- substitute(expr)
      } # force quoted

  htmlwidgets::shinyRenderWidget(expr, cyjShinyOutput, env, quoted = TRUE)

}
#------------------------------------------------------------------------------------------------------------------------
#' load a standard cytoscape.js style file
#'
#' @param filename character string, either relative or absolute path.
#'
#' @return nothing
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   loadStyleFile(system.file(package="cyjShiny", "extdata", "yeastGalactoseStyle.js"))
#' }
#'
#' @aliases loadStyleFile
#' @rdname loadStyleFile
#'
#' @export

loadStyleFile <- function(filename)
{
   if(!file.exists(filename)){
      warning(sprintf("cannot read style file: %s", filename))
      return();
      }

   jsonText <- toJSON(fromJSON(filename))
   print(jsonText)
   message <- list(json=jsonText)
   session <- shiny::getDefaultReactiveDomain()
   session$sendCustomMessage("loadStyle", message)

} # loadStyleFile
#------------------------------------------------------------------------------------------------------------------------
#' Set zoom and center of the graph display so that graph fills the display.
#'
#' @param session a Shiny server session object.
#' @param padding integer, default 50 pixels.
#'
#' @examples
#' \dontrun{
#'   fit(session, 100)
#'}
#'
#' @aliases fit
#' @rdname fit
#'
#' @seealso\code{\link{fitSelected}}
#'
#' @export

fit <- function(session, padding=50)
{
   session$sendCustomMessage("fit", list(padding=padding))

} # fitSelected
#------------------------------------------------------------------------------------------------------------------------
#' Set zoom and center of the graph display so that the currently selected nodes fill the display
#'
#' @param session  a Shiny server session object.
#' @param padding integer, default 50 pixels.
#'
#' @examples
#' \dontrun{
#'   fitSelected(session, 100)
#' }
#'
#' @aliases fitSelected
#' @rdname fitSelected
#'
#' @seealso\code{\link{fit}}
#'
#' @export

fitSelected <- function(session, padding=50)
{
   session$sendCustomMessage("fitSelected", list(padding=padding))

} # fitSelected
#------------------------------------------------------------------------------------------------------------------------
#' Assign the supplied node attribute values to the graph structure contained in the browser.
#'
#' @param session a Shiny Server session object.
#' @param attributeName character string, the attribute to update.
#' @param nodes a character vector the names of the nodes whose attributes are updated.
#' @param values a character, logical or numeric vector, the new values.
#'
#' @examples
#' \dontrun{
#'   setNodeAttributes(session,
#'                     attributeName=attribute,
#'                     nodes=yeastGalactodeNodeIDs,
#'                     values=expression.vector)
#' }
#'
#' @aliases setNodeAttributes
#' @rdname setNodeAttributes
#'
#' @export

setNodeAttributes <- function(session, attributeName, nodes, values)
{
   session$sendCustomMessage(type="setNodeAttributes",
                             message=list(attribute=attributeName,
                                          nodes=nodes,
                                          values=values))
} # setNodeAttributes
#------------------------------------------------------------------------------------------------------------------------
#' Layout the current graph using the specified strategy.
#'
#' @param session a Shiny Server session object.
#' @param strategy a character string, one of cola, cose, circle, concentric, grid, breadthfirst, random, dagre, cose-bilkent.
#'
#' @examples
#' \dontrun{
#'   doLayout(session, "cola")
#' }
#' @aliases doLayout
#' @rdname doLayout
#'
#' @export

doLayout <- function(session, strategy)
{
   stopifnot(strategy %in% c("cola", "cose", "circle", "concentric", "grid", "breadthfirst", "random",
                             "dagre", "cose-bilkent"))

   session$sendCustomMessage(type="doLayout", message=list(strategy=strategy))

} # doLayout
#------------------------------------------------------------------------------------------------------------------------
