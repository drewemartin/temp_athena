#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Pssa_Assignments_Report < Base

    #---------------------------------------------------------------------------
    def initialize(report_name)
        super()
        @structure = nil
        @demographic_fields = nil
        define_column_structure
        !report_name.empty? ? send(report_name[0]) : school_wide_report
    end
    #---------------------------------------------------------------------------
   
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
public
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPUBLIC_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def school_wide_report #Finish ASAP and send to Dan
        value = String.new
        y = "Yes"
        location    = "Pssa_Assignments"
        filename    = "pssa_assignments_schoolwide"
        rows        = Array.new
        rows.push(column_row)
        $students.current_pssa_students.each{|sid|
            student = $students.attach(sid)
            clean_content_row
            @demographic_fields.each{|field_name|
                
                value = ""
                if field_name == "is_specialed"
                    value = (student.send(field_name) ? "Yes" : "No")
                elsif field_name == "student_id"
                    value = student.send(field_name)
                else
                    value = student.send(field_name).value
                end 
                
                content_row[field_name] = value
            }
            if record = student.pssa_assignments.assignment_record
                record.fields.each_pair{|field_name,details|
                    if content_row.has_key?(field_name) 
                        value = details.to_user
                        value = $tables.attach("Pssa_Sites").by_primary_id(value).fields["site_name"].value if !value.empty? && field_name == "site_id"
                        content_row[field_name] = value
                    end
                }
            else
                $config.scuttle("PSSA Assignments Report - RECORD NOT FOUND!","Student ID: #{sid}")
                break
            end
            
            if accommodation_records = student.pssa_assignments.accommodations
                accommodation_records.each{|record|
                    f = record.fields
                    id  = record.fields["accommodation_id"].value
                    if !id.nil?
                        subject  = $tables.attach("Pssa_Accommodations").by_primary_id(id).fields["subject"].value
                        desc     = $tables.attach("Pssa_Accommodations").by_primary_id(id).fields["accommodation"].value
                        col_name = "#{subject} - #{desc}"
                        if id == "33"
                            content_row[col_name] = content_row[col_name].nil? ? "REASON: #{f["reason"].value} DESCRIPTION: #{f["description"].value}" : "#{content_row[col_name]} | REASON: #{f["reason"].value} DESCRIPTION: #{f["description"].value}"
                        else
                            content_row[col_name] = y
                        end
                    end
                }
            end
            i=0
            if emergency_contact_records = student.emergency_contacts
                emergency_contact_records.each{|record|
                    col_name = "emergency_contact_#{i}"
                    f = record.fields
                    value = "NAME: #{f["first_name"].value} #{f["last_name"].value} PHONE: #{f["phone_number"].value} ALT PHONE: #{f["alt_phone_number"].value}"
                    content_row[col_name] = value
                    i+=1
                }
            end
            
            this_row = Array.new
            column_row.each{|c| this_row.push(content_row[c])}
            rows.push(this_row)
            $students.detach(sid)
        }
        report_path = $reports.csv(location, filename, rows)
        subject = "PSSA Assignments Report - #{$idatetime}"
        content = "Please find the attached PSSA Assignments Report for #{$idate}"
        $team.by_k12_name("Dan Feldhaus").send_email(:subject=> subject, :content=> content, :attachment_path => report_path)
        $team.by_k12_name("Kerry Stone1").send_email(:subject=> subject, :content=> content, :attachment_path => report_path)
    end
    
    def by_site_report #Can be push back deadline if necessary
        site_name   = ""
        location    = "Pssa_Assignments"
        filename    = "pssa_assignments_#{site_name}"
        rows        = Array.new
        $reports.csv(location, filename, rows)
    end
    
    def by_ftc_report # push back deadline
        site_name   = ""
        location    = "Pssa_Assignments"
        filename    = "pssa_assignments_#{site_name}"
        rows        = Array.new
        $reports.csv(location, filename, rows)
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STRUCTURE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    
    def structure
        if @structure.nil?
            @structure = Hash.new
        end
        @structure
    end

#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
private
def xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxPRIVATE_METHODS
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def clean_content_row
        content_row.each_key{|key|
            content_row[key] = nil
        }
        return content_row
    end
    
    def column_row
        structure[:columns_row]
    end
    
    def content_row
        structure[:content_row]
    end

    def define_column_structure
        if !structure.has_key?(:content_row) || !structure.has_key?(:columns)
            content_row = Hash.new
            columns_row = Array.new
            @demographic_fields = ["student_id","first_name","last_name","grade","family_teacher_coach","specialed_teacher","is_specialed"]
            @demographic_fields.each{|field_name|
                columns_row.push(field_name) 
                content_row[field_name] = nil
            }
            $tables.attach("Pssa_Assignments").field_order.each{|field_name|
                unless field_name == "student_id"
                    columns_row.push(field_name) 
                    content_row[field_name] = nil
                end
            }
            $tables.attach("Pssa_Accommodations").records.each{|record|
                id       = record.fields["primary_id"   ].value
                subject  = record.fields["subject"].value
                desc     = record.fields["accommodation"].value
                col_name = "#{subject} - #{desc}" 
                columns_row.push(col_name) 
                content_row[col_name] = nil
            }
            i=0
            $tables.attach("Student_Emergency_Contacts").max_contacts_per_student.to_i.times do
                col_name = "emergency_contact_#{i+1}"
                columns_row.push(col_name) 
                content_row[col_name] = nil
                i+=1
            end
            structure[:content_row] = content_row
            structure[:columns_row] = columns_row
        end
        structure[:columns_row].each{|field_name|puts field_name}
    end
end

test = Pssa_Assignments_Report.new(ARGV)