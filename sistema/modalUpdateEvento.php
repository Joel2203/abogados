<?php require "../conexion.php"; ?>

<link rel="stylesheet" type="text/css" href="./css/opciones.css">

<div class="modal" id="modalUpdateEvento"  tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <?php $message = '';
         if ($_SESSION['rol'] == 1) {  
          $message = 'Actualizar';
         }else{
          $message = 'Ver';
         }
        ?>
        <h5 class="modal-title"><?php echo $message ?> mi Evento</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
  <form name="formEventoUpdate" id="formEventoUpdate"  class="form-horizontal" >
    <input type="hidden" class="form-control" name="idEvento" id="idEvento">
    <div class="form-group">
      <label for="evento" class="col-sm-12 control-label">Nombre del Evento</label>
      <div class="col-sm-10">
        <input type="text" class="form-control" name="evento" id="evento" placeholder="Nombre del Evento" required/>
      </div>
    </div>  
    <div class="form-group">
			<label for="evento" class="col-sm-12 control-label">Descripcion</label>
			<div class="col-sm-10">
				<input type="text" class="form-control" name="descripcion" id="descripcion" placeholder="Descripcion" required/>
			</div>
		</div>
    <div class="form-group">
      <label for="fecha_inicio" class="col-sm-12 control-label">Fecha Inicio</label>
      <div class="col-sm-10">
        <input type="text" class="form-control" name="fecha_inicio" id="fecha_inicio" placeholder="Fecha Inicio">
      </div>
    </div>
    <div class="form-group">
      <label for="fecha_fin" class="col-sm-12 control-label">Fecha Final</label>
      <div class="col-sm-10">
        <input type="text" class="form-control" name="fecha_fin" id="fecha_fin" placeholder="Fecha Final">
      </div>
    </div>

    <div class="form-group">
    <label for="fusuario" class="col-sm-12 control-label">Usuario</label>
    <?php
    $query_proveedor = mysqli_query($conexion, "SELECT * FROM usuario ORDER BY idusuario ASC");
    $resultado_proveedor = mysqli_num_rows($query_proveedor);
    ?>
    <div class="col-sm-10">
        <select id="usuario" name="asignado" class="c  form-control">
            <?php
            if ($resultado_proveedor > 0) {
                while ($proveedor = mysqli_fetch_array($query_proveedor)) {
            ?>
                    <option value="<?php echo $proveedor['idusuario']; ?>" selected><?php echo $proveedor['usuario']; ?></option>
            <?php
                }
            }
            mysqli_close($conexion);
            ?>
        </select>
        </div>
    </div>

 <style>
  /* Estilo para ocultar los radio buttons */
input[type="radio"] {
  display: none;
}

/* Estilo para personalizar la apariencia de la etiqueta y el radio button simulado */
label.circu {
  display: inline-block;
  margin-right: 10px;
  position: relative;
  cursor: pointer;
}

label.circu:before {
  content: "";
  display: inline-block;
  width: 20px; /* Tamaño del radio button simulado */
  height: 20px;
  border: 2px solid #ccc; /* Borde del radio button simulado */
  border-radius: 50%; /* Hacer el radio button simulado circular */
  margin-right: 5px;
  vertical-align: middle;
}

/* Estilo para cambiar el fondo del radio button simulado cuando está seleccionado */
input[type="radio"]:checked + label.circu:before {
  background-color: #fd0000; /* Cambia el color según el valor del radio button */
  border-color: #fd0000; /* Cambia el color del borde cuando está seleccionado */
}

/* Estilo para el texto de la etiqueta */
label.circu span {
  vertical-align: middle;
}

/* Estilo adicional para resaltar el texto cuando está seleccionado */
input[type="radio"]:checked + label.circu span {
  font-weight: bold;
}

 </style>

<div class="col-md-12" id="grupoRadio">
  
  <input type="radio" name="color_evento" id="orange" value="#fd0000" checked>
  <label for="orange" class="circu" style="background-color: #fd0000; font-size: 14px; color: black;">Urgente</label>

  <input type="radio" name="color_evento" id="amber" value="#FFC107">
  <label for="amber" class="circu" style="background-color: #FFC107; font-size: 14px; color: black;">Necesario</label>

  <input type="radio" name="color_evento" id="lime" value="#2196F3">
  <label for="lime" class="circu" style="background-color: #2196F3; font-size: 14px; color: black;">Pendiente</label>

</div>


    
     <div class="modal-footer">
     <?php if ($_SESSION['rol'] == 1) { ?>
     <button type="button" class="btn btn-success" id="guardarCambios">Guardar Cambios de mi Evento</button>
     <?php } ?>
                    <button type="button" onclick="marcarComoTerminado()">Terminado</button>

                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Salir</button>
      </div>
      <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

      <script>
    function marcarComoTerminado() {
        const descripcion = $('#descripcion').val();
        const idEvento = $('#idEvento').val();

        // Crear un objeto FormData
        const formData = new FormData();
        formData.append('descripcion', descripcion);
        formData.append('idEvento', idEvento);

        // Realizar la solicitud AJAX con jQuery
        $.ajax({
            url: 'query/terminado.php',
            method: 'POST',
            processData: false,  // No procesar los datos
            contentType: false,  // No establecer el tipo de contenido
            data: formData,
            success: function(data) {
                // Utilizar SweetAlert2 en lugar de la alerta estándar
                Swal.fire({
                    icon: 'success',
                    title: '¡Actividad marcada como terminada!',
                    showConfirmButton: false,
                    timer: 1500
                });
            },
            error: function(error) {
                console.error('Error:', error);
                // Mostrar un mensaje de error con SweetAlert2
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Hubo un error al marcar la actividad como terminada.',
                });
            }
        });

        return false; // Evitar la recarga de la página
    }
</script>

  </form>

  <script src="./js/opciones.js"></script>

  <script type="text/javascript"
  src="https://cdn.jsdelivr.net/npm/@emailjs/browser@4/dist/email.min.js"></script>

  <script type="text/javascript">
  emailjs.init('QuHI0lBxcZ-Er-i1A')
  </script>

<script>
                $(document).ready(function () {
                    // Asociar el evento de clic al botón "Guardar Cambios"
                    $("#guardarCambios").click(function () {
                        // Recoger los datos del formulario
                        var formData = $("#formEventoUpdate").serialize();

                        // Hacer la petición Ajax
                        $.ajax({
                            type: "POST",
                            url: "./UpdateEvento.php",
                            data: formData,
                            success: function (response) {
                                // Manejar la respuesta si es necesario
                                console.log(response);
                                  // Mostrar SweetAlert de éxito
                                 
                                  enviarCorreo(formData,response);
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Actualizado exitosamente',
                                    showConfirmButton: false,
                                    timer: 2000  // 3 segundos
                                }).then(function () {
                                   
                                    //location.reload();
                                });
                            },
                            error: function (error) {
                                // Manejar el error si es necesario
                                console.error(error);
                            }
                        });
                    });
                });

                  // Función para enviar el correo a través de Email.js
                function enviarCorreo(formData,correo1) {
                    // Inicializar Email.js con tu ID de usuario
                    emailjs.init('QuHI0lBxcZ-Er-i1A');

                    // Extraer datos del formulario
                    var datosFormulario = formData.split('&');
                    var evento = datosFormulario.find(item => item.includes('evento=')).split('=')[1];
                    var descripcion = datosFormulario.find(item => item.includes('descripcion=')).split('=')[1];
                    var fechaInicio = datosFormulario.find(item => item.includes('fecha_inicio=')).split('=')[1];
                    var fechaFin = datosFormulario.find(item => item.includes('fecha_fin=')).split('=')[1];
                    var correo = correo1;

                    console.log("Evento:", evento);
                    console.log("Descripción:", descripcion);
                    console.log("Fecha de inicio:", fechaInicio);
                    console.log("Fecha de fin:", fechaFin);
                    console.log("Correo:", correo);
                    // Utilizar expresión regular para quitar \r y \n
                   var correoSinCaracteres = correo.replace(/[\r\n]/g, '');



                    // Enviar el correo con los datos proporcionados
                    emailjs.send("service_z66iuap","template_9twwcid",{
                        to_descripcion: descripcion,
                        from_fecha_inicio: fechaInicio,
                        from_fecha_fin: fechaFin,
                        from_evento: evento,
                        reply_to: "elprocrakxd123@gmail.com",
                        from_correo: correoSinCaracteres,
                    });
                    console.log('SI FUNCIONA');
                }
            </script>
      
    </div>
  </div>
</div>