#!/bin/bash
if [ -z "$1" ]
then
  echo "Need a group name - 1st argument"
  exit 1
fi
group_name="$1"
group_initial="$(tr '[:lower:]' '[:upper:]' <<< ${group_name:0:1})"
mkdir -p "$group_initial"
if [ ! -e "$group_initial/$group_name.yml" ]
then
  (
    echo "---"
    echo "Group_$group_name:"
  ) > "$group_initial/$group_name.yml"
fi
