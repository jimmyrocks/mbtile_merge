#!/bin/bash
# Set Defaults {
  source_list=sources.txt # May want to bring this is as $1 ?
  mapbox_id=$1 # If above gets $1, this should be changed to $2
# }

# { Verify that a mapbox id has been passed in
  while [[ $mapbox_id == "" ]]
  do
    echo    "╔════════════════════════════════════════════════════════════════════════════╗"
    echo    "  MapBox id"
    read -p "  What would you like the mapbox id to be?: " mapbox_id
    echo    "══════════════════════════════════════════════════════════════════════════════"
    echo    ""
    if [[ $mapbox_id == "" ]]; then
      echo "You must enter a mapbox id"
    fi
  done
# }

# { Download Sources
  cat $source_list | while read line
  do
    echo "Downloading $line from Mapbox"
    curl -O -L http://a.tiles.mapbox.com/v3/$line.mbtiles
  done
# }

./process_sources.sh $mapbox_id
