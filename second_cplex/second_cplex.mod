/*********************************************
 * OPL 12.9.0.0 Model
 * Author: mccurdy
 * Creation Date: Jul 1, 2019 at 9:17:23 PM
 *********************************************/

//i=subject
int N=3; //there are 28 nodes in the network
range r1 = 1..N; //we define ranges to declare dimensions of variables and parameters, you can define as many as you need
range subjects = 1..2;

//j = teacher
int N2=3;
range r2 = 1..N2;

//k= cohort
int N3=3;
range r3 = 1..N3;
range class = 1..2;

//t = time
int N4=12;
range day1 = 1..6;
range day2 = 7..12;

range r4 = 1..N4;

// Problem parameters are defined below
int prep[r2]= [96,96,48]; //prep time array
int lengtht[r4]= [40,60,50,50,60,40,40,60,50,50,60,40];   //demand at each node
int teachMin[r2]=[504,504,252];
string subj[r1] = ["Math", "Language", "Prep"];
int rijkt = 1;

//decision variables
dvar boolean x[r1][r2][r3][r4]; //x is the binary location variable, 'boolean' defines a binary variable

maximize  sum(i in r1,j in r2, k in r3, t in r4)(rijkt)*x[i,j,k,t]; //objective function in minimization type

subject to //constraints are declared below
{	
	//assignment1- only 1 teacher assigned to a cohort and subject at a time-fixed constr
	forall(i in subjects, k in class, t in r4) sum(j in r2)x[i,j,k,t] <= 1;
	
	//teacher can only teach one subject/class at a time- new constraint
	forall(j in r2, t in r4) sum(i in r1, k in r3)x[i,j,k,t] == 1;
	
	//assignment2 - at every time, each cohort needs only one teacher and one subject
	forall(k in class, t in r4) sum(i in subjects, j in r2)x[i,j,k,t] == 1;
	
	//assignment3- each cohort assigned to 12 time periods
	forall(k in class) sum(i in subjects, j in r2, t in r4)x[i,j,k,t] == 12;
	
	//math
	forall(k in class) sum(j in r2, t in day1) lengtht[t]*x[1,j,k,t] == 60;
	forall(k in class) sum(j in r2, t in day2) lengtht[t]*x[1,j,k,t] == 60;
	
	//language
	forall(k in class) sum(j in r2, t in day1) lengtht[t]*x[2,j,k,t] >= 100;
	forall(k in class) sum(j in r2, t in day2) lengtht[t]*x[2,j,k,t] >= 100;
	
	//prep
	forall(j in r2) sum(t in r4) lengtht[t]*x[3,j,3,t] >= prep[j];
	
	//teaching mins
	forall(j in r2) sum(t in r4, i in subjects, k in class) lengtht[t]*x[i,j,k,t] <= teachMin[j];
}

int mathTime[class];
int prepTime[r2];

execute
{
	for(var t in r4)
	{
		for(var i in r1)
		{
			for(var j in r2)
			{
				for(var k in r3)
				{
					if(x[i][j][k][t]==1)
					{
						writeln("Teacher", j," teaches cohort: ", k, " ", subj[i], " during period ", t);
						if(i==1)
						{
							mathTime[k]= mathTime[k]+ lengtht[t];					
						}
						if(i==3)
						{
							prepTime[j] = prepTime[j] + lengtht[t];						
						}
   					}						
				}			
			}					
		}	
	}
}

 