#!/usr/bin/env bash

# echo What is your first name

# read FIRST_NAME

# echo What is your Last name
# read LAST_NAME

# echo Hello $FIRST_NAME $LAST_NAME

# echo Hello $1 $2

# if [ ${1,,} = herbet ]; then
#     echo "oh boss"
# elif [ ${1,,} = help ]; then
#     echo "enter name"
# else
#     echo "I don't know you"

# fi
# echo $1/$2
# cd "$1" || exit
# cd "$2" || exit
# # dir | grep js
## ls -a
# # ./ ../ .foo/ bar/ baz qux*
## shopt -s dotglob
## shopt -s nullglob
## array=(*/)
# for dir in "${array[@]}"; do echo "$dir"; done
# #.foo/
# #bar/
# #for dir in */; do echo "$dir"; done
# #.foo/
# #bar/
# #PS3="which dir do you want? "
## echo "There are ${#array[@]} dirs in the current path"; 

## value=".git"

## if [[ " ${array[*]} " =~ ${value} ]]; then
##     echo "Array contains value"
## else
##     echo "Array does not contain value"
## fi

# read -p "Enter [y/n] : " opt
if ! command -v git >/dev/null 2>&1; then
    echo "Install git first"
    exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
    echo "Install gh first"
    exit 1
fi


if ! gh auth status >/dev/null 2>&1; then
    printf "\nNot authenticated, To log in, run: gh auth login\n\n"
    exit 1
else
    printf "\nAuthenticated\n\n"
fi


GREEN='\033[0;32m'
GIT_FOLDER=".git"
IS_ALREADY_INITIALISED="n"
COMMIT_MESSAGE="First Commit"
REPOSITORY_NAME=""
IS_PRIVATE="y"
echo ""
echo "$1\\$2"
echo ""

if ! cd "$1" 2>/dev/null; then
  echo "Disk Not Found"
  exit 1
fi

if ! cd "$2" 2>/dev/null; then
  echo "Directory Not Found"
  exit 1
fi


ls -a > /dev/null

shopt -s dotglob
shopt -s nullglob
array=(*/)



if [[ " ${array[*]} " =~ ${GIT_FOLDER} ]]; then

    continue_after_init="y"
    IS_ALREADY_INITIALISED="y"
    echo ""
    read -e -p "Git Repository is already initilized are you sure you still want to continue [y/n] : " -i "$continue_after_init" continue_after_init;
    if [ "$continue_after_init" = "n" ]; then
        exit
    fi

    if [ -n "$(git ls-remote 2>/dev/null)" ]; then
        printf "\nRemote repository is already present."
        exit
    fi
fi

if [ $IS_ALREADY_INITIALISED != "y" ]; then
    echo ""
    git init
fi
printf "\n\nAdding All Files\n\n"

git add .

echo "";
read -e -p "Enter Commit Message : " -i "$COMMIT_MESSAGE" COMMIT_MESSAGE;
echo ""

git commit -m "$COMMIT_MESSAGE"

REPOSITORY_NAME=$(basename "$PWD")

echo "";
read -e -p "Enter Repository Name : " -i "$REPOSITORY_NAME" REPOSITORY_NAME;
read -e -p "Make Repository Private [y/n] : " -i "$IS_PRIVATE" IS_PRIVATE;

printf "\n\n\Creating %s and pusing files to it...\n\n" "$REPOSITORY_NAME"

if [ "$IS_PRIVATE" = "y" ]; then
    gh repo create "$REPOSITORY_NAME" --private --source=. --remote=upstream --push
else
    gh repo create "$REPOSITORY_NAME" --public --source=. --remote=upstream --push
fi

printf "${GREEN}\nRepository Created Successfully 🎉🎉\n\n"