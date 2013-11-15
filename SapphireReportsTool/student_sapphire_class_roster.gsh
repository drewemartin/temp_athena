/* CLASS ROSTER */
for ( school in ["EL","MS","HS"] ) {
    
    def durations = "YR"
    if (school == "EL"){
        durations = "YR"; 
    }
    if (school == "MS"){
        durations = "FY,S1"; 
    }
    if (school == "HS"){
        durations = "FA,YR,YS,S1,Q2"; 
    }
    
    loginToSapphire("https://agora-sapphire.k12system.com/Gradebook/main.cfm", "jhalverson", "tBM679p8a", "PAAGC", school, 2014);
    
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
        "Q:/athena_files/imports/student_sapphire_class_roster.csv"
    )
    
    logout()
    
    def command_2 = """ruby Q:/athena-sis/htdocs/athena/system/commands/load.rb student_sapphire_class_roster"""
    def proc_2    = command_2.execute()               
    proc_2.waitFor()
    
}

def command_2 = """ruby Q:/athena-sis/htdocs/athena/system/commands/after_load.rb student_sapphire_class_roster"""
def proc_2    = command_2.execute()               
proc_2.waitFor()
    