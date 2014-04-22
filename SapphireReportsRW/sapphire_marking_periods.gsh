def athena 		= new SchoolInfo()
def import_path 	= athena.strVar("\$paths.imports_path")
def commands_path 	= athena.strVar("\$paths.commands_path")

loginToReportWriter("https://agora-sapphire.k12system.com/analysis/services/repository", "PAAGC", "jhalverson", "tBM679p8a")

runReportAndSave(

	"/Reports/Jenifer/sapphire_marking_periods",
	[:],
	["RUN_OUTPUT_FORMAT":"CSV"],
	"${import_path}/sapphire_marking_periods.csv"
)

def x = """ruby ${commands_path}load.rb sapphire_marking_periods""".execute().waitFor()  

import groovy.json.*

public class SchoolInfo {

   public field_values(table_name, field_name, where_clause) {
      
      def args_string   = "{'get':'field_values','table':'${table_name}','field':'${field_name}'}"
      get(args_string)
      
   }
   
   public get(args_string){
      
      def q             = "ruby C:/Users/Parnassus/athena-sis/htdocs/athena/Athena_JSON.rb ${args_string.replaceAll("'", '"""') }".execute()
      q.waitForOrKill(2000)
      def response      = q.getText()
      
      if (response.trim()){
         
         return new JsonSlurper().parseText(response)
         
      }
      else{
        
         return response
         
      }
      
   }
   
   public path(){
      
      System.getProperty("user.dir").replaceAll("\\SapphireReportsRW", "")
      
   }
   
   public school_year(){
      
      def args_string   = "{'get':'\$school.current_school_year'}"
      get(args_string)
      
   }
   
   public strVar(variable_name){
      
      def args_string   = "{'get':'${variable_name}'}"
      def response = get(args_string)
      
      if (response){
         
         return response[0]
         
      }
      else{
        
         return false;
         
      }
      
   }
   
}