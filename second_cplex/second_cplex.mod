/*********************************************
 * OPL 12.9.0.0 Model
 * Author: mccurdy
 * Creation Date: Jul 1, 2019 at 9:17:23 PM
 *********************************************/
//this is the intial assignment problem
//i=subject
//9 because 7 subjects 2 dummies
//changing to 10 because 8 subjects and 2 dummies... 
//TODO: make number of classes and dependencies variable 

int N=11; 
range r1 = 1..N; 

range subjects = 1..9;
//art and music need to be split up
string subj[r1] = ["Math", "Language","Science", "Art", "Social-Studies", "Phys-Ed", "French","Music", "Drama", "Away", "Prep"];
int prepSubject = N;
int awaySubject = N-1;
range subjectRange = N..N;

//j = teacher
int N2=16;
range r2 = 1..N2;
float FTE[r2] = [1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.2,0.2,0.6,0.2,1.0,1.0]; //allocation array for the FTE distribution
//french indicator
range french = (N2-1)..N2;

//k= cohort
//13 because 11 cohorts, 2 dummies (away and prep)
int N3=13;
range r3 = 1..N3;

int teachingCohort = N3-2;
range teaching_class = 1..teachingCohort;

range primary = 1..(N3-10);
range frenchCohorts = (N3-9)..(N3-2);
range class = 1..(N3-2);

int prepCohort = N3;
int awayCohort = N3-1;
range cohortRange = N3..N3;

//t = time
int N4=30;
range numDays = 1..5;
range day1 = 1..6;
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

//blocks of time (ex 1,2 and 3,4)
range blockCount = 1..15;
range blocks = 1..3; //not yet implemented

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
							[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
							[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,1],
							[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,1,0,0,0,0,0,0],
							[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0],
							[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,1],
							[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
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



execute {

	for(var j in r2)
	{
	totalTeacherMin[j]= FTE[j] * totalTime;
	}
	
}

//defining an initial reward matrix
int rewards[teaching_class][r2][subjects];

execute{

for(var k in teaching_class){
	for (var j in r2){
		for(var i in subjects ){		
			//homeroom 1	
			if (k==1 && j==1){
				rewards[k][j][i] = 100;		
			}
			
			else if (k ==2 && j ==2 ){
				rewards[k][j][i] = 100;			
			}
			else if (k ==3 && j ==3 ){
				rewards[k][j][i] = 100;			
			}
			else if (k ==4 && j ==4 ){
				rewards[k][j][i] = 100;			
			}
			else if (k ==5 && j ==5 && (i == 4 || i == 2)){
				rewards[k][j][i] = 200;	
			}
			else if ((k >=3 && k <= 6)  && j ==5 && i ==7){
				rewards[k][j][i] = 200;	
			}
			else if ((k >=4 && k <= 6)  && j ==6 && (i != 2 && i <= 5 )){
				rewards[k][j][i] = 100;	
			}
			else if ((k >=4 && k <= 6)  && j == 7  &&  i == 5 ){
				rewards[k][j][i] = 100;	
			}
			else if (k == 7 && j == 7 && (i != 3 && i <= 6 )){
				rewards[k][j][i] = 100;	
			}
			else if (k == 1 && j == 7){
				rewards[k][j][i] = 10;	
			}
			else if (k == 8 && j == 8 && ((i ==2)|| i ==1 || i ==4 ||i ==6)){
				rewards[k][j][i] = 10;	
			}
			else if ((k >=1 && k <= 3)  && j == 8 && i ==6 ){
				rewards[k][j][i] = 10;	
			}
			else if (k==9  && j == 9 && i <=3 ){
				rewards[k][j][i] = 10;	
			}
			else if ((k >=1 && k <= 3)  && j == 9 && i ==6 ){
				rewards[k][j][i] = 10;	
			}
			else if (k==10  && j == 10 && i !=5 ){
				rewards[k][j][i] = 100;	
			}
			else if ((k >=9 && k <= 11)  && j == 11 && i ==5 ){
				rewards[k][j][i] = 10;	
			}
			else if (k==4  && j == 10 && i ==4 ){
				rewards[k][j][i] = 10;	
			}
			else if ((k >=1 && k <= 4)  && j == 12 ){
				rewards[k][j][i] = 10;	
			}
			else if ((k >=1 && k <= 3)  && j == 13 ){
				rewards[k][j][i] = 10;	
			}
			else if ((k >=4 && k <= 11)  && j == 14 && i== 4 ){
				rewards[k][j][i] = 200;	
			}
			else if ((k >=4 && k <= 11)  && j == 14 && i== 4 ){
				rewards[k][j][i] = 200;	
			}
			else if ((k >=4 && k <= 7)  && j == 15 && i== 5 ){
				rewards[k][j][i] = 200;	
			}
			else if ((k >=4 && k <= 7)  && j == 15 && i== 4 ){
				rewards[k][j][i] = 200;	
			}
			else if ((k >=4 && k <= 7)  && j == 16 && i== 7 ){
				rewards[k][j][i] = 200;	
			}
			else if ((k >=7 && k <= 11)  && j == 17 && i== 7 ){
				rewards[k][j][i] = 200;	
			}
	}

}

}

}



int pjd = 50; //penalty value for deviating from days with more or less than period of prep
int gymCap = 2;

//TODO: add in slack and surplus variables

//decision variables
dvar boolean x[r1][r2][r3][r4]; //x is the binary location variable, 'boolean' defines a binary variable
dvar boolean y[subjects][r2][class]; //y is binary for teacher to subject to cohort assignment
dvar int u1[r2][numDays]; //slack variable for prep even distribution
dvar int v1[r2][numDays]; //surplus variable for prep even distribution
dvar boolean a[primary][blockCount]; //indicator varaibled for back to back primary language
//dvar boolean b[1..1][r4]; //indicator variable if prep is assigned at time t - only assigned to 1 group of teachers (1 and 2) for now
//dvar int u2[1..1][r4]; //slack and surplus for prep time objective to schedule prep at same time - one group 
//dvar int v2[1..1][r4]; //not yet implemented

dvar int u7[class][numDays]; //slack variable for scienceeven distribution
dvar int v7[class][numDays]; //surplus variable for science even distribution
dvar int v9[class][numDays]; //surplus variable for gym even distribution
dvar int u10[class][numDays]; //slack variable for gym even distribution
dvar int v10[class][numDays]; //surplus variable for gym even distribution
dvar int u8[numDays][class][blocks];//art back to back if on same day //not yet implemented
dvar int v8[numDays][class][blocks];//art back to back if on same day //not yet implemented
dvar boolean g[class][blockCount]; //not yet implemented

//objective function
maximize  sum(i in subjects,j in r2, k in class, t in r4)(rewards[k][j][i])*x[i,j,k,t]
	- (sum(j in r2, d in numDays)pjd*u1[j][d] + sum(j in r2, d in numDays)pjd*v1[j][d])
	- (sum(k in class, d in numDays)150*v9[k][d])  
	- (sum(k in class, d in numDays)0*u7[k][d] + sum(k in class, d in numDays)150*v7[k][d]) 
	- (sum(k in class, d in numDays)0*u10[k][d] + sum(k in class, d in numDays)150*v10[k][d]) ;
//	- (sum(j in 1..1, t in r4)50*u2[j][t] + sum(j in 1..1, t in r4)50*v2[j][t]); //include this when we do prep at same time for same cohort

 	
subject to //constraints are declared below
{	
	//1 teacher assigned to subject per cohort
	forall(i in subjects, k in class)sum(j in r2)y[i,j,k] == 1;
	forall(i in subjects, k in class, t in r4, j in r2)x[i,j,k,t]-y[i,j,k] <= 0;

	//assignment1- only 1 teacher assigned to a cohort and subject at a time-fixed constr
	forall(i in subjects, k in class, t in r4) sum(j in r2)x[i,j,k,t] <= 1;
	
	//teacher can only teach one subject/class at a time- new constraint
	forall(j in r2, t in r4) sum(i in r1, k in r3)x[i,j,k,t] == 1;
	
	//teacher can only teach one subject/class at a time - if you're assigned to teach, cant be assigned away/prep and vice versa
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
	
	//language for primary cohorts
	forall(k in primary) sum(j in r2, t in day1) lengtht[t]*x[2,j,k,t] == 100;
	forall(k in primary) sum(j in r2, t in day2) lengtht[t]*x[2,j,k,t] == 100;
	forall(k in primary) sum(j in r2, t in day3) lengtht[t]*x[2,j,k,t] == 100;
	forall(k in primary) sum(j in r2, t in day4) lengtht[t]*x[2,j,k,t] == 100;
	forall(k in primary) sum(j in r2, t in day5) lengtht[t]*x[2,j,k,t] == 100;
	
	//language for french applicable cohorts
	forall(k in frenchCohorts) sum(j in r2, t in r4) lengtht[t]*x[2,j,k,t] >= 300;
	
	//science
	forall(k in class) sum(j in r2, t in r4) lengtht[t]*x[3,j,k,t] >= 80;
	
	//art
	forall(k in class) sum(j in r2, t in r4) lengtht[t]*x[4,j,k,t] >= 80;
	
	//Social Studies
	forall(k in class) sum(j in r2, t in r4) lengtht[t]*x[5,j,k,t] >= 80;
		
	//Phys-ed
	forall(k in class) sum(j in r2, t in r4) lengtht[t]*x[6,j,k,t] >= 80;
	
	//French for only applicable classes
	forall(k in frenchCohorts) sum(j in french, t in r4) lengtht[t]*x[7,j,k,t] == 200;
	forall(k in primary) sum(j in r2, t in r4) lengtht[t]*x[7,j,k,t] == 0; //primary cant have french
	
	//music
	forall(k in class) sum(j in r2, t in r4) lengtht[t]*x[8,j,k,t] >= 80;
	
	//drama
	forall(k in class) sum(j in r2, t in r4) lengtht[t]*x[9,j,k,t] >= 40;
	
	//prep
	forall(j in r2) sum(t in r4) lengtht[t]*x[prepSubject,j,prepCohort,t] >= prep[j];
	
	//teaching mins
	forall(j in r2) sum(t in r4, i in subjects, k in class) lengtht[t]*x[i,j,k,t] <= teachMin[j];
	
	//gym capacity
	forall(t in r4) sum(j in r2, k in r3)x[6,j,k,t] <= gymCap;
	
	//prep time objective - minimize # of times teachers have prep on the same day
	forall(j in r2) sum(t in day1)x[prepSubject,j,prepCohort,t] + u1[j][1] -v1[j][1] == 1;
	forall(j in r2) sum(t in day2)x[prepSubject,j,prepCohort,t] + u1[j][2] -v1[j][2] == 1;
	forall(j in r2) sum(t in day3)x[prepSubject,j,prepCohort,t] + u1[j][3] -v1[j][3] == 1;
	forall(j in r2) sum(t in day4)x[prepSubject,j,prepCohort,t] + u1[j][4] -v1[j][4] == 1;
	forall(j in r2) sum(t in day5)x[prepSubject,j,prepCohort,t] + u1[j][5] -v1[j][5] == 1;
	
	forall(j in r2, d in numDays) u1[j][d] >= 0;
	forall(j in r2, d in numDays) v1[j][d] >= 0;
	
	//have to have french less than or equal to once a day
	forall(k in frenchCohorts) sum(t in day1, j in french)x[7,j,k,t] <= 1;
	forall(k in frenchCohorts) sum(t in day2, j in french)x[7,j,k,t] <= 1;
	forall(k in frenchCohorts) sum(t in day3, j in french)x[7,j,k,t] <= 1;
	forall(k in frenchCohorts) sum(t in day4, j in french)x[7,j,k,t] <= 1;
	forall(k in frenchCohorts) sum(t in day5, j in french)x[7,j,k,t] <= 1;
	
	//junior and senior have to have language once a day
	forall(k in frenchCohorts) sum(t in day1, j in r2)x[2,j,k,t] >= 1;
	forall(k in frenchCohorts) sum(t in day2, j in r2)x[2,j,k,t] >= 1;
	forall(k in frenchCohorts) sum(t in day3, j in r2)x[2,j,k,t] >= 1;
	forall(k in frenchCohorts) sum(t in day4, j in r2)x[2,j,k,t] >= 1;
	forall(k in frenchCohorts) sum(t in day5, j in r2)x[2,j,k,t] >= 1;
	
	//language for primary has to be back to back 
	forall(d in numDays, k in primary) sum(j in r2)x[2,j,k,1 + (d-1)*6] + sum(j in r2)x[2,j,k,2 + (d-1)*6] == a[k][1 +3*(d-1)]*2;
	forall(d in numDays, k in primary) sum(j in r2)x[2,j,k,3 + (d-1)*6] + sum(j in r2)x[2,j,k,4 + (d-1)*6] == a[k][2 +3*(d-1)]*2;
	forall(d in numDays, k in primary) sum(j in r2)x[2,j,k,5 + (d-1)*6] + sum(j in r2)x[2,j,k,6 + (d-1)*6] == a[k][3 +3*(d-1)]*2;
	
	//minimize # of times cohorts have gym on the same day
	forall(k in class) sum(t in day1, j in r2)x[6,j,k,t]  -v9[k][1] <= 1;
	forall(k in class) sum(t in day2, j in r2)x[6,j,k,t]  -v9[k][2] <= 1;
	forall(k in class) sum(t in day3, j in r2)x[6,j,k,t]  -v9[k][3] <= 1;
	forall(k in class) sum(t in day4, j in r2)x[6,j,k,t]  -v9[k][4] <= 1;
	forall(k in class) sum(t in day5, j in r2)x[6,j,k,t]  -v9[k][5] <= 1;
	
	//forall(k in class, d in numDays) u9[k][d] >= 0; not included in pull request- keep for testing
	forall(k in class, d in numDays) v9[k][d] >= 0;
	

	//minimize # of times cohorts have science on the same day- not included in pull request- keep for testing
	forall(k in class) sum(t in day1, j in r2)x[3,j,k,t] + u7[k][1] -v7[k][1] == 1;
	forall(k in class) sum(t in day2, j in r2)x[3,j,k,t] + u7[k][2] -v7[k][2] == 1;
	forall(k in class) sum(t in day3, j in r2)x[3,j,k,t] + u7[k][3] -v7[k][3] == 1;
	forall(k in class) sum(t in day4, j in r2)x[3,j,k,t] + u7[k][4] -v7[k][4] == 1;
	forall(k in class) sum(t in day5, j in r2)x[3,j,k,t] + u7[k][5] -v7[k][5] == 1;
	
	forall(k in class, d in numDays) u7[k][d] >= 0;
	forall(k in class, d in numDays) v7[k][d] >= 0;
	

	//minimize # of times cohorts have social studies on the same day- not included in pull request- keep for testing
	forall(k in class) sum(t in day1, j in r2)x[5,j,k,t] + u10[k][1] -v10[k][1] == 1;
	forall(k in class) sum(t in day2, j in r2)x[5,j,k,t] + u10[k][2] -v10[k][2] == 1;
	forall(k in class) sum(t in day3, j in r2)x[5,j,k,t] + u10[k][3] -v10[k][3] == 1;
	forall(k in class) sum(t in day4, j in r2)x[5,j,k,t] + u10[k][4] -v10[k][4] == 1;
	forall(k in class) sum(t in day5, j in r2)x[5,j,k,t] + u10[k][5] -v10[k][5] == 1;
	
	forall(k in class, d in numDays) u10[k][d] >= 0;
	forall(k in class, d in numDays) v10[k][d] >= 0;

	//maximize the number of back to back art classes if assigned to the same day-no include in pull request- keep for testing but hasnt beeen tested
	//forall(d in numDays, k in class) sum(j in r2)x[4,j,k,1 + (d-1)*6] + sum(j in r2)x[4,j,k,2 + (d-1)*6] +u8[d][k][1] -v8[d][k][1]== g[k][1 +3*(d-1)]*2;
	//forall(d in numDays, k in class) sum(j in r2)x[4,j,k,3 + (d-1)*6] + sum(j in r2)x[4,j,k,4 + (d-1)*6] +u8[d][k][2] -v8[d][k][2]== g[k][2 +3*(d-1)]*2;
	//forall(d in numDays, k in class) sum(j in r2)x[4,j,k,5 + (d-1)*6] + sum(j in r2)x[4,j,k,6 + (d-1)*6] +u8[d][k][3] -v8[d][k][3]== g[k][3 +3*(d-1)]*2;
	
	//forall(k in frenchCohorts, d in numDays, b in blocks) u8[k][d][b] >= 0;
	//forall(k in frenchCohorts, d in numDays, b in blocks) v8[k][d][b] >= 0;
	
		//last teacher can only teach .3 french -still need to test this
	//sum(t in r4, k in frenchCohorts) lengtht[t]*x[7,15,k,t] <= teachMin[15]*.4;
	
}

int mathTime[class];
int langTime[class];
int scienceTime[class];
int artTime[class];
int socialStudiesTime[class];
int physedTime[class];
int frenchTime[class]; 
int dramaTime[class];
int prepTime[r2];
int teachTime[r2];
int awayTime[r2];

execute
{
writeln("Teacher ","Cohort ", "Subject ","Period ", "Day ");

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
						write("Teacher", j," ", k," ", subj[i]," ", t);
						
						if(t >=1 && t <= 6)
						{
							writeln(" Day1");					
						}
						
						if(t >=7 && t <= 12)
						{
							writeln(" Day2");							
						}
						
							if(t >=13 && t <= 18)
						{
							writeln(" Day3");							
						}
						
						if(t >=19 && t <= 24)
						{						
						writeln(" Day4");							
						}
						
						if(t >= 25 && t <= 30)
						{
							writeln(" Day5");								
						}
						
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
						if(i==8)
						{
							dramaTime[k] = dramaTime[k] + lengtht[t];						
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

 