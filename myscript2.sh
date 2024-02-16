#!/bin/bash

# Jon Bennett
# 02/11/2024
# Description:
# 
#  This script compares the statuses of processes based on different criteria using information from the /proc directory.
#  It provides functionalities to compare processes based on CPU usage and memory usage with identifcation to the PID number. 

# Function to display usage information
display_usage() {
    echo "Usage: $0"
    echo "Pick what you would like to do."
    echo "Options:"
    echo "  -c          Compare processes based on CPU usage, top 10"
    echo "  -m          Compare processes based on memory usage, top 10"
    echo "  -p          PID information"
    echo "  -h          Display this help message again"
}


# Function to compare processes based on CPU usage
compare_cpu_usage() {
    echo "Comparing processes based on CPU usage...">&1
    # Retrieve the top 10 CPU users and extract PID, CPU usage, memory usage.
    ps -eo pid,%cpu,%mem --sort=-%cpu | head -n 11 >&1
}

# Function to compare processes based on memory usage
compare_memory_usage() {
    echo "Comparing processes based on memory usage..." >&1
    # Retrieve the top 10 memory users and extract PID, CPU usage, memory usage.
    ps -eo pid,%mem,%cpu --sort=-%mem | head -n 11 >&1
}

# Function to display details of a specific process
display_process_details() {
    read -p "Enter PID number: " pid >&1
    # Check if PID exists
    if [[ -d "/proc/$pid" ]]; then
        # Retrieve process details
        echo "Process details for PID $pid:">&1
        echo "Command name: $(cat /proc/$pid/cmdline)">&1
        echo "State: $(awk '/State/ {print $2}' /proc/$pid/status)">&1
        echo "User: $(awk -F: '$1=="Uid" {print $2}' /proc/$pid/status)" >&1
    else
        echo "Error: PID $pid does not exist." >&1
    fi
}


# Main function
main() {
    display_usage >&1

    while true; do
        read -p "Enter your choice (c - CPU usage, m - Memory usage, p - PID information h - Help): " choice >&1

        case $choice in
            c|C) compare_cpu_usage ;;
            m|M) compare_memory_usage ;;
	    p|P) display_process_details ;;
            h|H) display_usage ;;
            *) echo "Invalid choice. Please enter 'c', 'm', 'p', or 'h'." >&1;;
        esac

        read -p "Do you want to compare again? (y/n): " repeat >&1

        if [[ $repeat != "y" ]]; then
            break
        fi
    done
}

# Call main function
main

# Return exit code: 0 for success and non-zero for failure
exit 0

