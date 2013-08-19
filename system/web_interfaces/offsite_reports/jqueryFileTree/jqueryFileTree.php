<?php
//
// jQuery File Tree PHP Connector
//
// Version 1.01
//
// Cory S.N. LaViska
// A Beautiful Site (http://abeautifulsite.net/)
// 24 March 2008
//
// History:
//
// 1.01 - updated to work with foreign characters in directory/file names (12 April 2008)
// 1.00 - released (24 March 2008)
//
// Output a list of files for jQuery File Tree
//
//
//#Hash of existing folder name(key) and display name(value)
$folder_name_replacements = array(
	'agora_staffList' 		 => 'Staff List',
	'agora_aggregate_progress' 	 => 'Aggregate Progress',
	'agora_all_students'             => 'All Students',
	'agora_attendance_modified'	 => 'Attendance Modified',
        'agora_attendanceModified'	 => 'Attendance Modified',
        'agora_calms_aggregateProg'      => 'CALMS Aggregate Progress',	
        'agora_classlistteacherview_vhs' => 'Class List Teacher View VHS',
	'agora_ecollege_detail'          => 'ECollege Detail',
	'agora_eitr_version2'            => 'EITR V2',
	'agora_elluminate_session'       => 'Elluminate Session',
	'agora_highschool_classroom'     => 'Highschool Classroom',
	'agora_home_language'            => 'Home Language',
	'agora_learning_coach_report'	 => 'Learning Coach Report',
	'agora_lessons_count_daily'	 => 'Lessons Count Daily',
	'agora_logins'                   => 'Logins',
	'agora_logins_afternoon'	 => 'Logins - Afternoon',
	'agora_omnibus'                  => 'Omnibus',
	'agora_sti_combined_report'      => 'STI Combined Report',
	'agora_sti_intervention'         => 'STI Intervention',
	'agora_student_course_report'	 => 'Student Course',
	'agora_withdraw'                 => 'Withdraw',
	'attendance_master'		 => 'Attendance Master',
	'flag_duplicates'		 => 'Flag Duplicates'
);

$_POST['dir'] = urldecode($_POST['dir']);
$root = isset($root) ? $root : "";
if( file_exists($root . $_POST['dir']) ) {
	$files = scandir($root . $_POST['dir']);
	natcasesort($files);
	if( count($files) > 2 ) { /* The 2 accounts for . and .. */
		echo "<ul class=\"jqueryFileTree\" style=\"display: none;\">";
		// All dirs
		foreach( $files as $file ) {
			if( file_exists($root . $_POST['dir'] . $file) && $file != '.' && $file != '..' && is_dir($root . $_POST['dir'] . $file) ) {
				if(array_key_exists($file, $folder_name_replacements)){
					$folder_name = $folder_name_replacements[$file];
				}else{
					$folder_name = $file;
				}
				echo "<li class=\"directory collapsed\"><a href=\"#\" rel=\"" . htmlentities($_POST['dir'] . $file) . "/\">" . htmlentities($folder_name) . "</a></li>";
			}
		}
		// All files
		$files = array_reverse($files, true);
		foreach( $files as $file ) {
			if( file_exists($root . $_POST['dir'] . $file) && $file != '.' && $file != '..' && !is_dir($root . $_POST['dir'] . $file) ) {
				$ext = preg_replace('/^.*\./', '', $file);
				$file_name = file_display_name($file);
				echo "<li class=\"file ext_$ext\"><a href=\"#\" rel=\"" . htmlentities($_POST['dir'] . $file) . "\">" . htmlentities($file_name) . "</a></li>";
			}
		}
		echo "</ul>";	
	}
}

function file_display_name($file){
	if(preg_match('/\d\.csv$/', $file)){
		global $folder_name_replacements;
		$name_split = explode("_", $file);
		$report_date = end($name_split);
		array_pop($name_split);
		$report_name = implode("_", $name_split);
		if(array_key_exists($report_name, $folder_name_replacements)){
			$report_name = $folder_name_replacements[$report_name];
		}
		
		$y = substr($report_date, 1,  4);
		$m = substr($report_date, 5,  2);
		$d = substr($report_date, 7,  2);
		$h = substr($report_date, 10, 2);
		$i = substr($report_date, 12, 2);
		$s = substr($report_date, 14, 2);
		$report_date = $m.'/'.$d.'/'.$y.' '.$h.':'.$i.':'.$s;
		
		$filesize = filesize(htmlentities($_POST['dir'].$file));
		$filesize = format_bytes($filesize);
		
		$new_name = $report_name.' - '.$report_date.'  '.$filesize;
		return $new_name;
	}else{
		return $file;
	}
}

function format_bytes($a_bytes)
{
    if ($a_bytes < 1048576) {
        return round($a_bytes / 1024, 2) .' kB';
    } elseif ($a_bytes < 1073741824) {
        return round($a_bytes / 1048576, 2) . ' MB';
    } elseif ($a_bytes < 1099511627776) {
        return round($a_bytes / 1073741824, 2) . ' GB';
    } else{
        return round($a_bytes / 1099511627776, 2) .' TB';
    }
}

?>