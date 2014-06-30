#!/usr/local/bin/ruby

class RECORD_REQUESTS_LABELS_PDF

    #---------------------------------------------------------------------------
    def initialize()
    end
    #---------------------------------------------------------------------------
    
    def set_fonts(pdf)
        
        pdf.font_families.update("Arial" => {
            :normal      => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf",
            :italic      => "c:/windows/fonts/ariali.ttf",
            :bold        => "c:/windows/fonts/arialbd.ttf",
            :bold_italic => "c:/windows/fonts/arialbi.ttf"
        })
        
        pdf.font "Arial"
        
        pdf.fallback_fonts ["#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"]
        
        return pdf
        
    end
    
    def generate_pdf(pids, pdf = nil)
        
        render_required = false
        
        margin_v = 22
        margin_h = 5
        
        if !pdf
            
            render_required = true
            file_name = "rri_labels_#{$ifilestamp}.pdf"
            file_path = $config.init_path("#{$paths.reports_path}Mailing_Labels")
            pdf       = Prawn::Document.new(:margin=>[margin_v, margin_h, margin_v, margin_h])
            
        end
        
        set_fonts(pdf)
        
        columns = 3
        rows    = 10
        pages   = (pids.length/((columns*rows).to_f)).ceil
        
        pdf.define_grid(
            :columns       => columns,
            :rows          => rows,
            :column_gutter => 16,
            :row_gutter    => 10
        )
        
        p=0
        while p < pages
            i=0
            while i < rows do
                j=0
                while j < columns
                    
                    pdf.grid([i,j], [i,j]).bounding_box do
                        
                        #pdf.stroke_bounds
                        pdf.move_down 5
                        
                        if pid = pids.delete_at(0)
                            
                            address = $tables.attach("STUDENT_RRI_RECIPIENTS").by_primary_id(pid)
                            fields = address.fields
                            
                            text = String.new
                            
                            text << "#{fields["name"     ].value}\n" if fields["name"     ] && fields["name"     ].value != ""
                            text << "ATTN:#{fields["attn"].value}\n" if fields["attn"     ] && fields["attn"     ].value != ""
                            text << "#{fields["address_1"].value}\n"
                            text << "#{fields["address_2"].value}\n" if fields["address_2"] && fields["address_2"].value != ""
                            text << "#{fields["city"     ].value}, #{fields["state"].value} #{fields["zip"].value}"
                            
                            pdf.text text, :size => 8, :inline_format => true
                            
                        else
                            
                            j = columns + 1
                            i = rows    + 1
                            
                        end
                        
                    end
                    j+=1
                end
                i+=1
            end
            pdf.start_new_page if pages-p != 1
            p+=1
        end
        
        pdf.render_file "#{file_path}#{file_name}" if render_required
        
    end
    
end