library('h2o')
library('dplyr')

h2o.init(nthreads = -1,
         max_mem_size = '4G')

h2o.clusterInfo()

setwd('D:/dev/Podyplomowe/Deep Learning/Deep-Learning-')
data.set <- read.csv('mushroom.csv') %>% mutate(across(everything(), as.factor))

str(data.set)

mushroom.hex <- as.h2o(data.set, destination_frame = 'mushroom.hex')

mushroom.split <- h2o.splitFrame(data = mushroom.hex,
                                 ratios = 0.8)

mushroom.train <- mushroom.split[[1]]
mushroom.test <- mushroom.split[[2]]

model <- h2o.deeplearning(x = 1:22,
                          y = 23,
                          training_frame = mushroom.train,
                          validation_frame = mushroom.test,
                          distribution = 'multinomial',
                          activation = 'RectifierWithDropout',
                          hidden = c(200, 200, 200),
                          input_dropout_ratio = 0.2,
                          l1 = 1e-5,
                          epochs = 20,
                          variable_importances = TRUE)

model@parameters
h2o.mse(model, valid = TRUE)

pred <- h2o.predict(object = model,
                    newdata = mushroom.test)

pred[,1]
mushroom.test[,23]

head(pred)

Conf.matrix <- table(as.data.frame(pred[,1])[,1], 
                     as.data.frame(mushroom.test[,23])[,1])

Conf.matrix

h2o.performance(model, valid = TRUE)

summary(model)

h2o.shutdown(prompt = TRUE)

