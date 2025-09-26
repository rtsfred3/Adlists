clear && clear

DIR="abp"

API_KEY="$1"
DATE=$(date -u +'%Y%m%d.%H%M00')

if [ ! -d "$DIR" ]; then
    mkdir $DIR
fi

bash scripts/generateHostToAdblockPro.sh frellwits.swedish.adblock.txt https://raw.githubusercontent.com/lassekongo83/Frellwits-filter-lists/master/Frellwits-Swedish-Hosts-File.txt
bash scripts/generateHostToAdblockPro.sh adaway.adblock.txt https://raw.githubusercontent.com/AdAway/adaway.github.io/master/hosts.txt

bash scripts/generateAdblockProCombined.sh hagezi.native.adblock.txt https://gist.githubusercontent.com/rtsfred3/8553b13be1263ccd5c296f5eb512e6e9/raw/hagezi.native.abp
bash scripts/generateAdblockProCombined.sh advertising.adblock.txt https://gist.githubusercontent.com/rtsfred3/8553b13be1263ccd5c296f5eb512e6e9/raw/advertising.abp
# bash scripts/generateAdblockProCombined.sh nrd14.txt https://gist.githubusercontent.com/rtsfred3/8553b13be1263ccd5c296f5eb512e6e9/raw/nrd14.abp

git config user.name "rtsfred3"
git config user.email "rtsfred3@gmail.com"
git add .
git commit -m "Updated Adlists @ $DATE"
git tag "$DATE"
git push
git push --tags

FILES=$(find $DIR -type f | sed '1d' | sort -u)

for FILE in ${FILES[@]}; do
   FILE_NAME="$(echo "$FILE" | cut -d "/" -f2)"

    curl --request PUT \
        --url https://storage.bunnycdn.com/adlists-rtf/adlist/adblock/$FILE_NAME \
        -H "AccessKey: $API_KEY" \
        -H 'Content-Type: application/octet-stream' \
        -H 'accept: application/json'  \
        --data-binary @$DIR/$FILE_NAME &
done