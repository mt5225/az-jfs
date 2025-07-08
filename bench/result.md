# Setting 1
- region = japaneast 
- vm = Standard B4ms (4 vcpus, 16 GiB memory)
- redis = Running - Premium 6 GB
- azure blob

## P = 2
```
root@vm-lvki:~# juicefs bench /jfs -p 2
  Write big blocks: 2048/2048 [==========================================================]  103.8/s  used: 19.730138942s
   Read big blocks: 2048/2048 [==========================================================]  236.5/s  used: 8.659435653s 
Write small blocks: 200/200 [============================================================]  92.5/s   used: 2.162357766s 
 Read small blocks: 200/200 [============================================================]  542.7/s  used: 368.595169ms 
  Stat small files: 200/200 [============================================================]  1893.8/s used: 105.666248ms 
Benchmark finished!
BlockSize: 1.0 MiB, BigFileSize: 1.0 GiB, SmallFileSize: 128 KiB, SmallFileCount: 100, NumThreads: 2
Time used: 33.0 s, CPU: 66.7%, Memory: 544.0 MiB
+------------------+------------------+---------------+
|       ITEM       |       VALUE      |      COST     |
+------------------+------------------+---------------+
|   Write big file |     103.80 MiB/s |  19.73 s/file |
|    Read big file |     236.53 MiB/s |   8.66 s/file |
| Write small file |     92.6 files/s | 21.61 ms/file |
|  Read small file |    544.2 files/s |  3.68 ms/file |
|        Stat file |   1907.3 files/s |  1.05 ms/file |
|   FUSE operation | 35688 operations |    1.47 ms/op |
|      Update meta |   639 operations |    6.37 ms/op |
|       Put object |   712 operations |  548.01 ms/op |
|       Get object |   512 operations |  174.56 ms/op |
|    Delete object |     0 operations |    0.00 ms/op |
| Write into cache |   572 operations |   14.12 ms/op |
|  Read from cache |   200 operations |    0.15 ms/op |
+------------------+------------------+---------------+
```

## P = 4

```
root@vm-lvki:/home/mt5225# juicefs bench /jfs -p 4
  Write big blocks: 4096/4096 [===========================================================]  108.3/s  used: 37.834716747s
   Read big blocks: 4096/4096 [===========================================================]  508.4/s  used: 8.057125267s 
Write small blocks: 400/400 [=============================================================]  129.3/s  used: 3.093662575s 
 Read small blocks: 400/400 [=============================================================]  426.9/s  used: 937.157419ms 
  Stat small files: 400/400 [=============================================================]  3640.5/s used: 109.933923ms 
Benchmark finished!
BlockSize: 1.0 MiB, BigFileSize: 1.0 GiB, SmallFileSize: 128 KiB, SmallFileCount: 100, NumThreads: 4
Time used: 57.1 s, CPU: 52.8%, Memory: 728.3 MiB
+------------------+------------------+---------------+
|       ITEM       |       VALUE      |      COST     |
+------------------+------------------+---------------+
|   Write big file |     108.27 MiB/s |  37.83 s/file |
|    Read big file |     508.41 MiB/s |   8.06 s/file |
| Write small file |    129.3 files/s | 30.93 ms/file |
|  Read small file |    427.2 files/s |  9.36 ms/file |
|        Stat file |   3664.5 files/s |  1.09 ms/file |
|   FUSE operation | 71599 operations |    2.81 ms/op |
|      Update meta |  1279 operations |    5.19 ms/op |
|       Put object |  1424 operations |  530.22 ms/op |
|       Get object |  1197 operations |  138.48 ms/op |
|    Delete object |     0 operations |    0.00 ms/op |
| Write into cache |  1254 operations |    7.49 ms/op |
|  Read from cache |   227 operations |    5.40 ms/op |
+------------------+------------------+---------------+
```

## Objbench P=4

```
+----------+---------------------+--------------------------------------------------+
| CATEGORY |         TEST        |                      RESULT                      |
+----------+---------------------+--------------------------------------------------+
|    basic |     create a bucket |                                             pass |
|    basic |       put an object |                                             pass |
|    basic |       get an object |                                             pass |
|    basic |       get non-exist |                                             pass |
|    basic |  get partial object | failed to get object with the offset out of r... |
|    basic |      head an object |                                             pass |
|    basic |    delete an object |                                             pass |
|    basic |    delete non-exist |                                             pass |
|    basic |        list objects |                                             pass |
|     sync |         special key | put encode file failed: PUT https://stlvki.bl... |
|     sync |    put a big object |                                             pass |
|     sync | put an empty object |                                             pass |
|     sync |    multipart upload |                                      not support |
|     sync |  change owner/group |                                      not support |
|     sync |   change permission |                                      not support |
|     sync |        change mtime |                                      not support |
+----------+---------------------+--------------------------------------------------+

Start Performance Testing ...
put small objects: 100/100 [=============================================================]  443.0/s   used: 225.75687ms  
get small objects: 100/100 [=============================================================]  791.8/s   used: 126.595253ms 
   upload objects: 256/256 [=============================================================]  14.8/s    used: 17.306048732s
 download objects: 256/256 [=============================================================]  26.5/s    used: 9.647101038s 
     list objects: 1424/1424 [===========================================================]  23004.4/s used: 61.971746ms  
     head objects: 356/356 [=============================================================]  1660.5/s  used: 214.49309ms  
   delete objects: 356/356 [=============================================================]  671.2/s   used: 530.560376ms 
Benchmark finished! block-size: 4.0 MiB, big-object-size: 1.0 GiB, small-object-size: 128 KiB, small-objects: 100, NumThreads: 4
+--------------------+--------------------+-----------------------+
|        ITEM        |        VALUE       |          COST         |
+--------------------+--------------------+-----------------------+
|     upload objects |        59.17 MiB/s |      270.40 ms/object |
|   download objects |       106.17 MiB/s |      150.70 ms/object |
|  put small objects |   444.25 objects/s |        9.00 ms/object |
|  get small objects |   811.52 objects/s |        4.93 ms/object |
|       list objects | 23444.83 objects/s | 60.74 ms/ 356 objects |
|       head objects |  1671.59 objects/s |        2.39 ms/object |
|     delete objects |   672.99 objects/s |        5.94 ms/object |
| change permissions |        not support |           not support |
| change owner/group |        not support |           not support |
|       update mtime |        not support |           not support |
+--------------------+--------------------+-----------------------+
```