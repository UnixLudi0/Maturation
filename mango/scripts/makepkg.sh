URL=$1
DIR=$(basename "$URL" .git)
mkdir -p ~/.cache/makepkg
cd ~/.cache/makepkg
git clone "$URL"
cd "$DIR"
makepkg -sric
