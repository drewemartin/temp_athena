def date = new Date().format("yyyy-MM-dd")
def year = new Date().format("yyyy")
def yearInt = Integer.parseInt(year)


def setQuarter(){
    def currentTime = new GregorianCalendar().time
    //n.b. the month arg for a new date object are zero index (i.e. sept is 8 not 9)
    def q1StartDate = new GregorianCalendar(2014, 8, 2).time
    def q1EndDate = new GregorianCalendar(2014, 10, 6).time
    def q2StartDate = new GregorianCalendar(2014, 10, 7).time
    def q2EndDate = new GregorianCalendar(2015, 0, 24).time
    def q3StartDate = new GregorianCalendar(2015, 0, 25).time
    def q3EndDate = new GregorianCalendar(2015, 3, 3).time
    def q4StartDate = new GregorianCalendar(2015, 3, 4).time
    def q4EndDate = new GregorianCalendar(2015, 5, 6).time
    
    if(currentTime >= q1StartDate && currentTime <= q1EndDate){
        return '1'
    }
    else if(currentTime >= q2StartDate && currentTime <= q2EndDate){
        return '2'
    }
    else if(currentTime >= q3StartDate && currentTime <= q3EndDate){
        return '3'
    }
    else if(currentTime >= q4StartDate && currentTime <= q4EndDate){
        return '4'
    }  
    //should return '1', '2', '3' or '4'
}

def setFallOrSpringAndSemester(typeOfPeriod){
    //use 'FS' or 'SEM' as arguments to recieve either semester or fall/spring info
    def currentTime = new GregorianCalendar().time
    //n.b. the month arg for a new date object are zero index (i.e. sept is 8 not 9)
    def faS1StartDate = new GregorianCalendar(2014, 8, 2).time
    def faS1EndDate = new GregorianCalendar(2015, 0, 23).time
    def spS2StartDate = new GregorianCalendar(2015, 0, 26).time
    def spS2EndDate = new GregorianCalendar(2015, 5, 6).time
    
    if (currentTime >= faS1StartDate && currentTime <= faS1EndDate){
        if(typeOfPeriod == 'FS'){
            return 'FA'
        }
        else if(typeOfPeriod == 'SEM'){
            return 'S1'
        }
        
    }
    else if (currentTime >= faS1EndDate && currentTime <= spS2EndDate){
        if(typeOfPeriod == 'FS'){
            return 'SP'
        }
        else if(typeOfPeriod == 'SEM'){
            return 'S2'
        }
    }
    
    //should return 'FA', 'SP', 'S1' or 'S2' 
}

/* CLASS ROSTER */
for ( school in ["MS"] ) {
    
    switch ( school ) {
        
        case "EL":
            
            grades = ["K","01","02","03","04","05"]
            
            mp = [setQuarter()]
            
            break
            
        case "MS":
            
            grades = ["05","06","07","08"]
            
            mp = [setQuarter()]
            
            break
            
        case "HS":
            
            grades = ["07","08","09","10","11","12"]
            
            mp = [setFallOrSpringAndSemester('FS'),setQuarter()]
            
            break
        
    }

    for ( grade in grades ) {
        
        
        loginToSapphire("https://agora-sapphire.k12system.com/Gradebook/main.cfm", "athena-reports@agora.org", password, "PAAGC", school, 2015);
        
        def params = [
        "DISTRICT_ID"           : "PAAGC",
        "REFERENCE_DATE"        : date,
        "MP_Code"               : mp.join(","),
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