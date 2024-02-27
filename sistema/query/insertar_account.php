<?php
include "../conexion.php";

// Get the data from the POST request
$aspecto_ambiental = $_POST['aspecto_ambiental'];
$fuente = $_POST['fuente'];
$norma_aprobacion = $_POST['norma_aprobacion'];
$denominacion = $_POST['denominacion'];
$fecha_publicacion = $_POST['fecha_publicacion'];
$articulo = $_POST['articulo'];
$descripcion_obligacion = $_POST['descripcion_obligacion'];
$consecuencias_incumplimiento = $_POST['consecuencias_incumplimiento'];
$periodicidad = $_POST['periodicidad'];
$fecha_cumplimiento = $_POST['fecha_cumplimiento'];
$norma_tipificadora = $_POST['norma_tipificadora'];
$actividades_cumplimiento = $_POST['actividades_cumplimiento'];
$evidencia = $_POST['evidencia'];

// Insert the data into the "obligacion" table
$query = "INSERT INTO obligacion (aspecto_ambiental, fuente, norma_aprobacion, denominacion, fecha_publicacion, articulo, descripcion_obligacion, consecuencias_incumplimiento, periodicidad, fecha_cumplimiento, norma_tipificadora, actividades_cumplimiento, evidencia) 
      VALUES ('$aspecto_ambiental', '$fuente', '$norma_aprobacion', '$denominacion', '$fecha_publicacion', '$articulo', '$descripcion_obligacion', '$consecuencias_incumplimiento', '$periodicidad', '$fecha_cumplimiento', '$norma_tipificadora', '$actividades_cumplimiento', '$evidencia')";
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
