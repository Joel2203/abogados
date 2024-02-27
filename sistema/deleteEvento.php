<?php
include "../conexion.php";
$id    		= $_REQUEST['id']; 

$sqlDeleteEvento = ("DELETE FROM eventoscalendar WHERE  id='" .$id. "'");
$resultProd = mysqli_query($conexion, $sqlDeleteEvento);

?>