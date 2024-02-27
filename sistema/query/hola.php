<?php
include "../../conexion.php";

// Get the data from the POST request
$codigo = $_POST['codigo'];

$aspecto_ambiental = $_POST['aspecto'];
$fuente = $_POST['fuente'];
$norma_aprobacion = $_POST['norma'];
$denominacion = $_POST['denominacion'];
$fecha_publicacion = $_POST['fecha'];
$articulo = $_POST['articulo'];
$descripcion_obligacion = $_POST['descripcion'];
$consecuencias_incumplimiento = $_POST['consecuencias'];
$periodicidad = $_POST['periodicidad'];
$fecha_cumplimiento = $_POST['fechaCumplimiento'];
$norma_tipificadora = $_POST['normaTipificadora'];
$actividades_cumplimiento = $_POST['actividadesCumplimiento'];
$evidencia = $_POST['evidencia'];

// Insert the data into the "obligacion" table
$query = "INSERT INTO obligacion (codigo, aspecto_ambiental, fuente, norma_aprobacion, denominacion, fecha_publicacion, articulo, descripcion_obligacion, consecuencias_incumplimiento, periodicidad, fecha_cumplimiento, norma_tipificadora, actividades_cumplimiento, evidencia) 
      VALUES ('$codigo','$aspecto_ambiental', '$fuente', '$norma_aprobacion', '$denominacion', '$fecha_publicacion', '$articulo', '$descripcion_obligacion', '$consecuencias_incumplimiento', '$periodicidad', '$fecha_cumplimiento', '$norma_tipificadora', '$actividades_cumplimiento', '$evidencia')";
$query_insert = mysqli_query($conexion, $query);

if ($query_insert) {
    $alert = "
    <script>
    Swal.fire(
      'Datos registrados correctamente',
      '',
      'success'
    );
    </script>
    ";
} else {
    $alert = '<div class="alert alert-danger" role="alert">
            Error al registrar los datos
          </div>';
}

if ($query_insert) {
    echo $alert;
} else {
    echo "Error al registrar los datos";
}
?>
