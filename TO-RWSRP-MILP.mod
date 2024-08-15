#Set
set S;		#set of system
set N;		#set of faulty unit
set P;		#set of team
set F;		#set of skill


#Property
param C{S};			#service capacity of the system
param LX{N};		#x-axis of the unit
param LY{N};		#y-axis of the unit
param T{N};			#execution time on rush-repair mission of unit
param LP{P,1..2};	#coordinates of the team

param D1{N,N};		#distance in Euclidean metric between unit
param D2{P,N};		#distance in Euclidean metric between team  and unit


#Relationship
param H{S,N} binary;		#Binary parameter indicating whether the system is composed of unit or not
param A{N,F} >=0 integer;	#Level requirement of unit for skill 
param A1{N,F} binary;		#Binary parameter indicating whether the unit i has a skill demand for repair skill
param B{P,F};				#Level of skill mastered by team 
param m{S} >=0;		#Importance of emergency rush-repair for system
param n{S} >=0;		#Probability of system being interrupted again due to post-disaster factors

param V:=60;
param h:=300;		#latest repair time for evaluating the rush-repair timeliness of systems
param M:=999999999;


#Variable
var o{S} binary;		#Binary variable denoting whether the service capacity of system is restored or not
var x{N} binary;		#Binary variable denoting whether unit is repaired or not
var y{N,P} binary;		#Binary variable denoting whether unit i is assigned to team p to perform rush-repair mission (yip = 1) or not (yip = 0)
var y1{N,P} binary;		#Binary variable denoting whether unit i is the first station (uip = 1) for team p or not (uip = 0) 
var y2{N,P} binary;		#Binary variable denoting whether unit i is the last station (wip = 1) for team p or not (wip = 0) 
var z{N,N} binary;		#Binary variable denoting whether arc (i,j) is traveled (zij = 1) or not (zij = 0) 
var e{S}>=0;			#Continuous variable denoting restoration time of system s
var e1{S}>=0;			#Continuous variable denoting rush-repair timeliness of system s
var full_time>=0;
var a{N}>=0;			#Continuous variable denoting starting time of rush-repair mission for unit i


#Objective function
maximize Total_eff_C: sum{s in S}e1[s]*m[s]*(1-n[s]);


#Constraint
subject to Con1{s in S, i in N: H[s,i]=1}:
	o[s] <= x[i];
	
subject to Con2{i in N}:
	sum{p in P}y[i,p] = x[i]; 

subject to Con3{i in N, p in P, f in F}:
	B[p,f] >= A[i,f] - M*(3 - x[i] - y[i,p] - A1[i,f]); 

subject to Con5{i in N, p in P}:
	a[i] >= 60*D2[p,i]/V - M*(1-y[i,p]);

subject to Con6{i in N, j in N: i<>j}:
	a[j] >= a[i] + T[i] + 60*D1[i,j]/V - M*(1-z[i,j]);

subject to Con7a{i in N, p in P}:
	y1[i,p] <= y[i,p];
subject to Con7b{p in P}:
	sum{i in N}y1[i,p] = 1;

subject to Con8a{i in N, p in P}:
	y2[i,p] <= y[i,p];
subject to Con8b{p in P}:
	sum{i in N}y2[i,p] = 1;

subject to Con8c{i in N, j in N, p in P: i<>j}:
	y[i,p] - y[j,p] >= z[i,j] - 1;

subject to Con9a{i in N}:
	sum{p in P}y1[i,p] + sum{j in N:i<>j}z[j,i] = x[i];

subject to Con9b{i in N}:
	sum{p in P}y2[i,p] + sum{j in N:j<>i}z[i,j] = x[i];

subject to Con11{i in N}:
	a[i]+T[i] <= h + M*(1-x[i]);
	
subject to Con12{i in N}:
	a[i] <= M*x[i];
	
subject to Con13{s in S, i in N: H[s,i]=1}:
	e[s] >= a[i] + T[i] - M*(1-x[i]);

subject to Con10_1{s in S}: e1[s] <= C[s]*(h - e[s]);
subject to Con10_2{s in S}: e1[s] <= M*o[s];
