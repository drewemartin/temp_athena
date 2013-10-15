def date = new Date().format("yyyy-MM-dd")

/* CLASS ROSTER */
for ( school in ["EL","MS","HS"] ) {
    
    loginToSapphire("https://agora-sapphire.k12system.com/Gradebook/main.cfm", "jhalverson", "tBM679p8a", "PAAGC", school, 2014);
    
    def params = [
    "DISTRICT_ID"           : "PAAGC",
    "REFERENCE_DATE"        : date,
    "MP_Code"               : "1",
    "Grade_Level"           : "",
    "Home_Room"             : "",
    "Team"                  : "",
    "Counselor"             : "",
    "Enrolled"              : "E",
    "STUDENT_ID"            : "",
    "GROUP_RID"             : "",
    "Activities"            : "",
    "SCHOOL_ID"             : school
    
    ];
    
    out << params;
    
    out << "${school} grades report requested"

    runReportAndSave("https://agora-sapphire.k12system.com/Gradebook/CMS/Reports/Reports/CurrentClassGradesRpt.cfm",
        params,
        "Q:/athena_files/imports/student_sapphire_grades.csv"
    )

    def command = """ruby Q:/athena-sis/htdocs/athena/system/commands/load.rb student_sapphire_grades"""
    def proc    = command.execute()               
    proc.waitFor()  
    
    logout()
    
}