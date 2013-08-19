#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("reports","base")}/base"

class Data_Validation_Report < Base

    #---------------------------------------------------------------------------
    def initialize(report_type = "New Data")
        super()
        case report_type
        when "New Data"
            records = $tables.attach("Data_Validation").unreported
        end
        create_report(records) if records
    end
    #---------------------------------------------------------------------------

    def create_report(records) #accepts and array of Data_Validation Rows.
        i = 3
        excel = WIN32OLE::new('excel.Application')
        book  = excel.Workbooks.Open("#{$paths.templates_path}data_validation_report.xlsx")
        sheet = book.worksheets("Data Validation Report")
        
        sheet.range("a1").value     = "Data Validation Report - #{$iuser}"
        records.each{|row|
            table_name  = row.fields["table_name"    ].to_user
            primary_id  = row.fields["row_id"        ].to_user
            row_content = $tables.attach(table_name).by_primary_id(primary_id)
            sheet.range("a#{i}").value = table_name
            sheet.range("b#{i}").value = primary_id
            sheet.range("c#{i}").value = row.fields["field_name"    ].to_user
            sheet.range("d#{i}").value = row.fields["data_type"     ].to_user
            sheet.range("e#{i}").value = row.fields["failed_value"  ].to_user
            sheet.range("f#{i}").value = row.fields["failed_reason" ].to_user
            sheet.range("g#{i}").value = row.fields["created_by"    ].to_user
            sheet.range("h#{i}").value = row_content.string_with_fieldnames
            i+=1
        }
        
        #Save Report
        file_path = $config.init_path("#{$paths.reports_path}Data_Validation/All_Data")   
        save_path = "#{file_path}ALL_DATA#{$ifilestamp}.xlsx"
        book.SaveAs(save_path.gsub("/","\\"))
        book.close
        excel.Quit
        
        #Email Report
        
        #Mark as reported
        records.each{|row|
            row.fields["reported"].value = true
            row.save
        }
    end

end

Data_Validation_Report.new