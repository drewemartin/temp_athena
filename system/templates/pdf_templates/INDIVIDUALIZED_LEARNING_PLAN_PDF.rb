#!/usr/local/bin/ruby

class INDIVIDUALIZED_LEARNING_PLAN_PDF

    #---------------------------------------------------------------------------
    def initialize()
        @student = nil
        @pdf     = nil
    end
    #---------------------------------------------------------------------------
    
    def generate_pdf(sid, pdf=nil)
        
        @student        = $students.get(sid)
        @pdf            = pdf
        
        logo_path       = "#{$paths.templates_path}images/agora_logo.jpg"
        
        render_required = false
        
        if !@pdf
            
            render_required = true
            file_name = "#{sid}_individualized_learning_plan_#{$ifilestamp}.pdf"
            file_path = $config.init_path(
                "#{$paths.student_path(sid)}/Individualized_Learning_Plan"
            )
            @pdf       = Prawn::Document.new
            
        end
        
        @pdf.font_families.update("Arial" => {
            :normal      => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf",
            :italic      => "c:/windows/fonts/ariali.ttf",
            :bold        => "c:/windows/fonts/arialbd.ttf",
            :bold_italic => "c:/windows/fonts/arialbi.ttf"
        })
        @pdf.font "Arial"
        @pdf.fallback_fonts ["#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"]
        
        student_info_box
        
        attendance_mode
        
        categories = $tables.attach("ILP_ENTRY_CATEGORY").primary_ids("ORDER BY pdf_order ASC")
        categories.each{|pid|
            
            student_ilps = @student.ilp.existing_records(
                "WHERE ilp_entry_category_id = '#{pid}'
                AND pdf_excluded IS NOT TRUE
                AND completed IS NOT TRUE"
            )
            if student_ilps
                
                category_record = $tables.attach("ILP_ENTRY_CATEGORY").by_primary_id(pid)
                
                @pdf.text "<b>#{category_record.fields["name"].value}</b>", :size => 12, :color=>"2570BA", :inline_format  => true
                @pdf.move_down 5
                
                case category_record.fields["display_type"].value
                when "Default"
                    
                    student_ilps.each{|ilp_record|
                        
                        ilp_line_item(ilp_record)
                        
                    }
                    
                when "Table"
                    display_as_table(student_ilps)
                when "Table 2"
                    display_as_table_two(student_ilps)
                when "Schedule - Weekly"
                    display_schedule_weekly(student_ilps)
                when "Schedule - 6 Day"
                    display_schedule_6day(student_ilps)
                when "Schedule - 7 Day"
                    display_schedule_7day(student_ilps)
                end
                
                @pdf.move_down 15
                
            end
            
        } if categories
        
        conference_notes
        
        signatures
        
        @pdf.render_file "#{file_path}#{file_name}" if render_required
        
        return "#{file_path}#{file_name}"
        
    end
    
    def conference_notes
        
        if (
            
            ilp_conference_records = @student.contacts.existing_records("WHERE ilp_conference IS TRUE AND successful IS TRUE")
            
        )
            
            @pdf.text "<b>Conference Details</b>", :size => 12, :color=>"2570BA", :inline_format  => true
            @pdf.move_down 5
            
            table_array = Array.new
            
            table_array.push(
                
                headers = [
                    "Conference Date"
                ]
                
            )
            
            ilp_conference_records.each{|record|
                
                row_array = Array.new
                row_array.push(record.fields["datetime" ].to_user)
                
                table_array.push(row_array)
                
            }
            
            width = 520.0
            table_length = table_array[0].length
            
            @pdf.table(
                table_array,
                :width          => width,
                :position       => :center,
                :column_widths  => Array.new(table_length).fill(width/table_length),
                :cell_style     => {
                    :inline_format  => true,
                    :align          => :left,
                    :size           => 8,
                    :padding        => 2,
                    :border_width   => 1,
                    :border_colors  => "AED0EA",
                    :borders        => [:right,:left,:top,:bottom]
                }
            ) do
                row(0   ).background_color = "DEEDF7"
            end
            
        end
        
    end
    
    def signatures
        
        @pdf.move_down 20
        @pdf.text "Please sign below."
        @pdf.move_down 20
        @pdf.text "<b>Student:</b>________________________________________________<b>Date:</b>________________________", :inline_format=>true
        @pdf.move_down 15                                                                      
        @pdf.text "<b>Learning Coach:</b>________________________________________<b>Date:</b>________________________", :inline_format=>true
        @pdf.move_down 15                                                                     
        @pdf.text "<b>Agora Representative:</b>___________________________________<b>Date:</b>________________________", :inline_format=>true
        @pdf.move_down 20
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________STUDENT_INFO_BOX
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def student_info_box
        
        @pdf.text "<b>Individual Learning Plan - #{$iuser}</b>", :size => 22, :color=>"2570BA", :inline_format  => true, :align => :center
        
        @pdf.move_down 3
        
        @pdf.table [
            
            ["<b>Student Information</b>"]
            
        ],
        :width      => 540,
        :position   => :center,
        :cell_style => {
            :inline_format      => true,
            :size               => 12,
            :padding            => 2,
            :align              => :center,
            :text_color         => "2570BA",
            :background_color   => "DEEDF7",
            :border_colors      => "AED0EA"
        }
        
        gc_record   = @student.relate.existing_records("WHERE role = 'Guidance Couselor' AND active IS TRUE")
        gc          = (gc_record ? gc_record[0].fields["team_id"].to_name(:full_name) : "")
        
        ftc_record  = @student.relate.existing_records("WHERE role = 'Family Teacher Coach' AND active IS TRUE")
        ftc         = (ftc_record ? ftc_record[0].fields["team_id"].to_name(:full_name) : "")
        
        @pdf.table [
            
            [
                "<b>Student Name:</b>",
                "#{@student.studentfirstname.value} #{@student.studentlastname.value}",
                "<b>Guardian (#{@student.lgrelationship.value}):</b>",
                "#{@student.lgfirstname.value} #{@student.lglastname.value}"
            ],
            [
                "<b>Student ID:</b>",
                @student.student_id.value,
                "<b>Coach (#{@student.lcrelationship.value}):</b>",
                "#{@student.lcfirstname.value} #{@student.lclastname.value}"
            ],
            [
                "<b>Birth Date:</b>",
                "#{@student.birthday.to_user}",
                "<b>Family Coach:</b>",
                ftc
            ],
            [
                "<b>Grade Level:</b>",
                "#{@student.grade.value.gsub(" Grade","")}",
                "<b>Counselor:</b>",
                gc
            ],
            [
                "<b>Enroll Date:</b>",
                @student.schoolenrolldate.to_user,
                "<b>Cohort Year:</b>",
                "#{@student.cohort_year.value}",
            ]
            
        ],
        :width          => 540,
        :position       => :center,
        :column_widths  => [85,160,135,160],
        :cell_style     => {
            :inline_format  => true,
            :size           => 10,
            :padding        => 2,
            :border_colors  => "AED0EA",
            :borders        => []
        }
        
        @pdf.move_down 20
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________ILP_LINE_ITEM
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def ilp_line_item(ilp_record)
        
        cat_id          = ilp_record.fields["ilp_entry_category_id"].value
        category_record = $tables.attach("ILP_ENTRY_CATEGORY").by_primary_id(cat_id)
        
        ilp_category_section_one(ilp_record, category_record)
        ilp_category_section_two(ilp_record, category_record)
        #ilp_line_item_fields_required(ilp_record)
        #ilp_line_item_fields_optional(ilp_record, category_record)
        
    end
    
    def ilp_category_section_one(ilp_record, category_record)
        
        if category_record.fields["pdf_responsible_parties"].is_true?
            
            top_cursor = @pdf.cursor
            
            responsible_parties_pids = $tables.attach("student_ilp_responsible_parties").primary_ids("WHERE ilp_id='#{ilp_record.fields["primary_id"].value}'")
            
            width = responsible_parties_pids ? 260.0 : 520.0
            
            headers      = "<b><u>#{$tables.attach("ILP_ENTRY_TYPE").field_by_pid("name", ilp_record.fields["ilp_entry_type_id"].value).value}:</u></b>"
            field_values = ilp_record.fields["description"].value ? ilp_record.fields["description"].value : "<i>No Description Entered</i>"
            
            ilp_line_item_field(headers, field_values, {:width=>width, :column_widths=>Array.new([headers].length).fill(width/[headers].length)})
            
            if category_record.fields["pdf_solution"        ].is_true?
                
                @pdf.move_down 5
                
                headers      = "<b>Solution:</b>"
                field_values = ilp_record.fields["solution"].value ? ilp_record.fields["solution"].value : "<i>None Provided</i>"
                
                ilp_line_item_field(headers, field_values, {:width=>width, :column_widths=>Array.new([headers].length).fill(width/[headers].length)}) 
                
            end
            
            bottom_cursor = @pdf.cursor
            
            @pdf.move_cursor_to top_cursor-20
            
            headers         = Array.new
            field_row       = Array.new
            
            headers = ["<b>Name</b>","<b>Responsiblity</b>","",]
            
            field_row.push(headers)
            
            if responsible_parties_pids
                responsible_parties_pids.each do |pid|
                    field_values    = Array.new
                    row = $tables.attach("student_ilp_responsible_parties").by_primary_id(pid)
                    t=$team.get(row.fields["team_id"].value)
                    field_values.push("#{t.legal_first_name.value} #{t.legal_last_name.value}")
                    field_values.push(row.fields["responsibility"].value)
                    complete = row.fields["completed"].is_true? ? checkbox_filled : checkbox_empty
                    field_values.push(complete)
                    field_row.push(field_values)
                end
                width = 260.0
                @pdf.table [["<b>Responsible Parties</b>"]],
                    :width          => width,
                    :position       => :right,
                    :cell_style     => {
                        :inline_format  => true,
                        :size           => 8,
                        :align          => :center,
                        :padding        => 2,
                        :border_width   => 1,
                        :border_colors  => "AED0EA",
                        :background_color=>"AED0EA",
                        :text_color=>"FFFFFF"
                    }
                @pdf.table field_row,
                    :width          => width,
                    :position       => :right,
                    :column_widths  => [120,120,20],
                    :cell_style     => {
                        :inline_format  => true,
                        :size           => 8,
                        :align          => :center,
                        :padding        => 2,
                        :border_width   => 1,
                        :border_colors  => "AED0EA"
                    }
            end
            
            if @pdf.cursor < bottom_cursor
                
                @pdf.move_down 10
                
            else
                
                @pdf.move_cursor_to bottom_cursor-10
                
            end
            
        else
            
            width = 520.0
            
            headers      = "<b><u>#{$tables.attach("ILP_ENTRY_TYPE").field_by_pid("name", ilp_record.fields["ilp_entry_type_id"].value).value}:</u></b>"
            field_values = ilp_record.fields["description"].value
            
            ilp_line_item_field(headers, field_values, {:width=>width, :column_widths=>Array.new([headers].length).fill(width/[headers].length)})
            
            if category_record.fields["pdf_solution"        ].is_true?
                
                @pdf.move_down 5
                
                headers      = "<b>Solution:</b>"
                field_values = ilp_record.fields["solution"].value
                
                ilp_line_item_field(headers, field_values, {:width=>width, :column_widths=>Array.new([headers].length).fill(width/[headers].length)}) 
                
            end
            
            @pdf.move_down 15
            
        end
    end
    
    def ilp_category_section_two(ilp_record, category_record)
        
        headers         = Array.new
        field_values    = Array.new
        
        if category_record.fields["pdf_goal_type"       ].is_true?
            headers.push("<b>Goal Type</b>")
            field_values.push(ilp_record.fields["goal_type"].value ? ilp_record.fields["goal_type"].value : "<i>Not Selected</i>")
        end
        
        if category_record.fields["pdf_completed"       ].is_true?
            headers.push("<b>Completed?</b>")
            field_values.push(ilp_record.fields["completed"].is_true?  ? checkbox_filled : checkbox_empty )
        end
        
        if category_record.fields["pdf_progress"       ].is_true?
            headers.push("<b>Progress</b>")
            field_values.push(ilp_record.fields["progress"].value ? ilp_record.fields["progress"].value : "<i>Not Selected</i>")
        end
        
        if category_record.fields["pdf_expiration_date"       ].is_true?
            headers.push("<b>Re-Evaluation Date</b>")
            field_values.push(ilp_record.fields["expiration_date"].value ? ilp_record.fields["expiration_date"].to_user : "<i>Not Selected</i>")
        end
        
        ilp_line_item_field(headers, field_values, {:position=>:center}, {:align=>:center}) if !headers.empty?
        
        @pdf.move_down 15
        
    end
    
    def ilp_line_item_field(headers, field_values, attributes_sub = nil, cell_style_sub = nil)
        
        headers         = (headers.type == Array)         ? headers       : [headers]
        field_values    = (field_values.type == Array)    ? field_values  : [field_values]
        
        attributes = {
            :width           => 520.0,
            :position        => :left,
            :column_widths   => Array.new(headers.length).fill(520.0/headers.length),
            :cell_style     => {
                :inline_format   => true,
                :size            => 10,
                :align           => :left,
                :padding         => 2,
                :border_width    => 0,
                :border_colors   => "AED0EA",
                :borders         => []
            }
        }
        
        #Chages attributes by substitution
        if attributes_sub
           
            attributes_sub.each_pair do |k,v|
                
                attributes[k] = v
                
            end
            
        end
        
        if cell_style_sub
           
            cell_style_sub.each_pair do |k,v|
            
            attributes[:cell_style][k] = v
            
            end
            
        end
        
        #HEADER
        @pdf.table [
            
            headers
            
        ],attributes
        
        #CONTENT/FIELD_VALUE
        @pdf.table [
            
            field_values
            
        ],attributes
        
    end
    
    def ilp_line_item_fields_optional(ilp_record, category_record)
        
        headers         = Array.new
        field_row       = Array.new
        
        if category_record.fields["pdf_responsible_parties"].is_true?
            headers = ["<b>Name</b>","<b>Responsiblity</b>","<b>Completed?</b>",]
            field_row.push(headers)
            responsible_parties_pids = $tables.attach("student_ilp_responsible_parties").primary_ids("WHERE ilp_id='#{ilp_record.fields["primary_id"].value}'")
            if responsible_parties_pids
                responsible_parties_pids.each do |pid|
                    field_values    = Array.new
                    row = $tables.attach("student_ilp_responsible_parties").by_primary_id(pid)
                    t=$team.get(row.fields["team_id"].value)
                    field_values.push("#{t.legal_first_name.value} #{t.legal_last_name.value}")
                    field_values.push(row.fields["responsibility"].value)
                    complete = row.fields["completed"].is_true? ? checkbox_filled : checkbox_empty
                    field_values.push(complete)
                    field_row.push(field_values)
                end
                width = 260.0
                @pdf.table [["<b>Responsible Parties</b>"]],
                    :width          => width,
                    :position       => :right,
                    :cell_style     => {
                        :inline_format  => true,
                        :size           => 8,
                        :align          => :center,
                        :padding        => 2,
                        :border_width   => 1,
                        :border_colors  => "AED0EA",
                        :borders        => [:left,:right,:bottom,:top],
                        :background_color=>"AED0EA",
                        :text_color=>"FFFFFF"
                    }
                @pdf.table field_row,
                    :width          => width,
                    :position       => :right,
                    :column_widths  => Array.new(field_row.first.length).fill(width/field_row.first.length),
                    :cell_style     => {
                        :inline_format  => true,
                        :size           => 8,
                        :align          => :center,
                        :padding        => 2,
                        :border_width   => 1,
                        :border_colors  => "AED0EA",
                        :borders        => [:left,:right,:bottom,:top]
                    }
                @pdf.move_down 5
            end
            
        end
        
        ilp_line_item_field("<b>Solution:</b>", ilp_record.fields["solution"].value) if category_record.fields["pdf_solution"        ].is_true?
        
        headers         = Array.new
        field_values    = Array.new
        
        if category_record.fields["pdf_goal_type"       ].is_true?
            headers.push("<b>Goal Type</b>")
            field_values.push(ilp_record.fields["goal_type"].value)
        end
        
        if category_record.fields["pdf_completed"       ].is_true?
            headers.push("<b>Completed?</b>")
            field_values.push(ilp_record.fields["completed"].is_true?  ? checkbox_filled : checkbox_empty )
        end
        
        if category_record.fields["pdf_progress"       ].is_true?
            headers.push("<b>Progress</b>")
            field_values.push(ilp_record.fields["progress"].value)
        end
        
        if category_record.fields["pdf_expiration_date"       ].is_true?
            headers.push("<b>Re-Evaluation Date</b>")
            field_values.push(ilp_record.fields["expiration_date"].to_user)
        end
        
        ilp_line_item_field(headers, field_values) if !headers.empty?
        
    end
    
    def ilp_line_item_fields_required(ilp_record)
        
        ilp_line_item_field("<b><u>#{$tables.attach("ILP_ENTRY_TYPE").field_by_pid("name", ilp_record.fields["ilp_entry_type_id"].value).value}:</u></b>", ilp_record.fields["description"].value)
     
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________DISPLAY_SCHEDULE
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-

    def display_as_table(student_ilps)
        
        types = Array.new
        
        student_ilps.each{|student_ilp|types.push(student_ilp.fields["ilp_entry_type_id"].value) if !types.include?(student_ilp.fields["ilp_entry_type_id"].value)}
        display_hash = Hash.new {|hash, key|
            
            columns_hash = Hash.new
            types.each{|type|
                columns_hash[type] = nil
            }
            hash[key] = columns_hash
            
        }
        
        rows = Array.new
        student_ilps.each{|ilp|
            
            rows.push(ilp.fields["description"].value) if !rows.include?(ilp.fields["description"].value)
            display_hash[ilp.fields["description"].value][ilp.fields["ilp_entry_type_id"].value] = ilp.fields["solution"].value
            
        }
        
        table_array = Array.new
        
        headers = [""]
        types.each{|type|
            headers.push(
                "<b>#{$tables.attach("ILP_ENTRY_TYPE").by_primary_id(type).fields["name"].value}</b>"
            )
        }
        table_array.push(headers)
        
        rows.each{|row|
            
            row_array = Array.new
            row_array.push("<b>#{row}</b>")
            types.each{|type|
                
                row_array.push(display_hash[row][type])
                
            }    
            table_array.push(row_array)
            
        }
        
        width = 520.0
        table_length = table_array[0].length
        
        @pdf.table(
            table_array,
            :width          => width,
            :position       => :center,
            :column_widths  => Array.new(table_length).fill(width/table_length),
            :cell_style     => {
                :inline_format  => true,
                :align          => :left,
                :size           => 8,
                :padding        => 2,
                :border_width   => 1,
                :border_colors  => "AED0EA",
                :borders        => [:right,:left,:top,:bottom]
            }
        ) do
            row(0   ).background_color = "DEEDF7"
            column(0).background_color = "DEEDF7"
        end
        
    end

    def display_as_table_two(student_ilps)
        
        ilp_settings_record = $tables.attach("ILP_ENTRY_CATEGORY").by_primary_id(student_ilps[0].fields["ilp_entry_category_id"].value)
        
        fields_displayed = Array.new
        ilp_settings_record.fields.each_pair{|field_name, setting|
            
            if (field_name.match(/pdf/) && setting.is_true?)
                
                if (ordered = ilp_settings_record.fields[field_name.gsub("pdf_","order_")].value)
                    fields_displayed[ordered.to_i-1] = field_name
                else
                    fields_displayed.push(field_name)
                end
                
            end
            
        }
        
        table_array = Array.new
        headers = Array.new
        
        fields_displayed.each{|field_name|
            
            custom_label    = ilp_settings_record.fields[field_name.gsub("pdf_","label_")].value
            default_label   = student_ilps[0].table.fields[field_name.gsub("pdf_","")][:label]
            header_label    = custom_label || default_label
            headers.push("<b>#{header_label}</b>")   
            
        }
        
        table_array.push(headers)
        
        student_ilps.each{|ilp|
            
            this_row = Array.new
            fields_displayed.each{|field_name|
             
                ilp_field_name = field_name.gsub("pdf_","")
                if ilp_field_name.match(/ilp_entry_category_id/)
                    ilp_value = $tables.attach("ILP_ENTRY_CATEGORY" ).field_by_pid("name", ilp.fields[ilp_field_name].value).to_user
                elsif ilp_field_name.match(/ilp_entry_type_id/)
                    ilp_value = $tables.attach("ILP_ENTRY_TYPE"     ).field_by_pid("name", ilp.fields[ilp_field_name].value).to_user
                else
                    ilp_value = ilp.fields[ilp_field_name].to_user
                end
                this_row.push(ilp_value)   
                
            }
            table_array.push(this_row)
            
        }
        
        width           = 520.0
        table_length    = table_array[0].length
        
        if table_length > 0
            
            @pdf.table(
                table_array,
                :width          => width,
                :position       => :center,
                :column_widths  => Array.new(table_length).fill(width/table_length),
                :cell_style     => {
                    :inline_format  => true,
                    :align          => :left,
                    :size           => 8,
                    :padding        => 2,
                    :border_width   => 1,
                    :border_colors  => "AED0EA",
                    :borders        => [:right,:left,:top,:bottom]
                }
            ) do row(0).background_color = "DEEDF7"
            end
            
        else
            @pdf.text "Nothing to display."
        end
        
    end

    def display_schedule_weekly(student_ilps)
        
        schedule_hash = Hash.new {|hash, key|
            
            hash[key] = {
                
                :monday     =>nil,
                :tuesday    =>nil,
                :wednesday  =>nil,
                :thursday   =>nil,
                :friday     =>nil
                
            }
            
        }
        
        type_names       = Array.new
        
        student_ilps.each{|ilp|
            
            type_name = "<b>#{$tables.attach("ILP_ENTRY_TYPE").field_by_pid("default_description", ilp.fields["ilp_entry_type_id"].value).value}</b>"
            type_names.push(type_name) if !type_names.include?(type_name)
            schedule_hash[type_name][:monday    ] = ilp.fields["description"].value if ilp.fields["monday"     ].is_true?
            schedule_hash[type_name][:tuesday   ] = ilp.fields["description"].value if ilp.fields["tuesday"    ].is_true?
            schedule_hash[type_name][:wednesday ] = ilp.fields["description"].value if ilp.fields["wednesday"  ].is_true?
            schedule_hash[type_name][:thursday  ] = ilp.fields["description"].value if ilp.fields["thursday"   ].is_true?
            schedule_hash[type_name][:friday    ] = ilp.fields["description"].value if ilp.fields["friday"     ].is_true?
            
        }
        
        table_array = Array.new
        table_array.push(["","<b>Monday</b>","<b>Tuesday</b>","<b>Wednesday</b>","<b>Thursday</b>","<b>Friday</b>"])
        type_names.sort.each{|type_name|
            
            
            table_array.push(
                
                [
                    "<b>#{type_name}</b>",
                    schedule_hash[type_name][:monday    ],
                    schedule_hash[type_name][:tuesday   ],
                    schedule_hash[type_name][:wednesday ],
                    schedule_hash[type_name][:thursday  ],
                    schedule_hash[type_name][:friday    ]
                ]
                
            )
            
        }
        
        width = 520.0
        table_length = table_array[0].length
        
        @pdf.table(
            table_array,
            :width          => width,
            :position       => :center,
            :column_widths  => Array.new(table_length).fill(width/table_length),
            :cell_style     => {
                :inline_format  => true,
                :align          => :center,
                :size           => 8,
                :padding        => 2,
                :border_width   => 1,
                :border_colors  => "AED0EA",
                :borders        => [:right,:left,:top,:bottom]
            }
        ) do
            row(0   ).background_color  = "DEEDF7"
            column(0).background_color  = "DEEDF7"
            column(0).align             = :left
        end
        
    end
    
    def display_schedule_6day(student_ilps)
        
        schedule_hash = Hash.new {|hash, key|
            
            hash[key] = {
                
                :day1 =>nil,
                :day2 =>nil,
                :day3 =>nil,
                :day4 =>nil,
                :day5 =>nil,
                :day6 =>nil
                
            }
            
        }
        
        type_names       = Array.new
        
        student_ilps.each{|ilp|
            
            type_name = "<b>#{$tables.attach("ILP_ENTRY_TYPE").field_by_pid("default_description", ilp.fields["ilp_entry_type_id"].value).value}</b>"
            type_names.push(type_name) if !type_names.include?(type_name)
            schedule_hash[type_name][:day1] = ilp.fields["description"].value if ilp.fields["day1"].is_true?
            schedule_hash[type_name][:day2] = ilp.fields["description"].value if ilp.fields["day2"].is_true?
            schedule_hash[type_name][:day3] = ilp.fields["description"].value if ilp.fields["day3"].is_true?
            schedule_hash[type_name][:day4] = ilp.fields["description"].value if ilp.fields["day4"].is_true?
            schedule_hash[type_name][:day5] = ilp.fields["description"].value if ilp.fields["day5"].is_true?
            schedule_hash[type_name][:day6] = ilp.fields["description"].value if ilp.fields["day6"].is_true?
            
        }
        
        table_array = Array.new
        table_array.push(["","<b>Day 1</b>","<b>Day 2</b>","<b>Day 3</b>","<b>Day 4</b>","<b>Day 5</b>","<b>Day 6</b>"])
        type_names.sort.each{|type_name|
            
            
            table_array.push(
                
                [
                    "<b>#{type_name}</b>",
                    schedule_hash[type_name][:day1],
                    schedule_hash[type_name][:day2],
                    schedule_hash[type_name][:day3],
                    schedule_hash[type_name][:day4],
                    schedule_hash[type_name][:day5],
                    schedule_hash[type_name][:day6]
                ]
                
            )
            
        }
        
        width = 520.0
        table_length = table_array[0].length
        
        @pdf.table(
            table_array,
            :width          => width,
            :position       => :center,
            :column_widths  => Array.new(table_length).fill(width/table_length),
            :cell_style     => {
                :inline_format  => true,
                :align          => :center,
                :size           => 8,
                :padding        => 2,
                :border_width   => 1,
                :border_colors  => "AED0EA",
                :borders        => [:right,:left,:top,:bottom]
            }
        ) do
            row(0   ).background_color = "DEEDF7"
            column(0).background_color = "DEEDF7"
        end
        
    end
    
    def display_schedule_7day(student_ilps)
        
        schedule_hash = Hash.new {|hash, key|
            
            hash[key] = {
                
                :day1 =>nil,
                :day2 =>nil,
                :day3 =>nil,
                :day4 =>nil,
                :day5 =>nil,
                :day6 =>nil,
                :day7 =>nil
                
            }
            
        }
        
        type_names       = Array.new
        
        student_ilps.each{|ilp|
            
            type_name = "<b>#{$tables.attach("ILP_ENTRY_TYPE").field_by_pid("default_description", ilp.fields["ilp_entry_type_id"].value).value}</b>"
            type_names.push(type_name) if !type_names.include?(type_name)
            schedule_hash[type_name][:day1] = ilp.fields["description"].value if ilp.fields["day1"].is_true?
            schedule_hash[type_name][:day2] = ilp.fields["description"].value if ilp.fields["day2"].is_true?
            schedule_hash[type_name][:day3] = ilp.fields["description"].value if ilp.fields["day3"].is_true?
            schedule_hash[type_name][:day4] = ilp.fields["description"].value if ilp.fields["day4"].is_true?
            schedule_hash[type_name][:day5] = ilp.fields["description"].value if ilp.fields["day5"].is_true?
            schedule_hash[type_name][:day6] = ilp.fields["description"].value if ilp.fields["day6"].is_true?
            schedule_hash[type_name][:day7] = ilp.fields["description"].value if ilp.fields["day7"].is_true?
            
        }
        
        table_array = Array.new
        table_array.push(["","<b>Day 1</b>","<b>Day 2</b>","<b>Day 3</b>","<b>Day 4</b>","<b>Day 5</b>","<b>Day 6</b>","<b>Day 7</b>"])
        type_names.sort.each{|type_name|
            
            
            table_array.push(
                
                [
                    "<b>#{type_name}</b>",
                    schedule_hash[type_name][:day1],
                    schedule_hash[type_name][:day2],
                    schedule_hash[type_name][:day3],
                    schedule_hash[type_name][:day4],
                    schedule_hash[type_name][:day5],
                    schedule_hash[type_name][:day6],
                    schedule_hash[type_name][:day7]
                ]
                
            )
            
        }
        
        width = 520.0
        table_length = table_array[0].length
        
        @pdf.table(
            table_array,
            :width          => width,
            :position       => :center,
            :column_widths  => Array.new(table_length).fill(width/table_length),
            :cell_style     => {
                :inline_format  => true,
                :align          => :center,
                :size           => 8,
                :padding        => 2,
                :border_width   => 1,
                :border_colors  => "AED0EA",
                :borders        => [:right,:left,:top,:bottom]
            }
        ) do
            row(0   ).background_color = "DEEDF7"
            column(0).background_color = "DEEDF7"
        end
        
    end
    
    def checkbox_empty
        
        return "\xE2\x98\x90"
        
    end
    
    def checkbox_filled
        
        return "\xE2\x98\x91"
        
    end
    
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
def x______________SYNCH_OR_ASYNCH
end
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    def attendance_mode
        
        if @student.attendance_mode.attendance_mode
            
            attendance_mode = @student.attendance_mode.attendance_mode.value
            mode_message    = $tables.attach("Attendance_Modes").find_field("description", "WHERE mode='#{attendance_mode}'").value
            
        else
            
            attendance_mode = "Not Found"
            mode_message    = "Please contact an administrator."
            
        end
        
        @pdf.text "<b>Educational Path: #{attendance_mode}</b>", :size => 12, :color=>"2570BA", :inline_format  => true
        
        @pdf.move_down 5
        
        @pdf.indent(10) do
            
            @pdf.text "#{mode_message}", :size => 10
            
        end
        
        enrolled    = @student.attendance.existing_records("WHERE official_code IS NOT NULL")
        present     = @student.attendance.existing_records("WHERE (#{official_code_sql("present")    })")
        excused     = @student.attendance.existing_records("WHERE (#{official_code_sql("excused")    })")
        unexcused   = @student.attendance.existing_records("WHERE (#{official_code_sql("unexcused")  })")
        
        table_array = Array.new
        table_array.push(
            [
                "Days Enrolled",
                "Days Present",
                "Days Excused",
                "Days Unexcused"
            ],
            [
                (enrolled   ? enrolled.length   : 0),
                (present    ? present.length    : 0),
                (excused    ? excused.length    : 0),
                (unexcused  ? unexcused.length  : 0)
            ]
        )
        
        width = 520.0
        table_length = table_array[0].length
        @pdf.table(
            table_array,
            :width          => width,
            :position       => :center,
            :column_widths  => Array.new(table_length).fill(width/table_length),
            :cell_style     => {
                :inline_format  => true,
                :align          => :center,
                :size           => 8,
                :padding        => 2,
                :border_width   => 1,
                :border_colors  => "AED0EA",
                :borders        => [:bottom]
            }
        ) #do
        #    row(0   ).background_color = "DEEDF7"
        #    column(0).background_color = "DEEDF7"
        #end
        
        @pdf.move_down 15
        
    end
    
    def official_code_sql(code_type)
        
        code_sql_string = String.new
        
        codes = $tables.attach("attendance_codes").find_fields("code", "WHERE code_type = '#{code_type}'")
        
        codes.each{|code|
            code_sql_string << (code_sql_string.empty? ? "official_code = '#{code.value}'" : " OR official_code = '#{code.value}'")
        }
        
        return code_sql_string
        
    end
    
end