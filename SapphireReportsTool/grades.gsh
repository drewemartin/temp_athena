def date = new Date().format("yyyy-MM-dd")
q = 1
/* CLASS ROSTER */
for ( school in ["EL","MS","HS"] ) {
    
    switch ( school ) {
        
        case "EL":
            
            grades = ["K","01","02","03","04","05"]
            
            switch(q){
                case 1:
                    mp = ["1"]
                    break
                case 2:
                    mp = ["2"]
                    break
                case 3:
                    mp = ["3"]
                    break
                case 4:
                    mp = ["4"]
                    break
            }
            
            break
            
        case "MS":
            
            grades = ["05","06","07","08"]
            
            switch(q){
                case 1:
                    mp = ["1"]
                    break
                case 2:
                    mp = ["2"]
                    break
                case 3:
                    mp = ["3"]
                    break
                case 4:
                    mp = ["4"]
                    break
            }
            
            break
            
        case "HS":
            
            grades = ["07","08","09","10","11","12"]
            
            switch(q){
                case 1:
                    mp = ["FA","1"]
                    break
                case 2:
                    mp = ["FA","2"]
                    break
                case 3:
                    mp = ["SP","3"]
                    break
                case 4:
                    mp = ["SP","4"]
                    break
            }
            
            break
        
    }

    for ( grade in grades ) {
        
        
        loginToSapphire("https://agora-sapphire.k12system.com/Gradebook/main.cfm", "jhalverson", "tBM679p8a", "PAAGC", school, 2014);
        
        def params = [
        "DISTRICT_ID"           : "PAAGC",
        "REFERENCE_DATE"        : date,
        "MP_Code"               : "",
        "Grade_Level"           : grade,
        "Home_Room"             : "",
        "Team"                  : "",
        "Counselor"             : "",
        "Enrolled"              : "",
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
    
}