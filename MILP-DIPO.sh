model TO-RWSRP-MILP.mod;
#data 50-20-12.dat;
data s4.dat;
option solver cplex;
#option randseed 0;

#option cplex_options  "mipdisplay=2 absmipgap=1.0e-12 feasibility=1.0e-9 return_mipgap=3 timelimit=10800 concurrentopt";
option cplex_options  "mipdisplay=2 return_mipgap=3 timelimit=3600";
suffix relmipgap OUT; 
suffix absmipgap OUT;

for{i in N, j in N}let D1[i,j]:= sqrt((LX[i]-LX[j])^2 + (LY[i]-LY[j])^2);
for{p in P, i in N}let D2[p,i]:= sqrt((LP[p,1]-LX[i])^2 + (LP[p,2]-LY[i])^2);

#Initial solution construction
param T0{P,N} ;	#travel time
param Tt{N};	#travel plus repair time
param T1{N};
for{p in P,i in N}let T0[p,i]:=60*D2[p,i]/V;
for{i in N}let T1[i]:=min{p in P}T0[p,i];
for{p in P,i in N}let Tt[i]:=T[i] + T1[i];
display Tt;

param PPP{S};
for{s in S} let PPP[s]:=sum{i in N:H[s,i]=1}Tt[i];

param PP{S};
for{s in S}let PP[s]:=C[s];
display PP;

param PR{S};
param TotalS;
param tempi;
param tempk;
let TotalS:=card(S);

for{k1 in 1..TotalS}let PR[k1]:=k1;

for{k1 in 1..TotalS}
			{
				for{k2 in k1+1..TotalS}
				{
					if(PP[k1] < PP[k2]) then
					{
						let tempi:=PP[k1];
						let PP[k1]:=PP[k2];
						let PP[k2]:=tempi;
						
						let tempk:=PR[k1];
						let PR[k1]:=PR[k2];
						let PR[k2]:=tempk;
						
					}
				}
			}
	
param icount;	
param op1;
param op;

param randn;
param randp;

param DR{N};
param PDR{N};
param tempii;
param tempkk;	
param DP{P};
param PDP{P};
param tempiii;
param tempkkk;	#NNS

param pri{N};
param priR{N};
param tempjj;
param temphh;	#IPS

param sk{P};
param skR{P};
param temppp;
param tempff;	#SPS


param startT;
param wd;
param wp;
param TotalN;
param TotalP;

param useN{1..3};
param succN{1..3};

param obj_c;
param obj_best;
param obj1;

param rat{1..3};

param count;
param newcount;
param goodcount{S};

for {run in 1..10}
{
	let icount:=card(S);
	let count:=1;
	let newcount:=0;
	for {i in 1..TotalS}let goodcount[i]:=0;
	unfix o;
	unfix x;
	unfix y;
	unfix y1;
	unfix y2;
	unfix z;

	for {iii in 1..TotalS}
	{
		if (newcount=0)then
		{
			for{s in 1..count}let o[PR[s]]:=1;
		}
		else
		{
			display goodcount;
			display goodcount[1];
			for {s in 1..TotalS}let o[s]:=0;
			# for{s in 1..goodcount[1]}let o[PR[s]]:=1;
			for{s in 1..TotalS}
			{
				if (goodcount[s]!=0)then let o[PR[goodcount[s]]]:=1;
			}
			let o[PR[newcount+1]]:=1;
			let count:=newcount+1;
		}
		display o;
		fix o;
		objective Initiali;
		drop newCon;
		solve;
		
		if (solve_result = "solved") then
		{
			# let cs:=Total_C;
			# objective Total_time;
			# restore newCon;
			# solve;
			let goodcount[count]:=count;
			let count:=count+1;
			
		}
		else
		{
			if (TotalS-count>1) then
			{
				let newcount:=count+1;
			}
			else if(TotalS-count=1) then
			{
				let newcount:=count;
			}
			else if(count=TotalS)then
			{
				break;
			}
		}
	}

	for {s in 1..TotalS} let o[s]:=0;
	for{s in 1..TotalS}
	{
		if (goodcount[s]!=0)then let o[PR[goodcount[s]]]:=1;
	}
	fix o;
	objective Total_eff_C;
	solve;
	display o;
	display x;
	display y;
	let obj1:=Total_eff_C;
	let obj_c:=Total_eff_C;
	let obj_best:=obj_c;

	#Initial

	for{i in 1..3}let useN[i]:=0;
	for{i in 1..3}let succN[i]:=0;
	
	##handwrite
	let wd:=10;
	let wp:=3;
	let startT:= _total_solve_elapsed_time;


	repeat
	{
		
		if(_total_solve_elapsed_time-startT>7200)then break;
		let randn:=round(Uniform(1,card(N)));
		let op1:=Uniform01();
		if(op1<=0.333333)then
		{
			let op:=1;
		}
		else if (op1<=0.666666)then
		{
			let op:=2;
		}
		else
		{
			let op:=3;
		}
		
		#1
		for {j in N:j<>randn}let DR[j]:=D1[randn,j];
		let DR[randn]:=10000;
		let TotalN:=card(N);
		for{k1 in 1..TotalN}let PDR[k1]:=k1;
		for{k1 in 1..TotalN}
		{
			for{k2 in k1+1..TotalN}
			{
				if(DR[k1] < DR[k2]) then
				{
					let tempii:=DR[k1];
					let DR[k1]:=DR[k2];
					let DR[k2]:=tempii;
					
					let tempkk:=PDR[k1];
					let PDR[k1]:=PDR[k2];
					let PDR[k2]:=tempkk;
					
				}
			}
		}
		for {p in P}let DP[p]:=D2[p,randn];
		let TotalP:=card(P);
		for{k1 in 1..TotalP}let PDP[k1]:=k1;
		for{k1 in 1..TotalP}
		{
			for{k2 in k1+1..TotalP}
			{
				if(DP[k1] < DP[k2]) then
				{
					let tempiii:=DP[k1];
					let DP[k1]:=DP[k2];
					let DP[k2]:=tempiii;
					
					let tempkkk:=PDP[k1];
					let PDP[k1]:=PDP[k2];
					let PDP[k2]:=tempkkk;
				}
			}
		}
		
		#2
		for {j in N:j<>randn}let pri[j]:=sum{s in S}o[s]*H[s,j];
		let pri[randn]:=10000;
		for{k1 in 1..TotalN}let priR[k1]:=k1;
		for{k1 in 1..TotalN}
		{
			for{k2 in k1+1..TotalN}
			{
				if(pri[k1] < pri[k2]) then
				{
					let tempjj:=pri[k1];
					let pri[k1]:=pri[k2];
					let pri[k2]:=tempjj;
					
					let tempkk:=priR[k1];
					let priR[k1]:=priR[k2];
					let priR[k2]:=tempkk;
					
				}
			}
		}
		
		
		#3
		for{k1 in 1..TotalP}let skR[k1]:=k1;
		for{k1 in 1..TotalP}
		{
			for{k2 in k1+1..TotalP}
			{
				if(skR[k1] < skR[k2]) then
				{
					let temppp:=skR[k1];
					let skR[k1]:=skR[k2];
					let skR[k2]:=temppp;
					
					let tempff:=skR[k1];
					let skR[k1]:=skR[k2];
					let skR[k2]:=tempff;
					
				}
			}
		}
		
		
		let randp:=round(Uniform(1,card(P)));
		
		fix o;
		fix x;
		fix y;
		fix y1;
		fix y2;
		fix z;
		
		display x;
		display y;
		if(op=1) then
		{
			for{i in 1..wd,p in 1..wp}
			{	
				
				unfix o;
				unfix x[PDR[i]];
				unfix y[PDR[i],PDP[p]];
				unfix y1;
				unfix y2;
				unfix z;
				# for {ii in N,pp in 1..wp}
				# {
					# if(y[ii,pp]=1)then
					# {
						# unfix x[ii];
						# unfix y[ii,pp];
					# }
				# }
			}
			display x;
			display y;
		}
		
		if(op=2) then
		{
			for{i in 1..wd,p in 1..wp}
			{	
				
				unfix o;
				unfix x[priR[i]];
				unfix y[priR[i],PDP[p]];
				unfix y1;
				unfix y2;
				unfix z;
				# for {ii in N,pp in 1..wp}
				# {
					# if(y[ii,pp]=1)then
					# {
						# unfix x[ii];
						# unfix y[ii,pp];
					# }
				# }
			}
		}
		
		if(op=3) then
		{	
			unfix o;
			unfix y1;
			unfix y2;
			unfix z;
			for {i in N,p in 1..wp}
			{
				if (y[i,p]=1)then
				{
					unfix x[i];
					unfix y[i,skR[p]];
				}
			}
		}
		let useN[op]:=useN[op]+1;
		
		
		objective Total_eff_C;
		
		solve;
		display op;
		display skR;
		display PDR;
		display priR;
		display randn;
		display randp;
		display o;
		display x;
		display y;
		display z;
		display y1;
		display y2;
		display a;
		
		display icount;
		if(_solve_elapsed_time<0.2 and wd<TotalN)then let wd:=wd+1;
		if(_solve_elapsed_time>2 and wd>=5)then let wd:=wd-1;
		# {
			# if(op=1 or op=2 and wd>=5)then
			# {
				# let wd:=wd-1;
			# }
			# if(op=3 and wp>=3)then
			# {
				# let wp:=wp-1;
			# }
		# }
		if(Total_eff_C>obj_c)then
		{
			#let cs:=Total_eff_C;
			#restore newCon;
			solve;
			unfix o;
			unfix x;
			unfix y;
			unfix y1;
			unfix y2;
			unfix x;
			unfix y;
			unfix y1;
			unfix y2;
			unfix z;
			let obj_c:=Total_eff_C;
			let icount:=0;
			display o;
			display x;
			display y;
			display z;
			display y1;
			display y2;
			display a;
			display _total_solve_elapsed_time;
			display Total_eff_C;
			display op;
			let succN[op]:=succN[op]+1;
		}
		else
		{
			let icount:=icount+1;
			if(op=1)then
			{
				let op:=2;
			}
			else if (op=2)then
			{
				let op:=3;
			}
			else
			{
				let op:=1;
			}
		}
	} until icount>50;

	display icount;
	display o;
	display x;
	display y;
	display z;
	display y1;
	display y2;
	display a;
	display e;
	display e1;
	display _total_solve_elapsed_time;
	display Total_eff_C;
	display op;
	for{i in 1..3}let rat[i]:=succN[i]/useN[i];
	display rat;
	printf "run=%d, op=%d, NonP=%d, obj=%f, t=%d\n ,wd=%d,wp=%d", run, op, icount, obj_c, _total_solve_elapsed_time - startT,wp,wd >>dipo.out;
	printf "run=%d,  obj=%f, useN[1,2,3]=[%d,%d,%d], succN[1,2,3]=[%d,%d,%d], rat[1,2,3]=[%d,%d,%d],t=%d\n", run,  obj_c, useN[1], useN[2], useN[3], succN[1], succN[2], succN[3], rat[1], rat[2], rat[3], _total_solve_elapsed_time - startT >>dipo-opt.out;
	for{k in 1..15}
		{
			printf "k=%d, gk1=%d, obj_1=%f",k, goodcount[k], obj1 >> _detail.out;			
		}
}
