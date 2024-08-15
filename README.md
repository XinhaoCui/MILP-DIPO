# MILP-DIPO：The main algorithm of “Timeliness-oriented rush repair optimization of workforce scheduling and routing for logically complex systems under uncertainty” （Manuscript submitted to RESS）
Codes and models of MILP-DIPO

1.News📰

**[2024.08.15]** We upload the algorithm code for MILP-DIPO and the model on TO-RWSRP-MILP

2.Overview✨

The optimization of workforce scheduling and routing problems (**WSRPs**) with a focus on timeliness-oriented rush repair in logically complex systems has received extensive attention because of the escalating degree and frequency of both natural and anthropogenic disasters. As there are many characteristics of complex system rush-repair, such as wide distribution but complex logical correlations, limited repair time, and different criticality levels, conventional approaches, such as distance priority, exhibit shortcomings in terms of timeliness (i.e., a comprehensive indicator that integrates both timely and mission reliability). 
![image](https://github.com/user-attachments/assets/ab4f6884-79c3-47e8-bc5c-724900df4755)

To improve the overall emergency response efficiency under uncertain disaster scenarios, we develop a general timeliness-oriented decision-making framework for rush-repair WSRP. An optimization model is then formulated based on integer linear programming to maximize the overall rush-repair timeliness while satisfying the skill-matching requirements and system-level recovery constraints. 

Furthermore, a novel **matheuristic algorithm** (i.e., the interoperation of metaheuristic and mathematical programming technique) is proposed as a general solution approach for rush-repair decision-making under serialized system disruption scenarios. Finally, diverse benchmark groups, including different scales and sparsity levels, are simulated to conduct computational experiments. Compared to several representative algorithms, the results show that the proposed method has strong robustness and high efficiency.
![image](https://github.com/user-attachments/assets/8f137121-6e43-4179-97bf-e5e8c5b2b76f)

3.Data Preparation➡️

Description of benchmark groups
![image](https://github.com/user-attachments/assets/745d0545-e351-4b03-8b06-1b0ec4b7e660)

4.Main Results🚀

Comparison table of solution
![image](https://github.com/user-attachments/assets/aea0e36c-8952-4a26-a334-91044d907fcd)

5.Data visualization👀

Comparison table of output
![image](https://github.com/user-attachments/assets/a9ace63b-611a-4f55-848b-c16fcbf02dbe)

Comparison table of computational  time
![image](https://github.com/user-attachments/assets/a5297090-ffde-4933-8266-6a187148c9f4)

6.Experimental environment🔨

The MIP solver AMPL/CPLEX (version 12.6.0.1) was used to solve the proposed MILP model using the synthesized problem instances. Computational experiments were performed on a PC server with two 2.30 GHz Intel 32 Core Processors and 128 GB of memory.

7.Contact☎️

If you have any questions, please feel free to reach me out at cuixinhao@buaa.edu.cn

8.Acknowledgements👍

We would like to thank all anonymous reviewers very much for their valuable comments and suggestions, which had helped us to improve the quality and presentation of the paper and algorithm substantially.

9.Citation✏️
If you think this project is helpful, please feel free to leave a star⭐️ and cite our paper:
Timeliness-oriented rush repair optimization of workforce scheduling and routing for logically complex systems under uncertainty. Reliability Engineering & System Safety (Under review)


