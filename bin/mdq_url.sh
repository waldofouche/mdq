#!/bin/bash

###########################################################
# Compute the request URL for the given IDENTIFIER as specified by
# the Metadata Query Protocol
#
# usage: mdq_url.sh [-vq] IDENTIFIER
#
# The -v option causes the script to produce verbose output while 
# the -q option causes the script to be silent. The options are 
# mutually exclusive.
#
# The single command-line argument is an arbitrary IDENTIFIER as defined
# by the Metadata Query Protocol specification. In a SAML context the 
# IDENTIFIER is usually a SAML entityID, which is used to fetch a single 
# entity descriptor.
#
# Note: set environment variable MDQ_BASE_URL before using this script.
#
# Example:
#
# $ export MDQ_BASE_URL=http://mdq.example.com/public
# $ mdq_url.sh -v https://sso.example.org/idp
# Using base URL http://mdq.example.com/public
# http://mdq.example.com/public/entities/https%3A%2F%2Fsso.example.org%2Fidp
#
# For details regarding the Metadata Query Protocol, see: 
# https://github.com/iay/md-query
###########################################################

script_name=${0##*/}  # equivalent to basename $0

# check the required environment variable
if [ -z "$MDQ_BASE_URL" ]; then
	echo "ERROR: $script_name: environment variable MDQ_BASE_URL does not exist" >&2
	exit 2
fi

# Construct a request URL per the MDQ Protocol specification
# See: https://github.com/iay/md-query
# To construct a reference to ALL entities served by the 
# metadata query server, simply omit the second argument
construct_mdq_url () {
	# construct_mdq_url <base_url> <url_encoded_id>

	# make sure there are one or two command-line arguments
	if [ $# -lt 1 -o $# -gt 2 ]; then
		echo "ERROR: $FUNCNAME: incorrect number of arguments: $# (1 or 2 required)" >&2
		return 2
	fi
	local base_url=$1
	
	# strip the trailing slash from the base URL if necessary
	local length="${#1}"
	if [[ "${base_url:length-1:1}" == '/' ]]; then
		base_url="${base_url:0:length-1}"
	fi
	
	# append the identifier if there is one
	if [ $# -eq 2 ]; then
		echo "${base_url}/entities/$2"
	else
		echo "${base_url}/entities"
	fi
}

# URL-encode an arbitrary string
# see: https://gist.github.com/cdown/1163649
urlencode () {
	# urlencode <string>
	
	# make sure there is one (and only one) command-line argument
	if [ $# -ne 1 ]; then
		echo "ERROR: $FUNCNAME: incorrect number of arguments: $# (1 required)" >&2
		return 2
	fi

	local length="${#1}"
	for (( i = 0; i < length; i++ )); do
		local c="${1:i:1}"
		case "$c" in
			[a-zA-Z0-9.~_-]) printf "$c" ;;
			*) printf '%%%02X' "'$c"
		esac
	done
}

# process command-line option(s)
verbose_mode=false; quiet_mode=false
while getopts ":vq" opt; do
	case $opt in
		v)
			verbose_mode=true
			quiet_mode=false
			;;
		q)
			verbose_mode=false
			quiet_mode=true
			;;
		\?)
			echo "ERROR: $script_name: Unrecognized option: -$OPTARG" >&2
			exit 2
			;;
	esac
done

#####################################################################
#
# main processing
#
#####################################################################

# start redirecting stdout
exec 6>&1                  # dup stdout as file descriptor &6
if $quiet_mode ; then
	exec 1>/dev/null       # redirect stdout to the bit bucket
fi

$verbose_mode && echo "Using base URL $MDQ_BASE_URL" >&6

# construct the request URL
shift $(( OPTIND - 1 ))
if [ $# -eq 1 ]; then
	# URL-encode the identifier
	encoded_id=$( urlencode "$1" )
	return_status=$?
	if [ "$return_status" -ne 0 ]; then
		echo "ERROR: $script_name: failed to URL-encode the identifier" >&2
		exit $return_status
	fi
	request_url=$( construct_mdq_url $MDQ_BASE_URL $encoded_id )
else
	echo "ERROR: $script_name: incorrect number of arguments: $# (1 required)" >&2
	exit 2
fi

# was the URL successfully constructed?
return_status=$?
if [ "$return_status" -ne 0 ]; then
	echo "ERROR: $script_name: failed to construct the request URL" >&2
	exit $return_status
fi

echo $request_url

# stop redirecting stdout
if $quiet_mode; then
	exec 1>&6              # restore stdout from file descriptor #6
fi
exec 6>&-                  # close file descriptor #6

exit 0