# SqlNetworkLatencyTester
Tool to test and report on network latency to a SQL DB. This can be used against any MS SQL database including PaaS and IaaS databases in Azure. 

This uses the .NET Framework System.Data.SqlClient. It opens a single connection and then in a loop looks up items from the item table by itemname.

The elapsed time tells how long it took to perform the amount of queries indicated in the config file. Smaller numbers indicate better performance. 


To use: 

1. Create the test table in your DB by running ```SQLQuery.sql```. This script creates a table called _items_. By default the 
script creates 20,000 rows. You can change this but you will also want to change the maxRow value in the config file.
1. Update the connection string in the App.config file to point to the database. 
1. Update the number of runs you want. 
1. Run: ```.\SqlTest.exe```

Note: you will get an elapsed time for each 10K of queries. 
```
C:\source\SqlTest\bin\Release> .\SqlTest.exe
Connected to DB: TestDb
Running 100000 times against 20000 rows
10000,1002.3456
20000,923.4651
30000,997.0607
40000,916.9079
50000,917.6408
60000,886.0189
70000,901.8941
80000,886.0717
90000,880.7538
Total time (ms): 9197.4908
C:\source\SqlTest\bin\Release>
```

There is a powershell script that allows you to change Azure PaaS SQL database sizes to see the performance differences. Results are written to the screen and to a log file. 

This file is ```perftest.ps1``` and requires the Azure Powershell tools and for you to be logged into your azure account. It will change the 
scale of the database then run the SqlTest several times. Results are displayed on the screen and logged to a file. By commenting out 
the lines at the top of the file you can select which DB scale sizes to test. 