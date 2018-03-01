
select table_name,
       partition_name,
       max_begin,
       max_end,
       range_diff,
       currdate,
       leftdays,
       floor(leftdays / range_diff) "left_parts",
       3 - floor(leftdays / range_diff) "expand_parts"
  from (select table_name,
               max(partition_name) "partition_name",
               split(max(partition_range), '-') [ 0 ] "max_begin",
               split(max(partition_range), '-') [ 1 ] "max_end",
               datediff(tdh_todate(split(max(partition_range), '-') [ 1 ],
                                   'yyyyMMdd',
                                   'yyyy-MM-dd'),
                        tdh_todate(split(max(partition_range), '-') [ 0 ],
                                   'yyyyMMdd',
                                   'yyyy-MM-dd')) range_diff,
               tdh_todate(sysdate, 'yyyy-MM-dd') "currdate",
               datediff(tdh_todate(split(max(partition_range), '-') [ 1 ],
                                   'yyyyMMdd',
                                   'yyyy-MM-dd'),
                        tdh_todate(sysdate, 'yyyy-MM-dd')) "leftdays"
          from system.range_partitions_v
         where upper(database_name) = upper('XXXXXXX')
           and partition_range not like '%VALUE%'
         group by table_name)
  where range_diff between 300 and 400
    and floor(leftdays / range_diff) < 3;



 
