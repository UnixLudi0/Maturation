mkdir -p ../logs
exec 2> ../logs/wine.sh.log
set -euxo pipefail

git clone https://github.com/ventureoo/PKGBUILDs
cd PKGBUILDs/wine-pure-git
makepkg -sricCf
