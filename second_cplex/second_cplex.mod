/*********************************************
 * OPL 12.9.0.0 Model
 * Author: mccurdy
 * Creation Date: Jul 1, 2019 at 9:17:23 PM
 *********************************************/
//this is the intial assignment problem
//i=subject
//9 because 7 subjects 2 dummies

int N=9; 
range r1 = 1..N; 
range subjects = 1..7;
string subj[r1] = ["Math", "Language","Science", "Art", "Social Studies", "Phys-Ed", "French", "Away", "Prep"];
int prepSubject = N;
int awaySubject = N-1;
range subjectRange = N..N;

//j = teacher
int N2=11;
range r2 = 1..N2;
float FTE[r2] = [1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.7,1.0]; //allocation array for the FTE distribution
//french indicator
range french = (N2-1)..N2;

//k= cohort
//4 because 2 cohorts, 2 dummies
int N3=8;
range r3 = 1..N3;
range class = 1..(N3-2);
int prepCohort = N3;
int awayCohort = N3-1;
range cohortRange = N3..N3;

//t = time
int N4=30;
range day1 = 1..6;
range numDays = 1..5;
range day2 = 7..12;
range day3 = 13..18;
range day4 = 19..24;
range day5 = 25..30;
range r4 = 1..N4;
int basePrepTime = 240;
int totalTime = 1500;

float totalTeacherMin[r2];
float prep[r2];
float teachMin[r2];

//time periods teachers are available- this will need to be automated from the user input
int availableTime[r2][r4]= [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
							[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
							[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
							[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
							[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
							[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
							[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
							[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
							[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
							[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0],
							[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]];

execute {

	for(var j in r2)
	{
	totalTeacherMin[j]= FTE[j] * totalTime;
	prep[j] = FTE[j]*basePrepTime; //prep time allocation
	teachMin[j] = totalTeacherMin[j]-prep[j]; //teaching minute allocation
	}

}
// Problem parameters are defined below
int lengtht[r4]= [40,60,50,50,60,40,
				 40,60,50,50,60,40,
				 40,60,50,50,60,40,
				 40,60,50,50,60,40,
				 40,60,50,50,60,40];   

int rewards[class][r2][subjects];

execute {

	for(var j in r2)
	{
	totalTeacherMin[j]= FTE[j] * totalTime;
	}
	
	


	
// 	for(m in class)
// 	{
//		for(j in r2){
//			for(i in subjects){
//			rewards[k][j][i] = 0;
//		}	
//	}
//
//
//	}
}
//base reward value
int rijkt = 1;

//defined reward 
//int rewards[class][r2] = [[100,0,0,0,0,0,10,10,0,0,0],
//						 [0,100,0,0,0,0,10,10,0,0,0],
//						 [0,0,100,0,0,0,10,10,0,0,0],
//						 [0,0,0,100,0,0,0,0,10,0,0],
//						 [0,0,0,0,100,0,0,0,10,0,0],
//		    			 [0,0,0,0,0,100,0,0,10,0,0]];



execute {
//for(k in 6){
//	for (j in 6){
//		if ( k == j){
//		rewards[k][j] = [100,100,100,100,100,-1];	
//		}
//	}  						


}



int pjd = 50; //penalty value for deviating from days with more or less than period of prep
int gymCap = 2;


//decision variables
dvar boolean x[r1][r2][r3][r4]; //x is the binary location variable, 'boolean' defines a binary variable
dvar int u[r2][numDays];
dvar int v[r2][numDays];

//objective function
maximize  sum(i in subjects,j in r2, k in class, t in r4)(rewards[k][j][i])*x[i,j,k,t] - (sum(j in r2, d in numDays)pjd*u[j][d] + sum(j in r2, d in numDays)pjd*v[j][d]); //objective function in minimization type

subject to //constraints are declared below
{	
	//assignment1- only 1 teacher assigned to a cohort and subject at a time-fixed constr
	forall(i in subjects, k in class, t in r4) sum(j in r2)x[i,j,k,t] <= 1;
	
	//teacher can only teach one subject/class at a time- new constraint
	forall(j in r2, t in r4) sum(i in r1, k in r3)x[i,j,k,t] == 1;
	
	//teacher can only teach one subject/class at a time - make this only for prep and teaching periods
	forall(j in r2, t in r4) sum(i in subjects, k in class)x[i,j,k,t] + sum(i in subjectRange, k in cohortRange)x[i,j,k,t]  == 1* availableTime[j][t];
	
	//assignment2 - at every time, each cohort needs only one teacher and one subject
	forall(k in class, t in r4) sum(i in subjects, j in r2)x[i,j,k,t] == 1;
	
	//assignment3- each cohort assigned to 12 time periods
	forall(k in class) sum(i in subjects, j in r2, t in r4)x[i,j,k,t] == 30;
	
	//schedule part time teachers away time
	forall(j in r2) sum(t in r4)lengtht[t]*x[awaySubject,j,awayCohort,t] >= totalTime - totalTeacherMin[j];
	
	//math
	forall(k in class) sum(j in r2, t in day1) lengtht[t]*x[1,j,k,t] == 60;
	forall(k in class) sum(j in r2, t in day2) lengtht[t]*x[1,j,k,t] == 60;
	forall(k in class) sum(j in r2, t in day3) lengtht[t]*x[1,j,k,t] == 60;
	forall(k in class) sum(j in r2, t in day4) lengtht[t]*x[1,j,k,t] == 60;
	forall(k in class) sum(j in r2, t in day5) lengtht[t]*x[1,j,k,t] == 60;
	
	//language
	/*forall(k in class) sum(j in r2, t in day1) lengtht[t]*x[2,j,k,t] >= 100;
	forall(k in class) sum(j in r2, t in day2) lengtht[t]*x[2,j,k,t] >= 100;
	forall(k in class) sum(j in r2, t in day3) lengtht[t]*x[2,j,k,t] >= 100;
	forall(k in class) sum(j in r2, t in day4) lengtht[t]*x[2,j,k,t] >= 100;
	forall(k in class) sum(j in r2, t in day5) lengtht[t]*x[2,j,k,t] >= 100;*/
	forall(k in class) sum(j in r2, t in r4) lengtht[t]*x[2,j,k,t] >= 300;
	
	//science
	forall(k in class) sum(j in r2, t in r4) lengtht[t]*x[3,j,k,t] >= 100;
	forall(k in class) sum(j in r2, t in r4) lengtht[t]*x[3,j,k,t] <= 150;
	
	//art
	forall(k in class) sum(j in r2, t in r4) lengtht[t]*x[4,j,k,t] >= 300;
	
	//Social Studies
	forall(k in class) sum(j in r2, t in r4) lengtht[t]*x[5,j,k,t] >= 100;
	
	//Phys-ed
	forall(k in class) sum(j in r2, t in r4) lengtht[t]*x[6,j,k,t] >= 150;
	forall(k in class) sum(j in r2, t in r4) lengtht[t]*x[6,j,k,t] <= 200;
	
	//French
	forall(k in class) sum(j in french, t in r4) lengtht[t]*x[7,j,k,t] >= 200;
	
	//prep
	forall(j in r2) sum(t in r4) lengtht[t]*x[prepSubject,j,prepCohort,t] >= prep[j];
	
	//teaching mins
	forall(j in r2) sum(t in r4, i in subjects, k in class) lengtht[t]*x[i,j,k,t] <= teachMin[j];
	
	//gym capacity
	forall(t in r4) sum(j in r2, k in r3)x[6,j,k,t] <= gymCap;
	
	//prep time objective - minimize # of times teachers have prep on the same day
	forall(j in r2) sum(t in day1)x[prepSubject,j,prepCohort,t] + u[j][1] -v[j][1] == 1;
	forall(j in r2) sum(t in day2)x[prepSubject,j,prepCohort,t] + u[j][2] -v[j][2] == 1;
	forall(j in r2) sum(t in day3)x[prepSubject,j,prepCohort,t] + u[j][3] -v[j][3] == 1;
	forall(j in r2) sum(t in day4)x[prepSubject,j,prepCohort,t] + u[j][4] -v[j][4] == 1;
	forall(j in r2) sum(t in day5)x[prepSubject,j,prepCohort,t] + u[j][5] -v[j][5] == 1;
	
	forall(j in r2, d in numDays) u[j][d] >= 0;
	forall(j in r2, d in numDays) v[j][d] >= 0;

}

int mathTime[class];
int langTime[class];
int scienceTime[class];
int artTime[class];
int socialStudiesTime[class];
int physedTime[class];
int frenchTime[class];
int prepTime[r2];
int teachTime[r2];
int awayTime[r2];

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
						if(i==2)
						{
							langTime[k]=langTime[k]+ lengtht[t];					
						}
						if(i==3)
						{
							scienceTime[k]=scienceTime[k]+ lengtht[t];					
						}
						if(i==4)
						{
							artTime[k] = artTime[k] + lengtht[t];					
						}
						if(i==5)
						{
							socialStudiesTime[k] = socialStudiesTime[k] + lengtht[t];					
						}
						if(i==6)
						{
							physedTime[k] = physedTime[k] + lengtht[t];					
						}
						if(i==7)
						{
							frenchTime[k] = frenchTime[k] + lengtht[t];					
						}
						if(i==prepSubject)
						{
							prepTime[j] = prepTime[j] + lengtht[t];						
						}						
						else if(i==awaySubject)
						{
							awayTime[j] = awayTime[j] + lengtht[t];					
						}
						else
						{
							teachTime[j] = teachTime[j] + lengtht[t];		
						}
   					}						
				}			
			}					
		}	
	}
}

 