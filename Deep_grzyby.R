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

get_dim <- function(x){
  img <- load.image(x)
  df_img <- data.frame(img_height = height(img),
                       img_width = width(img),
                       filename = x)
  return(df_img)
}

get_dim(file_name[1])


sample_file <- sample(file_name, 1000)
file_dim <- map_df(sample_file, get_dim)

summary(file_dim)

#Data augmentation
target_size <- c(125, 125)

batch_size <- 16

train_data_gen <- image_data_generator(rescale = 1/255,
                                       horizontal_flip = T,
                                       vertical_flip = T,
                                       rotation_range = 180,
                                       zoom_range = 0.25,
                                       validation_split = 0.2)

train_image_array_gen <- flow_images_from_directory(directory = getwd(),
                                                    target_size = target_size,
                                                    color_mode = 'rgb',
                                                    batch_size = batch_size,
                                                    seed = 99,
                                                    subset = 'training',
                                                    generator = train_data_gen
                                                    )

val_image_array_gen <- flow_images_from_directory(directory = getwd(),
                                                  target_size = target_size,
                                                  color_mode = 'rgb',
                                                  batch_size = batch_size,
                                                  seed = 99,
                                                  subset = 'validation',
                                                  generator = train_data_gen
                                                  )


