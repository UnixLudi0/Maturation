mkdir -p ../logs
exec > >(tee -a ../logs/wine.log) 2>&1
set -euxo pipefail

git clone https://github.com/ventureoo/PKGBUILDs
cd PKGBUILDs/wine-pure-git
makepkg -sricCf
