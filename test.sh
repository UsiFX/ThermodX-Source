#!/usr/bin/ksh

clear

#  Set select construct prompts for each menu level.
typeset -r MAINPROMPT="*) Select a main option: "
typeset -r MANGOPROMPT="*) Select mango option: "

#  Loop main menu until user exits explicitly.
while :
do
  print "\nTop-level Menu Title Goes Here\n"
  PS3=$MAINPROMPT  # PS3 is the prompt for the select construct.

  select option in "mango (has a sub-menu)" tango rango exit
  do
    case $REPLY in   # REPLY is set by the select construct, and is the number of the selection.
      1) # mango (has a sub-menu)
         #  Loop mango menu until user exits explicitly.
         while :
         do
           clear
           print "\nmango sub-menu title\n"
           PS3=$MANGOPROMPT
           select option1 in add substract exit
           do
             case $REPLY in
               1) # add
                  print "\nYou picked [add]"
                  clear
                  break  #  Breaks out of the select, back to the mango loop.
                  ;;
               2) # subtract
                  print "\nYou picked [subtract]"
                  clear
                  break  #  Breaks out of the select, back to the mango loop.
                  ;;
               3) # exit
                  clear
                  break 2  # Breaks out 2 levels, the select loop plus the mango while loop, back to the main loop.
                  ;;
               *) # always allow for the unexpected
                  print "[${REPLY}] Unknown mango operation"
                  sleep 2
                  clear
                  break
                  ;;
             esac
           done
         done
         break
         ;;
      2) # tango
         ;&  # Fall through to #3
      3) #rango
         print "\nYou picked $option"
         break
         ;;
      4) # exit
         break 2  #  Break out 2 levels, out of the select and the main loop.
         ;;
      *) # Always code for the unexpected.
         print "\nUnknown option [${REPLY}]"
         break
         ;;
    esac
  done
done

exit 0
