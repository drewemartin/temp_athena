/* CLASS ROSTER */
def year = new Date().format("yyyy")
def yearInt = Integer.parseInt(year)

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
        return 'Q1'
    }
    else if(currentTime >= q2StartDate && currentTime <= q2EndDate){
        return 'Q2'
    }
    else if(currentTime >= q3StartDate && currentTime <= q3EndDate){
        return 'Q3'
    }
    else if(currentTime >= q4StartDate && currentTime <= q4EndDate){
        return 'Q4'
    }  
    //should return 'Q1', 'Q2', 'Q3' or 'Q4'
}


for ( school in ["EL","MS","HS"] ) {
    
    def durations = "YR"
    if (school == "EL"){
        durations = "YR"; 
    }
    if (school == "MS"){
        durations = "FY,${setFallOrSpringAndSemester('SEM')}"; 
    }
    if (school == "HS"){
        durations = "${setFallOrSpringAndSemester('FS')},YR,YS,${setFallOrSpringAndSemester('SEM')},${setQuarter()}"; 
    }
    
    loginToSapphire("https://agora-sapphire.k12system.com/Gradebook/main.cfm", "athena-reports@agora.org", password, "PAAGC", school, 2015);
    
    def params = [ 
    
    "SCHOOL_ID"             : school,
    "REPORT_CATEGORY_ID"    : "1",
    "REPORT_CODE"           : "CLASS_ROSTER",
    "DURATIONS"             : durations,
    "TEACHER_RID"           : "",
    "YR"                    : "",
    "COURSE_ID"             : "",
    "SECTION_ID"            : "",
    "DEPARTMENT_CODE"       : "",
    "ROOM_CODE"             : "",
    "IEP_FLG"               : "",
    "GIEP_FLG"              : "",
    "SHOW_BLANK_COURSES_FLG": "",
    "SHOW_CURRICULUM_FLG"   : "",
    "SHOW_SPECIAL_NEEDS_FLG": "",
    "COURSE_ORDER"          : "COURSE_ID",  /* AVAILABLE OPTIONS - COURSE_ID, TEACHER_ID, TEACHER_NAME, DEPARTMENT, ROOM */
    "STUDENT_ORDER"         : "NAME",       /* AVAILABLE OPTIONS - NAME, BIRTHDATE, GENDER, GRADE, ID, HOME_ROOM, COUNSELOR */
    "REPORT_FORMAT"         : "CSV"         /* AVAILABLE OPTIONS - PDF, CSV */
    
    ];
    
    out << params;
    
    out << "${school} student_sapphire_class_roster report requested"

    runReportAndSave("https://agora-sapphire.k12system.com/Gradebook/CMS/Reports/Reports/ClassRosterRpt.cfm",
        params,
        "C:/athena_files/imports/student_sapphire_class_roster.csv"
    )
    
    logout()
    
    def command_2 = """ruby C:/xampp/htdocs/athena/system/commands/load.rb student_sapphire_class_roster"""
    def proc_2    = command_2.execute()               
    proc_2.waitFor()
    
}

def command_2 = """ruby C:/xampp/htdocs/athena/system/commands/after_load.rb student_sapphire_class_roster"""
def proc_2    = command_2.execute()               
proc_2.waitFor()
    