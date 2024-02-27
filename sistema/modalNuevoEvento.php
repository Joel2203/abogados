<?php require "../conexion.php"; ?>

<div class="modal" id="exampleModal"  tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Registrar Nuevo Evento</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
  <form name="formEvento" id="formEvento" action="nuevoEvento.php" class="form-horizontal" method="POST"  enctype="multipart/form-data">
		<div class="form-group">
			<label for="evento" class="col-sm-12 control-label">Nombre del Evento</label>
			<div class="col-sm-10">
				<input type="text" class="form-control" name="evento" id="evento" placeholder="Nombre del Evento" required/>
			</div>
		</div>
    <div class="form-group">
			<label for="descripcion" class="col-sm-12 control-label">Descripcion</label>
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
      mysqli_close($conexion);
      ?>
      <div class="col-sm-10">
        <select id="usuario" name="usuario" class="c  form-control">
          <?php
          if ($resultado_proveedor > 0) {
            while ($proveedor = mysqli_fetch_array($query_proveedor)) {
          ?>
              <option value="<?php echo $proveedor['idusuario']; ?>" selected><?php echo $proveedor['usuario']; ?></option>
          <?php
            }
          }
          ?>
        </select>
        </div>
    </div>

    <style>
    
    .form-container {
      background-color: #fff;
      border-radius: 8px;
      padding: 20px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      width: 400px;
      text-align: center;
    }

    .file-input {
      margin-bottom: 20px;
    }

    .custom-file-input {
      color: transparent;
    }

    .custom-file-input::-webkit-file-upload-button {
      visibility: hidden;
    }

    .custom-file-input::before {
      content: 'Seleccionar archivo';
      color: #fff;
      background-color: #007bff;
      display: inline-block;
      border: 1px solid #007bff;
      border-radius: 5px;
      padding: 8px 12px;
      outline: none;
      white-space: nowrap;
      cursor: pointer;
    }

    .custom-file-input:hover::before {
      border-color: #0056b3;
    }

    .custom-file-input:active::before {
      background-color: #0056b3;
    }

    .file-upload-banner {
      display: none;
      background-color: #4CAF50;
      color: #fff;
      padding: 10px;
      border-radius: 4px;
      margin-top: 10px;
    }
  </style>

<h2 class="mb-4">Subir Archivos</h2>
  <div class="custom-file mb-3">
      <input type="file" class="custom-file-input" id="customFile" name="imagen[]" multiple accept="image/*">
      <label class="custom-file-label" for="customFile">Seleccionar Archivos</label>
  </div>
  <br>
 
  

  <div class="col-md-12" id="grupoRadio">
  
  <input type="radio" name="color_evento" id="orange" value="#fd0000" checked>
  <label for="orange" class="circu" style="background-color: #fd0000; font-size: 14px; color: black;">Urgente</label>

  <input type="radio" name="color_evento" id="amber" value="#FFC107">
  <label for="amber" class="circu" style="background-color: #FFC107; font-size: 14px; color: black;">Necesario</label>

  <input type="radio" name="color_evento" id="lime" value="#2196F3">
  <label for="lime" class="circu" style="background-color: #2196F3; font-size: 14px; color: black;">Pendiente</label>

</div>
		
	   <div class="modal-footer">
      	<button type="submit" id="guardarEventos" class="btn btn-success">Guardar Evento</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Salir</button>
    	</div>
	</form>

 
      
    </div>
  </div>
</div>