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
root@vm-lvki:~# juicefs bench /jfs -p 4
  Write big blocks: 4096/4096 [==============================================================]  104.0/s  used: 39.396245604s
   Read big blocks: 4096/4096 [==============================================================]  257.2/s  used: 15.924818759s
Write small blocks: 400/400 [==============================================================]  150.6/s  used: 2.656664575s 
 Read small blocks: 400/400 [==============================================================]  913.0/s  used: 438.334331ms 
  Stat small files: 400/400 [==============================================================]  4454.4/s used: 89.855665ms  
Benchmark finished!
BlockSize: 1.0 MiB, BigFileSize: 1.0 GiB, SmallFileSize: 128 KiB, SmallFileCount: 100, NumThreads: 4
Time used: 61.8 s, CPU: 69.5%, Memory: 723.0 MiB
+------------------+------------------+---------------+
|       ITEM       |       VALUE      |      COST     |
+------------------+------------------+---------------+
|   Write big file |     103.97 MiB/s |  39.39 s/file |
|    Read big file |     257.35 MiB/s |  15.92 s/file |
| Write small file |    150.6 files/s | 26.55 ms/file |
|  Read small file |    915.9 files/s |  4.37 ms/file |
|        Stat file |   4486.7 files/s |  0.89 ms/file |
|   FUSE operation | 71592 operations |    2.41 ms/op |
|      Update meta |  1280 operations |    4.86 ms/op |
|       Put object |  1424 operations |  551.03 ms/op |
|       Get object |  1024 operations |  220.48 ms/op |
|    Delete object |     0 operations |    0.00 ms/op |
| Write into cache |   840 operations |   19.01 ms/op |
|  Read from cache |   400 operations |    0.21 ms/op |
+------------------+------------------+---------------+
```


## P = 6

```
root@vm-lvki:~# juicefs bench /jfs -p 6
  Write big blocks: 6144/6144 [==============================================================]  103.4/s  used: 59.41267474s 
   Read big blocks: 6144/6144 [==============================================================]  261.6/s  used: 23.483351335s
Write small blocks: 600/600 [==============================================================]  135.3/s  used: 4.434326836s 
 Read small blocks: 600/600 [==============================================================]  1036.7/s used: 578.853519ms 
  Stat small files: 600/600 [==============================================================]  5413.8/s used: 110.897155ms 
Benchmark finished!
BlockSize: 1.0 MiB, BigFileSize: 1.0 GiB, SmallFileSize: 128 KiB, SmallFileCount: 100, NumThreads: 6
Time used: 93.7 s, CPU: 66.7%, Memory: 784.9 MiB
+------------------+-------------------+---------------+
|       ITEM       |       VALUE       |      COST     |
+------------------+-------------------+---------------+
|   Write big file |      103.41 MiB/s |  59.41 s/file |
|    Read big file |      261.66 MiB/s |  23.48 s/file |
| Write small file |     135.3 files/s | 44.34 ms/file |
|  Read small file |    1038.4 files/s |  5.78 ms/file |
|        Stat file |    5457.4 files/s |  1.10 ms/file |
|   FUSE operation | 107590 operations |    3.71 ms/op |
|      Update meta |   1917 operations |    5.21 ms/op |
|       Put object |   2136 operations |  552.38 ms/op |
|       Get object |   1536 operations |  258.72 ms/op |
|    Delete object |      0 operations |    0.00 ms/op |
| Write into cache |   1128 operations |   20.51 ms/op |
|  Read from cache |    600 operations |    0.25 ms/op |
+------------------+-------------------+---------------+
```