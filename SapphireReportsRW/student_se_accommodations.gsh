loginToReportWriter("https://agora-sapphire.k12system.com/analysis/services/repository", "PAAGC", "jhalverson", "tBM679p8a")

/*LOAD THE SAPPHIRE TABLE WITH CURRENTLY DATA ONLY*/
runReportAndSave(

	"/Reports/Agora_All_Accommodations",
	
	[
		"SCHOOL_YEAR_1"	: "2015",
		"STATUS_FLG_1"	: [
			"E"
		]
	],
	["RUN_OUTPUT_FORMAT":"CSV"],
	/*"Q:/athena_files/imports/student_se_accommodations.csv"*/
	"C:/Users/Parnassus/athena-sis/htdocs/athena_files/imports/sapphire_student_se_accommodations.csv"
)

def x = """ruby C:/Users/Parnassus/athena-sis/htdocs/athena/system/commands/load.rb sapphire_student_se_accommodations"""
/*def x = """ruby Q:/athena-sis/htdocs/athena/system/commands/load.rb sapphire_student_se_accommodations"""*/

def y = x.execute()               
y.waitFor()