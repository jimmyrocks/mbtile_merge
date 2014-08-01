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

# { Combine Sources
  counter=1
  cat $source_list | while read line
  do
    counter=$((counter+1))
    dest=`head $source_list -n $((counter+1)) | tail -n 1`
    if [[ "$line" != "$dest" ]]
    then
      #echo "source: "$line
      #echo "  dest: "$dest
      echo "merging $line into $dest"
      bash ./mbutil/patch "./"$line".mbtiles" "./"$dest".mbtiles"
    fi
  done
# }

# { copy the final file to the new mapbox id
  last=`tail $source_list -n 1`
  cp $last.mbtiles $mapbox_id.mbiltes
  echo "UPDATE metadata SET value = '$mapbox_id' WHERE name = 'name';" | sqlite3 $mapbox_id.mbiltes
# }

# { Delete the downloaded files
  cat $source_list | while read line
  do
    rm $line.mbtiles
    rm -f $line.mbtiles-journal
  done
# }

# { Upload to Mapbox
  # TODO
# }

echo "Complete!"
