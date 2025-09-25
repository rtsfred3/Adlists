clear && clear

DIR="abp"
GIST_URL="$2"

FILE="$1"
DEDUPED_FILE="tmp_${FILE}"

SOURCE_URL=$(curl "$GIST_URL" --silent | sed '/^#/d')

echo $FILE

if [ ! -d "$DIR" ]; then
    mkdir $DIR
fi

if [ -f "$DIR/$FILE" ]; then
	rm "$DIR/$FILE"
fi

if [ -f "$DIR/$FILE.gz" ]; then
	rm "$DIR/$FILE.gz"
fi

echo "" > $DIR/$FILE
echo "[Adblock Plus]
! Generated at $(date +'%Y-%m-%dT%H:%M:%SZ')
! 
! Sources:" > $DIR/$DEDUPED_FILE

while IFS= read -r line; do
    echo "! $line" >> $DIR/$DEDUPED_FILE

	curl "$line" --silent | sed '/^!/d' | sed '/^\[/d' | sed '/^#/d' | sort >> $DIR/$FILE
done <<< "$SOURCE_URL"

# echo $(sed -E 's/^([^\|].*[^\^])$/\|\|\1\^/g' $DIR/$FILE) >  $DIR/$FILE

cat $DIR/$FILE | sed -E 's/^([^\|].*[^\^])$/\|\|\1\^/g' | sort -u >> $DIR/$DEDUPED_FILE

mv $DIR/$DEDUPED_FILE $DIR/$FILE

gzip -k -9 -f $DIR/$FILE