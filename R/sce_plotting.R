####################
#### UMAP plots ####
####################
plot_ind_dimred <- function(df, coord, pt_size, color, order, palette, title = "", ...) {
    
    # color by continuous or categorical
    if (is.numeric(df[, "color"])) {
        
        # Order the points if TRUE
        if (order)
            df <- df %>% dplyr::arrange(color)
        
        t <- scale_color_gradient(low = "#fffc9c", high = muted("red"))
        g <- NULL
    } else {
        
        palette_length <- RColorBrewer::brewer.pal.info[palette, "maxcolors"]
        color_length <- length(unique(df[, "color"]))
        # color theme
        if (color_length > palette_length) {
            palette_length <- RColorBrewer::brewer.pal.info[palette, "maxcolors"]
            mycolors <- colorRampPalette(
                RColorBrewer::brewer.pal(palette_length, palette))(color_length)
            t <- scale_color_manual(values = mycolors)
        } else {
            t <- scale_color_brewer(palette = palette)
        }
        
        # Guides
        g <- guides(color = guide_legend(override.aes = list(size = 3)))
        
    }
    
    # Plot
    p <- ggplot(df,
        aes_string(
            x = names(coord)[1],
            y = names(coord)[2],
            color = "color")) +
        ggrastr::geom_point_rast(size = pt_size, ...) +
        # Set color
        t +
        g +
        labs(title = title) +
        theme_classic()
}


plotDimRed <- function(
    x,
    color,
    pt_size = 1,
    dim = "UMAP",
    order = TRUE,
    ncol = NULL,
    palette = "Set2",
    assay = "logcounts",
    ...) {
    
    # Extract data from sce
    df <- colData(x) %>%
        data.frame()
    
    # Extract dim
    # dim <- match.arg(dim)
    coord <- data.frame(reducedDim(x, type = dim))
    names(coord) <- paste(dim, 1:ncol(coord), sep = "_")
    
    # Add coordinates
    df <- cbind(df, coord)
    
    if (length(color) > 1) {
        plt_ls <- lapply(color, function(i) {
            # color vector
            if (i %in% colnames(df)) {
                df[, "color"] <- df[, i]
            } else if (i %in% rownames(x)) {
                df[, "color"] <- assay(x, assay)[i, ]
            } else {
                warning(paste("Feature", i, "not present"))
            }
            
            # Return plot
            plot_ind_dimred(
                df = df,
                coord = coord,
                pt_size = pt_size,
                color = color,
                order = order,
                title = i,
                palette = palette,
                ...)
            
        })
        
        p <- patchwork::wrap_plots(plt_ls, ncol = ncol)
        
    } else {
        # color vector
        if (color %in% colnames(df)) {
            df[, "color"] <- df[, color]
        } else if (color %in% rownames(x)) {
            df[, "color"] <- assay(x, assay)[color, ]
        } else {
            warning(paste("Feature", color, "not present"))
        }
        
        p <- plot_ind_dimred(
            df = df,
            coord = coord,
            pt_size = pt_size,
            color = color,
            order = order,
            title = color,
            palette = palette,
            ...)
    }
    
    p
}

# plotDimRed(x = sce, color = c("leiden_0.05", "leiden_0.1"))

######################
#### Violin plots ####
######################
plot_ind_vln <- function(df, group, feat, color_by = group, palette, title = "",  ...) {
    
    palette_length <- RColorBrewer::brewer.pal.info[palette, "maxcolors"]
    nb.cols <- length(unique(df[, color_by]))
    # color theme
    if (nb.cols > palette_length) {
        # Expand color palette 
        mycolors <- colorRampPalette(
            RColorBrewer::brewer.pal(palette_length, palette))(nb.cols)
        t1 <- scale_fill_manual(values = mycolors)
        t2 <- scale_color_manual(values = mycolors)
    } else {
        t1 <- scale_fill_brewer(palette = palette)
        t2 <- scale_color_brewer(palette = palette)
    }
    
    p <- ggplot(df,
        aes_string(
            x = group,
            y = "color",
            fill = color_by),
        ...) +
        geom_violin(alpha = 0.7, width = 1) +
        geom_boxplot(
            color = "#2b2b2b",
            alpha = 0,
            outlier.shape = NA,
            width = .1) +
        t1 +
        t2 +
        labs(title = feat) +
        theme_classic()
    p
}

plotVln <- function(
    x,
    group,
    feats,
    color_by = group,
    pt_size = NULL,
    ncol = NULL,
    palette = "Set2",
    assay = "logcounts",
    ...) {
    
    # Extract data from sce
    df <- colData(x) %>%
        data.frame()
    
    # Extract features
    # fi <- intersect(feats, colnames(colData(x)))
    
    # Extract gene expression
    # gi <- intersect(feats, rownames(x))
    # lc_mtrx <- logcounts(x)
    
    # exp_mtrx <- as.matrix(t(lc_mtrx[gi, ]))
    
    # Add gene expression to dataframe
    # df <- cbind(df, exp_mtrx)
    
    plt_ls <- lapply(feats, function(i) {
        
        if (i %in% colnames(df)) {
            df[, "color"] <- df[, i]
        } else if (i %in% rownames(x)) {
            df[, "color"] <- assay(x, assay)[i, ]
        } else {
            warning(paste("Feature", i, "not present"))
        }
        
        plot_ind_vln(
            df = df,
            group = group,
            feat = i,
            color_by = color_by,
            palette = palette,
            title = i)
    })
    patchwork::wrap_plots(plt_ls, ncol = ncol)
}
