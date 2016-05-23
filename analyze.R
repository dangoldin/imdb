library(ggplot2)
library(grid)
library(gridExtra)
library(reshape)
library(scales)
library(lattice)
library(ggthemes)
library(data.table)
library(dplyr)

setwd("/Users/danielgoldin/Dropbox/dev/web/imdb/data")

data_year_age = read.csv("year_age.csv", header=FALSE)
names(data_year_age) <- c("gender","production_year","avg_age","count","num_movies")

png('year-age.png', width=800, height=800)
ggplot(data=data_year_age, aes(x=production_year, y=avg_age, color=gender)) +
  geom_line() +
  theme_few() + scale_colour_few() +
  xlab('Production Year') +
  ylab('Avg Age') +
  ggtitle("Avg Age by Gender") +
  theme(legend.title=element_blank())
dev.off()

data_year_age_100 = read.csv("year_age_min_100.csv", header=FALSE)
names(data_year_age_100) <- c("gender","production_year","avg_age","count","num_movies")

png('year-age-min-100.png', width=800, height=800)
ggplot(data=data_year_age_100, aes(x=production_year, y=avg_age, color=gender)) +
  geom_line() +
  theme_few() + scale_colour_few() +
  xlab('Production Year') +
  ylab('Avg Age') +
  ggtitle("Avg Age by Gender (Min 100 Movies)") +
  theme(legend.title=element_blank())
dev.off()

data_gender_age = read.csv("gender_age.csv", header=FALSE)
names(data_gender_age) <- c("gender","age","count","num_movies")
data_gender_age = group_by(data_gender_age, gender) %>% mutate(percent = count/sum(count))

png('age-gender.png', width=800, height=800)
ggplot(data=data_gender_age, aes(x=age, y=percent, fill=gender, color=gender)) +
  geom_bar(stat="identity", position="identity", alpha = 0.4) +
  theme_few() + scale_colour_few() +
  xlab('Age') +
  ylab('Frequency') +
  ggtitle("Age Distribution by Gender") +
  scale_y_continuous(labels=percent_format()) +
  theme(legend.title=element_blank())
dev.off()

data_gender_age_decade = read.csv("gender_age_decade.csv", header=FALSE)
names(data_gender_age_decade) <- c("decade", "gender","age","count","num_movies")
data_gender_age_decade = group_by(data_gender_age_decade, decade, gender) %>% mutate(percent = count/sum(count))

png('age-gender-decade-all.png', width=800, height=800)
ggplot(data=data_gender_age_decade, aes(x=age, y=percent, fill=gender, color=gender)) +
  geom_bar(stat="identity", position="identity", alpha = 0.4) +
  theme_few() + scale_colour_few() +
  facet_grid(decade ~ .) +
  xlab('Age') +
  ylab('Frequency') +
  ggtitle("Age Distribution by Gender") +
  scale_y_continuous(labels=percent_format()) +
  theme(legend.title=element_blank())
dev.off()

decades <- unique(data_gender_age_decade$decade)
max_age <- max(data_gender_age$age)

for (decade in decades) {
  d = data_gender_age_decade[data_gender_age_decade$decade==decade,]
  p <- ggplot(data=d, aes(x=age, y=percent, fill=gender, color=gender)) +
    geom_bar(stat="identity", position="identity", alpha = 0.4) +
    theme_few() + scale_colour_few() +
    xlab('Age') +
    ylab('Frequency') +
    ggtitle(sprintf("Age Distribution by Gender - %d", decade)) +
    scale_y_continuous(labels=percent_format(), limits=c(0, 0.12)) +
    scale_x_continuous(limits=c(0, max_age)) +
    theme(legend.title=element_blank())

  ggsave(filename=sprintf("age-gender-decade-%d.jpg", decade), plot=p, width=8, height=8, units="in", dpi=300)
}

data_prod_year_height = read.csv("gender_prod_year_height.csv", header=FALSE)
names(data_prod_year_height) <- c("gender","production_year","avg_height","count","num_movies")

png('gender-production-year-height.png', width=800, height=800)
ggplot(data=data_prod_year_height, aes(x=production_year, y=avg_height, color=gender)) +
  geom_line() +
  theme_few() + scale_colour_few() +
  xlab('Production Year') +
  ylab('Avg Height (inches)') +
  ggtitle("Avg Height by Gender") +
  theme(legend.title=element_blank())
dev.off()

data_birth_year_height = read.csv("gender_birth_year_height.csv", header=FALSE)
names(data_birth_year_height) <- c("gender","birth_year","avg_height","count","num_movies")

png('gender-birth-year-height.png', width=800, height=800)
ggplot(data=data_birth_year_height, aes(x=birth_year, y=avg_height, color=gender)) +
  geom_line() +
  theme_few() + scale_colour_few() +
  xlab('Birth Year') +
  ylab('Avg Height (inches)') +
  ggtitle("Avg Height by Gender") +
  theme(legend.title=element_blank())
dev.off()

data_num_movies = read.csv("gender_num_movies.csv", header=FALSE)
names(data_num_movies) <- c("gender","num_movies","count")
data_num_movies$log_count = log(data_num_movies$count)
data_num_movies = group_by(data_num_movies, gender) %>% mutate(log_count_percent = log_count/sum(log_count))

png('gender-num-movies.png', width=800, height=800)
ggplot(data=data_num_movies, aes(x=num_movies, y=log_count_percent, fill=gender, color=gender)) +
  geom_bar(stat="identity", position="identity", alpha = 0.4) +
  theme_few() + scale_colour_few() +
  xlab('# Movies') +
  ylab('Frequency (log(count))') +
  ggtitle("Actors/Actresses by # Movies") +
  scale_y_continuous(labels=percent_format()) +
  theme(legend.title=element_blank())
dev.off()
