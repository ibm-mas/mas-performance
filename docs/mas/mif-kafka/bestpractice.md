# MAS Manage MIF/Kafka

## Lab Result Highlights

- Same to [MIF/JMS test](../mif-jms/bestpractice.md), the lab results indicate a significant correlation between the transaction persecond (TPS) and database disk IO utilization. This correlation suggests that the level of transactionalactivity directly impacts the IO workload on the database disk. Conversely, the IO workload acts as alimitation on the system's ability to handle a larger volume of transactions.

- The results also demonstrate a notable connection between the disk IO throughput and the TPS (Transactions Per Second).

- Doubling the number of CRON JVMs and Kafka topic partitions leads to a twofold increase in the maximum TPS. However, this change also results in an enlarged distribution difference, growing from 2% to 10%. Consequently, in the final phase, the overall processing rate diminishes, with the TPS decreasing from 72 to 66, attributed to the Kafka rule - which allows a maximum of 1 consumer per partition.

- Increasing the number of partitions may result in better performance for small messages (e.g., 10 assetsper message) compared to large messages. Please ensure that there are an adequate number ofmessages in the queue for processing.

- When evaluating the performance of a single MEA JVM, the TPS in MIF/Kafka matches that of JMS. Nevertheless, when multiple processing JVMs are utilized, JMS surpasses performance due to its more equitable workload distribution. From a best-practice standpoint, it is advisable to have one Kafka topic with 6 partitions and multiple Kafka topics for parallel processing.