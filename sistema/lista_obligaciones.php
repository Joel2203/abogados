<?php include_once "includes/header.php"; 

$id = $_GET['id'];
$aspecto = $_GET['aspecto'];
$fuente = $_GET['fuente'];
$norma = $_GET['norma'];
$denominacion = $_GET['denominacion'];
$fecha = $_GET['fecha'];
$codigoNorma = $_GET['codigoNorma'];
$ruta = $_GET['ruta'];

include "../conexion.php";
$sql = "SELECT * FROM `obligacion` WHERE codigo = '$id'";
$query_verificar = mysqli_query($conexion,$sql );
$data = mysqli_fetch_array($query_verificar);

$option = "INSERTAR";

if (mysqli_num_rows($query_verificar) > 0) {
  $option = "ACTUALIZAR";
  
}else{
  echo "ES NUEVO SE DEBE INSERT";
}

?>

<div id="resultContact"></div>
<!-- Begin Page Content -->
<div class="container-fluid">
  <div class="container mt-5">
          <h2>DETALLE DE LA OBLIGACIÓN</h2>
          <!-- Botón para desbloquear campos (mostrado condicionalmente) -->
          <?php if ($option !== "INSERTAR") { ?>
          <div id="unlock">
              <button id="desbloquearCampos" class="btn btn-info"><i class="far fa-eye"></i></button>
          </div>
          <?php } ?>

          <form>
            <div class="form-group">
                <label for="id">ID:</label>
                <input type="text" class="form-control" id="codigo" value="<?php echo $id; ?>" readonly>
            </div>
            <div class="form-group">
                <label for="aspecto">Aspecto Ambiental:</label>
                <input type="text" class="form-control" id="aspecto" <?php echo ($option === "INSERTAR") ? '' : 'readonly value="' . $data['aspecto_ambiental'] . '"'; ?>>
            </div>
            <div class="form-group">
                <label for="fuente">Fuente: (Instrumento de gestión ambiental / Normas)</label>
                <input type="text" class="form-control" id="fuente" <?php echo ($option === "INSERTAR") ? '' : 'readonly  value="' . $data['fuente']; '"'; ?> >
            </div>
            <div class="form-group">
                <label for="norma">Norma de Aprobación:</label>
                <input type="text" class="form-control" id="norma" value="<?php echo $norma; ?>" readonly>
            </div>
            <div class="form-group">
                <label for="denominacion">Denominación:</label>
                <input type="text" class="form-control" id="denominacion" value="<?php echo $denominacion; ?>" readonly>
            </div>
            <div class="form-group">
                <label for="fecha">Fecha de Publicación: </label>
                <input type="text" class="form-control" id="fecha" value="<?php echo $fecha; ?>" readonly>
            </div>
            <div class="form-group">
                <label for="Artículo">Artículo:</label>
                <input type="text" class="form-control" id="articulo" value="<?php echo $codigoNorma; ?>" readonly>
            </div>
            <div class="form-group">
                <label for="ruta">Ruta:</label>
                <input type="text" class="form-control" id="ruta" value="<?php echo $ruta; ?>" readonly>
            </div>
            <div class="form-group">
                <label for="descripcion">Descripción de la obligación:</label>
                <textarea class="form-control" id="descripcion" rows="4" <?php echo ($option === "INSERTAR") ? '' : 'readonly'; ?>><?php echo ($option === "INSERTAR") ? '' : $data['descripcion_obligacion']; ?></textarea>
            </div>
            <div class="form-group">
                <label for="consecuencias">Consecuencias de incumplimiento:</label>
                <input type="text" class="form-control" id="consecuencias" <?php echo ($option === "INSERTAR") ? '' : 'readonly value="' . $data['consecuencias_incumplimiento'] . '"'; ?>>
            </div>
            <div class="form-group">
                <label for="periodicidad">Periodicidad:</label>
                <input type="text" class="form-control" id="periodicidad" <?php echo ($option === "INSERTAR") ? '' : 'readonly value="' . $data['periodicidad'] . '"'; ?>>
            </div>
            <div class="form-group">
                <label for="fechaCumplimiento">Fecha de cumplimiento: (Alerta: Envío de correo al responsable) </label>
                <input type="date" class="form-control" id="fechaCumplimiento" <?php echo ($option === "INSERTAR") ? '' : 'readonly value="' . $data['fecha_cumplimiento'] . '"'; ?>>
            </div>
            <div class="form-group">
                <label for="normaTipificadora">Norma tipificadora:</label>
                <input type="text" class="form-control" id="normaTipificadora" <?php echo ($option === "INSERTAR") ? '' : 'readonly value="' . $data['norma_tipificadora'] . '"'; ?>>
            </div>
            <div class="form-group">
                <label for="actividadesCumplimiento">Actividades para el cumplimiento:</label>
                <input type="text" class="form-control" id="actividadesCumplimiento" <?php echo ($option === "INSERTAR") ? '' : 'readonly value="' . $data['actividades_cumplimiento'] . '"'; ?>>
            </div>
            <div class="form-group">
                <label for="evidencia">Evidencia:</label>
                <input type="text" class="form-control" id="evidencia" <?php echo ($option === "INSERTAR") ? '' : 'readonly value="' . $data['evidencia'] . '"'; ?>>
            </div>

            <button type="button" class="btn btn-primary" id="sendDataButton"><?php echo $option?></button>
          </form>
      </div>
	<!-- Page Heading -->
	<div class="d-sm-flex align-items-center justify-content-between mb-4">
		<h1 class="h3 mb-0 text-gray-800">Obligaciones</h1>
		<a href="nueva_obligacion.php" class="btn btn-primary">Nuevo</a>
	</div>

	<div class="row">
		<div class="col-lg-12">
			<div class="table-responsive">
				<table class="table table-striped table-bordered" id="table">
					<thead class="thead-dark">
						<tr>
							<th>ID</th>
							<th>Aspecto Ambiental</th>
							<th>Fuente</th>
							<th>Norma de Aprobación</th>
							<th>Denominación</th>
							<th>Fecha de Publicación</th>
							<th>Artículo</th>
							<th>Descripción de la Obligación</th>
							<th>Consecuencias de Incumplimiento</th>
							<th>Periodicidad</th>
							<th>Fecha de Cumplimiento</th>
							<th>Norma Tipificadora</th>
							<th>Actividades de Cumplimiento</th>
							<th>Evidencia</th>
							<?php if ($_SESSION['rol'] == 1) { ?>
								<th>ACCIONES</th>
							<?php } ?>
						</tr>
					</thead>
					 
					<tbody>
						<?php
						include "../conexion.php";

						$query = mysqli_query($conexion, "SELECT * FROM obligacion");
						$result = mysqli_num_rows($query);
						if ($result > 0) {
							while ($data = mysqli_fetch_assoc($query)) { ?>
								<tr>
									<td><?php echo $data['id']; ?></td>
									<td><?php echo $data['aspecto_ambiental']; ?></td>
									<td><?php echo $data['fuente']; ?></td>
									<td><?php echo $data['norma_aprobacion']; ?></td>
									<td><?php echo $data['denominacion']; ?></td>
									<td><?php echo $data['fecha_publicacion']; ?></td>
									<td><?php echo $data['articulo']; ?></td>
									<td><?php echo $data['descripcion_obligacion']; ?></td>
									<td><?php echo $data['consecuencias_incumplimiento']; ?></td>
									<td><?php echo $data['periodicidad']; ?></td>
									<td><?php echo $data['fecha_cumplimiento']; ?></td>
									<td><?php echo $data['norma_tipificadora']; ?></td>
									<td><?php echo $data['actividades_cumplimiento']; ?></td>
									<td><?php echo $data['evidencia']; ?></td>
									<?php if ($_SESSION['rol'] == 1) { ?>
										<td>
											<a href="editar_obligacion.php?id=<?php echo $data['id']; ?>" class="btn btn-success"><i class='fas fa-edit'></i> Editar</a>
											<form action="eliminar_obligacion.php?id=<?php echo $data['id']; ?>" method="post" class="confirmar d-inline">
												<button class="btn btn-danger" type="submit"><i class='fas fa-trash-alt'></i> </button>
											</form>
										</td>
									<?php } ?>
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

<script>
  document.addEventListener('DOMContentLoaded', function() {
      // Función para desbloquear campos y cambiar el botón
      function desbloquearCampos() {
            var elementosInput = document.querySelectorAll('input');
            var elementoTextarea = document.getElementById('descripcion');
            elementosInput.forEach(function(elemento) {
                elemento.removeAttribute('readonly');
            });
            elementoTextarea.removeAttribute('readonly');

            // Cambiar el icono y el texto del botón
            var botonDesbloquear = document.getElementById('desbloquearCampos');
            botonDesbloquear.classList.remove('btn-success');
            botonDesbloquear.classList.add('btn-danger');
            botonDesbloquear.innerHTML = '<i class="fas fa-ban"></i>  ';

            // Agregar un evento de clic al botón para bloquear los campos nuevamente
            botonDesbloquear.removeEventListener('click', desbloquearCampos);
            botonDesbloquear.addEventListener('click', bloquearCampos);
        }

        // Función para bloquear campos y restaurar el botón
        function bloquearCampos() {
            var elementosInput = document.querySelectorAll('input');
            var elementoTextarea = document.getElementById('descripcion');
            elementosInput.forEach(function(elemento) {
                elemento.setAttribute('readonly', 'readonly');
            });
            elementoTextarea.setAttribute('readonly', 'readonly');

            // Cambiar el icono y el texto del botón
            var botonBloquear = document.getElementById('desbloquearCampos');
            botonBloquear.classList.remove('btn-danger');
            botonBloquear.classList.add('btn-success');
            botonBloquear.innerHTML = '<i class="far fa-eye"></i> ';

            // Agregar un evento de clic al botón para desbloquear los campos nuevamente
            botonBloquear.removeEventListener('click', bloquearCampos);
            botonBloquear.addEventListener('click', desbloquearCampos);
        }

        // Agregar un evento de clic al botón para desbloquear los campos
        var botonDesbloquear = document.getElementById('desbloquearCampos');
        botonDesbloquear.addEventListener('click', desbloquearCampos);
});

   
        
        $(document).ready(function() {
          // Capture the click event of the button
          $("#sendDataButton").click(function() {
              // Get the values from the form fields
              var id = $("#id").val();
              var codigo = $("#codigo").val();
              var aspecto = $("#aspecto").val();
              var fuente = $("#fuente").val();
              var norma = $("#norma").val();
              var denominacion = $("#denominacion").val();
              var fecha = $("#fecha").val();
              var codigoNorma = $("#codigoNorma").val();
              var ruta = $("#ruta").val();
              var articulo = $("#articulo").val();
              var descripcion = $("#descripcion").val();
              var consecuencias = $("#consecuencias").val();
              var periodicidad = $("#periodicidad").val();
              var fechaCumplimiento = $("#fechaCumplimiento").val();
              var normaTipificadora = $("#normaTipificadora").val();
              var actividadesCumplimiento = $("#actividadesCumplimiento").val();
              var evidencia = $("#evidencia").val();
              var option = "<?php echo $option?>";
              if(option == "INSERTAR"){
                                // Array para almacenar mensajes de error
                    var errores = [];

                // Validar cada campo
                if (aspecto.trim() === '') {
                    errores.push('El campo "Aspecto Ambiental" es requerido.');
                }

                if (fuente.trim() === '') {
                    errores.push('El campo "Fuente" es requerido.');
                }

                if (norma.trim() === '') {
                    errores.push('El campo "Norma de Aprobación" es requerido.');
                }

                if (denominacion.trim() === '') {
                    errores.push('El campo "Denominación" es requerido.');
                }

                if (fecha.trim() === '') {
                    errores.push('El campo "Fecha de Publicación" es requerido.');
                }
 
                if (ruta.trim() === '') {
                    errores.push('El campo "Ruta" es requerido.');
                }

                if (articulo.trim() === '') {
                    errores.push('El campo "Artículo" es requerido.');
                }

                if (descripcion.trim() === '') {
                    errores.push('El campo "Descripción de la obligación" es requerido.');
                }

                if (consecuencias.trim() === '') {
                    errores.push('El campo "Consecuencias de incumplimiento" es requerido.');
                }

                if (periodicidad.trim() === '') {
                    errores.push('El campo "Periodicidad" es requerido.');
                }

                if (fechaCumplimiento.trim() === '') {
                    errores.push('El campo "Fecha de cumplimiento" es requerido.');
                }

                if (normaTipificadora.trim() === '') {
                    errores.push('El campo "Norma tipificadora" es requerido.');
                }

                if (actividadesCumplimiento.trim() === '') {
                    errores.push('El campo "Actividades para el cumplimiento" es requerido.');
                }

                if (evidencia.trim() === '') {
                    errores.push('El campo "Evidencia" es requerido.');
                }

                // Mostrar mensajes de error si existen
                if (errores.length > 0) {
                    var mensaje = errores.join('\n');
                    Swal.fire({
                        icon: 'error',
                        title: 'Error de validación',
                        text: mensaje
                    });
                    return false; // Devuelve falso para indicar que la validación ha fallado
                }
              }

              // Create an object with the data
              var data = {
                  id: id,
                  codigo: codigo,
                  aspecto: aspecto,
                  fuente: fuente,
                  norma: norma,
                  denominacion: denominacion,
                  fecha: fecha,
                  codigoNorma: codigoNorma,
                  ruta: ruta,
                  articulo: articulo,
                  descripcion: descripcion,
                  consecuencias: consecuencias,
                  periodicidad: periodicidad,
                  fechaCumplimiento: fechaCumplimiento,
                  normaTipificadora: normaTipificadora,
                  actividadesCumplimiento: actividadesCumplimiento,
                  evidencia: evidencia
              };
              
              var url = option === "INSERTAR" ? "query/hola.php" : "query/actualizar_obligacion.php";
              // Send the data to hola.php using AJAX
              $.ajax({
                  type: "POST",
                  url: url,
                  data: data,
                  success: function(response) {
                      // Handle the response from hola.php (if needed)
                      $('#resultContact').html(response);
                      console.log(response);
                      setTimeout(function() {
                        location.reload();
                      }, 2000);
              
                  },
                  error: function(error) {
                      // Handle any errors (if needed)
                      console.error(error);
                  }
              });
          });
      });

      //Se ejecutara ni bien se recarge la página
      document.addEventListener("DOMContentLoaded", function () {
        consultarAPI();
      });
      document.getElementById('buscador').addEventListener('input', function() {
          var texto = this.value.toLowerCase();
          var cards = document.getElementsByClassName('custom-card');

          for (var i = 0; i < cards.length; i++) {
              var titulo = cards[i].getElementsByClassName('Sumilla')[0].innerText.toLowerCase();
              if (titulo.includes(texto)) {
                  cards[i].style.display = 'block';
              } else {
                  cards[i].style.display = 'none';
              }
          }
      });

      function consultarAPI() {
        const url = "https://spijwsii.minjus.gob.pe/spij-ext-solr/api/buscar";
        const token =
          "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzcGlqZXh0IiwidGlwbyI6IjEiLCJleHAiOjE2OTYxOTA4NzIsImlhdCI6MTY5NjEwNDQ3Mn0.WIw0j7EJFVXBoxVz8AnHPQgoS39rBI_Lo1r9yyLAxes";
        const valorInput = document.getElementById("textoBusqueda").value;
        const textBusqueda = valorInput ? valorInput : null;
        const body = JSON.stringify({
          filtros: {
            buscarHistorico: false,
            busquedaSugerida: false,
            numeroDispositivoLegal: " ",
            dispositivoLegal: [
              "ACUERDO",
              "ANEXO",
              "DECRETO DE ALCALDIA",
              "DECRETO REGIONAL",
              "DECRETOS VARIOS",
              "RESOLUCION VARIAS",
              "RESOLUCION JEFATURAL",
              "RESOLUCION EJECUTIVA",
              "RESOLUCION DIRECTORAL",
              "RESOLUCION DE ALCALDIA",
              "RESOLUCION ADMINISTRATIVA",
              "ORDENANZA",
              "FE DE ERRATAS",
              "EDICTO",
              "DIRECTIVA",
            ],
            tomo: {
              id: "",
              nombre: "",
            },
            materia: {
              id: "",
              nombre: "",
            },
            agrupacion: [
              "LEGISLACIÓN EMITIDA POR GOBIERNOS LOCALES Y REGIONALES",
            ],
            sector: [],
            subSector: {
              id: "",
              nombre: "",
            },
            orden: "1",
          },
          facetsSeleccionadas: {
            fechaPublicacionGap: {
              numero: 10,
              unidad: "YEAR",
            },
          },
          tipoNorma: "NR",
          textoBusqueda: textBusqueda,
          textoSumilla: null,
          desde: 1,
          hasta: 50,
        });

        fetch(url, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
          body: body,
        })
          .then((response) => response.json())
          .then((data) => {
            const resultados = data.resultados;
            const resultadosContainer = document.getElementById("resultados");

            resultadosContainer.innerHTML = "";

      
            resultados.forEach((resultado) => {
                const row = document.createElement("tr");

                const aspectoAmbiental = document.createElement("td");
                aspectoAmbiental.textContent = resultado.sumilla;
                row.appendChild(aspectoAmbiental);

                const fuente = document.createElement("td");
                fuente.textContent = "";
                row.appendChild(fuente);

                const normaAprobacion = document.createElement("td");
                normaAprobacion.textContent = resultado.dispositivoLegal;
                row.appendChild(normaAprobacion);

                const denominacion = document.createElement("td");
                denominacion.textContent = resultado.sector;
                row.appendChild(denominacion);

                const fechaPublicacion = document.createElement("td");
                fechaPublicacion.textContent = resultado.fechaPublicacion;
                row.appendChild(fechaPublicacion);

                const codigoNorma = document.createElement("td");
                codigoNorma.textContent = resultado.codigoNorma;
                row.appendChild(codigoNorma);

                const ruta = document.createElement("td");
                ruta.textContent = resultado.ruta;
                row.appendChild(ruta);

                const link = document.createElement("td");
                link.innerHTML = `<a href="https://spij.minjus.gob.pe/spij-ext-web/#/detallenorma/${resultado.id}" class="btn btn-primary">Link</a>`;
                row.appendChild(link);

                const ver = document.createElement("td");
                ver.innerHTML = `<a href="documento.php?id=${resultado.id}" class="btn btn-secondary">Ver</a>`;
                row.appendChild(ver);

                document.getElementById("resultados").appendChild(row);
            });

            
          })
          .catch((error) => {
              console.error("Error:", error);
              const resultadosContainer = document.getElementById("resultados");
              resultadosContainer.innerHTML = "<p>No se encontraron resultados</p>";
          });
      }
      document
        .getElementById("actualizar")
        .addEventListener("click", function (e) {
          e.preventDefault();
          consultarAPI();
        });

    
    </script>
</div>
<!-- End of Main Content -->

<?php include_once "includes/footer.php"; ?>
