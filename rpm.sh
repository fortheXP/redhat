#!/bin/bash

# Get the current time in Unix timestamp format
#current_time=$(date +%s)

# Get the time 24 hours ago in Unix timestamp format
time_24h_ago=$(date --date='24 hours ago' +%s)

# Use the rpm command to list the packages that were upgraded in the past 24 hours
rpm -qa --last | awk '
  # Define a function to convert the month name to a month number
  function getMonthNumber(month) {
    split("January February March April May June July August September October November December", months)
    for (i in months) {
      #if (month == months[i]) {
       if (tolower(substr(month, 1, 3)) == tolower(substr(months[i], 1, 3))) {
          return  i  
      }
    }
    return "01"
  }

  # Split the line into fields
  { split($6, t, ":"); r[1] = $5; r[2] = $4; r[3] = $3; r[4] = t[1]; r[5] = t[2]; r[6] = t[3]; r[7] = $7 }

  # Convert the date and time fields into a Unix timestamp
  { etime = (r[1]" "getMonthNumber(r[2])" "r[3]" "r[4]" "r[5]" "r[6]" "r[7])
    epoch = mktime(etime) }

  # Check if the package was upgraded within the past 24 hours
  epoch > "'"$time_24h_ago"'"  {
    print $1
  }'

