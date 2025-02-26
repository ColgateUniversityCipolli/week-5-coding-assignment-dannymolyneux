# Homework 5

#install.packages("tidyverse")
library(tidyverse)
#install.packages("jsonlite")
library(jsonlite)
#install.packages("stringr")
library(stringr)

current.filename = "EssentiaOutput/The Front Bottoms-Talon Of The Hawk-Au Revoir (Adios).json"

file.parts = str_split(current.filename, "-")[[1]] #gets the track, artist, and album
track.json = file.parts[length(file.parts)] #track name with the .json
track.name = str_sub(track.json, start = 1, end = length(track.name) - 7) #just track name
track.album = file.parts[length(file.parts) - 1] #album name
artist = file.parts[length(file.parts) - 2] #artist name with "EssentiaOutput/"
track.artist = str_split(artist, "/")[[1]][[2]] #just artist name
#track.name
#track.album
#track.album
json.r = fromJSON(current.filename) #processes the json file
features = tibble( #data frame containing each feature for the json file
  overall_loudness = json.r$lowlevel$loudness_ebu128$integrated,
  spectral_energy = json.r$lowlevel$spectral_energy,
  dissonance = json.r$lowlevel$dissonance,
  pitch_salience = json.r$lowlevel$pitch_salience,
  bpm = json.r$rhythm$bpm,
  beats_loudness = json.r$rhythm$beats_loudness,
  danceability = json.r$rhythm$danceability,
  tuning_frequency = json.r$tonal$tuning_frequency
)
#view(features)

#step 2
files = list.files("EssentiaOutput", pattern = ".json") #gets a list of all files from EssentiaOutput
#lapply will apply all of these methods to each file in files
json.df <- lapply(files, function(file) { #data frame that will have info for each song
  json <- fromJSON(paste("EssentiaOutput/", file, sep = "")) #variable for each new file
  file.parts <- str_split(basename(file), "-")[[1]] #gives just the file parts, not the "EssentiaOutput/"
  track.json <- file.parts[length(file.parts)] #track name with .json
  track <- str_sub(track.json, start = 1, end = length(track.name) - 7) #just track name
  album <- file.parts[length(file.parts) - 1] #album name
  artist <- file.parts[length(file.parts) - 2] #artist name
  #features
  overall_loudness <- json$lowlevel$loudness_ebu128$integrated
  spectral_energy <- json$lowlevel$spectral_energy$mean
  dissonance <- json$lowlevel$dissonance$mean
  pitch_salience <- json$lowlevel$pitch_salience$mean
  bpm <- json$rhythm$bpm
  beats_loudness <- json$rhythm$beats_loudness$mean
  danceability <- json$rhythm$danceability
  tuning_frequency <- json$tonal$tuning_frequency
  #tibble to make sure we only have columns for the relevant variables
  tibble(
    track,
    album,
    artist,
    overall_loudness,
    spectral_energy,
    dissonance,
    pitch_salience,
    bpm,
    beats_loudness,
    danceability,
    tuning_frequency,
  )
})
json.df = bind_rows(json.df)
view(json.df)

#step 3
essentia.data = read_csv("EssentiaOutput/EssentiaModelOutput.csv") #all essentia data
#view(essentia.data)
essentia.data <- essentia.data %>% #super pipe
  mutate(
    #gets the mean of all columns ending with that name
    valence = rowMeans(select(., ends_with("valence"))),
    arousal = rowMeans(select(., ends_with("arousal"))),
    #gets the mean of all columns ending with that name excpet for the "not" columns
    happy = rowMeans(select(., ends_with("happy") & !contains("not"))),
    aggressive = rowMeans(select(., ends_with("aggressive") & !contains("not"))),
    party = rowMeans(select(., ends_with("party") & !contains("not"))),
    relaxed = rowMeans(select(., ends_with("relax") & !contains("not"))),
    sad = rowMeans(select(., ends_with("sad") & !contains("not"))),
    acoustic = rowMeans(select(., ends_with("acoustic") & !contains("not"))),
    electric = rowMeans(select(., ends_with("electronic") & !contains("not"))),
    instrumental = rowMeans(select(., ends_with("instrumental") & !contains("not"))),
  ) |>
 rename(timbreBright = "eff_timbre_bright") |> #rename the column
 select(-c(4:47)) |> #remove columns
 select(-eff_timbre_dark) #remove last unnecessary column
#view(essentia.data)

#step 4



