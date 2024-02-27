<meta charset="UTF-8">

<?php
include "../conexion.php";
header('Content-Type: text/html; charset=utf-8');
mysqli_set_charset($conexion, "utf8mb4");

$tipo       = $_FILES['dataCliente']['type'];
$tamanio    = $_FILES['dataCliente']['size'];
$archivotmp = $_FILES['dataCliente']['tmp_name'];
$lineas     = file($archivotmp);

$i = 0;

foreach ($lineas as $linea) {
    $cantidad_registros = count($lineas);
    $cantidad_regist_agregados =  ($cantidad_registros - 1);

    if ($i != 0) {

        $datos = explode(";", $linea);
        $datos = mb_convert_encoding($datos, 'UTF-8', 'ISO-8859-1');
 

        $ambito_aplicacion = !empty($datos[0]) ? $datos[0] : '';
        $materia = !empty($datos[1]) ? $datos[1] : '';
        $tema = !empty($datos[2]) ? $datos[2] : '';
        $etapa = !empty($datos[3]) ? $datos[3] : '';
        $fecha_notificacion = !empty($datos[4]) ? $datos[4] : '';
        $resolucion_aprobacion = !empty($datos[5]) ? $datos[5] : '';
        $nombre = !empty($datos[6]) ? $datos[6] : '';
        $item = !empty($datos[7]) ? $datos[7] : '';
        $descripcion_literal = !empty($datos[8]) ? $datos[8] : '';
        $obligaciones = !empty($datos[9]) ? $datos[9] : '';
        $frecuencia = !empty($datos[10]) ? $datos[10] : '';
        $autoridades_competentes = !empty($datos[11]) ? $datos[11] : '';
        $consecuencias_incumplimiento = !empty($datos[12]) ? $datos[12] : '';
        $base_legal = !empty($datos[13]) ? $datos[13] : '';
        $relacion_otras_obligaciones = !empty($datos[14]) ? $datos[14] : '';
        $evidencia = !empty($datos[15]) ? $datos[15] : '';
        $area_responsable = !empty($datos[16]) ? $datos[16] : '';
        $responsable_cumplimiento = !empty($datos[17]) ? $datos[17] : '';
        $fecha_verificacion = !empty($datos[18]) ? $datos[18] : '';
        $cumple = !empty($datos[19]) ? $datos[19] : '';
        $estado_verificacion = !empty($datos[20]) ? $datos[20] : '';
        $plan_accion = !empty($datos[21]) ? $datos[21] : '';
        $responsable = !empty($datos[22]) ? $datos[22] : '';
        $fecha_implementacion = !empty($datos[23]) ? $datos[23] : '';
        $observaciones = !empty($datos[24]) ? $datos[24] : '';
        $responsables_corregido = !empty($datos[25]) ? $datos[25] : '';
        $correos = !empty($datos[26]) ? $datos[26] : '';
        $area_responsable = !empty($datos[27]) ? $datos[27] : '';
        $id_obligacion = !empty($datos[28]) ? $datos[28] : '';

        $insertar = "INSERT INTO datos (
            Ambito_de_aplicacion,
            Materia,
            Tema,
            Etapa,
            Fecha_de_notificacion,
            Resolucion_de_aprobacion,
            Nombre,
            Item,
            Descripcion_literal,
            Obligaciones,
            Frecuencia,
            Autoridades_competentes,
            Consecuencias_de_incumplimiento,
            Base_Legal,
            Relacion_con_otras_obligaciones,
            Evidencia,
            Area_Responsable,
            Responsable_de_cumplimiento,
            Fecha_de_Verificacion,
            Cumple,
            Estado_de_Verificacion,
            Plan_de_accion,
            Responsable,
            Fecha_de_implementacion,
            Observaciones,
            Responsables_corregido,
            Correos,
            Area_responsable_u,
            Id_obligacion
        ) VALUES (
            '$ambito_aplicacion',
            '$materia',
            '$tema',
            '$etapa',
            '$fecha_notificacion',
            '$resolucion_aprobacion',
            '$nombre',
            '$item',
            '$descripcion_literal',
            '$obligaciones',
            '$frecuencia',
            '$autoridades_competentes',
            '$consecuencias_incumplimiento',
            '$base_legal',
            '$relacion_otras_obligaciones',
            '$evidencia',
            '$area_responsable',
            '$responsable_cumplimiento',
            '$fecha_verificacion',
            '$cumple',
            '$estado_verificacion',
            '$plan_accion',
            '$responsable',
            '$fecha_implementacion',
            '$observaciones',
            '$responsables_corregido',
            '$correos',
            '$area_responsable',
            '$id_obligacion'
        )";
   mysqli_query($conexion, $insertar);
  }

  echo '<div>'. $i. "). " .$insertar.'</div>';
  $i++;
}

echo '<p style="text-align:center; color:#333;">Total de Registros: '. $cantidad_regist_agregados .'</p>';
?>

<a href="lista_unidades.php">Atras</a>