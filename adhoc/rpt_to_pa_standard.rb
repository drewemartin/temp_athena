#!/usr/local/bin/ruby
require "#{File.dirname(__FILE__).gsub("adhoc","system/base")}/base"

class Rpt_To_Pa_Standard < Base
    
    def initialize()
        super()
        
        @total_wages    = 0
        @total_withheld = 0
        @rs_total       = 0
        
        all_text = String.new
        rpt_path = "#{$paths.imports_path}w2report.rpt"
        pas_file  = File.new("#{$paths.reports_path}pa_standard.txt", "wb")
        @csv_path = "#{$paths.imports_path}additional_finance_information.csv"
        
        File.open(rpt_path, 'rb' ) do |file|
            
            all_text << file.read
            rows = all_text.split("\r\n")
            i=0
            
            rows.each do |row|
                
                puts i
                
                new_row = String.new
                
                if i==0
                    
                    pas_file << ra(row)
                    pas_file << "\r\n"
                    
                elsif i==1
                    
                    pas_file << re(row)
                    pas_file << "\r\n"
                    
                elsif i>=2 && i<rows.length-2
                    
                    rs_row = rs(row)
                    
                    if rs_row
                        pas_file << rs_row
                        pas_file << "\r\n"
                        @rs_total += 1
                    end
                    
                elsif i==rows.length-2
                    
                    pas_file << rt(row)
                    pas_file << "\r\n"
                    
                elsif i==rows.length-1
                    
                    pas_file << rf(row)
                    
                end
                
                i+=1
                
            end
            
        end
        
    end
    
    def ra(row)
        row.gsub!("\t"," ")
        output = String.new
        
        output << "RA"                                  #Record ID
        output << row.slice(2..10)                      #EIN
        output << " "*26                                #Filler*26
        output << row.slice(30..108).rstrip.upcase      #Company Name
        output << " " until output.length == 94         #Padding
        output << " "*22                                #Filler
        output << row.slice(109..130).rstrip.upcase     #Delivery Address
        output << " " until output.length == 138        #Padding
        output << row.slice(131..152).rstrip.upcase     #City
        output << " " until output.length == 160        #Padding
        output << row.slice(153..154).upcase            #State Abbreviation
        output << row.slice(155..159)                   #Zip Code
        output << row.slice(160..163)                   #Zip Code Extension
        output << " "*224                               #Filler
        output << row.slice(388..414).rstrip.upcase     #Contact Name
        output << " " until output.length == 422        #Padding
        output << "00000"                               #Filler Phone
        output << row.slice(415..437).rstrip            #Contact Phone Number
        output << " "*5                                 #Contact Phone Extension
        output << " "*3                                 #Filler
        output << row.slice(438..491).rstrip.upcase     #Contact E-Mail
        output << " " until output.length == 512        #Padding
        
        return output
        
    end
    
    def re(row)
        
        output = String.new
        
        #variables not in RPT
        tax_quarter       = "4"
        psd_code          = "150902"
        reporting_period  = "201312"
        tax_type          = "W"
        
        output << "RE"                                  #Record ID
        output << row.slice(2..5)                       #Tax Year
        output << tax_quarter                           #Tax Quarter
        output << row.slice(7..15)                      #EIN
        output << " "*23                                #Filler
        output << row.slice(39..117).rstrip.upcase      #Employer Name
        output << " " until output.length == 96         #Padding
        output << " "*22                                #Filler
        output << row.slice(118..139).rstrip.upcase     #Delivery Address
        output << " " until output.length == 140        #Padding
        output << row.slice(140..161).rstrip.upcase     #City
        output << " " until output.length == 162        #Padding
        output << row.slice(162..163).rstrip.upcase     #State Abbreviation
        output << row.slice(164..168).rstrip            #Zip Code
        output << row.slice(169..172).rstrip            #Zip Code Extension
        output << "0"                                   #Record Change Notice
        output << " "*47                                #Filler
        output << psd_code                              #PSD Code
        output << " "                                   #Filler
        output << reporting_period                      #Reporting Period
        output << tax_type                              #Tax Type
        output << " " until output.length == 512        #Padding
        
        return output
        
    end
    
    def rs(row)
        
        output = String.new
        
        last_name        = String.new
        suffix           = String.new
        suffixes         = ["SR","JR","II","III","IV","V","VI","VII","VIII","IX","X"]
        ssn              = row.slice(2..10).rstrip
        reporting_period = "122013"
        tax_type         = "W"
        psd_code         = String.new
        local_taxable    = String.new
        tax_withheld     = String.new
        
        CSV.open(@csv_path, "rb").each do |csv_row|
            if csv_row[0].gsub("-","") == ssn
                psd_code        = csv_row[1]
                psd_code.insert(0,"0") until psd_code.length == 6
                local_taxable   = (((csv_row[2].to_f)*100).to_i).to_s
                local_taxable.insert(0,"0") until local_taxable.length == 11
                tax_withheld    = (((csv_row[3].to_f)*100).to_i).to_s
                tax_withheld.insert(0,"0") until tax_withheld.length == 11
                break
            end
        end
        
        if psd_code != "888888" && psd_code != "999999" && psd_code != "510101"
            
            output << "RS"                                  #Record ID
            output << " "*7                                 #Filler
            output << ssn                                   #SSN
            output << row.slice(11..25).rstrip.upcase       #Employee First Name
            output << " " until output.length == 33         #Padding
            output << row.slice(26..26).rstrip.upcase       #Employee Middle Initial
            output << " " until output.length == 48         #Padding
            last_name_str = row.slice(41..64).rstrip.upcase
            last_name_arr = last_name_str.split(" ")
            if suffixes.include?(last_name_arr.last)
                suffix = last_name_arr.last
                last_name_arr.delete_at(-1)
                last_name = last_name_arr.join(" ")
            else
                last_name = last_name_str
            end
            output << last_name                             #Employee Last Name
            output << " " until output.length == 68         #Padding
            output << suffix                                #Suffix
            output << " " until output.length == 72         #Padding
            output << row.slice(65..86).rstrip.upcase       #Location Address
            output << " " until output.length == 94         #Padding
            output << row.slice(87..108).rstrip.upcase      #Delivery Address
            output << " " until output.length == 116        #Padding
            output << row.slice(109..130).rstrip.upcase     #City
            output << " " until output.length == 138        #Padding
            output << row.slice(131..132).upcase            #State Abbreviation
            output << row.slice(133..137)                   #Zip Code
            output << row.slice(138..141)                   #Zip Code Extension
            output << " "*46                                #Filler
            output << "0"                                   #Record Change Notice
            output << reporting_period                      #Reporting Period
            output << " "*105                               #Filler
            output << tax_type                              #Tax Type
            output << local_taxable                         #Local Taxable Wages
            output << tax_withheld                          #Local Income Tax Withheld
            output << " "*7                                 #Filler
            output << psd_code                              #PSD Code
            output << " " until output.length == 512        #Padding
            
            @total_wages    += local_taxable.to_i
            @total_withheld += tax_withheld.to_i
            
            return output
            
        else
            
            return false
            
        end
        
    end
    
    def rt(row)
        
        output = String.new
        
        total_taxable    = String.new
        total_withheld   = String.new
        rs_total         = String.new
        
        output << "RT"                                  #Record ID
        
        rs_total = @rs_total.to_s
        rs_total.insert(0,"0") until rs_total.length == 7
        
        output << rs_total                              #Number of RS Records
        
        total_taxable   = @total_wages.to_s
        total_taxable.insert(0,"0") until total_taxable.length == 15
        total_withheld  = @total_withheld.to_s
        total_withheld.insert(0,"0") until total_withheld.length == 15
        
        output << total_taxable                         #Total Local Wages, Tips, and Other Compensation
        output << total_withheld                        #Total Local Income Tax Withheld
        output << " " until output.length == 512        #Padding
        
        return output
    end
    
    def rf(row)
        
        output = String.new
        
        total_taxable    = String.new
        total_withheld   = String.new
        rs_total         = String.new
        
        output << "RF"                                  #Record ID
        output << " "*5                                 #Filler
        
        rs_total = @rs_total.to_s
        rs_total.insert(0,"0") until rs_total.length == 9
        
        output << rs_total                              #Number of RS Records
        
        total_taxable   = @total_wages.to_s
        total_taxable.insert(0,"0") until total_taxable.length == 15
        total_withheld  = @total_withheld.to_s
        total_withheld.insert(0,"0") until total_withheld.length == 15
        
        output << total_taxable                         #Total Wages
        output << total_withheld                        #Total Withheld
        output << " " until output.length == 512        #Padding
        
        return output
        
    end
    
end

Rpt_To_Pa_Standard.new()