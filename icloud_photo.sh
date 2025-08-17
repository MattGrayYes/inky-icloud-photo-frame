#!/bin/bash

# code from: https://gist.github.com/fay59/8f719cd81967e0eb2234897491e051ec?permalink_comment_id=4219612#gistcomment-4219612
# requires jq
# arg 1: iCloud web album URL
# arg 2: folder to download into (optional)

function curl_post_json {
	curl -sH "Content-Type: application/json" -X POST -d "@-" "$@"
}

printf "Getting iCloud Stream\n"
BASE_API_URL="https://p23-sharedstreams.icloud.com/$(echo $1 | cut -d# -f2)/sharedstreams"

pushd $2 2> /dev/null
STREAM=$(echo '{"streamCtag":null}' | curl_post_json "$BASE_API_URL/webstream")
HOST=$(echo $STREAM | jq '.["X-Apple-MMe-Host"]' | cut -c 2- | rev | cut -c 2- | rev)

if [ "$HOST" ]; then
    BASE_API_URL="https://$(echo $HOST)/$(echo $1 | cut -d# -f2)/sharedstreams"
    STREAM=$(echo '{"streamCtag":null}' | curl_post_json "$BASE_API_URL/webstream")
fi

printf "Grabbing Large File Checksums\n"
CHECKSUMS=$(echo $STREAM | jq -r '.photos[] | [(.derivatives[] | {size: .fileSize | tonumber, value: .checksum})] | max_by(.size | tonumber).value')

printf "Adding Checksums to Array\n"
for CHECKSUM in $CHECKSUMS; do
    arrCHKSUM+=($CHECKSUM)
done
printf "Total Downloads: ${#arrCHKSUM[@]}\n"

# Dedup checksum to only include unique ids.
arrCHKSUM=($(printf "%s\n" "${arrCHKSUM[@]}" | sort -u))
printf "Unique Downloads: ${#arrCHKSUM[@]}\n"

printf "Streaming All Assets\n"
echo $STREAM \
| jq -c "{photoGuids: [.photos[].photoGuid]}" \
| curl_post_json "$BASE_API_URL/webasseturls" \
| jq -r '.items | to_entries[] | "https://" + .value.url_location + .value.url_path + "&" + .key' \
| while read URL; do

	# Get this URL's checksum value, not all URL's will be downloaded as there are both the fill size AND the thumbnail link in the Assets stream.
	LOCAL_CHECKSUM=$(echo "${URL##*&}")

	# If the url's checksum exists in the large checksum array then proceed with the download steps.
	if [[ " ${arrCHKSUM[*]} " =~ " ${LOCAL_CHECKSUM} " ]]; then

			# Get the filename from the URL, first we delimit on the forward slashes grabbing index 6 where the filename starts.
			# then we must delimit again on ? to remove all the URL parameters after the filename.
			# Example: https://www.example.com/4/5/IMG_0828.JPG?o=param1&v=param2&z=param3....
			FILE=$(echo $URL|cut -d "/" -f6 | cut -d "?" -f1)
            echo $FILE

			# Don't download movies
			if [[ "$FILE" == *.mp4* ]]; then
				echo "Downloading movie"
					curl -OJ $URL
			else

				# Don't download files that already exist
				if [[ -f "$FILE" ]]; then
					printf "File $FILE already present. Ignoring \n"
					#TIMESTAMP=$(date +%s%N)
					#curl $URL -o "${TIMESTAMP}_${FILE}"

				else
					# Original curl -sOJ $URL -> s = silent : O = download to file : J = Save using uploaded filename -- this also skips files that already exist.
					curl -OJ $URL
				fi

			fi

	else
		echo "Skipping Thumbnail"
	fi

done

popd 2> /dev/null
wait
