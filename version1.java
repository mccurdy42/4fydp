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
