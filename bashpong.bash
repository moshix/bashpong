#!/usr/local/bin/bash510
# pong game in bash 
# game strategy make ball go thru whole in right wall
# copyright 2022 by moshix
# version 0.1 get screen size
# version 0.2 set colors and set up logging
# version 0.3 make ball go back and forth
# version 0.4 use unicode for ball requires bash510
# version 0.5 3D play 

set_color () {
# set up color attributes variables                                             
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 7`
blink=`tput blink`
rev=`tput rev`
reset=`tput sgr0`
}

logit () {
# log to file all messages
logdate=`date "+%F-%T"`
export PATH=./herc4x/bin:$PATH
xport LD_LIBRARY_PATH=./herc4x/lib:$LD_LIBRARY_PATH
xport LD_LIBRARY_PATH=./herc4x/lib/hercules:$LD_LIBRARY_PATH
                                                                                                              
local FILE=./logs/tkbuntu.log.$logdate
echo "$logdate:$1" >> $FILE
}


get_termsize() {
# get terminal size 
 term_width=$(tput cols)
    term_height=$(tput lines)
    
    if (( $((term_width % 2)) == 0 ))
    then
        grid_width=$((term_width / 2 - 1))
    else
        grid_width=$((term_width / 2))
    fi
    
    grid_height=$((term_height - 2))


#echo " screen width:  $grid_width"
#echo " screen height: $grid_height"
w=$grid_width
h=$grid_height
}

center_text() {
# get string and center in terminal
local terminal_width=$(tput cols)    # query the Terminfo database: number of columns
    local text="${1:?}"                  # text to center
    local glyph="${2:- }"                # glyph to compose the border
    local padding="${3:-2}"              # spacing around the text

    local border=                           # shape of the border
    local text_width=${#text}

    # the border is as wide as the screen
    for ((i=0; i<terminal_width; i++))
    do
        border+="${glyph}"
    done
    printf "$border"

    # width of the text area (text and spacing)
    local area_width=$(( text_width + (padding * 2) ))

    # horizontal position of the cursor: column numbering starts at 0
    local hpc=$(( (terminal_width - area_width) / 2 ))
    tput hpa $hpc                       # move the cursor to the beginning of the area
    tput ech $area_width                # erase the border inside the area without moving the cursor
    tput cuf $padding                   # move the cursor after the spacing (create padding)
    printf "$text"                      # print the text inside the area
    tput cud1                           # move the cursor on the next line
}

center() {
  termwidth="$(tput cols)"
  padding="$(printf '%0.1s' .{1..500})"
  printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

moveleftright () {
wl=$1
tput civis
echo "wl: $wl"
while true; do
  ball_x=$((ball_x + ball_vel_x))
    
    # Hit the right hand wall
    if [ $ball_x -gt $w ]; then
        ball_vel_x=$((-1))
    fi

    if [ $ball_x -lt 1 ]; then
        ball_vel_x=$((1))
    fi
    tput cup 7 $ball_x; echo -e "\u25A0"
    sleep 0.15
    tput cup 7 $ball_x; echo " "
done
echo "${reset}"
}

3d () {
wl=$1
hl=$2
rightwall=`echo "$((wl-1))"`
tput civis
ball_x=2
while true; do
    tput cup 6 1; read -t 0.01  RESP  
    if [[ $RESP = "u" ]]; then
       let hl=$hl-1
    elif [[ $RESP = "d" ]]; then
       let hl=$hl+1
    fi

    ball_x=$((ball_x + ball_vel_x))

    if [ $ball_x -gt $rightwall ]; then         # Hit the right wall 
        ball_vel_x=$((-1))
    fi

    if [ $ball_x -lt 3 ]; then          # Hit the left wall 
        ball_vel_x=$((1))
    fi
    tput cup $hl $ball_x; echo -e "\u25A0"
    sleep 0.05
    tput cup $hl $ball_x; echo " "                                                       
done
echo "${reset}"
}

draw_box () {
# draw box where the game will play in
sz=$1
echo "width: $w  reduced wdidth: $rw   hight: $sz"
#read -p 'Size: ' sz

topbottom=$(yes '*' | head -n "$sz" | tr -d '\n' )
printf -v midrows '*%*s*' "$((sz-2))" ""

printf '%s\n' "$topbottom"
yes "$midrows" | head -n "$((sz-2))"
printf '%s\n' "$topbottom"
}
#####################################
# main function
######################################

set_color
get_termsize
clear
center_text  "${cyan}Hello and welcome to pong/bash${reset}"
center_text  "${cyan}==============================${reset}"
echo "${yellow}screen width: ${green} $grid_width ${reset}"
echo "${yellow}screen height:${green} $grid_height ${reset}"
echo "starting little test: "
sleep 1

# works right: moveleftright $grid_width
# moveleftright $grid_width $grid_height
draw_box 20  #hight
3d 18 18 #widgth and hight



exit
