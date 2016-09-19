<?php

// ***************
// DO NOT ALTER
error_reporting(0);
set_time_limit(90);
// ***************

// BEGIN PERSONAL SETTINGS

// Change email addresses below  
$emailTo = "you@yourwebsite.com";

// if you want the email to be sent from the submitted email address, leave this blank
// otherwise, enter your own email address here
$emailFrom = "";

$name = "qCreative";

// This is the subject that will appear in the email
$subject = "Website Email";

// This is the greeting in the body of the email you'll recieve
$greeting = "You have a new website email! \n\n";

// END PERSONAL SETTINGS

// ****************************
// DO NOT ALTER BELOW THIS LINE
// ****************************

$ef = $_POST['ee'];
$eff = (int)$ef;

if($eff != 999) {
	$sendFromE = true;
}
else {
	$sendFromE = false;
}

$str = $_POST['tt'];
$arr = explode("r7yi2s", $str);

$st = $_POST['ff'];
$ar = explode("z85c64", $st);
$counter = count($ar);

$details .= $greeting;

for($i = 0; $i < $counter; $i++) {
	if($i != 0) {
	
		$details .= $arr[$i] . " = " . $ar[$i] . "\n";
		
		if($sendFromE) {
			if($eff == $i) {
				$emailFrom .= $ar[$i];
				$sendFromE = false;
			}
		}
		
	}
}

$headers = "MIME-Version: 1.0\r\n";
$headers .= "Content-type: text/plain; charset=UTF-8\r\n";
$headers .= "From: " . $emailFrom . " <" . $name . "> \n";
$headers .= "Reply-To: " . $emailFrom . "\n\n";
	
mail($emailTo, $subject, $details, $headers);

?>