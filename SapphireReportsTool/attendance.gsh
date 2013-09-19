/* CLASS ROSTER */
for ( school in ["EL","MS","HS"] ) {

    loginToSapphire("https://agora-sapphire.k12system.com/Gradebook/main.cfm", "jhalverson", "tBM679p8a", "PAAGC", school, 2014);
    
    def params = [ 
    
    "SCHOOL_ID"             : school,
    "REPORT_CATEGORY_ID"    : "1",
    "REPORT_CODE"           : "CLASS_ROSTER",
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
        "C:/Users/Parnassus/athena-sis/htdocs/athena_files/imports/sapphire_class_roster_${school.toLowerCase();}.csv"
    )
    
    /* out << "\n${school} student_sapphire_class_roster load started"

    def command = """ruby C:/Users/Parnassus/athena-sis/htdocs/athena/system/commands/load.rb student_sapphire_class_roster"""
    def proc    = command.execute()               
    proc.waitFor()  
    
    out << "${school} student_sapphire_class_roster load complete" */

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
    "START_DATE"            : "2013-09-16",
    "END_DATE"              : "2013-09-16",
    "GRADE_LEVEL"           : "",
    "STUDENT_IDS"           : "",
    "STATUS_FLG"            : "E",
    "ORDER_BY"              : "NAME",       /* AVAILABLE OPTIONS - NAME, BIRTHDATE, GENDER, GRADE, ID, HOME_ROOM, COUNSELOR */
    "FORMAT"                : "CSV"         /* AVAILABLE OPTIONS - PDF, CSV */
    
    ];
    
    out << params;
    
    out << "\n\n${school} REQUESTING REPORT\n\n"

    runReportAndSave("https://agora-sapphire.k12system.com/Gradebook/CMS/Reports/Reports/PeriodAttendRpt.cfm",
        params,
        "C:/Users/Parnassus/athena-sis/htdocs/athena_files/imports/sapphire_period_attendance_${school.toLowerCase();}.csv"
    )
    
    /* out << "\n${school} REQUESTING LOAD\n"

    def command = """ruby C:/Users/Parnassus/athena-sis/htdocs/athena/system/commands/load.rb sapphire_period_attendance_${school.toLowerCase();}"""
    def proc    = command.execute()               
    proc.waitFor()*/  

    logout()
    
}