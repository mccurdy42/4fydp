import ilog.concert.*;
import ilog.cplex.*;

public class version1 {

	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}
	
	public static void modelConfig() {
	 //define parameters - subjects
		int n = 9;
		String [] subj = {"Math", "Language", "Science", "Art", "Social-Studies", "Phys-Ed", "French", "Away", "Prep"};
		int prepSubject = n;
		int awaySubject = (n-1);
		
	//define parameters - teachers
		int n2 = 11;
		double [] FTE = {1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.7,1.0};
		int frenchInd = n2-1;
	
	//define parameters - cohorts
		int n3 = 8;
		int teachingCohort = n3-2;
		int primaryUb = n3-5;
		int frenchCohortlb = n3-4;
		int frenchCohortub = n3-2;
		//int classUb = n3-2;
		int prepCohort = n3;
		int awayCohort = n3-1;
		
	//define parameters - time
		int n4 = 30;
		int basePrepTime = 240;
		int totalTime = 1500;
		
	//initializing arrays
		double [] totalTeacherMin = new double [n2];
		double [] prep = new double [n2];
		double [] teachMin = new double [n2];
		
	//fill above arrays
		for (int j = 0; j<=n2-1;j++) {
			totalTeacherMin[j] = FTE[j]*totalTime;
			prep[j] = FTE[j]*basePrepTime; //prep time allocation
			teachMin[j] = totalTeacherMin[j]-prep[j]; //teaching minute allocation
		}
		
	//time periods matrix
		int [][] availableTime = new int[n2][n4];
		//fill availableTime matrix
		
		//first nine rows are 1
		for(int a = 0; a<=8;a++) {
			for(int b=0;b<=29;b++) {
				availableTime[a][b]=1;
			}
		}
		
		//last 9 entries of 10th row are 0
		for(int c=0;c<=20;c++) {
			availableTime[8][c]=1;
		}
		
		//last row is all 1's
		for(int d=0;d<=29;d++) {
			availableTime[10][d]=1;
		}
				
	//time periods array
		int [] lengtht = {40,60,50,50,60,40,40,60,50,50,60,40,40,60,50,50,60,40,40,60,50,50,60,40,40,60,50,50,60,40};
		
	//defining initial reward matrix
		int [][][] rewards = new int [teachingCohort][n2][n-2];
		
		//fill the initial reward matrix
		for (int k=0; k<=teachingCohort-1;k++) {
			for(int j=0;j<=n2-1;j++) {
				for(int i=0;i<=n-3;i++) {
					if(k==j) {
						rewards[k][j][i]=100;
					}else if((k==1 || k==2 || k==3) && j==7) {
						//teacher 7 teachers art specialty
						if(i==4) {
							rewards[k][j][i]=200;
						}else {
							rewards[k][j][i]=10;
						}
					}else if(( k==1 || k==2 || k==3)&& j==7) {
						//teacher 8 teaches gym specialty
						if(i==6) {
							rewards[k][j][i]=200;
						}else {
							rewards[k][j][i]=10;
						}
					}else if (( k==4|| k==5 || k==6)&& j==9) {
						//9 is a generalist
						rewards [k][j][i]=10;
					}else {
						rewards[k][j][i]=0;
					}
				}
			}
		}
			
		//misc parameters
		int pjd = 50; //penalty value
		int gymCap = 2;
		
		try {
			//define the model
			IloCplex cplex = new IloCplex();
			
			//ranges - subjects
			IloRange r1 = cplex.addRange(1, n);
			IloRange subjects = cplex.addRange(1, 7);
			IloRange subjectRange = cplex.addRange(n,n);
			
			//French indicator
			IloRange french = cplex.addRange(frenchInd, n2);
			
			//ranges - teachers
			IloRange r2 = cplex.addRange(1, n2);
			
			//ranges - cohorts
			IloRange r3 = cplex.addRange(1,n3);
			IloRange teaching_class = cplex.addRange(1, teachingCohort);
			IloRange primary = cplex.addRange(1, primaryUb);
			IloRange frenchCohorts = cplex.addRange(frenchCohortlb, frenchCohortub);
			IloRange classGroup = cplex.addRange(1,teachingCohort);
			IloRange cohortRange = cplex.addRange(n3, n3);
			
			//ranges - time
			IloRange day1 = cplex.addRange(1, 6);
			IloRange numDays = cplex.addRange(1, 5);
			IloRange day2 = cplex.addRange(7, 12);
			IloRange day3 = cplex.addRange(13, 18);
			IloRange day4 = cplex.addRange(19, 24);
			IloRange day5 = cplex.addRange(25, 30);
			IloRange r4 = cplex.addRange(1, n4);
			IloRange blockCount = cplex.addRange(1,15);
		
			
			//variables
			IloIntVar x = cplex.boolVar();
			//IloNumVar x = cplex.numVar(0, Double.MAX_VALUE, "x");
			//IloNumVar y = cplex.numVar(0, Double.MAX_VALUE, "y");

			//expressions
			//IloLinearNumExpr objective = cplex.linearNumExpr();
			//objective.addTerm(0.12, x);
			//objective.addTerm(0.15, y);
			
			//define objective
			//cplex.addMinimize(objective);
			
			//define constraints
			//cplex.addGe(cplex.sum(cplex.prod(60, x), cplex.prod(60, y)), 300);
			//cplex.addGe(cplex.sum(cplex.prod(12, x), cplex.prod(6, y)), 36);
			//cplex.addGe(cplex.sum(cplex.prod(10, x), cplex.prod(30, y)), 90);

		}
		
		catch (IloException exc) {
			exc.printStackTrace();
		}
 
	}
	
}
