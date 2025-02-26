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
json.r = fromJSON(current.filename)
features = tibble(
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


