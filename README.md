# Statistics of 100k Quackle games

Last updated: Dec 17th 2025

An interest outside geospatial data science is tournament Scrabble, and a dataset of 100,000 games of the computer versus itself is available. This set of scripts takes advantage of the standard `.gcg` game file format to find interesting games in this dataset, which is roughly equivalent to a lifetime of play for an active human gamer. Since computer play is similar to high-level human play, it shows what sorts of games might happen “once in a lifetime”.

## Requirements

- Machine that can run `bash` shell scripts and Quackle app
- Dataset `100,000_CSW15_scrabble_games_Quackle_Speedy_Player.7z`

## Setup

- Terminal in `bash` shell
- Change line `dir=$HOME/Data/Quackle/100,000_CSW15_scrabble_games_Quackle_Speedy_Player/games_Speedy_Player_16.03_01.04.40` in `format_100k_directories.sh` to your location of this directory
- Same for `basedir=$HOME/Data/Quackle/100,000_CSW15_scrabble_games_Quackle_Speedy_Player/games_Speedy_Player_16.03_01.04.40/gcg` in `quackle_stats.sh` (note additional `/gcg`)
- Create directory `$HOME/tmp` or set `tmp=$HOME/tmp` to an existing directory in `quackle_stats.sh`

Optional

- To view `.gcg` files as boards, download and install [Quackle](https://people.csail.mit.edu/jasonkb/quackle/)

## Run

From the terminal

- `bash format_100k_directories.sh`. This creates from the original dataset 100 subdirectories `00`-`99` with 1000 `.gcg` files in each.
- `bash quackle_stats.sh`. This outputs the stats to the terminal (`stdout`).

The number of rows to show in the table for each category can be adjusted by changing `ntoshow=20`.

Each output stat refers to a `.gcg` file which can be viewed in Quackle.

## Improvements

- Sanity check each of the 100k `.gcg`s conforms to the `.gcg` format
- More games: 1 million+ could be generated, or use such a dataset if it exists already (maybe Woogles Discord)
- More stats: `quackle_stats.sh` lists over 30 more ideas
- Stronger player: Quackle speedy player is limited → Woogles BestBot with GPUs?
- Update CSW15 to the latest version of the lexicon, CSW24
- Other lexica: North American English (NWL), other languages
- Look at the distributions of values: are they Gaussian, skew-Gaussian, something else?
- Related to this, are there any true anomalies, i.e., values beyond what would be expected to be the outliers of a distribution in 100k games or any number of games? The 845 game might be an example for 100k.
- Compare to humans using [cross-tables](cross-tables.com)
- Speedups: multithreading, Parquet/similar, GPU

