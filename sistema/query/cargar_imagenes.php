<?php
include "../../conexion.php";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $clienteId = mysqli_real_escape_string($conexion, $_POST["clienteId"]);

    // Consulta SQL para obtener las imágenes asociadas al cliente
    $sql = "SELECT * FROM file_data WHERE cod_data = '$clienteId'";
    $result = $conexion->query($sql);

    if ($result->num_rows > 0) {
        // Generar el HTML para mostrar las imágenes
        while ($row = $result->fetch_assoc()) {
            $urlSinPuntos = str_replace('..', '', $row['url_obligacion']);
            
            // Obtener la extensión del archivo
            $extension = pathinfo($urlSinPuntos, PATHINFO_EXTENSION);
            
            // Verificar si la extensión corresponde a una imagen
            $esImagen = in_array(strtolower($extension), ['jpg', 'jpeg', 'png', 'gif']);

            if ($esImagen) {
                echo '<img src="/abogados/sistema' . $urlSinPuntos . '" alt="Imagen" style="width: 350px; height: auto;">';
            } else {
                // Si no es una imagen, mostrar un enlace de descarga
                echo '<center><a href="/abogados/sistema' . $urlSinPuntos . '" download>' . $row['name_obligacion'] . '</a></center><br>';
            }
        }
    } else {
        echo '<p>No hay imágenes para mostrar.</p>';
    }
}
?>
