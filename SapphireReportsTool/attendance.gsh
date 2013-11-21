def date = new Date().format("yyyy-MM-dd")

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
        "Q:/athena_files/imports/sapphire_class_roster_${school.toLowerCase();}.csv"
    )

    def command = """ruby Q:/athena-sis/htdocs/athena/system/commands/load.rb sapphire_class_roster_${school.toLowerCase();}"""
    def proc    = command.execute()               
    proc.waitFor()  
    
    logout()
    
}

/* PERIOD ATTENDANCE */
for ( school in ["EL","MS","HS"] ) {

    loginToSapphire("https://agora-sapphire.k12system.com/Gradebook/main.cfm", "jhalverson", "tBM679p8a", "PAAGC", school, 2014);
    
    def params = [ 
    
    "SCHOOL_ID"             : school,
    "REPORT_CATEGORY_ID"    : "3",
    "REPORT_CODE"           : "PERIOD_ATTEND_RPT",
    "SJC_REPORT_ID"         : "PERIOD_ATTEND_RPT",
    "START_DATE"            : date,
    "END_DATE"              : date,
    "GRADE_LEVEL"           : "",
    "STUDENT_IDS"           : "",
    "STATUS_FLG"            : "E",
    "ORDER_BY"              : "NAME",       /* AVAILABLE OPTIONS - NAME, BIRTHDATE, GENDER, GRADE, ID, HOME_ROOM, COUNSELOR */
    "FORMAT"                : "CSV"         /* AVAILABLE OPTIONS - PDF, CSV */
    
    ];
    
    out << params;

    runReportAndSave("https://agora-sapphire.k12system.com/Gradebook/CMS/Reports/Reports/PeriodAttendRpt.cfm",
        params,
        "Q:/athena_files/imports/sapphire_period_attendance_${school.toLowerCase();}.csv"
    )

    def command = """ruby Q:/athena-sis/htdocs/athena/system/commands/load.rb sapphire_period_attendance_${school.toLowerCase();}"""
    def proc    = command.execute()               
    proc.waitFor() 

    logout()
    
}