library(keras)
library(dplyr)
library(ggplot2)
library(tensorflow)
library(tidyverse)
library(imager)

reticulate::use_python("D:\\Anaconda\\envs\\tf_image", required = TRUE)

setwd("D:\\dev\\Podyplomowe\\Deep Learning\\Deep-Learning-\\mushroom_dataset")

folder_list <- list.files()
folder_path <- paste0(getwd(),"/", folder_list, "/")
folder_path

file_name <- map(folder_path, 
                 function(x) paste0(x, list.files(x))
                 ) %>%
  unlist()

set.seed(99)
sample_image <- sample(file_name, 6)

img <- map(sample_image, load.image)

par(mfrow = c(2, 3))
map(img, plot)

img <- load.image(file_name[1])
dim(img)
