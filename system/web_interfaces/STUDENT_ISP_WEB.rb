#!/usr/local/bin/ruby


class STUDENT_ISP_WEB
    
    #---------------------------------------------------------------------------
    def initialize()
        
    end
    #---------------------------------------------------------------------------
    
    def page_title
        
        "ISP"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________LOAD_AND_RESPONSE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def load
        $kit.student_data_entry
    end
    
    def response
        
        if $kit.add_new?
            
            $kit.student_record.content
            
        end
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________WORKING_LIST_AND_STUDENT_RECORD
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def student_record
        
        tabs = Array.new
        tabs.push(["Reimbursment",            reimbursement_status   ])
       
        $kit.tools.tabs(
            tabs,
            selected_tab    = 0,
            tab_id          = "isp",
            search          = false
        )
        
    end

    def reimbursement_status
        
        $focus_student.isp_reimbursement_status.existing_record || $focus_student.isp_reimbursement_status.new_record.save         
        
        table_array = Array.new
        
        table_array.push([
            
            #Fall Reimbursement
            $tools.table(
                :table_array    => [
                    
                    [
                        "Approval Status",
                        $focus_student.isp_reimbursement_status.fall_approval_status.web.select(
                            
                            :dd_choices     => $dd.from_array(
                                [
                                    "Approved",
                                    "Rejected"
                                ]
                            )
                            
                        )
                    ],
                    [
                        "Request Method",
                        $focus_student.isp_reimbursement_status.fall_request_method.web.select(
                            
                            :dd_choices     => $dd.from_array(
                                [
                                    "mail",
                                    "email",
                                    "kmail",
                                    "fax",
                                    "other"
                                ]
                            )
                            
                        )
                    ],
                    ["Contact Approved?",       $focus_student.isp_reimbursement_status.fall_req_contact.web.default       ],
                    ["Address Approved?",       $focus_student.isp_reimbursement_status.fall_req_address.web.default       ],
                    ["Time Period Approved?",   $focus_student.isp_reimbursement_status.fall_req_timeperiod.web.default    ],
                    ["Amount Approved?",        $focus_student.isp_reimbursement_status.fall_req_amount.web.default +
                        $focus_student.isp_reimbursement_status.fall_req_billed_monthly.web.default
                    ],
                    ["Reimbursement Amount",    $focus_student.isp_reimbursement_status.fall_check_amount.web.default      ],
                    ["Reimbursement Datetime",  $focus_student.isp_reimbursement_status.fall_run.web.default               ],
                    
                    ["Notes",                   $focus_student.isp_reimbursement_status.fall_notes.web.default             ]
                    
                ],
                :unique_name    => "fall_reimbursement",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => "Fall Reimbursement"
            ),
            
            #Spring Reimbursement
            $tools.table(
                :table_array    => [
                    
                    [
                        "Approval Status",
                        $focus_student.isp_reimbursement_status.spring_approval_status.web.select(
                            
                            :dd_choices     => $dd.from_array(
                                [
                                    "Approved",
                                    "Rejected"
                                ]
                            )
                            
                        )
                    ],
                    [
                        "Request Method",
                        $focus_student.isp_reimbursement_status.spring_request_method.web.select(
                            
                            :dd_choices     => $dd.from_array(
                                [
                                    "mail",
                                    "email",
                                    "kmail",
                                    "fax",
                                    "other"
                                ]
                            )
                            
                        )
                    ],
                    ["Contact Approved?",       $focus_student.isp_reimbursement_status.spring_req_contact.web.default       ],
                    ["Address Approved?",       $focus_student.isp_reimbursement_status.spring_req_address.web.default       ],
                    ["Time Period Approved?",   $focus_student.isp_reimbursement_status.spring_req_timeperiod.web.default    ],
                    ["Amount Approved?",        $focus_student.isp_reimbursement_status.spring_req_amount.web.default +
                        $focus_student.isp_reimbursement_status.spring_req_billed_monthly.web.default
                    ],
                    ["Reimbursement Amount",    $focus_student.isp_reimbursement_status.spring_check_amount.web.default      ],
                    ["Reimbursement Datetime",  $focus_student.isp_reimbursement_status.spring_run.web.default               ],
                    
                    ["Notes",                   $focus_student.isp_reimbursement_status.spring_notes.web.default             ]
                    
                ],
                :unique_name    => "spring_reimbursement",
                :footers        => false,
                :head_section   => false,
                :title          => false,
                :caption        => "Spring Reimbursement"
            )
            
        ])
        
        return $tools.table(
            :table_array    => table_array,
            :unique_name    => "Reimbursement",
            :footers        => false,
            :head_section   => false,
            :title          => false,
            :caption        => false
        )
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_PDF
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ADD_NEW_RECORDS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________EXPAND_SECTION
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DROP_DOWN_OPTIONS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SUPPORT_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________CSS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def css
        
        output = String.new
        output << "<style>"
        
        output << "table#Reimbursement                  { width:100%;}"
        output << "table#Reimbursement      caption     { font-size: medium; text-align:center;}"
        output << "table                    td.column_0 { width: 50%;}"
        output << "table                    td.column_1 { width: 50%;}"
        
        output <<
        "   div.STUDENT_ISP_REIMBURSEMENT_STATUS__fall_req_amount           {width: 25px; display: inline-block;}
            div.STUDENT_ISP_REIMBURSEMENT_STATUS__fall_req_billed_monthly   {display: inline-block;}
            input.STUDENT_ISP_REIMBURSEMENT_STATUS__fall_req_billed_monthly {width: 123px;}"
        
        output <<
        "   div.STUDENT_ISP_REIMBURSEMENT_STATUS__spring_req_amount           {width: 25px; display: inline-block;}
            div.STUDENT_ISP_REIMBURSEMENT_STATUS__spring_req_billed_monthly   {display: inline-block;}
            input.STUDENT_ISP_REIMBURSEMENT_STATUS__spring_req_billed_monthly {width: 123px;}"
        
        output << "</style>"
        return output
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x_______________________JavaScript
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def javascript
        output = "<script type=\"text/javascript\">"
        #output << "YOUR CODE HERE"
        output << "</script>"
        return output
    end
    
end