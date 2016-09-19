<?php
//Importamos las variables del formulario
@$name = addslashes($_POST['name']);
@$email = addslashes($_POST['email']);
@$subject = addslashes($_POST['subject']);
@$message = addslashes($_POST['message']);
//Preparamos el mensaje de contacto
$cabeceras = "From: $email\n" //La persona que envia el correo
 . "Reply-To: $email\n";
$asunto = "$subject"; //El asunto
$email_to = "ideas.informacion@gmail.com , angelapulido.design@gmail.com , info@ideas-soluciones.com"; //cambiar por tu email
$contenido = "$name le ha enviado el siguiente mensaje:\n"
. "\n"
. "$message\n"
. "\n";
//Enviamos el mensaje y comprobamos el resultado
if (@mail($email_to, $asunto ,$contenido ,$cabeceras )) {
//Si el mensaje se envía muestra una confirmación
die("Muchas gracias, su mensaje fue enviado correctamente");
}else{
//Si el mensaje no se envía muestra el mensaje de error
die("Error: Su mensaje no pudo ser enviado, intente despues");
}
?>
