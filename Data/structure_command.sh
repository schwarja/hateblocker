cat labeled_data.csv | grep -e "^[0-9][0-9]*," | sed 's/[0-9]*,[0-9]*,[0-9]*,[0-9]*,[0-9]*,//; /^$/d; s/"*//g; s/\([0-9]*\),\(.*\)/\{^M"text": "\2",^M"label": "\1"^M\},/'
