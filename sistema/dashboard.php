<?php include_once "includes/header.php"; ?>
<script src="https://cdn.jsdelivr.net/npm/echarts@5"></script>
<!-- Begin Page Content -->
<div class="container-fluid">

 

	<div class="row">

<!-- Megadiseño con círculo y porcentaje -->
<div class="col-xl-3 col-md-6 mb-4">
    <div class="card border-left-primary shadow h-100 py-2">
        <div class="card-body">
            <div class="row no-gutters align-items-center">
                <div class="col mr-2">
                    <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Obligaciones Totales</div>
                    <div class="h5 mb-0 font-weight-bold text-gray-800">
                        <?php echo $_SESSION['totalObligaciones']; ?>
                    </div>
                </div>
                <div class="col-auto">
                    <div class="circular-progress" data-percentage="75"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Earnings (Monthly) Card Example -->
<div class="col-xl-3 col-md-6 mb-4">
    <div class="card border-left-success shadow h-100 py-2">
        <div class="card-body">
            <div class="row no-gutters align-items-center">
                <div class="col mr-2">
                    <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Obligaciones Cumplidas</div>
                    <div class="h5 mb-0 font-weight-bold text-gray-800">
                        <?php echo $_SESSION['obligacionesCumplidas']; ?>
                    </div>
                </div>
                <div class="col-auto">
                    <div class="circular-progress" data-percentage="60"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Earnings (Monthly) Card Example -->
<div class="col-xl-3 col-md-6 mb-4">
    <div class="card border-left-warning shadow h-100 py-2">
        <div class="card-body">
            <div class="row no-gutters align-items-center">
                <div class="col mr-2">
                    <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Obligaciones Dentro del Plazo</div>
                    <div class="h5 mb-0 font-weight-bold text-gray-800">
                        <?php echo $_SESSION['obligacionesDentroPlazo']; ?>
                    </div>
                </div>
                <div class="col-auto">
                    <div class="circular-progress" data-percentage="80"></div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Earnings (Monthly) Card Example -->
<div class="col-xl-3 col-md-6 mb-4">
    <div class="card border-left-danger shadow h-100 py-2">
        <div class="card-body">
            <div class="row no-gutters align-items-center">
                <div class="col mr-2">
                    <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Obligaciones Fuera de Plazo</div>
                    <div class="h5 mb-0 font-weight-bold text-gray-800">
                        <?php echo $_SESSION['obligacionesFueraPlazo']; ?>
                    </div>
                </div>
                <div class="col-auto">
                    <div class="circular-progress" data-percentage="40"></div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Earnings (Monthly) Card Example -->
<div class="col-xl-3 col-md-6 mb-4">
    <div class="card border-left-danger shadow h-100 py-2">
        <div class="card-body">
            <div class="row no-gutters align-items-center">
                <div class="col mr-2">
                    <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Obligaciones Incumplidas</div>
                    <div class="h5 mb-0 font-weight-bold text-gray-800">
                        <?php echo $_SESSION['obligacionesIncumplidas']; ?>
                    </div>
                </div>
                <div class="col-auto">
                    <div class="circular-progress" data-percentage="25"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Obtener todos los elementos con la clase 'circular-progress'
        const circularProgressElements = document.querySelectorAll('.circular-progress');

        // Iterar sobre cada elemento y establecer el porcentaje
        circularProgressElements.forEach(function (element) {
            const percentage = parseInt(element.dataset.percentage);
            const strokeWidth = 8;
            const radius = 40;
            const circumference = 2 * Math.PI * radius;

            const progress = percentage / 100;
            const dashoffset = circumference * (1 - progress);

            // Crear el círculo SVG
            const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
            svg.setAttribute('width', radius * 2);
            svg.setAttribute('height', radius * 2);

            // Crear el círculo de fondo
            const backgroundCircle = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
            backgroundCircle.setAttribute('cx', radius);
            backgroundCircle.setAttribute('cy', radius);
            backgroundCircle.setAttribute('r', radius - strokeWidth / 2);
            backgroundCircle.setAttribute('stroke', '#e0e0e0');
            backgroundCircle.setAttribute('stroke-width', strokeWidth);
            backgroundCircle.setAttribute('fill', 'none');
            svg.appendChild(backgroundCircle);

            // Crear el círculo de progreso
            const progressCircle = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
            progressCircle.setAttribute('cx', radius);
            progressCircle.setAttribute('cy', radius);
            progressCircle.setAttribute('r', radius - strokeWidth / 2);
            progressCircle.setAttribute('stroke', '#C01E1E');
            progressCircle.setAttribute('stroke-width', strokeWidth);
            progressCircle.setAttribute('fill', 'none');
            progressCircle.setAttribute('stroke-dasharray', circumference);
            progressCircle.setAttribute('stroke-dashoffset', dashoffset);
            svg.appendChild(progressCircle);

            // Añadir el SVG al elemento
            element.appendChild(svg);
        });
    });
</script>


		<!-- Earnings (Monthly) Card Example -->
		<a class="col-xl-3 col-md-6 mb-4" href="lista_usuarios.php">
			<div class="card border-left-primary shadow h-100 py-2">
				<div class="card-body">
					<div class="row no-gutters align-items-center">
						<div class="col mr-2">
							<div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Usuarios</div>
							<div class="h5 mb-0 font-weight-bold text-gray-800"><?php echo $_SESSION['usuarios']; ?></div>
						</div>
						<div class="col-auto">
							<svg class="svg-inline--fa fa-user fa-w-14 fa-2x text-gray-300" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="user" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg=""><path fill="currentColor" d="M224 256c70.7 0 128-57.3 128-128S294.7 0 224 0 96 57.3 96 128s57.3 128 128 128zm89.6 32h-16.7c-22.2 10.2-46.9 16-72.9 16s-50.6-5.8-72.9-16h-16.7C60.2 288 0 348.2 0 422.4V464c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48v-41.6c0-74.2-60.2-134.4-134.4-134.4z"></path></svg><!-- <i class="fas fa-user fa-2x text-gray-300"></i> -->
						</div>
					</div>
				</div>
			</div>
		</a>
 
	</div>

	<div class="container-fluid">
        <div class="row">
            <div class="col-md-6">
		    	<div id="myEChart" style="width: 100%; height: 600px;"></div>
            </div>
            <div class="col-md-6">
                <canvas id="chartAreaEstado" width="200" height="200"></canvas>
            </div>
        </div>
    </div>

	<?php
	include "../conexion.php";

	// Ejecutar la consulta
	$query = "SELECT Tema, COUNT(*) as Cantidad FROM `datos` GROUP BY Tema;";
	$result = mysqli_query($conexion, $query);

	// Almacenar los resultados en un array en PHP
	$data = array();
	while ($row = mysqli_fetch_assoc($result)) {
		$data[] = $row;
	}

	// Convertir los resultados en un formato que pueda ser utilizado por Chart.js
	$labels = array();
	$values = array();

	foreach ($data as $row) {
		$labels[] = $row['Tema'];
		$values[] = $row['Cantidad'];
	}

	
	?>

	<script>
 // Datos del gráfico
 var labels = <?php echo json_encode($labels); ?>;
  var data = <?php echo json_encode($values); ?>;

  // Crear el gráfico con ECharts
  var myEChart = echarts.init(document.getElementById('myEChart'), 'dark'); // Puedes cambiar 'dark' por 'light' según tu preferencia de tema.

  // Configuración del gráfico tipo "pie" con los colores especificados
  var option = {
    backgroundColor: '#f8f9fc',
    title: {
      text: 'Cantidad',
      left: 'center',
      top: 20,
      textStyle: {
        color: '#C01E1E'
      }
    },
    series: [{
      name: 'Cantidad',
      type: 'pie',
      radius: '55%',
      center: ['50%', '50%'],
      data: labels.map(function (label, index) {
        return {
          value: data[index],
          name: label
        };
      }),
      roseType: 'radius',
      label: {
		color: '#fffff',
      },
      labelLine: {
        lineStyle: {
          color: '#fffff',
        },
        smooth: 0.2,
        length: 10,
        length2: 20
      },
      itemStyle: {
        color: '#c23531', // Color de las partes del gráfico
        shadowBlur: 200,
        shadowColor: 'rgba(0, 0, 0, 0.5)'
      },
      animationType: 'scale',
      animationEasing: 'elasticOut',
      animationDelay: function (idx) {
        return Math.random() * 200;
      },
	  emphasis: {
        label: {
          show: true,
          formatter: '{b}: {c} ({d}%)' // Muestra el nombre, la cantidad y el porcentaje al pasar el mouse
        }
      }
    }]
  };

  // Configurar el gráfico con la opción definida
  myEChart.setOption(option);

  // Hacer el gráfico responsive al cambiar el tamaño de la ventana
  window.addEventListener('resize', function () {
    myEChart.resize();
  });
	</script>

	<?php
	// Consulta para el conteo de combinaciones de Area_Responsable y Estado_de_Verificacion
	$queryAreaEstado = "SELECT Area_Responsable, Estado_de_Verificacion, COUNT(*) as Cantidad FROM datos GROUP BY Area_Responsable, Estado_de_Verificacion";
	$resultAreaEstado = mysqli_query($conexion, $queryAreaEstado);

	$dataAreaEstado = array();
	while ($rowAreaEstado = mysqli_fetch_assoc($resultAreaEstado)) {
		$dataAreaEstado[] = $rowAreaEstado;
	}

	$labelsAreaEstado = array();
	$datasetAreaEstado = array();

	foreach ($dataAreaEstado as $rowAreaEstado) {
		$labelsAreaEstado[] = $rowAreaEstado['Area_Responsable'] . ' - ' . $rowAreaEstado['Estado_de_Verificacion'];
		$datasetAreaEstado[] = $rowAreaEstado['Cantidad'];
	}
	?>

	<script>
	// Datos del segundo gráfico (Area_Responsable y Estado_de_Verificacion)
	var labelsAreaEstado = <?php echo json_encode($labelsAreaEstado); ?>;
	var dataAreaEstado = <?php echo json_encode($datasetAreaEstado); ?>;

	// Crear el segundo gráfico con Chart.js
	var ctxAreaEstado = document.getElementById('chartAreaEstado').getContext('2d');
	var chartAreaEstado = new Chart(ctxAreaEstado, {
	type: 'bar',
	data: {
		labels: labelsAreaEstado,
		datasets: [{
		label: 'Cantidad',
		data: dataAreaEstado,
		backgroundColor: 'rgba(255, 0, 0, 0.7)', // Rojo con opacidad
		borderColor: 'rgba(255, 0, 0, 1)', // Rojo sin opacidad
		borderWidth: 1
		}] 
	},
	options: {
		scales: {
		y: {
			beginAtZero: true
		}
		},
		plugins: {
		legend: {
			display: false // Oculta la leyenda si no es necesaria
		}
		}
	}
	});
	</script>
	 
	<!-- Page Heading -->
	<div class="d-sm-flex align-items-center justify-content-between mb-4">
		<h1 class="h3 mb-0 text-gray-800">Configuración</h1>
	</div>
	<div class="row">
		<div class="col-lg-6">
			<div class="card">
				<div class="card-header bg-primary text-white">
					Información Personal
				</div>
				<div class="card-body">
					<div class="form-group">
						<label>Nombre: <strong><?php echo $_SESSION['nombre']; ?></strong></label>
					</div>
					<div class="form-group">
						<label>Correo: <strong><?php echo $_SESSION['email']; ?></strong></label>
					</div>
					<div class="form-group">
						<label>Rol: <strong><?php echo $_SESSION['rol_name']; ?></strong></label>
					</div>
					<div class="form-group">
						<label>Usuario: <strong><?php echo $_SESSION['user']; ?></strong></label>
					</div>
					<ul class="list-group">
						<li class="list-group-item active">Cambiar Contraseña</li>
						<form action="" method=" post" name="frmChangePass" id="frmChangePass" class="p-3">
							<div class="form-group">
								<label>Contraseña Actual</label>
								<input type="password" name="actual" id="actual" placeholder="Clave Actual" required class="form-control">
							</div>
							<div class="form-group">
								<label>Nueva Contraseña</label>
								<input type="password" name="nueva" id="nueva" placeholder="Nueva Clave" required class="form-control">
							</div>
							<div class="form-group">
								<label>Confirmar Contraseña</label>
								<input type="password" name="confirmar" id="confirmar" placeholder="Confirmar clave" required class="form-control">
							</div>
							<div class="alertChangePass" style="display:none;">
							</div>
							<div>
								<button type="submit" class="btn btn-primary btnChangePass">Cambiar Contraseña</button>
							</div>
						</form>
					</ul>
				</div>
			</div>
		</div>
		<?php if ($_SESSION['rol'] == 1) { ?>
			<div class="col-lg-6">
				<div class="card">
					<div class="card-header bg-primary text-white">
						Datos de la Empresa
					</div>
					<div class="card-body">
						<form action="empresa.php" method="post" id="frmEmpresa" class="p-3">
							<div class="form-group">
								<label>Ruc:</label>
								<input type="number" name="txtDni" value="<?php echo $dni; ?>" id="txtDni" placeholder="Dni de la Empresa" required class="form-control">
							</div>
							<div class="form-group">
								<label>Nombre:</label>
								<input type="text" name="txtNombre" class="form-control" value="<?php echo $nombre_empresa; ?>" id="txtNombre" placeholder="Nombre de la Empresa" required class="form-control">
							</div>
							<div class="form-group">
								<label>Razon Social:</label>
								<input type="text" name="txtRSocial" class="form-control" value="<?php echo $razonSocial; ?>" id="txtRSocial" placeholder="Razon Social de la Empresa">
							</div>
							<div class="form-group">
								<label>Teléfono:</label>
								<input type="number" name="txtTelEmpresa" class="form-control" value="<?php echo $telEmpresa; ?>" id="txtTelEmpresa" placeholder="teléfono de la Empresa" required>
							</div>
							<div class="form-group">
								<label>Correo Electrónico:</label>
								<input type="email" name="txtEmailEmpresa" class="form-control" value="<?php echo $emailEmpresa; ?>" id="txtEmailEmpresa" placeholder="Correo de la Empresa" required>
							</div>
							<div class="form-group">
								<label>Dirección:</label>
								<input type="text" name="txtDirEmpresa" class="form-control" value="<?php echo $dirEmpresa; ?>" id="txtDirEmpresa" placeholder="Dirreción de la Empresa" required>
							</div>
							<div class="form-group">
								<label>IGV (%):</label>
								<input type="text" name="txtIgv" class="form-control" value="<?php echo $igv; ?>" id="txtIgv" placeholder="IGV de la Empresa" required>
							</div>
							<?php echo isset($alert) ? $alert : ''; ?>
							<div>
								<button type="submit" class="btn btn-primary btnChangePass"><i class="fas fa-save"></i> Guardar Datos</button>
							</div>

						</form>
					</div>
				</div>
			</div>
		<?php } else { ?>
			<div class="col-lg-6">
				<div class="card">
					<div class="card-header bg-primary text-white">
						Datos de la Empresa
					</div>
					<div class="card-body">
						<div class="p-3">
							<div class="form-group">
								<strong>Ruc:</strong>
								<h6><?php echo $dni; ?></h6>
							</div>
							<div class="form-group">
								<strong>Nombre:</strong>
								<h6><?php echo $nombre_empresa; ?></h6>
							</div>
							<div class="form-group">
								<strong>Razon Social:</strong>
								<h6><?php echo $razonSocial; ?></h6>
							</div>
							<div class="form-group">
								<strong>Teléfono:</strong>
								<?php echo $telEmpresa; ?>
							</div>
							<div class="form-group">
								<strong>Correo Electrónico:</strong>
								<h6><?php echo $emailEmpresa; ?></h6>
							</div>
							<div class="form-group">
								<strong>Dirección:</strong>
								<h6><?php echo $dirEmpresa; ?></h6>
							</div>
							<div class="form-group">
								<strong>IGV (%):</strong>
								<h6><?php echo $igv; ?></h6>
							</div>

						</div>
					</div>
				</div>
			</div>

		<?php } ?>
	</div>


</div>
<!-- /.container-fluid -->

</div>
<!-- End of Main Content -->


<?php include_once "includes/footer.php"; ?>