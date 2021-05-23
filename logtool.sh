#!/bin/bash

protocol() { # Function created for coding instructions where user elects protocol criteria.
    read - p "Enter the protocol to display: " pro # User enters a term to search in protocol.
    grep $pro > $filename # The term entered is sent to the file elected by the user.
}

srcip() { # Function created for coding instructions where user elects SRC IP criteria.
    read -p "Enter the partial string to search: " string # User enters a string to search in SRC IP
    grep -iw $string > $filename # The whole word, case insensitive, is sent to the file elected by the user.
}

srcport() { # Function created for coding instructions where user elects SRC PORT criteria.
    read - p "Enter the source port to display: " port # User enters a port to search in SRC PORT.
    grep $port > $filename # The port details are sent to the file elected by the user.
}

destip() { # Function created for coding instructions where user elects DEST IP criteria.
    read -p "Enter the partial string to search: " string # User enters a string to search in DEST IP.
    grep -iw $string > $filename # THe wole word, case insensitive, is sent to the file elected by the user.
}

destport() { # Function created for coding instructions where user elects DEST PORT criteria.
read - p "Enter the destination port to display: " port # # User enters a port to search in DEST PORT.
    grep $port > $filename # The port details are sent to the file elected by the user.
}

packets() { # Function created for coding instructions where user elects packets criteria.
read -p 'Do you want to retrieve values greater than [1], less than [2], equal to [3], or not equal to [4]  a specific value:' var # User selects if they want their search to be greater than. less than, equal to or not equal to the result.
        if [[ $var -eq 1 ]]; && [[ ${sterm[@]} -lt $8 ]]; then # If the user selects option 1, and there are values in packets greater than the search term(s) entered
            grep $8 > $filename # The values are moved from the file log to the file elected by the user.
        elif [[ $var -eq 2 ]]; && [[ ${sterm[@]} -gt $8 ]]; then # If the user selects option 2, and there are values in packets less than the search term(s) entered
            grep $8 > $filename # The values are moved from the file log to the file elected by the user.
        elif [[ $var -eq 3 ]]; && [[ ${sterm[@]} -eq $8 ]]; then # If the user selects option 3, and there are values equal to the search term(s) entered
            grep $8 > $filename # The values are moved from the file log to the file elected by the user.
        elif [[ $var -eq 4 ]]; && [[ ${sterm[@]} ! -eq $8 ]]; then # If the user selects option 4, and there are values not equal to the search term(s) entered
            grep $8 > $filename # The values are moved from the file log to the file elected by the user.
        else
            echo " " # If there are no results, nothing is echoed to the screen.
}

bytes() { # Function created for coding instructions where user elects bytes criteria.
    read -p 'Do you want to retrieve values greater than [1], less than [2], equal to [3], or not equal to [4]  a specific value:' var
        if [[ $var -eq 1 ]]; && [[ ${sterm[@]} -lt $9 ]]; then # If the user selects option 1, and there are values in bytes greater than the search term(s) entered
            grep $9 > $filename # The values are moved from the file log to the file elected by the user.
        elif [[ $var -eq 2 ]]; && [[ ${sterm[@]} -gt $9 ]]; then # If the user selects option 2, and there are values in bytes less than the search term(s) entered
            grep $9 > $filename # The values are moved from the file log to the file elected by the user.
        elif [[ $var -eq 3 ]]; && [[ ${sterm[@]} -eq $9 ]]; then # If the user selects option 3, and there are values equal to the search term(s) entered
            grep $9 > $filename # The values are moved from the file log to the file elected by the user.
        elif [[ $var -eq 4 ]]; && [[ ${sterm[@]} ! -eq $9 ]]; then # If the user selects option 4, and there are values not equal to the search term(s) entered
            grep $9 > $filename # The values are moved from the file log to the file elected by the user.
        else
            echo " " # If there are no results, nothing is echoed to the screen.
}

class() { # Function created for coding instructions where user elects class criteria.
    grep 'suspicious' > $filename # Only the suspicious results are moved across to the file elected by the user.
}

scount=0 #Counter is set to zero so the code determines if the user has already carried out a search.

while true; do # While loop is created so the script continues to give the user an option to search until they elect not to.
    if [[$scount -eq 0 ]]; then # Where the user has not carried out any prior searches.
        read - -p "Enter [1] to search or [2] to exit: " reply # User enters an option to either search or exit the search.
    else
        read -p "Enter [1] to search again or [2] to exit: " reply # If the user has already completed a search, they are prompted to either search again or exit.
    fi

    if [[ $reply -eq 2 ]]; then # If the user selects to exit the search, they break out of the while loop.
        break
    else
        clear # If the user decides to continue searching (or selects an invalid key) they are prompted to continue searching.

        orig_ifs=IFS
        IFS=$'\n' # Internal field separator allows each entry to start on a new line. This allows for the menu to be listed.

        declare -a logs # An array is declared to list the avaiable log files when the criteria is met.
        patt="serv_acc_log.+csv$" # The pattern to search for log files includes serv_acc_log. and ends in csv.
        mennum=1 # As the logs are listed, they are numbered to assist with selecting them when populated to a menu.

        for file in ./*; do # Identifies files within the directory 
            if [[ $file =~ $patt ]]; then # Compares the files with the pattern provided
                logs+=($(basename $file)) # Files that meet the pattern criteria are added to the logs array and the extended name is stripped down to the base name.
            fi
        done

        count=${#logs[*]} # The number of files identified as meeting the criteria are counted
        echo -e "There are $count files.\n" # The number of log files is displayed on the screen.
        read -p "Enter [1] to search all logs, or any key to search a specific log: " logsearch # The user is prompted to search in all the log files or a selected log file.

        for file in "${logs[@]}"; do # For each of the log files assign a menu number and list it on the screen.
            echo -e "$mennum $file"
            ((mennum++)) #The menu number increments by 1 with each entry listed.

            if [[ $logsearch -eq 1 ]]; then # The user will search all logs by default.
                echo "You have selected all logs"

            else 
                echo -e "\t" # A space is left between the menu and the next search option.
                read -p "Enter the number of the log file to search by corresponding number, i.e. [1, 2, 3, 4 or 5]: " sel
                echo "You have selected $sel" # The user selects the number that corresponds to the log file they wish to search and it is stored in $sel.

            fi
        done

        IFS=orig_ifs # The IFS is reverted back to it's default setting.

        read "Enter the number of criteria you wish to search between 1 and 3, i.e. [1], [2], or [3] criteria: " numsearch
        echo "You have selected $numsearch criteria" # The user is given the option to search 1, 2 or 3 different criteria.

            if [[ $numsearch -eq 1 ]]; then # If the user selects 1 criteria, they are prompted for 1 search term.
                read -p 'Enter a search term:' sterm1
                
            elif [[ $numsearch -eq 2 ]]; then # If the user selects 2 criteria, they are prompted for 2 search terms.
                read -p 'Enter a search term:' sterm1
                read -p 'Enter a search term:' sterm2
                
            elif [[ $numsearch -eq 3]]; then # If the user selects 3 criteria, they are prompted for 3 search terms.
                read -p 'Enter a search term:' sterm1
                read -p 'Enter a search term:' sterm2
                read -p 'Enter a search term:' sterm3   

            else # If the user makes an invalid selection the below message appears and they exit the search with 1 error.
                echo "The entry you made is invalid."
                exit 1
            fi
        read - p 'Enter the name of the file you wish to save your search results: ' filename #The user identifies the file they wish to save their results.
        if ! [ -f $filename]; then
        touch $filename # If the file does not exist, it is created.
        fi

        orig_ifs=IFS # The IFS is used for a new array.
        IFS=$'\n'

        declare -a records # An array is created with the table headings from the log files.
        records=($DATE $DURATION $PROTOCOL $SRCIP $SRCPORT $DESTIP $DESTPORT $PACKETS $BYTES $FLOWS $FLAGS $TOS $CLASS)

        # The below search terms are executed through the functions so the results can be saved to the file selected by the user.
        protocol $sterm1 $sterm2 $sterm3
        srcip $sterm1 $sterm2 $sterm3
        srcport $sterm1 $sterm2 $sterm3
        destip $sterm1 $sterm2 $sterm3
        destport $sterm1 $sterm2 $sterm3
        packets $sterm1 $sterm2 $sterm3
        bytes $sterm1 $sterm2 $sterm3
        class $sterm1 $sterm2 $sterm3

        if ${sterm[@]} =~ "${logs[@]}"; then # If the search term(s) is/are searched in all log files the following applies;
            cat ${logs[@]} | grep ${sterm[@]} | sed /$date/; /$duration/; /$flows/; /$flags/; /$tos/; /'normal'/ | awk '{printf "%-4s %-15s %-5s %-15s %-5s %-3s %-5s %-10s \n", $3 $4 $5 $6 $7 $8 $9 $13}'
            # The information is searched in all files, the term(s) retrieved, the columns date, duration, flows, flags and tos, as well as the word normal, are removed, and the results  of the -
            # - remaining data are formatted into columns of equal spacing according to the column in which the data was retrieved.
        elif ${sterm[@]} =~ "${logs[*]}"; then # If the search term(s) is/are searched in a select log file the following applies;
            cat ${logs[*]} | grep ${sterm[@]} | sed /$date/; /$duration/; /$flows/; /$flags/; /$tos/; /'normal'/ | awk '{printf "%-4s %-15s %-5s %-15s %-5s %-3s %-5s %-10s \n", $3 $4 $5 $6 $7 $8 $9 $13}'
            # The information is searched in all files, the term(s) retrieved, the columns date, duration, flows, flags and tos, as well as the word normal, are removed, and the results  of the -
            # - remaining data are formatted into columns of equal spacing according to the column in which the data was retrieved.
        else
            echo "No results found" # If there are no search results, this message appears. 

        done #needs to match up with the clear command to complete actions following the option to continue searching.
        IFS=orig_ifs # The IFS restores back to default.
    fi #Indicates the search has finished.
    ((scount++)) #Keeps count of how many searches have been completed.
    #Check if IFS is needed here

done #Indicates the searching is complete.

exit 0  #Script ends with no errors.