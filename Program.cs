using System;
using System.Configuration;
using System.Data.SqlClient;

namespace SqlTest
{
    class Program
    {
        static void Main(string[] args)
        {
            string connStr = ConfigurationManager.AppSettings["sqlconn"];
            SqlConnection conn = new SqlConnection(connStr);

            conn.Open();

            string db = conn.Database;
            Console.WriteLine("Connected to DB: " + db);

            Random ran = new Random();
            int numRuns = int.Parse(ConfigurationManager.AppSettings["numRuns"]);
            int maxRow = int.Parse(ConfigurationManager.AppSettings["maxRow"]);

            Console.WriteLine("Running {0} times against {1} rows", numRuns, maxRow);

            DateTime now = DateTime.Now;
            DateTime now1 = DateTime.Now;

            for (int i = 0; i < numRuns; i++)
            {
                int itemNumToRetrieve = ran.Next(1, maxRow);
                SqlCommand cmd = new SqlCommand("select itemid, itemname from items where itemname = 'foo" + itemNumToRetrieve + "'", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    if (!reader.HasRows)
                    {
                        Console.WriteLine("No rows!");
                    }
                    if (i % 10000 == 0 && i > 0)
                    {
                        TimeSpan diff1 = DateTime.Now - now1;
                        Console.WriteLine("{0},{1}", i, diff1.TotalMilliseconds);
                        now1 = DateTime.Now;
                    }
                }
            }

            TimeSpan diff = DateTime.Now - now;
            Console.WriteLine("Total time (ms): " + diff.TotalMilliseconds);
        }
    }
}
