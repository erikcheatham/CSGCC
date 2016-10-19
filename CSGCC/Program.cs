using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication1
{
    class Solution
    {
        public static void Main(string[] args)
        {
            string der =
 @"00:01:07,400-234-090
   00:05:01,701-080-080
   00:05:00,400-234-090";
            Solution sol = new Solution();
            int cost = sol.solution(der);
        }

        public int solution(string S)
        {
            List<string[]> phoneTable = new List<string[]>();
            List<string> phoneNumbers = new List<string>();

            string[] logs = S.Split(new string[] { "\r\n", "\n" }, StringSplitOptions.None);

            foreach (string z in logs)
            {
                string[] callArr = z.Split(',');
                phoneTable.Add(callArr);
                phoneNumbers.Add(callArr[1]);
            }

            //running count
            int i = 0;

            //remember me
            string[] culprit = { };

            foreach (string[] duh in phoneTable)
            {
                //checker count
                int j = phoneNumbers.Where(x => x == duh[1]).Count();
                if (i == 0)
                {
                    i = j;
                    culprit = duh;
                }
                else if (j < i)
                {
                    i = j;
                    culprit = duh;
                }

                //TODO: equal durations
                //else if ()
            }

            string costDirty = culprit[0].Replace(":", "").Trim();
            int hours = int.Parse(costDirty.Substring(0, 2));
            int minutes = int.Parse(costDirty.Substring(2, 2));
            int seconds = int.Parse(costDirty.Substring(4, 2));
            int cost = 0;

            if (minutes < 5)
            { }
            else if (minutes >= 5)
            {
                cost = minutes * 150;
                if (seconds > 0 && seconds <= 60)
                {
                    cost = cost + 150;
                }
            }
            else
            { }

            return cost;
        }
    }
}
