<?php include_once "includes/header.php"; 
?>
<meta charset="UTF-8">
<!-- Begin Page Content -->
<div class="container-fluid">

	<!-- Page Heading -->
	<div class="d-sm-flex align-items-center justify-content-between mb-4">
		<h1 class="h3 mb-0 text-gray-800">Obligaciones</h1>
		 
	</div>

	<div class="row">
		<div class="col-lg-12">

			<div class="table-responsive">
				<table class="table table-striped table-bordered" id="table">
					<thead class="thead-dark">
						<tr>
						<div class="col-lg-12">
 
						</div>
						
							<!-- Modal para mostrar imágenes -->
								 
						

						</div>
						
						<?php if ($_SESSION['rol'] == 1) { ?>
							<th>ACCIONES</th>
							<?php } ?>
							<th>Id</th>
							<th>Ambito de aplicacion</th>
                            <th>Materia</th>
                            <th>Tema</th>
                            <th>Etapa</th>
                            <th>Fecha de notificacion</th>
                            <th>Resolucion de aprobacion</th>
                            <th>Nombre</th>
                            <th>Item</th>
                            <th>Descripcion literal</th>
                            <th>Obligaciones</th>
                            <th>Frecuencia</th>
                            <th>Autoridades competentes</th>
                            <th>Consecuencias de incumplimiento</th>
                            <th>Base Legal</th>
                            <th>Relacion con otras obligaciones</th>
                            <th>Evidencia</th>
                            <th>Area Responsable</th>
                            <th>Responsable de cumplimiento</th>
                            <th>Fecha de Verificacion</th>
                            <th>Cumple</th>
                            <th>Estado de Verificacion</th>
                            <th>Plan de accion</th>
                            <th>Responsable</th>
                            <th>Fecha de implementacion</th>
                            <th>Observaciones</th>
                            <th>Responsables corregido</th>
                            <th>Correos</th>
                            <th>Area responsable</th>
                            <th>Id obligacion</th>
				
						</tr>
					</thead>
					<tbody>
						<?php
						include "../conexion.php";


						$asesor = $_SESSION['nombre'];

						function convertirFechaExcel($fechaSerial) {
							if (empty($fechaSerial) || $fechaSerial == 0) {
								return ""; // Devuelve una cadena vacía si el dato es vacío o nulo
							  }
							  
							  $unixTimestamp = ($fechaSerial - 25569) * 86400;
							  return date('Y-m-d', $unixTimestamp);
						  }
						  function convertirFechaExcel1($fechaNormal) {
							if (empty($fechaNormal)) {
								return ""; // Devuelve una cadena vacía si el dato es vacío o nulo
							}
							
							$fechaUnix = strtotime($fechaNormal);
							$fechaSerial = round(($fechaUnix / 86400) + 25569, 0);
							
							return $fechaSerial;
						}

						
						$fechaActual = date("Y-m-d");
                        $fechaHoy = convertirFechaExcel1($fechaActual);


						  $search = isset($_GET['search']) ? $_GET['search'] : '';
						  

						if(!empty($search)){
							
							$sql = "SELECT * FROM datos WHERE  `RUC` = '$search' LIMIT 500; ";
							$query = mysqli_query($conexion, $sql);

							
						}else{
							
							$sql = "SELECT * FROM datos LIMIT 500; ";
							$query = mysqli_query($conexion, $sql);

						}  
						
						$result = mysqli_num_rows($query);
						if ($result > 0) {
							while ($data = mysqli_fetch_assoc($query)) { ?>
								<tr>
								<?php if ($_SESSION['rol'] == 1) { ?>
									<td>
								     	<a href="lista_uniser.php?id=<?php echo $data['id']; ?>" class="btn btn-primary"><i class='fas fa-eye'></i></a>
										 <a href="#" class="btn btn-primary btn-abrir-modal" data-toggle="modal"  data-id="<?php echo $data['id']; ?>" data-target="#myModal"><i class="fas fa-file"></i></a>

									

									</td>
									<?php } ?>
									<td><?php echo $data['id']; ?></td>
									<td><?php echo $data['Ambito_de_aplicacion']; ?></td>
									<td><?php echo $data['Materia']; ?></td>
									<td><?php echo $data['Tema']; ?></td>
									<td><?php echo $data['Etapa']; ?></td>
									<td><?php echo $data['Fecha_de_notificacion']; ?></td>
									<td><?php echo $data['Resolucion_de_aprobacion']; ?></td>
									<td><?php echo $data['Nombre']; ?></td>
									<td><?php echo $data['Item']; ?></td>
									<td><?php echo $data['Descripcion_literal']; ?></td>
									<td><?php echo $data['Obligaciones']; ?></td>
									<td><?php echo $data['Frecuencia']; ?></td>
									<td><?php echo $data['Autoridades_competentes']; ?></td>
									<td><?php echo $data['Consecuencias_de_incumplimiento']; ?></td>
									<td><?php echo $data['Base_Legal']; ?></td>
									<td><?php echo $data['Relacion_con_otras_obligaciones']; ?></td>
									<td><?php echo $data['Evidencia']; ?></td>
									<td><?php echo $data['Area_Responsable']; ?></td>
									<td><?php echo $data['Responsable_de_cumplimiento']; ?></td>
									<td><?php echo $data['Fecha_de_Verificacion']; ?></td>
									<td><?php echo $data['Cumple']; ?></td>
									<td><?php echo $data['Estado_de_Verificacion']; ?></td>
									<td><?php echo $data['Plan_de_accion']; ?></td>
									<td><?php echo $data['Responsable']; ?></td>
									<td><?php echo $data['Fecha_de_implementacion']; ?></td>
									<td><?php echo $data['Observaciones']; ?></td>
									<td><?php echo $data['Responsables_corregido']; ?></td>
									<td><?php echo $data['Correos']; ?></td>
									<td><?php echo $data['Area_responsable_u']; ?></td>
									<td><?php echo $data['Id_obligacion']; ?></td>

									
								</tr>
						<?php }
						} ?>
					</tbody>

				</table>
			</div>

		</div>
	</div>


</div>
<!-- /.container-fluid -->
<!-- Agrega la referencia al ícono de archivo (Font Awesome) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Subir Archivos</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <!-- Contenido del modal -->
        <div class="row">
          <div class="col-lg-12 mx-auto">
            <form id="formulario" autocomplete="off" enctype="multipart/form-data">
              <?php echo isset($alert) ? $alert : ''; ?>
 
              <div class="form-group">
                <div class="col-md-12">
                  <div data-aos="flip-left" class="col-md-12">
                    <div class="custom-file">
                      <input type="file" class="custom-file-input" id="obligacion_img" name="obligacion_img[]" accept="image/*" multiple onchange="mostrarImagen()">
                      <label class="custom-file-label" for="obligacion_img">Elegir Archivo</label>
                    </div>
                  </div>
                  <div id="fotoCount">El número de fotos seleccionadas es 0.</div>
                  <div id="imagenContainer" style="display:none;">
                    <label for="imagen">Imagen seleccionada:</label>
                    <div id="imagenPreview" class="img-preview"></div>
                  </div>
                  <!-- Agregar un campo oculto para almacenar el id -->
                  <input type="hidden" id="modal_id" name="modal_id" value="">
                </div>
              </div>
              <div class="text-center">
                <input type="submit" value="Guardar archivos" class="btn btn-primary" id="guardar_imagen">
              </div>
            </form>
            <div id="mensaje" class="mt-3"></div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
      </div>
    </div>
  </div>
</div>

 
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script>
 
	$(document).ready(function () {
		// Manejador de clic en el enlace que abre el modal
		$('.btn-abrir-modal').on('click', function () {
			// Obtener el id de la fila desde el atributo data-id
			var clienteId = $(this).data('id');
			console.log('ID del cliente al abrir el modal:', clienteId);
			$('#modal_id').val(clienteId);

			 // Obtener el ID de la fila
			 var clienteId = $(this).data('id');
				console.log('ID del cliente al abrir el modal:', clienteId);

				// Resto del código para abrir el modal si es necesario

				// Llamada AJAX para obtener las imágenes del servidor
				$.ajax({
					url: 'query/cargar_imagenes.php', // Cambia la ruta según tu estructura de archivos
					type: 'POST',
					data: { clienteId: clienteId },
					success: function (response) {
						// Actualizar el contenido del modal con las imágenes
						$('#mensaje').html(response);

						// Mostrar el modal
						$('#modalImagenes').modal('show');
					},
					error: function (xhr, status, error) {
						console.error('Error al cargar las imágenes:', status, error);
					}
				});

			// Resto del código para abrir el modal si es necesario
		});
	});
 // Agrega el siguiente código en tu script de JavaScript

 

 
 
// Manejador de envío del formulario
$('#formulario').on('submit', function (event) {
			event.preventDefault(); // Evita que el formulario se envíe normalmente

			  // Verificar si el campo de archivo está vacío
			  var archivoInput = $('#obligacion_img');
			if (archivoInput[0].files.length === 0) {
				// Mostrar alerta de que se deben subir imágenes
				Swal.fire({
					icon: 'warning',
					title: 'Alerta',
					text: 'Debes subir al menos una imagen.',
				});
				return; // Detener el proceso si no hay archivos seleccionados
			}
			// Obtén los datos del formulario
			var formData = new FormData(this);

			// Realiza la llamada Ajax
			$.ajax({
				url: 'query/insertar_img.php', // Ruta al script PHP que procesará los datos
				type: 'POST',
				data: formData,
				processData: false, // No procesar los datos automáticamente
				contentType: false, // No establecer el tipo de contenido automáticamente
				success: function (response) {
					 // Mostrar SweetAlert2 según la respuesta
					 if (response == 1) {
						// Éxito
						Swal.fire({
							icon: 'success',
							title: 'Éxito',
							text: 'Archivos subidos correctamente.',
						});
						} else {
							// Error
							Swal.fire({
								icon: 'error',
								title: 'Error',
								text: 'Hubo un problema con el servidor.',
							});
						}
				},
				error: function (xhr, status, error) {
					// Manejar errores aquí
					console.error('Error:', status, error);
				}
			});
		});

  function mostrarImagen() {
    var input = document.getElementById("obligacion_img");
    var imagenContainer = document.getElementById("imagenContainer");
    var fotoCount = document.getElementById("fotoCount");

    // Limpiar el contenedor y el conteo antes de agregar nuevas imágenes
    imagenContainer.style.display = "block";
    imagenContainer.innerHTML = "";
    fotoCount.innerHTML = "El número de fotos seleccionadas es 0.";

    if (input.files && input.files.length > 0) {
      for (var i = 0; i < input.files.length; i++) {
        var reader = new FileReader();

        // Utilizar una función de cierre para capturar la variable i
        (function(index) {
          reader.onload = function(e) {
            var imagenPreview = document.createElement("div");
            imagenPreview.classList.add("imagenPreview");
            imagenPreview.style.backgroundImage = "url(" + e.target.result + ")";
            imagenContainer.appendChild(imagenPreview);

            // Actualizar el conteo de fotos seleccionadas
            fotoCount.innerHTML =
              "El número de fotos seleccionadas es " + (index + 1) + ".";
          };
        })(i);

        reader.readAsDataURL(input.files[i]);
      }
    }
  }
</script>


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</div>
<!-- End of Main Content -->


<?php include_once "includes/footer.php"; ?>