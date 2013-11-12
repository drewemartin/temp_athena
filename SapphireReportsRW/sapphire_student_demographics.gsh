loginToReportWriter("https://agora-sapphire.k12system.com/analysis/services/repository", "PAAGC", "jhalverson", "tBM679p8a")

runReportAndSave(

	"/Reports/Jenifer/student_demographics",
	
	[
		"SCHOOL_ID_1"	: [
			"EL",
			"HS",
			"MS"
		],
		"SCHOOL_YEAR_1"	: new Date().format("yyyy"),
		"STATUS_FLG_1"	: [
			"E"
		]
	],
	["RUN_OUTPUT_FORMAT":"CSV"],
	/*"Q:/athena_files/imports/sapphire_student_demographics.csv"*/
	"C:/Users/Parnassus/athena-sis/htdocs/athena_files/imports/sapphire_student_demographics.csv"
)

def command = """ruby C:/Users/Parnassus/athena-sis/htdocs/athena/system/commands/load.rb sapphire_student_demographics"""
/*def command = """ruby Q:/athena-sis/htdocs/athena/system/commands/load.rb sapphire_student_demographics"""*/

def proc    = command.execute()               
proc.waitFor()