<?php
date_default_timezone_set("America/Bogota");
setlocale(LC_ALL, "es_ES");

include "../conexion.php";

$evento         = ucwords($_REQUEST['evento']);
$descripcion    = $_REQUEST['descripcion'];
$f_inicio       = $_REQUEST['fecha_inicio'];
$fecha_inicio   = date('Y-m-d', strtotime($f_inicio));

$f_fin          = $_REQUEST['fecha_fin'];
$seteando_f_final  = date('Y-m-d', strtotime($f_fin));
$fecha_fin1     = strtotime($seteando_f_final . "+ 1 days");
$fecha_fin      = date('Y-m-d', ($fecha_fin1));
$color_evento   = $_REQUEST['color_evento'];
$asignado       = isset($_REQUEST['usuario']) ? $_REQUEST['usuario'] : '';
$estado         = isset($_REQUEST['estado']) ? $_REQUEST['estado'] : '';

//AGREGAR ASIGNADO Y ESTADO
//ASIGNADO
//$ID = ASIGNADO


$InsertNuevoEvento = "INSERT INTO eventoscalendar(
      evento,
      descripcion,
      fecha_inicio,
      fecha_fin,
      color_evento,
      asignado,
      estado
      )
    VALUES (
      '" . $evento . "',
      '" . $descripcion . "',
      '" . $fecha_inicio . "',
      '" . $fecha_fin . "',
      '" . $color_evento . "',
      '" . $asignado . "',
      '" . $estado . "'
  )";

$resultadoNuevoEvento = mysqli_query($conexion, $InsertNuevoEvento);

if ($resultadoNuevoEvento) {
    $id = mysqli_insert_id($conexion);
    $sql = "SELECT u.correo FROM `eventoscalendar` as e INNER JOIN usuario as u ON e.asignado = u.idusuario where e.asignado =  $asignado ";
 
    $consultarcorreo = mysqli_query($conexion, $sql);
    $dato = mysqli_fetch_array($consultarcorreo);
    $correo = $dato['correo'];
 
 
    ?>


<script type="text/javascript"
  src="https://cdn.jsdelivr.net/npm/@emailjs/browser@4/dist/email.min.js"></script>

<script type="text/javascript">
  emailjs.init('QuHI0lBxcZ-Er-i1A')
</script>

    <script>
        // Función para enviar el correo a través de Email.js
        function enviarCorreo() {
            // ...

            emailjs.send("service_z66iuap", "template_9twwcid", {
                to_descripcion: '<?php echo $descripcion; ?>',
                from_fecha_inicio: '<?php echo $fecha_inicio; ?>',
                from_fecha_fin: '<?php echo $fecha_fin; ?>',
                from_evento: '<?php echo $evento; ?>',
                reply_to: "elprocrakxd123@gmail.com",
                from_correo: '<?php echo $correo; ?>',
            });
            console.log('SI FUNCIONA');
        }
        enviarCorreo();
    </script>

    <?php
}
if (!$resultadoNuevoEvento) {
    echo "Error al insertar el evento en la base de datos: " . mysqli_error($conexion);
}


if (!empty($_FILES['imagen']['name'][0])) {
    // Si la imagen existe
    if ($_FILES['imagen']['error'][0] === UPLOAD_ERR_OK) {
        $imagenes = $_FILES['imagen'];
        $fechaActual = date('YmdHis');

        // Iterar sobre cada imagen
        for ($i = 0; $i < count($imagenes['name']); $i++) {
            // Obtener información de cada imagen
            $subir = $imagenes['name'][$i];
            $imagenNombre = pathinfo($imagenes['name'][$i], PATHINFO_FILENAME);

            $imagenTmpName = $imagenes['tmp_name'][$i];
            $imagenExtension = strtolower(pathinfo($imagenes['name'][$i], PATHINFO_EXTENSION));

            // Ruta de destino para la imagen
            $targetDir =  __DIR__ . "/img/archivos/";
            $targetPath = $targetDir . $fechaActual . '-' . $subir;
            $path_info = pathinfo($targetPath);
            $extension = isset($path_info['extension']) ? $path_info['extension'] : "0";
            $extension_sin_espacios = rtrim($targetPath);

            $src = $fechaActual . '-' . $imagenNombre . '.' . $imagenExtension;

            // Mover la imagen al destino
            move_uploaded_file($imagenTmpName, $extension_sin_espacios);

            // Insertar información en la base de datos
            $sqlInsertImagen = "INSERT INTO archivos (name_obligacion, url_obligacion, type_obligacion, cod_data) VALUES ('$imagenNombre', '$src', '$imagenExtension', '$id')";
            $query_insert1 = mysqli_query($conexion, $sqlInsertImagen);
        }
    } else {
        echo "Error al subir la imagen"; // Manejar el error al subir la imagen
    }
} else {
    echo "No se han seleccionado archivos"; // Manejar el caso en el que no se haya seleccionado ningún archivo
}


echo '<script>
        setTimeout(function(){
            window.location.href = "calendar.php?e=1";
        }, 1000); // 1000 milisegundos = 1 segundo
      </script>';
?>
