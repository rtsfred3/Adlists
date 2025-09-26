clear && clear

DIR="top_domains"
API_KEY="$1"
README="README.md"

FILES=(ranking_top_50000 ranking_top_100000 ranking_top_200000 ranking_top_500000 ranking_top_1000000)

if [ ! -d "$DIR" ]; then
    mkdir $DIR
fi

echo "# Cloudflare Top Domains

Refreshed at $(date +'%Y-%m-%dT%H:%M:%SZ')

| File | Link |
| :------- | :------: |" > $DIR/$README

updateRankingTopDomains() {
    curl "https://api.cloudflare.com/client/v4/radar/datasets/$1" -H "Authorization: Bearer $API_KEY" --silent | sed '1d' > $DIR/$1.txt
	
	gzip -k -9 -f -c $DIR/$1.txt > $DIR/$1.txt.gz    
}

for file in ${FILES[@]}; do
    echo "| $file.txt | [GH](https://raw.githubusercontent.com/rtsfred3/PiHoleAdlists/main/$DIR/$file.txt) [JSDelivr](https://cdn.jsdelivr.net/gh/rtsfred3/PiHoleAdlists@main/$DIR/$file.txt)" >> $DIR/$README
done

for file in ${FILES[@]}; do
    updateRankingTopDomains $file &
done

wait

echo "DONE"