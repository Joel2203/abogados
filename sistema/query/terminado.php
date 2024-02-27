<?php
include "../../conexion.php";
 
 
// Verificar si la solicitud es de tipo POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    
    $descripcion = $_POST['descripcion'] ?? null;
    $codievento = $_POST['idEvento'] ?? null; // Corregir el nombre de la variable aquí

    $query_insert = mysqli_query($conexion, "INSERT INTO realizado(descripcion,codidevento) values ('$descripcion', '$codievento')");

    if (!$query_insert) {
        die("Error en la consulta: " . mysqli_error($conexion));
    }
    
}  
?>
