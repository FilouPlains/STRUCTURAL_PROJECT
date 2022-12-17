rm(list = ls())

library("viridis")

ss <- t(read.csv("PSIPRED/psipred.csv", header = FALSE))[, 1]
conf <- t(read.csv("PSIPRED/psipred.csv", header = FALSE))[, 2]
v_col <- viridis(3)

png("PSIPRED/psipred.png", width = 13, height = 5, units = "in", res = 200)

par(family = "Times")

RESOLUTION <- 5
AMP_REDUCTOR <- 1

filter <- seq_len(length(ss)) %% RESOLUTION == 0

barplot(
    conf[filter] / AMP_REDUCTOR + 0.5,
    col = v_col[ss + 1][filter],
    border = v_col[ss + 1][filter],
    ylim = c(0, 12),
    xlab = "",
    names.arg = (seq_len(length(ss)) + 818)[filter],
    axis.lty = 1,
    las = 2
)

box()

mtext("Residu index", font = 2, side = 1, line = 3)
mtext("Confidence level", font = 2, side = 2, line = 3)

legend(
    "top",
    legend = c("Coil", "Alpha helix", "Beta strand"),
    fill = v_col,
    horiz = TRUE,
    bty = "n"
)

dev.off()
