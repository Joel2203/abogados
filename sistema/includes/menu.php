<!-- Font Awesome CSS -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css" integrity="sha384-lY4TJ0vMLKk2E6k1IcgYyzg6fNfn6Z7oJyy0+qd7eSpoN+jnOu+Mz3f2f6kmVk/5" crossorigin="anonymous">

<!-- Bootstrap JS and Popper.js -->
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.1/dist/umd/popper.min.js" integrity="sha384-gg2XXP4oYFUbTOKwJ2T5v2gFgTcZMJ2EVgM/pHHa6R6cp5FO9DtrLdWJGKPMtza" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>


<!-- Sidebar -->
<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

	<!-- Sidebar - Brand -->
	<a class="sidebar-brand d-flex align-items-center justify-content-center" href="index.php">
		<div class="sidebar-brand-icon rotate-n-0">
			<img src="img/logo.jpg" class="img-thumbnail" style="width: 70px; height: 70px;">
		</div>
		<div class="sidebar-brand-text mx-3">SZA</div>
	</a>

	<!-- Divider -->
	<hr class="sidebar-divider my-0">

	<!-- Divider -->
	<hr class="sidebar-divider">

	<!-- Heading -->
	<div class="sidebar-heading">
		Interface
	</div>

	<!-- Nav Item - Pages Collapse Menu -->

	<li class="nav-item">
		<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseObligaciones" aria-expanded="true" aria-controls="collapseObligaciones">
			<svg class="svg-inline--fa fa-file fa-w-12" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="file" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512" data-fa-i2svg="">
				<path fill="currentColor" d="M312 0H64C28.6 0 0 28.6 0 64v384c0 35.4 28.6 64 64 64h256c35.4 0 64-28.6 64-64V64c0-35.4-28.6-64-64-64zM144 96h96c8.8 0 16 7.2 16 16s-7.2 16-16 16h-96c-8.8 0-16-7.2-16-16s7.2-16 16-16zm144 304H96c-8.8 0-16-7.2-16-16s7.2-16 16-16h192c8.8 0 16 7.2 16 16s-7.2 16-16 16zm0-80H96c-8.8 0-16-7.2-16-16s7.2-16 16-16h192c8.8 0-16-7.2-16-16s7.2-16 16-16zm0-80H96c-8.8 0-16-7.2-16-16s7.2-16 16-16h192c8.8 0 16 7.2 16 16s-7.2-16 16-16z"></path>
			</svg>
			<span>Obligaciones</span>
		</a>
		<div id="collapseObligaciones" class="collapse" aria-labelledby="headingObligaciones" data-parent="#accordionSidebar">
			<div class="bg-white py-2 collapse-inner rounded">
				<a class="collapse-item" href="loquequiereelcliente.php">Obligaciones</a>
			</div>
		</div>
	</li>

	<li class="nav-item">
		<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseNormas" aria-expanded="true" aria-controls="collapseNormas">
			<svg class="svg-inline--fa fa-file fa-w-12" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="file" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512" data-fa-i2svg="">
				<path fill="currentColor" d="M312 0H64C28.6 0 0 28.6 0 64v384c0 35.4 28.6 64 64 64h256c35.4 0 64-28.6 64-64V64c0-35.4-28.6-64-64-64zM144 96h96c8.8 0 16 7.2 16 16s-7.2 16-16 16h-96c-8.8 0-16-7.2-16-16s7.2-16 16-16zm144 304H96c-8.8 0-16-7.2-16-16s7.2-16 16-16h192c8.8 0 16 7.2 16 16s-7.2 16-16 16zm0-80H96c-8.8 0-16-7.2-16-16s7.2-16 16-16h192c8.8 0-16-7.2-16-16s7.2-16 16-16zm0-80H96c-8.8 0-16-7.2-16-16s7.2-16 16-16h192c8.8 0 16 7.2 16 16s-7.2-16 16-16z"></path>
			</svg>
			<span>Normas y Sumillas</span>
		</a>
		<div id="collapseNormas" class="collapse" aria-labelledby="headingNormas" data-parent="#accordionSidebar">
			<div class="bg-white py-2 collapse-inner rounded">
				<a class="collapse-item" href="normas.php">Normas y Obligaciones</a>
			</div>
		</div>
	</li>

	<li class="nav-item">
		<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseNormas1" aria-expanded="true" aria-controls="collapseNormas1">

		<i class="fas fa-font"></i>
			<span>Datos de dashboard</span>
		</a>
		<div id="collapseNormas1" class="collapse" aria-labelledby="headingNormas" data-parent="#accordionSidebar">
			<div class="bg-white py-2 collapse-inner rounded">
			<?php if ($_SESSION['rol'] == 1) { ?>
				<a class="collapse-item" href="lista_data.php">Obligaciones</a>
			<?php  ?>	
				<a class="collapse-item" href="dashboard.php">Dashboard</a>
			<?php } ?>	
			<a class="collapse-item" href="calendar.php">Calendario</a>
			</div>
		</div>
	</li>
 
 
	<?php if ($_SESSION['rol'] == 1) { ?>
		<!-- Nav Item - Usuarios Collapse Menu -->
		<li class="nav-item">
			<a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUsuarios" aria-expanded="true" aria-controls="collapseUtilities">
				<i class="fas fa-user"></i>
				<span>Usuarios</span>
			</a>
			<div id="collapseUsuarios" class="collapse" aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
				<div class="bg-white py-2 collapse-inner rounded">
					<a class="collapse-item" href="registro_usuario.php">Nuevo Usuario</a>
					<a class="collapse-item" href="lista_usuarios.php">Usuarios</a>
				</div>
			</div>
		</li>
	<?php } ?>

</ul>