findSubCluster <- function(
    object,
    cluster,
    dimred = "PCA",
    res_sub = 0.25) {
    # Extract cell ids to recluster
    sub.cell <- colnames(object[, colData(object)[, res] == cluster])
    # build graph bewteen cells
    g <- buildSNNGraph(
        object[, sub.cell],
        use.dimred = dimred,
        k = 10,
        BPPARAM = MulticoreParam())
    # Find subclusters for the resolution desired using Leiden
    clust <- igraph::cluster_leiden(
        graph = g,
        objective_function = "modularity",
        resolution_parameter = res_sub)$membership
    # Update cluster name
    clust <- paste(cluster, clust, sep = "_")
    # Update colData name
    cname <- glue::glue("{res}_sub_{cluster}")
    colData(object)[sub.cell, cname] <- clust
    colData(object)[, cname] <- dplyr::if_else(is.na(colData(object)[, cname]),
        colData(object)[, res],
        colData(object)[, cname])
    return(object)
}
