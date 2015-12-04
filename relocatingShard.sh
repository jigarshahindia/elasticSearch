cnt=0
index=0
for shard in $(curl -XGET localhost:9200/_cat/shards | grep UNASSIGNED | awk '{print $1, $2}'); do
    result=`expr $cnt % 2`

    if [ $result -eq 0 ]; then
          index=$shard
    else
        curl -XPOST 'localhost:9200/_cluster/reroute' -d '{
        "commands" : [ {
              "allocate" : {
                  "index" : "'"$index"'", 
                  "shard" : "'"$shard"'", 
                  "node" : "localhost:9201", 
                  "allow_primary" : true
              }
            }
        ]
        }'
         echo $index
         echo $shard
    fi
    ((cnt++))
done
