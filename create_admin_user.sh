#!/bin/sh
# Must be run as root
# Usage: ./create_admin_user.sh argyris "Argyris Zymnis"
# Authors: Argyris, Anand

set -e
set -x
if [ ! $# == 2 ]; then
  echo "Usage: $0 <username> <actual name quoted>"
  exit
fi

USERNAME=$1
NAME=$2

# Get unique user ID
LASTUID=$(dscl . -readall /Users | grep UniqueID | sort -k 2 -n  | tail -1 | cut -f 2 -d " ")
NEXTUID=$(echo $LASTUID + 1 | bc)

# Create user
dscl . -create /Users/$USERNAME
dscl . -create /Users/$USERNAME UserShell /bin/bash
dscl . -create /Users/$USERNAME RealName "$NAME"
dscl . -create /Users/$USERNAME UniqueID "$NEXTUID"
dscl . -create /Users/$USERNAME PrimaryGroupID 20
dscl . -create /Users/$USERNAME NFSHomeDirectory /Users/$USERNAME


# Create user directory
mkdir -v /Users/$USERNAME
chown -R $USERNAME:staff /Users/$USERNAME

# Also give admin access
dscl . -append /Groups/admin GroupMembership $USERNAME
dscl . -passwd /Users/$USERNAME

