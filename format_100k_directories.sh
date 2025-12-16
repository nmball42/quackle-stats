# Format 100,000_CSW15_scrabble_games_Quackle_Speedy_Player.7z to be usable by quackle_stats.sh
#
# Assume fresh copy of decompressed .7z -> 100,000_CSW15_scrabble_games_Quackle_Speedy_Player/
# Then this script is run once
# Takes ~ 10 minutes to run on 2023 MacBook Pro
#
# Create 100 subdirectories of 1000 files each (so can use in xargs and easier to navigate)
# Separate .report and .gcg
# Convert DOS to UNIX line endings
#
# Sep 03rd 2025

dir=$HOME/Data/Quackle/100,000_CSW15_scrabble_games_Quackle_Speedy_Player/games_Speedy_Player_16.03_01.04.40

cd $dir
mkdir gcg report

# Files are Speedy_Player-game-{0, 1, ..., 99999}.gcg and same for .report

for idir in {0..99}; do

    idir_0=$(printf "%02d" "$idir")
    echo $idir_0

    mkdir gcg/$idir_0
    mkdir report/$idir_0

    # Files 0-999, 1000-1999, ..., 99000-99999
    start_file=$((1000 * idir))
    end_file=$((start_file + 999))

    # tr needs intermediate file, e.g., tr -d '\r' < input.txt > tmp.txt && mv tmp.txt input.txt
    # sed on Mac needs -i '' -e for in place

    for ifile in $(seq $start_file $end_file); do

        sed -i '' -e "s/\r$//g" Speedy_Player-game-$ifile.gcg
        sed -i '' -e "s/\r$//g" Speedy_Player-game-$ifile.report

        mv Speedy_Player-game-$ifile.gcg    gcg/$idir_0
        mv Speedy_Player-game-$ifile.report report/$idir_0

    done

done