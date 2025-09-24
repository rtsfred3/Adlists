clear && clear

DIR="abp"

HOST_LISTS=("https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.amazon.txt" "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.apple.txt" "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.huawei.txt" "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.lgwebos.txt" "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.oppo-realme.txt" "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.roku.txt" "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.samsung.txt" "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.tiktok.extended.txt" "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.tiktok.txt" "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.vivo.txt" "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.winoffice.txt" "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.xiaomi.txt")
# HOST_LISTS=("native.amazon.txt" "native.apple.txt" "native.huawei.txt" "native.lgwebos.txt" "native.oppo-realme.txt" "native.roku.txt" "native.samsung.txt" "native.tiktok.extended.txt" "native.tiktok.txt" "native.vivo.txt" "native.winoffice.txt" "native.xiaomi.txt")

FILE="hagezi.native.adblock.txt"
DEDUPED_FILE="tmp_${FILE}"

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

for url in ${HOST_LISTS[@]}; do
    echo "! $url" >> $DIR/$DEDUPED_FILE

	curl "$url" --silent | sed '/^!/d' | sed '/^\[/d' | sed '/^#/d' | sort >> $DIR/$FILE
done

cat $DIR/$FILE | sort -u >> $DIR/$DEDUPED_FILE

mv $DIR/$DEDUPED_FILE $DIR/$FILE

gzip -k -9 -f $DIR/$FILE