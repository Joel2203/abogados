<?php
include "../../conexion.php";

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    // Obtén el ID del cliente desde los datos del formulario
    $clienteId = mysqli_real_escape_string($conexion, $_POST["modal_id"]);

    // Información de los archivos
    $numArchivos = count($_FILES["obligacion_img"]["name"]);

    for ($i = 0; $i < $numArchivos; $i++) {
        $nombreArchivo = $_FILES["obligacion_img"]["name"][$i];
        $tipoArchivo = $_FILES["obligacion_img"]["type"][$i];
        $urlArchivo = "../img/obligaciones/" . basename($nombreArchivo); // Ajusta la ruta según tu estructura

        // Mueve el archivo a la ubicación deseada
        move_uploaded_file($_FILES["obligacion_img"]["tmp_name"][$i], $urlArchivo);

        // Inserta la información en la tabla file_data
        $sql = "INSERT INTO file_data (  name_obligacion, url_obligacion, type_obligacion, cod_data) 
                VALUES (  '$nombreArchivo', '$urlArchivo', '$tipoArchivo', '$clienteId')";

        if ($conexion->query($sql) !== TRUE) {
            echo "Error al subir el archivo: " . $conexion->error;
            exit;
        }
    }

    echo "1";
} else {
    echo "0";
}
?>
