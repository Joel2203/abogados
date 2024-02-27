<?php
include "../../conexion.php";

if (isset($_POST['codigo'])) {
    // Obtener el ID del registro que se va a actualizar
    $codigo = $_POST['codigo'];

    // Obtener los datos del formulario POST
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

    // Construir la consulta SQL de actualización
    $query = "UPDATE obligacion SET
              aspecto_ambiental = '$aspecto_ambiental',
              fuente = '$fuente',
              norma_aprobacion = '$norma_aprobacion',
              denominacion = '$denominacion',
              fecha_publicacion = '$fecha_publicacion',
              articulo = '$articulo',
              descripcion_obligacion = '$descripcion_obligacion',
              consecuencias_incumplimiento = '$consecuencias_incumplimiento',
              periodicidad = '$periodicidad',
              fecha_cumplimiento = '$fecha_cumplimiento',
              norma_tipificadora = '$norma_tipificadora',
              actividades_cumplimiento = '$actividades_cumplimiento',
              evidencia = '$evidencia'
              WHERE codigo = '$codigo'";

    // Ejecutar la consulta de actualización
    $query_update = mysqli_query($conexion, $query);

    if ($query_update) {
        $alert = "
        <script>
        Swal.fire(
          'Datos actualizados correctamente',
          '',
          'success'
        );
        </script>
        ";
    } else {
        $alert = '<div class="alert alert-danger" role="alert">
                Error al actualizar los datos
              </div>';
    }

    if ($query_update) {
        echo $alert;
    } else {
        echo "Error al actualizar los datos";
    }
} else {
    echo "No se proporcionó un ID para actualizar";
}
?>
