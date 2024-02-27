<?php
include "../conexion.php";

date_default_timezone_set("America/Bogota");
setlocale(LC_ALL, "es_ES");

// Obtener idEvento de manera segura usando $_POST
$idEvento = isset($_POST['idEvento']) ? $_POST['idEvento'] : '';

// Verificar si se proporcionó un ID de evento
if (empty($idEvento)) {
    echo "Error: No se proporcionó un ID de evento.";
    exit;
}

// Obtener otros datos del formulario de manera segura usando $_POST
$evento = ucwords($_POST['evento']);
$descripcion = $_POST['descripcion'];
$f_inicio = $_POST['fecha_inicio'];
$fecha_inicio = date('Y-m-d', strtotime($f_inicio));
$f_fin = $_POST['fecha_fin'];
$seteando_f_final = date('Y-m-d', strtotime($f_fin));
$fecha_fin1 = strtotime($seteando_f_final . "+ 1 days");
$fecha_fin = date('Y-m-d', ($fecha_fin1));
$color_evento = isset($_POST['color_evento']) ? $_POST['color_evento'] : '';
$asignado = isset($_POST['asignado']) ? $_POST['asignado'] : '';
$estado = '';

// Determinar el estado según el color_evento
if ($color_evento == '#fd0000') {
    $estado = 'Urgente';
} elseif ($color_evento == '#FFC107') {
    $estado = 'Necesario';
} else {
    $estado = 'Pendiente';
}

// Consultar el correo del usuario asignado
$query = "SELECT correo FROM `usuario` WHERE idusuario = $asignado LIMIT 1";

$consultarcorreo = mysqli_query($conexion, $query);
$dato = mysqli_fetch_array($consultarcorreo);
$correo = $dato['correo'];

// Mostrar el correo obtenido (puedes eliminar esta línea si no es necesario)
echo $correo;

// Actualizar el evento en la base de datos
$sql = "UPDATE eventoscalendar 
        SET evento = '$evento',
            descripcion = '$descripcion',
            fecha_inicio = '$fecha_inicio',
            fecha_fin = '$fecha_fin',
            color_evento = $color_evento,
            asignado = '$asignado',
            estado = '$estado'
        WHERE id = '".$idEvento."' ";
 
 $ejecutagei = mysqli_query($conexion,$sql);
?>

