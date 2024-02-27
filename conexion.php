<?php
 
 /*
    $host = "localhost";
    $user = "u124192910_root24";
    $clave = "?28Je0hFu";
    $bd = "u124192910_db_zuniga1";
*/
    $host = "localhost";
    $user = "root";
    $clave = "";
    $bd = "bd_abogados_1";

    $conexion = mysqli_connect($host,$user,$clave,$bd);
    if (mysqli_connect_errno()){
        echo "No se pudo conectar a la base de datos";
        exit();
    }

    mysqli_select_db($conexion,$bd) or die("No se encuentra la base de datos");

    mysqli_set_charset($conexion,"utf8");

?>
