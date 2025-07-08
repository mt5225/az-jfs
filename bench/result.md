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
