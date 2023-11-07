#! /bin/bash

####################################################################################
#OWNER: bhusahankahire
#ABOUT: this script use to pring the users of the repositeory  who has read access
#Input: REPO_OWNER and REPO_NAME
####################################################################################

#HitHub API Url
API_URL="https://api.github.com"

# GitHub username and personal access token
echo -e  "Please enter the Repository username: \c"
read USERNAME
echo -e " please enter the token : \c"
read TOKEN

#user and repository information
echo -e "Please enter the  Repository Owner name: \c"
read REPO_OWNER
echo -e "Please enter the Repository Name: \c"
read REPO_NAME

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main script

echo "Listing users with access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
