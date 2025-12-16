#!/bin/bash
#
# Quackle Stats
#
# bash $HOME/Common/Projects/Quackle_100k_games/quackle_stats.sh <integer {1,2, ... 13}>
#
# Takes ~ 1-2s per 1000 games to run
# Hard to quit because is calling awk, etc., subcommands many times (quit the terminal tab to stop it)
# Won't pick games not in .gcg format, e.g., .txt or .tiff screenshots
# If values same, sorting depends on the content of the tmpfile, e.g., score probably file order but longest primary words probably string order
# Does not recurse into subdirectories of the directories listed
# Run with bash not sh to pick up, e.g., echo -e
#
# Assumptions
#
# Player names contain "Nick" and "Quackle"
# File list can be parsed by xargs: not too many in dir, no spaces or quotes in filenames
# tmp dir exists
#
# History
#
# Jan 31st 2009
# Jul 14th 2013: Updated, csh -> bash; based on Scrabble/csh/quackle_stats.csh
# Apr 22nd 2017: Updated; allow combined stats from multiple directories; output file each stat is from
# Aug 27th 2020: Added dirs since 2017 v1.0.3/Quackle_2017_desktop ... v1.0.4/Quackle_2020
# Aug 28th 2020: Added integer input argument to say which stat to run. Run with sh not bash for now
#                Added stats 4-13 (longest words - spreads)
# Aug 30th 2020: Moved to $HOME/Not_Work/Scrabble/stats/quackle from ../../bash/
# Sep 03rd 2025: Move to $HOME/Common/Projects
#                Update dirs() to current: add v1.0.4/Quackle_2020 ... v1.0.4/Quackle_2025
#                echo -> echo -e
#                Indent loops properly
#                Add player name as setting: removes duplicate options deriving Quackle and Nick stats, enables 100k games players A & B
#                Should match .gcg LHS whole or part, e.g., "Nick" will find this and "Nick_Ball"
#                Specify both players as some stats need both, e.g., combined score
#                Add #!/bin/bash
#
# Improvements
#
# Make some plots
# Named stat args as options (1 or more) not single integer (e.g., https://www.baeldung.com/linux/use-command-line-arguments-in-bash-script)
# Each stat as a function
# Sorting of output more explicit on values and files in tmpfile
# List of dirs in text file
# Other settings as optional args
# Check gcgs are correct format
# Long words formed by hooks are missed


# Settings
# --------

# All CSW directory set

# basedir=$HOME/Not_Work/Scrabble/quackle
# dirs=( \
#     v0.90/csw \
#     v0.92/csw \
#     v0.93/csw \
#     v0.941/csw \
#     v0.95/csw \
#     v0.95/csw/desktop \
#     v0.951/csw \
#     v0.96/csw/2008 \
#     v0.96/csw/2009 \
#     v0.96/csw/2010 \
#     v0.96/csw/2011 \
#     v0.96/csw/desktop \
#     v0.97/2011 \
#     v0.97/2012 \
#     v0.97/2013 \
#     v0.97/2014 \
#     v0.97/desktop \
#     v0.98/2014 \
#     v0.98/2015 \
#     v1.0.1/Quackle_2015 \
#     v1.0.1/Quackle_2016 \
#     v1.0.3/Quackle_2016 \
#     v1.0.3/Quackle_2017 \
#     v1.0.3/Quackle_2017_desktop \
#     v1.0.3/Quackle_2018 \
#     v1.0.3/Quackle_2018_desktop \
#     v1.0.3/Quackle_2019 \
#     v1.0.4/Quackle_2019 \
#     v1.0.4/Quackle_2020 \
#     v1.0.4/Quackle_2021 \
#     v1.0.4/Quackle_2022 \
#     v1.0.4/Quackle_2023 \
#     v1.0.4/Quackle_2024 \
#     v1.0.4/Quackle_2025 \
# )
# player_a_name="Quackle"
# player_b_name="Nick"

# 100k games set
# Takes ~ 1-2s per directory

basedir=$HOME/Data/Quackle/100,000_CSW15_scrabble_games_Quackle_Speedy_Player/games_Speedy_Player_16.03_01.04.40/gcg
# dirs=( 00 )
# dirs=( 00 01 02 03 04 05 06 07 08 09 )
dirs=( \
00 01 02 03 04 05 06 07 08 09 \
10 11 12 13 14 15 16 17 18 19 \
20 21 22 23 24 25 26 27 28 29 \
30 31 32 33 34 35 36 37 38 39 \
40 41 42 43 44 45 46 47 48 49 \
50 51 52 53 54 55 56 57 58 59 \
60 61 62 63 64 65 66 67 68 69 \
70 71 72 73 74 75 76 77 78 79 \
80 81 82 83 84 85 86 87 88 89 \
90 91 92 93 94 95 96 97 98 99 \
)
player_a_name="A"
player_b_name="B"

# Other settings

ntoshow=20
tmp=$HOME/tmp

# Generic setup

player_a_str=">${player_a_name}" # grep instances of player name in the .gcg left-hand side of line that starts with ">"
player_b_str=">${player_b_name}"


# Highest and lowest game scores
# ------------------------------

# Player A

if [ $1 -eq 1 ]; then
    
    if [ -f $tmp/tmp_quackle_stats.dat ]; then
	    rm -f $tmp/tmp_quackle_stats.dat
    fi

    for dir in ${dirs[@]}; do

        #echo $dir

	    cd $basedir/$dir
	    files=`ls *.gcg | xargs`

	    for file in $files; do
	        grep $player_a_str $file | tail -1 | awk '{print $NF,basedir"/"dir"/"file}' basedir=$basedir dir=$dir file=$file >> $tmp/tmp_quackle_stats.dat
	    done

    done
    
    echo -e '\nHighest game scores for '${player_a_name}':\n'
    cat $tmp/tmp_quackle_stats.dat | sort -nr | head -$ntoshow

    echo -e '\nLowest game scores for '${player_a_name}':\n'
    cat $tmp/tmp_quackle_stats.dat | sort -n | head -$ntoshow

fi

# Player B

if [ $1 -eq 2 ]; then

    if [ -f $tmp/tmp_quackle_stats.dat ]; then
	    rm -f $tmp/tmp_quackle_stats.dat
    fi

    for dir in ${dirs[@]}; do

        #echo $dir

	    cd $basedir/$dir
	    files=`ls *.gcg | xargs`

	    for file in $files; do
	        grep $player_b_str $file | tail -1 | awk '{print $NF,basedir"/"dir"/"file}' basedir=$basedir dir=$dir file=$file >> $tmp/tmp_quackle_stats.dat
	    done

    done

    echo -e '\nHighest game scores for '${player_b_name}':\n'
    cat $tmp/tmp_quackle_stats.dat | sort -nr | head -$ntoshow

    echo -e '\nLowest game scores for '${player_b_name}':\n'
    cat $tmp/tmp_quackle_stats.dat | sort -n | head -$ntoshow

fi


# Combined Scores
# ---------------

# Highest and lowest
# Could also print the game scores

if [ $1 -eq 3 ]; then

    if [ -f $tmp/tmp_quackle_stats.dat ]; then
	    rm -f $tmp/tmp_quackle_stats.dat
    fi

    for dir in ${dirs[@]}; do

        #echo $dir

	    cd $basedir/$dir
	    files=`ls *.gcg | xargs`

	    for file in $files; do
	        a=`grep $player_a_str $file | tail -1 | awk '{print $NF}'`
	        b=`grep $player_b_str $file | tail -1 | awk '{print $NF+a}' a=$a`
	        echo $b $basedir/$dir/$file >> $tmp/tmp_quackle_stats.dat
	    done

    done

    echo -e '\nHighest combined scores:\n'
    cat $tmp/tmp_quackle_stats.dat | sort -nr | head -$ntoshow

    echo -e '\nLowest combined scores:\n'
    cat $tmp/tmp_quackle_stats.dat | sort -n | head -$ntoshow

fi


# Longest primary words
# ---------------------

# Finds longest primary words, so if extended by a perpendicular move it won't see it
# Doesn't show word, but the form like ".......FINAL" from the .gcg
# Can see the whole word by opening the .gcg in Quackle
# NF==6 misses passes and exchanges but doesn't matter here

# Player A

if [ $1 -eq 4 ]; then

    if [ -f $tmp/tmp_quackle_stats.dat ]; then
	    rm -f $tmp/tmp_quackle_stats.dat
    fi

    for dir in ${dirs[@]}; do

        #echo $dir

	    cd $basedir/$dir
	    files=`ls *.gcg | xargs`

	    for file in $files; do
	        grep $player_a_str $file | awk 'NF==6 {print length($4),$4,basedir"/"dir"/"file}' basedir=$basedir dir=$dir file=$file >> $tmp/tmp_quackle_stats.dat
	    done

    done

    echo -e '\nLongest primary words for '${player_a_name}':\n'
    cat $tmp/tmp_quackle_stats.dat | sort -nr | head -$ntoshow

fi

# Player B

if [ $1 -eq 5 ]; then

    if [ -f $tmp/tmp_quackle_stats.dat ]; then
	    rm -f $tmp/tmp_quackle_stats.dat
    fi

    for dir in ${dirs[@]}; do

        #echo $dir

	    cd $basedir/$dir
	    files=`ls *.gcg | xargs`

	    for file in $files; do
	        grep $player_b_str $file | awk 'NF==6 {print length($4),$4,basedir"/"dir"/"file}' basedir=$basedir dir=$dir file=$file >> $tmp/tmp_quackle_stats.dat
	    done

    done

    echo -e '\nLongest primary words for '${player_b_name}':\n'
    cat $tmp/tmp_quackle_stats.dat | sort -nr | head -$ntoshow

fi


# Highest scoring moves
# ---------------------

# Not lowest moves because those are exchanges
# NF==6 misses passes and exchanges but doesn't matter here
# Also print the (primary) word played

# Player A

if [ $1 -eq 6 ]; then

    if [ -f $tmp/tmp_quackle_stats.dat ]; then
	    rm -f $tmp/tmp_quackle_stats.dat
    fi

    for dir in ${dirs[@]}; do

        #echo $dir

	    cd $basedir/$dir
	    files=`ls *.gcg | xargs`

	    for file in $files; do
	        grep $player_a_str $file | awk 'NF==6 {print substr($(NF-1),2,length($(NF-1))),$4,basedir"/"dir"/"file}' basedir=$basedir dir=$dir file=$file >> $tmp/tmp_quackle_stats.dat
	    done

    done

    echo -e '\nHighest scoring moves for '${player_a_name}':\n'
    cat $tmp/tmp_quackle_stats.dat | sort -nr | head -$ntoshow

fi

# Player B

if [ $1 -eq 7 ]; then

    if [ -f $tmp/tmp_quackle_stats.dat ]; then
	    rm -f $tmp/tmp_quackle_stats.dat
    fi

    for dir in ${dirs[@]}; do

        #echo $dir

	    cd $basedir/$dir
	    files=`ls *.gcg | xargs`

	    for file in $files; do
	        grep $player_b_str $file | awk 'NF==6 {print substr($(NF-1),2,length($(NF-1))),$4,basedir"/"dir"/"file}' basedir=$basedir dir=$dir file=$file >> $tmp/tmp_quackle_stats.dat
	    done
	
    done

    echo -e '\nHighest scoring moves for '${player_b_name}':\n'
    cat $tmp/tmp_quackle_stats.dat | sort -nr | head -$ntoshow

fi


# Number of game moves
# --------------------

# Lowest and highest
# Could do moves for each player as well but not much different

if [ $1 -eq 8 ]; then

    if [ -f $tmp/tmp_quackle_stats.dat ]; then
	    rm -f $tmp/tmp_quackle_stats.dat
    fi

    for dir in ${dirs[@]}; do

        #echo $dir

	    cd $basedir/$dir
	    files=`ls *.gcg | xargs`

	    for file in $files; do	
	        m=`awk 'NF==6 || $4=="+0"' $file | wc -l`
	        echo $m $basedir/$dir/$file >> $tmp/tmp_quackle_stats.dat
	    done

    done

    echo -e '\nLowest number of game moves:\n'
    cat $tmp/tmp_quackle_stats.dat | sort -n | head -$ntoshow

    echo -e '\nHighest number of game moves:\n'
    cat $tmp/tmp_quackle_stats.dat | sort -nr | head -$ntoshow

fi


# Average score per move
# ----------------------

# Highest and lowest
# Print to 2 decimal places

# Player A

if [ $1 -eq 9 ]; then

    if [ -f $tmp/tmp_quackle_stats.dat ]; then
	    rm -f $tmp/tmp_quackle_stats.dat
    fi

    for dir in ${dirs[@]}; do

        #echo $dir

	    cd $basedir/$dir
	    files=`ls *.gcg | xargs`

	    for file in $files; do	
	        turns1=`grep $player_a_str $file | awk 'NF==6 || $4=="+0"' | wc -l`
	        turns2=`echo $turns1 | awk '{print substr($1,1,length($1))}'` # Needed to get, e.g., "9", "10", etc., and not " 9", " 10", etc., for awk
	        score=`grep $player_a_str $file | tail -1 | awk '{print $NF}'`
	        asm=`echo | awk '{printf "%.2f\n",score/turns2}' score=$score turns2=$turns2`
	        echo $asm $basedir/$dir/$file >> $tmp/tmp_quackle_stats.dat
	    done

    done

    echo -e '\nHighest average scores per move for '${player_a_name}':\n'
    cat $tmp/tmp_quackle_stats.dat | sort -nr | head -$ntoshow

    echo -e '\nLowest average scores per move for '${player_a_name}':\n'
    cat $tmp/tmp_quackle_stats.dat | sort -n | head -$ntoshow

fi

# Player B

if [ $1 -eq 10 ]; then

    if [ -f $tmp/tmp_quackle_stats.dat ]; then
	    rm -f $tmp/tmp_quackle_stats.dat
    fi

    for dir in ${dirs[@]}; do

        #echo $dir

	    cd $basedir/$dir
	    files=`ls *.gcg | xargs`

	    for file in $files; do	
	        turns1=`grep $player_b_str $file | awk 'NF==6 || $4=="+0"' | wc -l`
	        turns2=`echo $turns1 | awk '{print substr($1,1,length($1))}'`
    	    score=`grep $player_b_str $file | tail -1 | awk '{print $NF}'`
	        asm=`echo | awk '{printf "%.2f\n",score/turns2}' score=$score turns2=$turns2`
	        echo $asm $basedir/$dir/$file >> $tmp/tmp_quackle_stats.dat
	    done

    done
    
    echo -e '\nHighest average scores per move for '${player_b_name}':\n'
    cat $tmp/tmp_quackle_stats.dat | sort -nr | head -$ntoshow

    echo -e '\nLowest average scores per move for '${player_b_name}':\n'
    cat $tmp/tmp_quackle_stats.dat | sort -n | head -$ntoshow

fi


# Highest losing scores
# ---------------------

# Could also do lowest winning scores

# Player A

if [ $1 -eq 11 ]; then

    if [ -f $tmp/tmp_quackle_stats.dat ]; then
    	rm -f $tmp/tmp_quackle_stats.dat
    fi

    for dir in ${dirs[@]}; do

        #echo $dir

    	cd $basedir/$dir
    	files=`ls *.gcg | xargs`

    	for file in $files; do
    	    scorea=`grep $player_a_str $file | tail -1 | awk '{print $NF}'`
    	    scoreb=`grep $player_b_str $file | tail -1 | awk '{print $NF}'`
    	    if [ $scorea -lt $scoreb ]; then
        		echo $scorea $basedir/$dir/$file >> $tmp/tmp_quackle_stats.dat
    	    fi
    	done

    done
    
    echo -e '\nHighest losing scores for '${player_a_name}':\n'
    cat $tmp/tmp_quackle_stats.dat | sort -nr | head -$ntoshow

fi

# Player B

if [ $1 -eq 12 ]; then

    if [ -f $tmp/tmp_quackle_stats.dat ]; then
	    rm -f $tmp/tmp_quackle_stats.dat
    fi

    for dir in ${dirs[@]}; do

        #echo $dir

    	cd $basedir/$dir
    	files=`ls *.gcg | xargs`

    	for file in $files; do
    	    scorea=`grep $player_a_str $file | tail -1 | awk '{print $NF}'`
    	    scoreb=`grep $player_b_str $file | tail -1 | awk '{print $NF}'`
    	    if [ $scoreb -lt $scorea ]; then
	        	echo $scoreb $basedir/$dir/$file >> $tmp/tmp_quackle_stats.dat
	        fi
	    done

    done
    
    echo -e '\nHighest losing scores for '${player_b_name}':\n'
    cat $tmp/tmp_quackle_stats.dat | sort -nr | head -$ntoshow

fi


# Largest positive & negative spreads
# -----------------------------------

# Only need to do one player since symmetrical
# Could similarly do highest spreads for each player
# Also print the game scores

if [ $1 -eq 13 ]; then

    if [ -f $tmp/tmp_quackle_stats.dat ]; then
	    rm -f $tmp/tmp_quackle_stats.dat
    fi

    for dir in ${dirs[@]}; do

        #echo $dir

	    cd $basedir/$dir
	    files=`ls *.gcg | xargs`

    	for file in $files; do
	        scorea=`grep $player_a_str $file | tail -1 | awk '{print $NF}'`
	        scoreb=`grep $player_b_str $file | tail -1 | awk '{print $NF}'`
	        spread=`echo | awk '{print scorea-scoreb}' scorea=$scorea scoreb=$scoreb`
	        echo $spread $scorea-$scoreb $basedir/$dir/$file >> $tmp/tmp_quackle_stats.dat
	    done

    done
    
    echo -e '\nHighest spreads for '${player_a_name}':\n'
    cat $tmp/tmp_quackle_stats.dat | sort -nr | head -$ntoshow

    echo -e '\nLowest spreads for '${player_a_name}':\n'
    cat $tmp/tmp_quackle_stats.dat | sort -n | head -$ntoshow

fi


# Notes
# -----

# A typical .gcg looks like this (line spacing added for clarity)

# #character-encoding UTF-8
#
# #player1 Quackle Quackle
# #player2 Nick_Ball Nick Ball
#
# >Quackle: BELNSXY 8F LYNX +28 28
# >Nick_Ball: AILRSTY 9G AY +17 17
# >Quackle: BEEHOST 10B BEHOTES +82 110
# >Nick_Ball: AEILRST B8 LI.RATES +70 87
# >Quackle: ADDFORV A12 FADO +56 166
# >Nick_Ball: ?DLLNOW 12A ..LLOW +24 111
# >Quackle: DDNRRVV -DNRVV +0 166
# >Nick_Ball: ??DEINR A3 gRInNED +80 191
# >Quackle: DEIIRST C2 TIDIERS +71 237
# >Nick_Ball: AACNNOZ D1 ZONA +56 247
# >Quackle: CEEPTUU E4 PUCE +22 259
# >Nick_Ball: ACIKNOV 1D .INCO +48 295
# >Quackle: EIQRTTU 2H REQUIT +37 296
# >Nick_Ball: AAEIKPV 1L KIVA +61 356
# >Quackle: EEFNOST N1 .ETO +46 342
# >Nick_Ball: AAAEMPV 7I AVA +17 373
# >Quackle: EEFGNOS 8K GONEF +33 375
# >Nick_Ball: ABEHMPU 3L PA.H +33 406
# >Quackle: EIMNRST 13E REMINTS +70 445
# >Nick_Ball: BDEGMOU N8 .MBOGUED +90 496
# >Quackle: AEGJRUW 15L JA.E +60 505
# >Nick_Ball: I J2 .I +11 507
#
# >Nick_Ball:  (GRUW) +16 523

# More possible stats
#
#  - From .gcgs directly
#
# Easy/Medium
#
# Largest end rack adjustment (countback)
# Highest outplay
# Highest opening move
# Number of exchanges (move -XXXX and scores 0)
# Low spreads (draws and closest games)
# Low wins
# Longest letter stick, e.g., Q (passes in a row at end)
# Unfinished: neither side could play a tile (both negative rack countback at game end + unseen tiles, or most unseen tiles)
# Number of bingos (no. non-dots in word >= 7, score >= 50), for one player or combined
# Highest non-bingo moves
# Highest out-bingo (score + countback) to win
# Unusual letters to be stuck with, e.g., C, Z (like longest, but record letter)
# Avg. word length played / distribution
# No. exchanges in a row (w/o 6 pass)
# Most points in N moves, e.g., 2
# Highest lowest scoring game move, and vice versa
# Best/worst use of JQXZ (total score of primary words)
# Distribution of letters stuck with at end
# Highest spread / ASM after N moves
# Most moves over 100: in the game, in a row
# Highest ratio of winning score to losing
# Hardest to see, e.g., most disconnected tiles, no. blanks
# Most bingos in a row (both players or just one), most moves without one
# Blanks as each letter how many times
# 7 tile overlaps (8 words)
# Same word or leave repeated
# Words beginning with same letter repeated
# Moves in a row with same score

# Harder
#
# Highest non-9x bingo moves
# Number of bingos in a row, one side, both sides
# Lowest equity loss, from game reports
# Most/least words of given length, e.g., 2
# Most times same move score occurs
# Board circularity / similar stats
# Number of each type of premium square used
# Equity loss, using the reports
#
#  - Not just from .gcgs
#
# Easy/Medium
#
# Plot distributions
# D3 board visualizer
#
# Harder
#
# D3 visualize candidate moves
# Who won -> rating
# Longest words not just base: search text board
# Number of times each square used
