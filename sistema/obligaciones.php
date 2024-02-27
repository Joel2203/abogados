<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <!-- Estilos de Select2 -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />

<!-- Bootstrap CSS -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<!-- Incluir el CSS de Select2 en la sección <head> de tu HTML -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />

<!-- Incluir el JS de Select2 justo antes de cerrar tu </body> -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>
<link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet">

<!-- EXCEL  -->
<script src="https://unpkg.com/xlsx/dist/xlsx.full.min.js"></script>

</head>
<style>
  .pagination-container {
  text-align: center; /* Centers the pagination container's content */
}

.pagination {
  display: inline-block; /* Allows the pagination to be centered */
  margin: 0 auto; /* Additional centering for the pagination */
}

.page-item.disabled .page-link {
  color: #6c757d; /* Bootstrap default for disabled state */
  pointer-events: none; /* Prevent clicking on disabled items */
  background-color: #fff;
  border-color: #dee2e6;
}

.page-item.active .page-link {
  z-index: 3;
  color: #fff;
  background-color: #774642; /* Bootstrap primary color */
  border-color: #774642; /* Bootstrap primary color */
}

.page-link {
  position: relative;
  display: block;
  padding: 0.5rem 0.75rem; /* Bootstrap default padding for page-links */
  margin-left: -1px; /* Bootstrap default to align borders between page-links */
  line-height: 1.25;
  color: #774642; /* Bootstrap link color */
  background-color: #fff;
  border: 1px solid #dee2e6; /* Bootstrap default border-color */
}

.page-link:hover {
  color: #0056b3; /* Darken the color slightly on hover */
  text-decoration: none; /* No underline on hover */
  background-color: #e9ecef; /* Light background on hover */
  border-color: #dee2e6; /* Keep border color on hover */
}

/* For accessibility of the current page */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
}

   body {
      font-family: "Montserrat", sans-serif;
          
    }
    .container {
      margin-top: 50px;
    }
    .titulo {
      font-size: 18px;
      font-weight: bold;
    }
     
    .header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 10px 20px;
        background-color: #774642!important;
    }
    .header img {
        width: 175px;
        border-radius: 50%; /* Ajustar el tamaño de la imagen a 75px de ancho */
    }
    .pagination {
        margin-bottom: 0;
    }
    .custom-card {
            border: 3px solid #774642; /* Bordes 3D azules */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Sombra suave */
    }
    .custom-card {
            border-radius: 50px;
            border: 1px solid #ccc;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
    }

    .custom-card:hover {
        transform: scale(1.05);
    }
    .custom-input {
            border: 1px solid #ced4da; /* Color del borde */
            border-radius: 0.5rem; /* Bordes redondeados */
            box-shadow: 0 0 0.375rem rgba(0, 0, 0, 0.1); /* Sombra */
    }
    /* Reset de algunos estilos por defecto para asegurar coherencia entre navegadores */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

/* Estilo base del formulario */
form {
  max-width: 540px; /* Ancho máximo del formulario */
  margin: 2rem auto; /* Centrado con margen */
  padding: 2rem;
  background: #fff; /* Fondo blanco */
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); /* Sombra suave */
  border-radius: 10px; /* Bordes redondeados */
}

/* Estilos para controles de formulario */
.form-control, .form-select, .select2-container--default .select2-selection--multiple {
  display: block;
  width: 100%; /* Ancho completo */
  padding: 0.75rem;
  line-height: 1.25;
  color: #495057; /* Color del texto */
  background-color: #fff; /* Fondo blanco */
  background-clip: padding-box;
  border: 2px solid #ced4da; /* Borde sólido */
  border-radius: 0.25rem; /* Bordes redondeados */
  transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
  margin-bottom: 1rem; /* Espacio entre controles */
}

/* Estilo para el efecto 3D en los bordes */
.form-control:focus, .form-select:focus {
  border-color: #80bdff;
  outline: 0;
  box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
  position: relative;
  z-index: 1; /* Asegura que el input está sobre otros elementos */
}

/* Aplicar el efecto 3D también en la biblioteca Select2 */
.select2-container--default .select2-selection--multiple {
  border: 2px solid #ced4da;
}

.select2-container--default .select2-selection--multiple:focus {
  border-color: #80bdff;
}

/* Estilos para las etiquetas */
.form-label {
  display: block;
  margin-bottom: 0.5rem;
  color: #333;
  font-weight: bold; /* Texto en negrita */
}

/* Estilos para las columnas en responsive */
.row {
  display: flex;
  flex-wrap: wrap;
  margin-right: -15px;
  margin-left: -15px;
}

.col {
  padding-right: 15px;
  padding-left: 15px;
  flex: 1; /* Ocupan el espacio disponible */
}

/* Estilos para botones y elementos interactivos */
button, .btn {
  color: #fff;
  background-color: #774642;
  border-color: #774642;
  padding: 0.5rem 1rem;
  font-size: 1rem;
  line-height: 1.5;
  border-radius: 0.25rem;
  transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out;
}

button:hover, .btn:hover {
  color: #fff;
  background-color: #0069d9;
  border-color: #0062cc;
}

/* Responsive */
@media (max-width: 768px) {
  .col {
    flex-basis: 100%; /* Las columnas toman el ancho completo en dispositivos móviles */
    max-width: 100%;
  }
}

/* Animaciones y transiciones para el efecto 3D */
.form-control::placeholder {
  transition: opacity 0.25s ease-out;
}

.form-control:hover::placeholder {
  opacity: 0.5;
}

.sidebar {
    width: 300px;
    position: fixed;
    left: 0;
    top: 0;
    bottom: 0;
    background: #f1f1f1;
    overflow-x: hidden;
    transition: 0.5s;
    padding: 20px;
}

.toggle-btn {
    position: absolute;
    right: -30px;
    top: 20px;
    font-size: 20px;
    cursor: pointer;
    background: #555;
    color: white;
    border: none;
    border-radius: 5px;
    padding: 5px 10px;
}
.table-responsive {
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
}


.container {
  padding: 20px;
}

/* Estilos de la Tabla */
.table {
  width: 100%;
  margin-bottom: 1rem;
  color: #212529;
  border-collapse: collapse;
}

.table th,
.table td {
  padding: 0.75rem;
  vertical-align: top;
  border-top: 1px solid #dee2e6;
}

.table thead th {
  vertical-align: bottom;
  border-bottom: 2px solid #dee2e6;
  background-color: #774642;
  color: white;
  text-align: center;
}

.table tbody tr:nth-of-type(odd) {
  background-color: rgba(0, 0, 0, 0.05);
}

.table tbody tr:hover {
  background-color: #ddd;
}

.table td,
.table th {
  text-align: center;
}

/* Estilos para la Responsividad */
.table-responsive {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

@media (max-width: 768px) {
    .table-responsive {
        border: 0;
    }
}

</style>
<body>

<div id="sidebar" class="sidebar">
    <button onclick="toggleSidebar()" class="toggle-btn">Volver&#9776;</button>
    <form>
      <!-- Número de Norma -->
      <select class="form-control select2-multiple" multiple="multiple" id="entrada">
      <!-- Las opciones se generarán dinámicamente con JavaScript -->
    </select>

      <div class="mb-3">
        <label for="numeroNorma" class="form-label">Número de Norma</label>
        <input type="text" class="form-control" id="numeroNorma" placeholder="N° 338-MDL">
      </div>

      <!-- Ordenar por (Opcional) -->
      <div class="mb-3">
        <label for="ordenarPor" class="form-label">Ordenar por (Opcional):</label>
        <select class="form-select" id="ordenarPor">
          <option selected>Elige una opción</option>
          <option value="0">Más antiguo</option>
          <option value="1">Más reciente</option>
          <!-- Otras opciones... -->
        </select>
      </div>

      <!-- Desde - Hasta -->
      <div class="row">
        <div class="col">
          <label for="desde" class="form-label">Desde</label>
          <input type="date" class="form-control" id="desde">
        </div>
        <div class="col">
          <label for="hasta" class="form-label">Hasta</label>
          <input type="date" class="form-control" id="hasta">
        </div>
      </div>

      <!-- Contenido -->
      <div class="mb-3">
        <label for="contenido" class="form-label">Contenido</label>
        <input type="text" class="form-control" id="contenido" placeholder="Palabra o frase...">
      </div>

      <!-- Sumillas -->
      <div class="mb-3">
        <label for="sumillas" class="form-label">Sumillas</label>
        <textarea class="form-control" id="sumillas" placeholder="Introduzca su consulta..."></textarea>
      </div>

      <!-- Sector -->
      <div class="mb-3">
        <label for="sector" class="form-label">Sector</label>
        <select class="form-select" id="sector">
          <option value="" selected>Elige un sector</option>
          <option value="AUTORIDAD DEL PROYECTO COSTA VERDE">AUTORIDAD DEL PROYECTO COSTA VERDE</option>
            <option value="GOBIERNO REGIONAL DE AMAZONAS">GOBIERNO REGIONAL DE AMAZONAS</option>
            <option value="GOBIERNO REGIONAL DE ANCASH">GOBIERNO REGIONAL DE ANCASH</option>
            <option value="GOBIERNO REGIONAL DE APURIMAC">GOBIERNO REGIONAL DE APURIMAC</option>
            <option value="GOBIERNO REGIONAL DE AREQUIPA">GOBIERNO REGIONAL DE AREQUIPA</option>
            <option value="GOBIERNO REGIONAL DE AYACUCHO">GOBIERNO REGIONAL DE AYACUCHO</option>
            <option value="GOBIERNO REGIONAL DE CAJAMARCA">GOBIERNO REGIONAL DE CAJAMARCA</option>
            <option value="GOBIERNO REGIONAL DE HUANCAVELICA">GOBIERNO REGIONAL DE HUANCAVELICA</option>
            <option value="GOBIERNO REGIONAL DE HUANUCO">GOBIERNO REGIONAL DE HUANUCO</option>
            <option value="GOBIERNO REGIONAL DE ICA">GOBIERNO REGIONAL DE ICA</option>
            <option value="GOBIERNO REGIONAL DE JUNIN">GOBIERNO REGIONAL DE JUNIN</option>
            <option value="GOBIERNO REGIONAL DE LA LIBERTAD">GOBIERNO REGIONAL DE LA LIBERTAD</option>
            <option value="GOBIERNO REGIONAL DE LAMBAYEQUE">GOBIERNO REGIONAL DE LAMBAYEQUE</option>
            <option value="GOBIERNO REGIONAL DE LIMA">GOBIERNO REGIONAL DE LIMA</option>
            <option value="GOBIERNO REGIONAL DE LORETO">GOBIERNO REGIONAL DE LORETO</option>
            <option value="GOBIERNO REGIONAL DE MADRE DE DIOS">GOBIERNO REGIONAL DE MADRE DE DIOS</option>
            <option value="GOBIERNO REGIONAL DE MOQUEGUA">GOBIERNO REGIONAL DE MOQUEGUA</option>
            <option value="GOBIERNO REGIONAL DE PASCO">GOBIERNO REGIONAL DE PASCO</option>
            <option value="GOBIERNO REGIONAL DE PIURA">GOBIERNO REGIONAL DE PIURA</option>
            <option value="GOBIERNO REGIONAL DE PUNO">GOBIERNO REGIONAL DE PUNO</option>
            <option value="GOBIERNO REGIONAL DE SAN MARTIN">GOBIERNO REGIONAL DE SAN MARTIN</option>
            <option value="GOBIERNO REGIONAL DE TACNA">GOBIERNO REGIONAL DE TACNA</option>
            <option value="GOBIERNO REGIONAL DE TUMBES">GOBIERNO REGIONAL DE TUMBES</option>
            <option value="GOBIERNO REGIONAL DE UCAYALI">GOBIERNO REGIONAL DE UCAYALI</option>
            <option value="GOBIERNO REGIONAL DEL CALLAO">GOBIERNO REGIONAL DEL CALLAO</option>
            <option value="GOBIERNO REGIONAL DEL CUSCO">GOBIERNO REGIONAL DEL CUSCO</option>
            <option value="MUNICIPALIDAD CP DE NICOLAS DE PIEROLA">MUNICIPALIDAD CP DE NICOLAS DE PIEROLA</option>
            <option value="MUNICIPALIDAD CP JOSE OLAYA">MUNICIPALIDAD CP JOSE OLAYA</option>
            <option value="MUNICIPALIDAD DE ANCON">MUNICIPALIDAD DE ANCON</option>
            <option value="MUNICIPALIDAD DE ATE">MUNICIPALIDAD DE ATE</option>
            <option value="MUNICIPALIDAD DE BARRANCO">MUNICIPALIDAD DE BARRANCO</option>
            <option value="MUNICIPALIDAD DE BELLAVISTA">MUNICIPALIDAD DE BELLAVISTA</option>
            <option value="MUNICIPALIDAD DE BREÑA">MUNICIPALIDAD DE BREÑA</option>
            <option value="MUNICIPALIDAD DE CARABAYLLO">MUNICIPALIDAD DE CARABAYLLO</option>
            <option value="MUNICIPALIDAD DE CARMEN DE LA LEGUA REYNOSO">MUNICIPALIDAD DE CARMEN DE LA LEGUA REYNOSO</option>
            <option value="MUNICIPALIDAD DE CHACLACAYO">MUNICIPALIDAD DE CHACLACAYO</option>
            <option value="MUNICIPALIDAD DE CHORRILLOS">MUNICIPALIDAD DE CHORRILLOS</option>
            <option value="MUNICIPALIDAD DE CIENEGUILLA">MUNICIPALIDAD DE CIENEGUILLA</option>
            <option value="MUNICIPALIDAD DE COMAS">MUNICIPALIDAD DE COMAS</option>
            <option value="MUNICIPALIDAD DE EL AGUSTINO">MUNICIPALIDAD DE EL AGUSTINO</option>
            <option value="MUNICIPALIDAD DE INDEPENDENCIA">MUNICIPALIDAD DE INDEPENDENCIA</option>
            <option value="MUNICIPALIDAD DE JESUS MARIA">MUNICIPALIDAD DE JESUS MARIA</option>
            <option value="MUNICIPALIDAD DE LA MOLINA">MUNICIPALIDAD DE LA MOLINA</option>
            <option value="MUNICIPALIDAD DE LA PERLA">MUNICIPALIDAD DE LA PERLA</option>
            <option value="MUNICIPALIDAD DE LA PUNTA">MUNICIPALIDAD DE LA PUNTA</option>
            <option value="MUNICIPALIDAD DE LA VICTORIA">MUNICIPALIDAD DE LA VICTORIA</option>
            <option value="MUNICIPALIDAD DE LINCE">MUNICIPALIDAD DE LINCE</option>
            <option value="MUNICIPALIDAD DE LOS OLIVOS">MUNICIPALIDAD DE LOS OLIVOS</option>
            <option value="MUNICIPALIDAD DE LURIGANCHO CHOSICA">MUNICIPALIDAD DE LURIGANCHO CHOSICA</option>
            <option value="MUNICIPALIDAD DE LURIN">MUNICIPALIDAD DE LURIN</option>
            <option value="MUNICIPALIDAD DE MAGDALENA DEL MAR">MUNICIPALIDAD DE MAGDALENA DEL MAR</option>
            <option value="MUNICIPALIDAD DE MI PERU">MUNICIPALIDAD DE MI PERU</option>
            <option value="MUNICIPALIDAD DE MIRAFLORES">MUNICIPALIDAD DE MIRAFLORES</option>
            <option value="MUNICIPALIDAD DE PACHACAMAC">MUNICIPALIDAD DE PACHACAMAC</option>
            <option value="MUNICIPALIDAD DE PUCUSANA">MUNICIPALIDAD DE PUCUSANA</option>
            <option value="MUNICIPALIDAD DE PUEBLO LIBRE">MUNICIPALIDAD DE PUEBLO LIBRE</option>
            <option value="MUNICIPALIDAD DE PUENTE PIEDRA">MUNICIPALIDAD DE PUENTE PIEDRA</option>
            <option value="MUNICIPALIDAD DE PUNTA HERMOSA">MUNICIPALIDAD DE PUNTA HERMOSA</option>
            <option value="MUNICIPALIDAD DE PUNTA NEGRA">MUNICIPALIDAD DE PUNTA NEGRA</option>
            <option value="MUNICIPALIDAD DE SAN BARTOLO">MUNICIPALIDAD DE SAN BARTOLO</option>
            <option value="MUNICIPALIDAD DE SAN BORJA">MUNICIPALIDAD DE SAN BORJA</option>
            <option value="MUNICIPALIDAD DE SAN ISIDRO">MUNICIPALIDAD DE SAN ISIDRO</option>
            <option value="MUNICIPALIDAD DE SAN JUAN DE LURIGANCHO">MUNICIPALIDAD DE SAN JUAN DE LURIGANCHO</option>
            <option value="MUNICIPALIDAD DE SAN JUAN DE MIRAFLORES">MUNICIPALIDAD DE SAN JUAN DE MIRAFLORES</option>
            <option value="MUNICIPALIDAD DE SAN LUIS">MUNICIPALIDAD DE SAN LUIS</option>
            <option value="MUNICIPALIDAD DE SAN MARTIN DE PORRES">MUNICIPALIDAD DE SAN MARTIN DE PORRES</option>
            <option value="MUNICIPALIDAD DE SAN MIGUEL">MUNICIPALIDAD DE SAN MIGUEL</option>
            <option value="MUNICIPALIDAD DE SAN PEDRO DE LURIN">MUNICIPALIDAD DE SAN PEDRO DE LURIN</option>
            <option value="MUNICIPALIDAD DE SANTA ANITA">MUNICIPALIDAD DE SANTA ANITA</option>
            <option value="MUNICIPALIDAD DE SANTA MARIA DEL MAR">MUNICIPALIDAD DE SANTA MARIA DEL MAR</option>
            <option value="MUNICIPALIDAD DE SANTA ROSA">MUNICIPALIDAD DE SANTA ROSA</option>
            <option value="MUNICIPALIDAD DE SANTIAGO DE SURCO">MUNICIPALIDAD DE SANTIAGO DE SURCO</option>
            <option value="MUNICIPALIDAD DE SURQUILLO">MUNICIPALIDAD DE SURQUILLO</option>
            <option value="MUNICIPALIDAD DE VENTANILLA">MUNICIPALIDAD DE VENTANILLA</option>
            <option value="MUNICIPALIDAD DE VILLA EL SALVADOR">MUNICIPALIDAD DE VILLA EL SALVADOR</option>
            <option value="MUNICIPALIDAD DE VILLA MARIA DEL TRIUNFO">MUNICIPALIDAD DE VILLA MARIA DEL TRIUNFO</option>
            <option value="MUNICIPALIDAD DEL CENTRO POBLADO SANTA MARIA DE HUACHIPA">MUNICIPALIDAD DEL CENTRO POBLADO SANTA MARIA DE HUACHIPA</option>
            <option value="MUNICIPALIDAD DEL RIMAC">MUNICIPALIDAD DEL RIMAC</option>
            <option value="MUNICIPALIDAD DELEGADA SAN LUCAS DE COLAN">MUNICIPALIDAD DELEGADA SAN LUCAS DE COLAN</option>
            <option value="MUNICIPALIDAD DISTRITAL ALTO DE LA ALIANZA">MUNICIPALIDAD DISTRITAL ALTO DE LA ALIANZA</option>
            <option value="MUNICIPALIDAD DISTRITAL CORONEL GREGORIO ALBARRACIN LANCHIPA">MUNICIPALIDAD DISTRITAL CORONEL GREGORIO ALBARRACIN LANCHIPA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ACHAYA">MUNICIPALIDAD DISTRITAL DE ACHAYA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ACOBAMBA">MUNICIPALIDAD DISTRITAL DE ACOBAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ACOBAMBILLA">MUNICIPALIDAD DISTRITAL DE ACOBAMBILLA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ACOCHACA">MUNICIPALIDAD DISTRITAL DE ACOCHACA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ACOPAMPA">MUNICIPALIDAD DISTRITAL DE ACOPAMPA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ACORA">MUNICIPALIDAD DISTRITAL DE ACORA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ACORIA">MUNICIPALIDAD DISTRITAL DE ACORIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ACRAQUIA">MUNICIPALIDAD DISTRITAL DE ACRAQUIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE AGALLPAMPA">MUNICIPALIDAD DISTRITAL DE AGALLPAMPA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE AGUAS VERDES">MUNICIPALIDAD DISTRITAL DE AGUAS VERDES</option>
            <option value="MUNICIPALIDAD DISTRITAL DE AHUAC">MUNICIPALIDAD DISTRITAL DE AHUAC</option>
            <option value="MUNICIPALIDAD DISTRITAL DE AJOYANI">MUNICIPALIDAD DISTRITAL DE AJOYANI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ALLAUCA">MUNICIPALIDAD DISTRITAL DE ALLAUCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ALTO LARAN">MUNICIPALIDAD DISTRITAL DE ALTO LARAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ALTO SELVA ALEGRE">MUNICIPALIDAD DISTRITAL DE ALTO SELVA ALEGRE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE AMANTANI">MUNICIPALIDAD DISTRITAL DE AMANTANI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE AMARILIS">MUNICIPALIDAD DISTRITAL DE AMARILIS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ANANEA">MUNICIPALIDAD DISTRITAL DE ANANEA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ANCO - LA MAR">MUNICIPALIDAD DISTRITAL DE ANCO - LA MAR</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ANCO HUALLO">MUNICIPALIDAD DISTRITAL DE ANCO HUALLO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ANDABAMBA">MUNICIPALIDAD DISTRITAL DE ANDABAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ANDAGUA">MUNICIPALIDAD DISTRITAL DE ANDAGUA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ANDAHUAYLILLAS">MUNICIPALIDAD DISTRITAL DE ANDAHUAYLILLAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ANDAJES">MUNICIPALIDAD DISTRITAL DE ANDAJES</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ANDAMARCA">MUNICIPALIDAD DISTRITAL DE ANDAMARCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ANDARAPA">MUNICIPALIDAD DISTRITAL DE ANDARAPA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ANDARAY">MUNICIPALIDAD DISTRITAL DE ANDARAY</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ANTA">MUNICIPALIDAD DISTRITAL DE ANTA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ANTIOQUIA">MUNICIPALIDAD DISTRITAL DE ANTIOQUIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ANTONIO RAYMONDI">MUNICIPALIDAD DISTRITAL DE ANTONIO RAYMONDI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE APATA">MUNICIPALIDAD DISTRITAL DE APATA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE AQUIA">MUNICIPALIDAD DISTRITAL DE AQUIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ARAMANGO">MUNICIPALIDAD DISTRITAL DE ARAMANGO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ARAPA">MUNICIPALIDAD DISTRITAL DE ARAPA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ASCENSION">MUNICIPALIDAD DISTRITAL DE ASCENSION</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ASIA">MUNICIPALIDAD DISTRITAL DE ASIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ASUNCION">MUNICIPALIDAD DISTRITAL DE ASUNCION</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ATUNCOLLA">MUNICIPALIDAD DISTRITAL DE ATUNCOLLA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE AUCALLAMA">MUNICIPALIDAD DISTRITAL DE AUCALLAMA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE AUCARA">MUNICIPALIDAD DISTRITAL DE AUCARA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE AYAHUANCO">MUNICIPALIDAD DISTRITAL DE AYAHUANCO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE AYAVI">MUNICIPALIDAD DISTRITAL DE AYAVI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE AYNA SAN FRANCISCO">MUNICIPALIDAD DISTRITAL DE AYNA SAN FRANCISCO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE BALSAS">MUNICIPALIDAD DISTRITAL DE BALSAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE BAÑOS">MUNICIPALIDAD DISTRITAL DE BAÑOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE BARRANCA">MUNICIPALIDAD DISTRITAL DE BARRANCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE BELEN">MUNICIPALIDAD DISTRITAL DE BELEN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE BELLA UNION">MUNICIPALIDAD DISTRITAL DE BELLA UNION</option>
            <option value="MUNICIPALIDAD DISTRITAL DE BELLAVISTA">MUNICIPALIDAD DISTRITAL DE BELLAVISTA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE BELLAVISTA JAEN">MUNICIPALIDAD DISTRITAL DE BELLAVISTA JAEN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE BERNAL">MUNICIPALIDAD DISTRITAL DE BERNAL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE BOLOGNESI">MUNICIPALIDAD DISTRITAL DE BOLOGNESI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE BUENOS AIRES">MUNICIPALIDAD DISTRITAL DE BUENOS AIRES</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CABANA">MUNICIPALIDAD DISTRITAL DE CABANA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CABANACONDE">MUNICIPALIDAD DISTRITAL DE CABANACONDE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CACHACHI">MUNICIPALIDAD DISTRITAL DE CACHACHI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CACHICADAN">MUNICIPALIDAD DISTRITAL DE CACHICADAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CACHIMAYO">MUNICIPALIDAD DISTRITAL DE CACHIMAYO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CAHUACHO">MUNICIPALIDAD DISTRITAL DE CAHUACHO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CAHUAPANAS">MUNICIPALIDAD DISTRITAL DE CAHUAPANAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CAICAY">MUNICIPALIDAD DISTRITAL DE CAICAY</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CAJA ESPIRITU">MUNICIPALIDAD DISTRITAL DE CAJA ESPIRITU</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CAJARURO">MUNICIPALIDAD DISTRITAL DE CAJARURO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CAJAY">MUNICIPALIDAD DISTRITAL DE CAJAY</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CALAMARCA">MUNICIPALIDAD DISTRITAL DE CALAMARCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CALANGO">MUNICIPALIDAD DISTRITAL DE CALANGO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CALAPUJA">MUNICIPALIDAD DISTRITAL DE CALAPUJA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CALETA DE CARQUIN">MUNICIPALIDAD DISTRITAL DE CALETA DE CARQUIN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CALLAHUANCA">MUNICIPALIDAD DISTRITAL DE CALLAHUANCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CALLANMARCA">MUNICIPALIDAD DISTRITAL DE CALLANMARCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CALLAYUC">MUNICIPALIDAD DISTRITAL DE CALLAYUC</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CAMPANILLA">MUNICIPALIDAD DISTRITAL DE CAMPANILLA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CAMPORREDONDO - LUYA">MUNICIPALIDAD DISTRITAL DE CAMPORREDONDO - LUYA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CANCHAQUE">MUNICIPALIDAD DISTRITAL DE CANCHAQUE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CANOAS DE PUNTA SAL">MUNICIPALIDAD DISTRITAL DE CANOAS DE PUNTA SAL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CAPACHICA">MUNICIPALIDAD DISTRITAL DE CAPACHICA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CARAMPOMA">MUNICIPALIDAD DISTRITAL DE CARAMPOMA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CARANIA">MUNICIPALIDAD DISTRITAL DE CARANIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CARHUAMAYO">MUNICIPALIDAD DISTRITAL DE CARHUAMAYO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CARHUAPAMPA">MUNICIPALIDAD DISTRITAL DE CARHUAPAMPA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CARMEN SALCEDO">MUNICIPALIDAD DISTRITAL DE CARMEN SALCEDO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CARUMAS">MUNICIPALIDAD DISTRITAL DE CARUMAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CASA GRANDE">MUNICIPALIDAD DISTRITAL DE CASA GRANDE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CASTILLA">MUNICIPALIDAD DISTRITAL DE CASTILLA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CASTILLO GRANDE">MUNICIPALIDAD DISTRITAL DE CASTILLO GRANDE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CATAC">MUNICIPALIDAD DISTRITAL DE CATAC</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CATACAOS">MUNICIPALIDAD DISTRITAL DE CATACAOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CAYMA">MUNICIPALIDAD DISTRITAL DE CAYMA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CCAPACMARCA">MUNICIPALIDAD DISTRITAL DE CCAPACMARCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CCAPI">MUNICIPALIDAD DISTRITAL DE CCAPI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CCARHUAYO">MUNICIPALIDAD DISTRITAL DE CCARHUAYO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CCATCCA">MUNICIPALIDAD DISTRITAL DE CCATCCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CERRO AZUL">MUNICIPALIDAD DISTRITAL DE CERRO AZUL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CERRO COLORADO">MUNICIPALIDAD DISTRITAL DE CERRO COLORADO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHAGLLA">MUNICIPALIDAD DISTRITAL DE CHAGLLA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHALA">MUNICIPALIDAD DISTRITAL DE CHALA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHALACO">MUNICIPALIDAD DISTRITAL DE CHALACO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHALLABAMBA">MUNICIPALIDAD DISTRITAL DE CHALLABAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHANCAY">MUNICIPALIDAD DISTRITAL DE CHANCAY</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHANCAY - CAJAMARCA">MUNICIPALIDAD DISTRITAL DE CHANCAY - CAJAMARCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHAO">MUNICIPALIDAD DISTRITAL DE CHAO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHARACATO">MUNICIPALIDAD DISTRITAL DE CHARACATO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHARAT">MUNICIPALIDAD DISTRITAL DE CHARAT</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHARCANA">MUNICIPALIDAD DISTRITAL DE CHARCANA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHAVIN">MUNICIPALIDAD DISTRITAL DE CHAVIN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHAVIN DE HUANTAR">MUNICIPALIDAD DISTRITAL DE CHAVIN DE HUANTAR</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHECRAS">MUNICIPALIDAD DISTRITAL DE CHECRAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHETILLA">MUNICIPALIDAD DISTRITAL DE CHETILLA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHICAMA">MUNICIPALIDAD DISTRITAL DE CHICAMA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHICHAS">MUNICIPALIDAD DISTRITAL DE CHICHAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHICLA">MUNICIPALIDAD DISTRITAL DE CHICLA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHILCA-HUANCAYO">MUNICIPALIDAD DISTRITAL DE CHILCA-HUANCAYO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHINCHA BAJA">MUNICIPALIDAD DISTRITAL DE CHINCHA BAJA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHINCHAO">MUNICIPALIDAD DISTRITAL DE CHINCHAO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHINCHERO">MUNICIPALIDAD DISTRITAL DE CHINCHERO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHINGAS">MUNICIPALIDAD DISTRITAL DE CHINGAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHIPAO">MUNICIPALIDAD DISTRITAL DE CHIPAO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHIRINOS">MUNICIPALIDAD DISTRITAL DE CHIRINOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHISQUILLA">MUNICIPALIDAD DISTRITAL DE CHISQUILLA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHOCOPE">MUNICIPALIDAD DISTRITAL DE CHOCOPE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHONGOS BAJO">MUNICIPALIDAD DISTRITAL DE CHONGOS BAJO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHONGOYAPE">MUNICIPALIDAD DISTRITAL DE CHONGOYAPE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHONTABAMBA">MUNICIPALIDAD DISTRITAL DE CHONTABAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHOROS">MUNICIPALIDAD DISTRITAL DE CHOROS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHUGUR">MUNICIPALIDAD DISTRITAL DE CHUGUR</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHUQUIBAMBA">MUNICIPALIDAD DISTRITAL DE CHUQUIBAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHURUBAMBA">MUNICIPALIDAD DISTRITAL DE CHURUBAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CHURUJA">MUNICIPALIDAD DISTRITAL DE CHURUJA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CIUDAD NUEVA">MUNICIPALIDAD DISTRITAL DE CIUDAD NUEVA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COALAQUE">MUNICIPALIDAD DISTRITAL DE COALAQUE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COATA">MUNICIPALIDAD DISTRITAL DE COATA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COCABAMBA">MUNICIPALIDAD DISTRITAL DE COCABAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COCACHACRA">MUNICIPALIDAD DISTRITAL DE COCACHACRA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COCHABAMBA">MUNICIPALIDAD DISTRITAL DE COCHABAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COCHARCAS">MUNICIPALIDAD DISTRITAL DE COCHARCAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COCHAS">MUNICIPALIDAD DISTRITAL DE COCHAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COCHORCO">MUNICIPALIDAD DISTRITAL DE COCHORCO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CODO DEL POZUZO">MUNICIPALIDAD DISTRITAL DE CODO DEL POZUZO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COISHCO">MUNICIPALIDAD DISTRITAL DE COISHCO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COLASAY">MUNICIPALIDAD DISTRITAL DE COLASAY</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COLCABAMBA">MUNICIPALIDAD DISTRITAL DE COLCABAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COLCABAMCA">MUNICIPALIDAD DISTRITAL DE COLCABAMCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COLCAMAR">MUNICIPALIDAD DISTRITAL DE COLCAMAR</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COLQUIOC">MUNICIPALIDAD DISTRITAL DE COLQUIOC</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COMANDANTE NOEL">MUNICIPALIDAD DISTRITAL DE COMANDANTE NOEL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COMAS - JUNIN">MUNICIPALIDAD DISTRITAL DE COMAS - JUNIN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CONDEBAMBA">MUNICIPALIDAD DISTRITAL DE CONDEBAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CONILA">MUNICIPALIDAD DISTRITAL DE CONILA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COPA">MUNICIPALIDAD DISTRITAL DE COPA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COPANI">MUNICIPALIDAD DISTRITAL DE COPANI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CORCULLA">MUNICIPALIDAD DISTRITAL DE CORCULLA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COROSHA">MUNICIPALIDAD DISTRITAL DE COROSHA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CORRALES">MUNICIPALIDAD DISTRITAL DE CORRALES</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COTABAMBAS">MUNICIPALIDAD DISTRITAL DE COTABAMBAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COTAPARACO">MUNICIPALIDAD DISTRITAL DE COTAPARACO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COTARUSI">MUNICIPALIDAD DISTRITAL DE COTARUSI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE COVIRIALI">MUNICIPALIDAD DISTRITAL DE COVIRIALI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CRISTO NOS VALGA">MUNICIPALIDAD DISTRITAL DE CRISTO NOS VALGA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CUCHUMBAYA">MUNICIPALIDAD DISTRITAL DE CUCHUMBAYA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CUENCA">MUNICIPALIDAD DISTRITAL DE CUENCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CUISPES">MUNICIPALIDAD DISTRITAL DE CUISPES</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CULLHUAS">MUNICIPALIDAD DISTRITAL DE CULLHUAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CUPI">MUNICIPALIDAD DISTRITAL DE CUPI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CURA MORI">MUNICIPALIDAD DISTRITAL DE CURA MORI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CURIMANA">MUNICIPALIDAD DISTRITAL DE CURIMANA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CUTURAPI">MUNICIPALIDAD DISTRITAL DE CUTURAPI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE CUYOCUYO">MUNICIPALIDAD DISTRITAL DE CUYOCUYO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE DANIEL HERNANDEZ">MUNICIPALIDAD DISTRITAL DE DANIEL HERNANDEZ</option>
            <option value="MUNICIPALIDAD DISTRITAL DE DESAGUADERO">MUNICIPALIDAD DISTRITAL DE DESAGUADERO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ECHARATI">MUNICIPALIDAD DISTRITAL DE ECHARATI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE EL ALGARROBAL">MUNICIPALIDAD DISTRITAL DE EL ALGARROBAL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE EL ALTO">MUNICIPALIDAD DISTRITAL DE EL ALTO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE EL ARENAL">MUNICIPALIDAD DISTRITAL DE EL ARENAL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE EL CARMEN">MUNICIPALIDAD DISTRITAL DE EL CARMEN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE EL CARMEN DE LA FRONTERA">MUNICIPALIDAD DISTRITAL DE EL CARMEN DE LA FRONTERA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE EL PORVENIR">MUNICIPALIDAD DISTRITAL DE EL PORVENIR</option>
            <option value="MUNICIPALIDAD DISTRITAL DE EL TAMBO">MUNICIPALIDAD DISTRITAL DE EL TAMBO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE EL TIGRE">MUNICIPALIDAD DISTRITAL DE EL TIGRE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ELIAS SOPLIN VARGAS">MUNICIPALIDAD DISTRITAL DE ELIAS SOPLIN VARGAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE FERNANDO LORES">MUNICIPALIDAD DISTRITAL DE FERNANDO LORES</option>
            <option value="MUNICIPALIDAD DISTRITAL DE FIDEL OLIVAS ESCUDERO">MUNICIPALIDAD DISTRITAL DE FIDEL OLIVAS ESCUDERO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE FLORENCIA DE MORA">MUNICIPALIDAD DISTRITAL DE FLORENCIA DE MORA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE FLORIDA">MUNICIPALIDAD DISTRITAL DE FLORIDA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE FRIAS">MUNICIPALIDAD DISTRITAL DE FRIAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE GORGOR">MUNICIPALIDAD DISTRITAL DE GORGOR</option>
            <option value="MUNICIPALIDAD DISTRITAL DE GOYLLARISQUIZGA">MUNICIPALIDAD DISTRITAL DE GOYLLARISQUIZGA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE GRANADA">MUNICIPALIDAD DISTRITAL DE GRANADA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE GROCIO PRADO">MUNICIPALIDAD DISTRITAL DE GROCIO PRADO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE GUADALUPE">MUNICIPALIDAD DISTRITAL DE GUADALUPE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HONGOS">MUNICIPALIDAD DISTRITAL DE HONGOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUACACHI">MUNICIPALIDAD DISTRITAL DE HUACACHI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUACCANA">MUNICIPALIDAD DISTRITAL DE HUACCANA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUACCHIS">MUNICIPALIDAD DISTRITAL DE HUACCHIS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUACHOCOLPA">MUNICIPALIDAD DISTRITAL DE HUACHOCOLPA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUACRAPUQUIO">MUNICIPALIDAD DISTRITAL DE HUACRAPUQUIO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUALGAYOC">MUNICIPALIDAD DISTRITAL DE HUALGAYOC</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUALLAGA LEDOY">MUNICIPALIDAD DISTRITAL DE HUALLAGA LEDOY</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUALLANCA">MUNICIPALIDAD DISTRITAL DE HUALLANCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUALMAY">MUNICIPALIDAD DISTRITAL DE HUALMAY</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUAMANCACA CHICO">MUNICIPALIDAD DISTRITAL DE HUAMANCACA CHICO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUAMATAMBO">MUNICIPALIDAD DISTRITAL DE HUAMATAMBO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUAMPARA">MUNICIPALIDAD DISTRITAL DE HUAMPARA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUANCABAMBA">MUNICIPALIDAD DISTRITAL DE HUANCABAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUANCAN">MUNICIPALIDAD DISTRITAL DE HUANCAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUANCANO">MUNICIPALIDAD DISTRITAL DE HUANCANO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUANCAPON">MUNICIPALIDAD DISTRITAL DE HUANCAPON</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUANCARAMA">MUNICIPALIDAD DISTRITAL DE HUANCARAMA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUANCARAY">MUNICIPALIDAD DISTRITAL DE HUANCARAY</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUANCAS">MUNICIPALIDAD DISTRITAL DE HUANCAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUANCASPATA">MUNICIPALIDAD DISTRITAL DE HUANCASPATA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUANCAYA">MUNICIPALIDAD DISTRITAL DE HUANCAYA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUANCHACO">MUNICIPALIDAD DISTRITAL DE HUANCHACO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUANDO">MUNICIPALIDAD DISTRITAL DE HUANDO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUANTAN">MUNICIPALIDAD DISTRITAL DE HUANTAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUANTAR">MUNICIPALIDAD DISTRITAL DE HUANTAR</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUANUHUANU">MUNICIPALIDAD DISTRITAL DE HUANUHUANU</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUANZA">MUNICIPALIDAD DISTRITAL DE HUANZA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUARANCHAL">MUNICIPALIDAD DISTRITAL DE HUARANCHAL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUARANGO">MUNICIPALIDAD DISTRITAL DE HUARANGO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUARIBAMBA">MUNICIPALIDAD DISTRITAL DE HUARIBAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUARMACA">MUNICIPALIDAD DISTRITAL DE HUARMACA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUAROCHIRI - HUAROCHIRI">MUNICIPALIDAD DISTRITAL DE HUAROCHIRI - HUAROCHIRI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUAROS">MUNICIPALIDAD DISTRITAL DE HUAROS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUASAHUASI">MUNICIPALIDAD DISTRITAL DE HUASAHUASI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUASTA">MUNICIPALIDAD DISTRITAL DE HUASTA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUATA">MUNICIPALIDAD DISTRITAL DE HUATA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUAURA">MUNICIPALIDAD DISTRITAL DE HUAURA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUAYAN">MUNICIPALIDAD DISTRITAL DE HUAYAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUAYLAS">MUNICIPALIDAD DISTRITAL DE HUAYLAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUAYLLACAYAN">MUNICIPALIDAD DISTRITAL DE HUAYLLACAYAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUAYLLAHUARA">MUNICIPALIDAD DISTRITAL DE HUAYLLAHUARA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUAYLLAN">MUNICIPALIDAD DISTRITAL DE HUAYLLAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUAYLLAPAMPA">MUNICIPALIDAD DISTRITAL DE HUAYLLAPAMPA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUAYLLAY">MUNICIPALIDAD DISTRITAL DE HUAYLLAY</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUAYLLAY GRANDE">MUNICIPALIDAD DISTRITAL DE HUAYLLAY GRANDE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUAYRAPATA">MUNICIPALIDAD DISTRITAL DE HUAYRAPATA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUICUNGO">MUNICIPALIDAD DISTRITAL DE HUICUNGO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUIMBAYOC">MUNICIPALIDAD DISTRITAL DE HUIMBAYOC</option>
            <option value="MUNICIPALIDAD DISTRITAL DE HUMAY">MUNICIPALIDAD DISTRITAL DE HUMAY</option>
            <option value="MUNICIPALIDAD DISTRITAL DE IBERIA">MUNICIPALIDAD DISTRITAL DE IBERIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ICHOCAN">MUNICIPALIDAD DISTRITAL DE ICHOCAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE IGNACIO ESCUDERO">MUNICIPALIDAD DISTRITAL DE IGNACIO ESCUDERO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ILABAYA">MUNICIPALIDAD DISTRITAL DE ILABAYA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE IMAZA-CHIRIACO">MUNICIPALIDAD DISTRITAL DE IMAZA-CHIRIACO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE IMPERIAL">MUNICIPALIDAD DISTRITAL DE IMPERIAL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE INAHUAYA">MUNICIPALIDAD DISTRITAL DE INAHUAYA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE INCAHUASI">MUNICIPALIDAD DISTRITAL DE INCAHUASI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE IPARIA">MUNICIPALIDAD DISTRITAL DE IPARIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE IRAZOLA">MUNICIPALIDAD DISTRITAL DE IRAZOLA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ISLAY">MUNICIPALIDAD DISTRITAL DE ISLAY</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ITE">MUNICIPALIDAD DISTRITAL DE ITE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE JACOBO HUNTER">MUNICIPALIDAD DISTRITAL DE JACOBO HUNTER</option>
            <option value="MUNICIPALIDAD DISTRITAL DE JAMALCA">MUNICIPALIDAD DISTRITAL DE JAMALCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE JAZAN">MUNICIPALIDAD DISTRITAL DE JAZAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE JOSE CRESPO Y CASTILLO">MUNICIPALIDAD DISTRITAL DE JOSE CRESPO Y CASTILLO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE JOSE GALVEZ">MUNICIPALIDAD DISTRITAL DE JOSE GALVEZ</option>
            <option value="MUNICIPALIDAD DISTRITAL DE JOSE LEONARDO ORTIZ">MUNICIPALIDAD DISTRITAL DE JOSE LEONARDO ORTIZ</option>
            <option value="MUNICIPALIDAD DISTRITAL DE JOSE LUIS BUSTAMANTE Y RIBERO">MUNICIPALIDAD DISTRITAL DE JOSE LUIS BUSTAMANTE Y RIBERO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE JULCAMARCA">MUNICIPALIDAD DISTRITAL DE JULCAMARCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE KIMBIRI">MUNICIPALIDAD DISTRITAL DE KIMBIRI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE KOSÑIPATA">MUNICIPALIDAD DISTRITAL DE KOSÑIPATA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA ARENA">MUNICIPALIDAD DISTRITAL DE LA ARENA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA BANDA DE SHILCAYO">MUNICIPALIDAD DISTRITAL DE LA BANDA DE SHILCAYO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA BREA - NEGRITOS">MUNICIPALIDAD DISTRITAL DE LA BREA - NEGRITOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA COIPA">MUNICIPALIDAD DISTRITAL DE LA COIPA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA CRUZ">MUNICIPALIDAD DISTRITAL DE LA CRUZ</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA CUESTA">MUNICIPALIDAD DISTRITAL DE LA CUESTA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA ESPERANZA">MUNICIPALIDAD DISTRITAL DE LA ESPERANZA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA FLORIDA">MUNICIPALIDAD DISTRITAL DE LA FLORIDA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA HUACA">MUNICIPALIDAD DISTRITAL DE LA HUACA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA JOYA">MUNICIPALIDAD DISTRITAL DE LA JOYA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA LIBERTAD">MUNICIPALIDAD DISTRITAL DE LA LIBERTAD</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA MATANZA">MUNICIPALIDAD DISTRITAL DE LA MATANZA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA MERCED">MUNICIPALIDAD DISTRITAL DE LA MERCED</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA TINGUIÑA">MUNICIPALIDAD DISTRITAL DE LA TINGUIÑA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA UNION">MUNICIPALIDAD DISTRITAL DE LA UNION</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA UNION - PIURA">MUNICIPALIDAD DISTRITAL DE LA UNION - PIURA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA UNION LETICIA">MUNICIPALIDAD DISTRITAL DE LA UNION LETICIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA VICTORIA">MUNICIPALIDAD DISTRITAL DE LA VICTORIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA VILLA DE ORURILLO">MUNICIPALIDAD DISTRITAL DE LA VILLA DE ORURILLO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LA VILLA HERMOSA DE YANAHUARA">MUNICIPALIDAD DISTRITAL DE LA VILLA HERMOSA DE YANAHUARA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LABERINTO">MUNICIPALIDAD DISTRITAL DE LABERINTO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LAGUNAS">MUNICIPALIDAD DISTRITAL DE LAGUNAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LAHUAYTAMBO">MUNICIPALIDAD DISTRITAL DE LAHUAYTAMBO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LAJAS">MUNICIPALIDAD DISTRITAL DE LAJAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LALAQUIZ">MUNICIPALIDAD DISTRITAL DE LALAQUIZ</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LARAMATE">MUNICIPALIDAD DISTRITAL DE LARAMATE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LARAOS">MUNICIPALIDAD DISTRITAL DE LARAOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LAREDO">MUNICIPALIDAD DISTRITAL DE LAREDO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LARES">MUNICIPALIDAD DISTRITAL DE LARES</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LARI">MUNICIPALIDAD DISTRITAL DE LARI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LAS AMAZONAS">MUNICIPALIDAD DISTRITAL DE LAS AMAZONAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LAS LOMAS">MUNICIPALIDAD DISTRITAL DE LAS LOMAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LAS PIRIAS">MUNICIPALIDAD DISTRITAL DE LAS PIRIAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LEIMEBAMBA">MUNICIPALIDAD DISTRITAL DE LEIMEBAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LEONCIO PRADO">MUNICIPALIDAD DISTRITAL DE LEONCIO PRADO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LEYMEBAMBA">MUNICIPALIDAD DISTRITAL DE LEYMEBAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LIMABAMBA">MUNICIPALIDAD DISTRITAL DE LIMABAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LIMATAMBO">MUNICIPALIDAD DISTRITAL DE LIMATAMBO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LLACANORA">MUNICIPALIDAD DISTRITAL DE LLACANORA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LLAMA">MUNICIPALIDAD DISTRITAL DE LLAMA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LLANACORA">MUNICIPALIDAD DISTRITAL DE LLANACORA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LLAPO">MUNICIPALIDAD DISTRITAL DE LLAPO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LOBITOS">MUNICIPALIDAD DISTRITAL DE LOBITOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LOCROJA">MUNICIPALIDAD DISTRITAL DE LOCROJA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LONGUITA">MUNICIPALIDAD DISTRITAL DE LONGUITA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LOS AQUIJES">MUNICIPALIDAD DISTRITAL DE LOS AQUIJES</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LOS BAÑOS DEL INCA">MUNICIPALIDAD DISTRITAL DE LOS BAÑOS DEL INCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LOS ORGANOS">MUNICIPALIDAD DISTRITAL DE LOS ORGANOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LUCMA">MUNICIPALIDAD DISTRITAL DE LUCMA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LUCRE">MUNICIPALIDAD DISTRITAL DE LUCRE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LUYA">MUNICIPALIDAD DISTRITAL DE LUYA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LUYA VIEJO">MUNICIPALIDAD DISTRITAL DE LUYA VIEJO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE LUYANDO">MUNICIPALIDAD DISTRITAL DE LUYANDO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MACARI">MUNICIPALIDAD DISTRITAL DE MACARI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MACATE">MUNICIPALIDAD DISTRITAL DE MACATE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MACHE">MUNICIPALIDAD DISTRITAL DE MACHE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MACHUPICCHU">MUNICIPALIDAD DISTRITAL DE MACHUPICCHU</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MADEAN">MUNICIPALIDAD DISTRITAL DE MADEAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MADRE DE DIOS">MUNICIPALIDAD DISTRITAL DE MADRE DE DIOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MAGDALENA">MUNICIPALIDAD DISTRITAL DE MAGDALENA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MAGDALENA DE CAO">MUNICIPALIDAD DISTRITAL DE MAGDALENA DE CAO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MAJES">MUNICIPALIDAD DISTRITAL DE MAJES</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MALA">MUNICIPALIDAD DISTRITAL DE MALA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MANANTAY">MUNICIPALIDAD DISTRITAL DE MANANTAY</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MANAS">MUNICIPALIDAD DISTRITAL DE MANAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MANCORA">MUNICIPALIDAD DISTRITAL DE MANCORA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MANTA">MUNICIPALIDAD DISTRITAL DE MANTA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MARANGANI">MUNICIPALIDAD DISTRITAL DE MARANGANI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MARANURA">MUNICIPALIDAD DISTRITAL DE MARANURA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MARCA">MUNICIPALIDAD DISTRITAL DE MARCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MARCABAL">MUNICIPALIDAD DISTRITAL DE MARCABAL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MARCAPOMACOCHA">MUNICIPALIDAD DISTRITAL DE MARCAPOMACOCHA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MARCARA">MUNICIPALIDAD DISTRITAL DE MARCARA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MARCAVELICA">MUNICIPALIDAD DISTRITAL DE MARCAVELICA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MARCONA">MUNICIPALIDAD DISTRITAL DE MARCONA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MARIA">MUNICIPALIDAD DISTRITAL DE MARIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MARIANO MELGAR">MUNICIPALIDAD DISTRITAL DE MARIANO MELGAR</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MARIANO NICOLAS VALCARCEL">MUNICIPALIDAD DISTRITAL DE MARIANO NICOLAS VALCARCEL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MARIATANA">MUNICIPALIDAD DISTRITAL DE MARIATANA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MARISCAL BENAVIDES">MUNICIPALIDAD DISTRITAL DE MARISCAL BENAVIDES</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MARISCAL CASTILLA">MUNICIPALIDAD DISTRITAL DE MARISCAL CASTILLA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MARMOT">MUNICIPALIDAD DISTRITAL DE MARMOT</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MASISEA">MUNICIPALIDAD DISTRITAL DE MASISEA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MAZAMARI">MUNICIPALIDAD DISTRITAL DE MAZAMARI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MEGANTONI">MUNICIPALIDAD DISTRITAL DE MEGANTONI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MEJIA">MUNICIPALIDAD DISTRITAL DE MEJIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MIGUEL CHECA">MUNICIPALIDAD DISTRITAL DE MIGUEL CHECA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MOCHE">MUNICIPALIDAD DISTRITAL DE MOCHE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MOLINO">MUNICIPALIDAD DISTRITAL DE MOLINO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MOLLEBAMBA">MUNICIPALIDAD DISTRITAL DE MOLLEBAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MOLLEPAMPA">MUNICIPALIDAD DISTRITAL DE MOLLEPAMPA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MOLLEPATA">MUNICIPALIDAD DISTRITAL DE MOLLEPATA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MONOBAMBA">MUNICIPALIDAD DISTRITAL DE MONOBAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MONTERO">MUNICIPALIDAD DISTRITAL DE MONTERO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MONTEVIDEO">MUNICIPALIDAD DISTRITAL DE MONTEVIDEO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MONZON">MUNICIPALIDAD DISTRITAL DE MONZON</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MORALES">MUNICIPALIDAD DISTRITAL DE MORALES</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MOROCOCHA">MUNICIPALIDAD DISTRITAL DE MOROCOCHA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MORONA">MUNICIPALIDAD DISTRITAL DE MORONA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MORROPE">MUNICIPALIDAD DISTRITAL DE MORROPE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MORROPON">MUNICIPALIDAD DISTRITAL DE MORROPON</option>
            <option value="MUNICIPALIDAD DISTRITAL DE MOYA">MUNICIPALIDAD DISTRITAL DE MOYA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE NAMORA">MUNICIPALIDAD DISTRITAL DE NAMORA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE NEPEÑA">MUNICIPALIDAD DISTRITAL DE NEPEÑA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE NIEPOS">MUNICIPALIDAD DISTRITAL DE NIEPOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE NINABAMBA">MUNICIPALIDAD DISTRITAL DE NINABAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE NUEVA CAJAMARCA">MUNICIPALIDAD DISTRITAL DE NUEVA CAJAMARCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE NUEVA REQUENA">MUNICIPALIDAD DISTRITAL DE NUEVA REQUENA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE NUEVO CHIMBOTE">MUNICIPALIDAD DISTRITAL DE NUEVO CHIMBOTE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE NUEVO IMPERIAL">MUNICIPALIDAD DISTRITAL DE NUEVO IMPERIAL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE NUEVO PROGRESO">MUNICIPALIDAD DISTRITAL DE NUEVO PROGRESO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE OCALLI">MUNICIPALIDAD DISTRITAL DE OCALLI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE OCOBAMBA">MUNICIPALIDAD DISTRITAL DE OCOBAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE OCROS">MUNICIPALIDAD DISTRITAL DE OCROS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE OCUCAJE">MUNICIPALIDAD DISTRITAL DE OCUCAJE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE OCUMAL">MUNICIPALIDAD DISTRITAL DE OCUMAL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE OLLANTAYTAMBO">MUNICIPALIDAD DISTRITAL DE OLLANTAYTAMBO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE OLLEROS">MUNICIPALIDAD DISTRITAL DE OLLEROS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE OLMOS">MUNICIPALIDAD DISTRITAL DE OLMOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE OMACHA">MUNICIPALIDAD DISTRITAL DE OMACHA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE OMIA">MUNICIPALIDAD DISTRITAL DE OMIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ONGOY">MUNICIPALIDAD DISTRITAL DE ONGOY</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ORCOPAMPA">MUNICIPALIDAD DISTRITAL DE ORCOPAMPA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE OROPESA">MUNICIPALIDAD DISTRITAL DE OROPESA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PACAIPAMPA">MUNICIPALIDAD DISTRITAL DE PACAIPAMPA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PACANGA">MUNICIPALIDAD DISTRITAL DE PACANGA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PACARAN">MUNICIPALIDAD DISTRITAL DE PACARAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PACARAOS">MUNICIPALIDAD DISTRITAL DE PACARAOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PACASMAYO">MUNICIPALIDAD DISTRITAL DE PACASMAYO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PACHACUTEC">MUNICIPALIDAD DISTRITAL DE PACHACUTEC</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PACHANGARA">MUNICIPALIDAD DISTRITAL DE PACHANGARA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PACHAS">MUNICIPALIDAD DISTRITAL DE PACHAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PACHIA">MUNICIPALIDAD DISTRITAL DE PACHIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PACOCHA">MUNICIPALIDAD DISTRITAL DE PACOCHA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PACORA">MUNICIPALIDAD DISTRITAL DE PACORA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PACUCHA">MUNICIPALIDAD DISTRITAL DE PACUCHA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PADRE MARQUEZ">MUNICIPALIDAD DISTRITAL DE PADRE MARQUEZ</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PAIJAN">MUNICIPALIDAD DISTRITAL DE PAIJAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PALCA">MUNICIPALIDAD DISTRITAL DE PALCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PALCAMAYO">MUNICIPALIDAD DISTRITAL DE PALCAMAYO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PALCAZU">MUNICIPALIDAD DISTRITAL DE PALCAZU</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PALLASCA">MUNICIPALIDAD DISTRITAL DE PALLASCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PAMPA HERMOSA">MUNICIPALIDAD DISTRITAL DE PAMPA HERMOSA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PAMPACOLCA">MUNICIPALIDAD DISTRITAL DE PAMPACOLCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PAMPAS">MUNICIPALIDAD DISTRITAL DE PAMPAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PAMPAS CHICO">MUNICIPALIDAD DISTRITAL DE PAMPAS CHICO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PAMPAS DE HOSPITAL">MUNICIPALIDAD DISTRITAL DE PAMPAS DE HOSPITAL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PANGOA">MUNICIPALIDAD DISTRITAL DE PANGOA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PAPAYAL">MUNICIPALIDAD DISTRITAL DE PAPAYAL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PARACAS">MUNICIPALIDAD DISTRITAL DE PARACAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PARAMONGA">MUNICIPALIDAD DISTRITAL DE PARAMONGA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PARATIA">MUNICIPALIDAD DISTRITAL DE PARATIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PARCONA">MUNICIPALIDAD DISTRITAL DE PARCONA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PARCOY">MUNICIPALIDAD DISTRITAL DE PARCOY</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PARIACOTO">MUNICIPALIDAD DISTRITAL DE PARIACOTO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PARIAHUANCA">MUNICIPALIDAD DISTRITAL DE PARIAHUANCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PASTAZA">MUNICIPALIDAD DISTRITAL DE PASTAZA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PATIVILCA">MUNICIPALIDAD DISTRITAL DE PATIVILCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PAUCARA">MUNICIPALIDAD DISTRITAL DE PAUCARA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PAUCARBAMBA">MUNICIPALIDAD DISTRITAL DE PAUCARBAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PAUCARPATA">MUNICIPALIDAD DISTRITAL DE PAUCARPATA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PAUCAS">MUNICIPALIDAD DISTRITAL DE PAUCAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PAZOS">MUNICIPALIDAD DISTRITAL DE PAZOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PERENE">MUNICIPALIDAD DISTRITAL DE PERENE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PICHACANI PUNO">MUNICIPALIDAD DISTRITAL DE PICHACANI PUNO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PICHANAQUI">MUNICIPALIDAD DISTRITAL DE PICHANAQUI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PICHIGUA">MUNICIPALIDAD DISTRITAL DE PICHIGUA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PILCHACA">MUNICIPALIDAD DISTRITAL DE PILCHACA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PILCOMAYO">MUNICIPALIDAD DISTRITAL DE PILCOMAYO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PILPICHACA">MUNICIPALIDAD DISTRITAL DE PILPICHACA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PIMENTEL">MUNICIPALIDAD DISTRITAL DE PIMENTEL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PISACOMA">MUNICIPALIDAD DISTRITAL DE PISACOMA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PISUQUIA">MUNICIPALIDAD DISTRITAL DE PISUQUIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PITIPO">MUNICIPALIDAD DISTRITAL DE PITIPO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PIZACOMA">MUNICIPALIDAD DISTRITAL DE PIZACOMA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE POCOLLAY">MUNICIPALIDAD DISTRITAL DE POCOLLAY</option>
            <option value="MUNICIPALIDAD DISTRITAL DE POLVORA">MUNICIPALIDAD DISTRITAL DE POLVORA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE POMACANCHI">MUNICIPALIDAD DISTRITAL DE POMACANCHI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE POMACOCHA">MUNICIPALIDAD DISTRITAL DE POMACOCHA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE POMATA">MUNICIPALIDAD DISTRITAL DE POMATA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE POROY">MUNICIPALIDAD DISTRITAL DE POROY</option>
            <option value="MUNICIPALIDAD DISTRITAL DE POZUZO">MUNICIPALIDAD DISTRITAL DE POZUZO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PROVIDENCIA">MUNICIPALIDAD DISTRITAL DE PROVIDENCIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PUCALA">MUNICIPALIDAD DISTRITAL DE PUCALA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PUCYURA">MUNICIPALIDAD DISTRITAL DE PUCYURA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PUEBLO LIBRE">MUNICIPALIDAD DISTRITAL DE PUEBLO LIBRE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PUEBLO NUEVO">MUNICIPALIDAD DISTRITAL DE PUEBLO NUEVO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PUEBLO NUEVO DE COLAN">MUNICIPALIDAD DISTRITAL DE PUEBLO NUEVO DE COLAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PUERTO BERMUDEZ">MUNICIPALIDAD DISTRITAL DE PUERTO BERMUDEZ</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PULAN">MUNICIPALIDAD DISTRITAL DE PULAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PULLO">MUNICIPALIDAD DISTRITAL DE PULLO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE PUTUMAYO">MUNICIPALIDAD DISTRITAL DE PUTUMAYO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE QUELLOUNO">MUNICIPALIDAD DISTRITAL DE QUELLOUNO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE QUERECOTILLO">MUNICIPALIDAD DISTRITAL DE QUERECOTILLO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE QUILLO">MUNICIPALIDAD DISTRITAL DE QUILLO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE QUILMANA">MUNICIPALIDAD DISTRITAL DE QUILMANA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE QUINJALCA">MUNICIPALIDAD DISTRITAL DE QUINJALCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE QUINOCAY">MUNICIPALIDAD DISTRITAL DE QUINOCAY</option>
            <option value="MUNICIPALIDAD DISTRITAL DE QUINUABAMBA">MUNICIPALIDAD DISTRITAL DE QUINUABAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE QUIRUVILCA">MUNICIPALIDAD DISTRITAL DE QUIRUVILCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE QUISHUAR">MUNICIPALIDAD DISTRITAL DE QUISHUAR</option>
            <option value="MUNICIPALIDAD DISTRITAL DE QUISPICANCHI">MUNICIPALIDAD DISTRITAL DE QUISPICANCHI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE QUITO ARMA">MUNICIPALIDAD DISTRITAL DE QUITO ARMA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE RAGASH">MUNICIPALIDAD DISTRITAL DE RAGASH</option>
            <option value="MUNICIPALIDAD DISTRITAL DE RANRACANCHA">MUNICIPALIDAD DISTRITAL DE RANRACANCHA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE RAPAYAN">MUNICIPALIDAD DISTRITAL DE RAPAYAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE RAZURI">MUNICIPALIDAD DISTRITAL DE RAZURI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE RECTA">MUNICIPALIDAD DISTRITAL DE RECTA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE REQUE">MUNICIPALIDAD DISTRITAL DE REQUE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE RICARDO PALMA">MUNICIPALIDAD DISTRITAL DE RICARDO PALMA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE RIO NEGRO">MUNICIPALIDAD DISTRITAL DE RIO NEGRO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE RIO TAMBO">MUNICIPALIDAD DISTRITAL DE RIO TAMBO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE RIPAN">MUNICIPALIDAD DISTRITAL DE RIPAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE RONDOCAN">MUNICIPALIDAD DISTRITAL DE RONDOCAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SABANDIA">MUNICIPALIDAD DISTRITAL DE SABANDIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SACHACA">MUNICIPALIDAD DISTRITAL DE SACHACA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SALAS">MUNICIPALIDAD DISTRITAL DE SALAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SALCABAMBA">MUNICIPALIDAD DISTRITAL DE SALCABAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SALCAHUASI">MUNICIPALIDAD DISTRITAL DE SALCAHUASI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SALITRAL">MUNICIPALIDAD DISTRITAL DE SALITRAL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SALPO">MUNICIPALIDAD DISTRITAL DE SALPO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAMANCO">MUNICIPALIDAD DISTRITAL DE SAMANCO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAMEGUA">MUNICIPALIDAD DISTRITAL DE SAMEGUA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN AGUSTIN DE CAJAS">MUNICIPALIDAD DISTRITAL DE SAN AGUSTIN DE CAJAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN ANDRES">MUNICIPALIDAD DISTRITAL DE SAN ANDRES</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN ANTONIO">MUNICIPALIDAD DISTRITAL DE SAN ANTONIO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN ANTONIO - CHACLLA">MUNICIPALIDAD DISTRITAL DE SAN ANTONIO - CHACLLA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN BARTOLOME">MUNICIPALIDAD DISTRITAL DE SAN BARTOLOME</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN BUENAVENTURA">MUNICIPALIDAD DISTRITAL DE SAN BUENAVENTURA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN CLEMENTE">MUNICIPALIDAD DISTRITAL DE SAN CLEMENTE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN CRISTOBAL">MUNICIPALIDAD DISTRITAL DE SAN CRISTOBAL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN DAMIAN">MUNICIPALIDAD DISTRITAL DE SAN DAMIAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN FRANCISCO DE ASIS DE YARUSYACAN">MUNICIPALIDAD DISTRITAL DE SAN FRANCISCO DE ASIS DE YARUSYACAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN FRANCISCO DEL YESO">MUNICIPALIDAD DISTRITAL DE SAN FRANCISCO DEL YESO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN ISIDRO DE MAINO">MUNICIPALIDAD DISTRITAL DE SAN ISIDRO DE MAINO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN JACINTO">MUNICIPALIDAD DISTRITAL DE SAN JACINTO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN JAVIER DE ALPABAMBA">MUNICIPALIDAD DISTRITAL DE SAN JAVIER DE ALPABAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN JERONIMO">MUNICIPALIDAD DISTRITAL DE SAN JERONIMO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN JERONIMO - PACLAS">MUNICIPALIDAD DISTRITAL DE SAN JERONIMO - PACLAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN JERONIMO DE TUNAN">MUNICIPALIDAD DISTRITAL DE SAN JERONIMO DE TUNAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN JOSE">MUNICIPALIDAD DISTRITAL DE SAN JOSE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN JOSE DE LOS MOLINOS">MUNICIPALIDAD DISTRITAL DE SAN JOSE DE LOS MOLINOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN JOSE DE LOURDES">MUNICIPALIDAD DISTRITAL DE SAN JOSE DE LOURDES</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN JOSE DE QUERO">MUNICIPALIDAD DISTRITAL DE SAN JOSE DE QUERO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN JUAN BAUTISTA">MUNICIPALIDAD DISTRITAL DE SAN JUAN BAUTISTA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN JUAN DE BIGOTE">MUNICIPALIDAD DISTRITAL DE SAN JUAN DE BIGOTE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN JUAN DE IRIS">MUNICIPALIDAD DISTRITAL DE SAN JUAN DE IRIS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN JUAN DE LOPECANCHA">MUNICIPALIDAD DISTRITAL DE SAN JUAN DE LOPECANCHA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN LORENZO DE QUINTI">MUNICIPALIDAD DISTRITAL DE SAN LORENZO DE QUINTI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN LUIS">MUNICIPALIDAD DISTRITAL DE SAN LUIS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN LUIS DE SHUARO">MUNICIPALIDAD DISTRITAL DE SAN LUIS DE SHUARO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN MARCOS">MUNICIPALIDAD DISTRITAL DE SAN MARCOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN MARCOS DE ROCCHAC">MUNICIPALIDAD DISTRITAL DE SAN MARCOS DE ROCCHAC</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN MATEO">MUNICIPALIDAD DISTRITAL DE SAN MATEO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN MATEO DE HUANCHOR">MUNICIPALIDAD DISTRITAL DE SAN MATEO DE HUANCHOR</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN MATEO DE OTAO">MUNICIPALIDAD DISTRITAL DE SAN MATEO DE OTAO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN MIGUEL DE ACO">MUNICIPALIDAD DISTRITAL DE SAN MIGUEL DE ACO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN MIGUEL DE CHACCRAMPA">MUNICIPALIDAD DISTRITAL DE SAN MIGUEL DE CHACCRAMPA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN MIGUEL DE CORPANQUI">MUNICIPALIDAD DISTRITAL DE SAN MIGUEL DE CORPANQUI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN MIGUEL DE EL FAIQUE">MUNICIPALIDAD DISTRITAL DE SAN MIGUEL DE EL FAIQUE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN PABLO">MUNICIPALIDAD DISTRITAL DE SAN PABLO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN PEDRO DE CAJAS">MUNICIPALIDAD DISTRITAL DE SAN PEDRO DE CAJAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN PEDRO DE CASTA">MUNICIPALIDAD DISTRITAL DE SAN PEDRO DE CASTA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN PEDRO DE CHAULAN">MUNICIPALIDAD DISTRITAL DE SAN PEDRO DE CHAULAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN PEDRO DE PUTINA PUNCO">MUNICIPALIDAD DISTRITAL DE SAN PEDRO DE PUTINA PUNCO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN PEDRO DE SAÑO">MUNICIPALIDAD DISTRITAL DE SAN PEDRO DE SAÑO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN RAFAEL">MUNICIPALIDAD DISTRITAL DE SAN RAFAEL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN RAMON">MUNICIPALIDAD DISTRITAL DE SAN RAMON</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAN SEBASTIAN">MUNICIPALIDAD DISTRITAL DE SAN SEBASTIAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAÑA">MUNICIPALIDAD DISTRITAL DE SAÑA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANAGORAN">MUNICIPALIDAD DISTRITAL DE SANAGORAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANGALLAYA">MUNICIPALIDAD DISTRITAL DE SANGALLAYA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANGARARA">MUNICIPALIDAD DISTRITAL DE SANGARARA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTA">MUNICIPALIDAD DISTRITAL DE SANTA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTA ANA DE TUSI">MUNICIPALIDAD DISTRITAL DE SANTA ANA DE TUSI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTA BARBARA DE CARHUACAYAN">MUNICIPALIDAD DISTRITAL DE SANTA BARBARA DE CARHUACAYAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTA CATALINA">MUNICIPALIDAD DISTRITAL DE SANTA CATALINA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTA CATALINA DE MOSSA">MUNICIPALIDAD DISTRITAL DE SANTA CATALINA DE MOSSA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTA CRUZ">MUNICIPALIDAD DISTRITAL DE SANTA CRUZ</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTA CRUZ DE FLORES">MUNICIPALIDAD DISTRITAL DE SANTA CRUZ DE FLORES</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTA EULALIA">MUNICIPALIDAD DISTRITAL DE SANTA EULALIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTA MARIA">MUNICIPALIDAD DISTRITAL DE SANTA MARIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTA MARIA DE CHICMO">MUNICIPALIDAD DISTRITAL DE SANTA MARIA DE CHICMO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTA MARIA DE HUAURA">MUNICIPALIDAD DISTRITAL DE SANTA MARIA DE HUAURA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTA MARIA DEL VALLE">MUNICIPALIDAD DISTRITAL DE SANTA MARIA DEL VALLE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTA ROSA - MAZOCRUZ">MUNICIPALIDAD DISTRITAL DE SANTA ROSA - MAZOCRUZ</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTA ROSA DE OCOPA">MUNICIPALIDAD DISTRITAL DE SANTA ROSA DE OCOPA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTA ROSA DE QUIVES">MUNICIPALIDAD DISTRITAL DE SANTA ROSA DE QUIVES</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTA ROSA DE SACCO">MUNICIPALIDAD DISTRITAL DE SANTA ROSA DE SACCO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTIAGO DE CAO">MUNICIPALIDAD DISTRITAL DE SANTIAGO DE CAO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTIAGO DE CHOCORVOS">MUNICIPALIDAD DISTRITAL DE SANTIAGO DE CHOCORVOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTIAGO DE CUSCO">MUNICIPALIDAD DISTRITAL DE SANTIAGO DE CUSCO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTIAGO DE QUIRAHUARA">MUNICIPALIDAD DISTRITAL DE SANTIAGO DE QUIRAHUARA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTO DOMINGO">MUNICIPALIDAD DISTRITAL DE SANTO DOMINGO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTO DOMINGO DE LOS OLLEROS">MUNICIPALIDAD DISTRITAL DE SANTO DOMINGO DE LOS OLLEROS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SANTO TOMAS">MUNICIPALIDAD DISTRITAL DE SANTO TOMAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAPALLANGA">MUNICIPALIDAD DISTRITAL DE SAPALLANGA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAPILLICA">MUNICIPALIDAD DISTRITAL DE SAPILLICA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SARAYACU">MUNICIPALIDAD DISTRITAL DE SARAYACU</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SARTIMBAMBA">MUNICIPALIDAD DISTRITAL DE SARTIMBAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAUCE">MUNICIPALIDAD DISTRITAL DE SAUCE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAYAN">MUNICIPALIDAD DISTRITAL DE SAYAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAYAPULLO">MUNICIPALIDAD DISTRITAL DE SAYAPULLO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SAYLLA">MUNICIPALIDAD DISTRITAL DE SAYLLA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SEPAHUA">MUNICIPALIDAD DISTRITAL DE SEPAHUA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SHILLA">MUNICIPALIDAD DISTRITAL DE SHILLA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SHIPASBAMBA">MUNICIPALIDAD DISTRITAL DE SHIPASBAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SIBAYO">MUNICIPALIDAD DISTRITAL DE SIBAYO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SICCHEZ">MUNICIPALIDAD DISTRITAL DE SICCHEZ</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SIMBAL">MUNICIPALIDAD DISTRITAL DE SIMBAL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SIMON BOLIVAR">MUNICIPALIDAD DISTRITAL DE SIMON BOLIVAR</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SINSICAP">MUNICIPALIDAD DISTRITAL DE SINSICAP</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SITABAMBA">MUNICIPALIDAD DISTRITAL DE SITABAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SITACOCHA">MUNICIPALIDAD DISTRITAL DE SITACOCHA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SITAJARA">MUNICIPALIDAD DISTRITAL DE SITAJARA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SIVIA">MUNICIPALIDAD DISTRITAL DE SIVIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SOCABAYA">MUNICIPALIDAD DISTRITAL DE SOCABAYA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SOCAYABA">MUNICIPALIDAD DISTRITAL DE SOCAYABA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SOCOTA">MUNICIPALIDAD DISTRITAL DE SOCOTA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SOLOCO">MUNICIPALIDAD DISTRITAL DE SOLOCO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SONDORILLO">MUNICIPALIDAD DISTRITAL DE SONDORILLO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SOROCHUCO">MUNICIPALIDAD DISTRITAL DE SOROCHUCO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SUBTANJALLA">MUNICIPALIDAD DISTRITAL DE SUBTANJALLA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SUCCHA">MUNICIPALIDAD DISTRITAL DE SUCCHA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SUCRE">MUNICIPALIDAD DISTRITAL DE SUCRE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SUNAMPE">MUNICIPALIDAD DISTRITAL DE SUNAMPE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SUPE">MUNICIPALIDAD DISTRITAL DE SUPE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SUPE PUERTO">MUNICIPALIDAD DISTRITAL DE SUPE PUERTO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SURCO">MUNICIPALIDAD DISTRITAL DE SURCO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE SUYO">MUNICIPALIDAD DISTRITAL DE SUYO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TABACONAS">MUNICIPALIDAD DISTRITAL DE TABACONAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TABALOSOS">MUNICIPALIDAD DISTRITAL DE TABALOSOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TAHUANIA">MUNICIPALIDAD DISTRITAL DE TAHUANIA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TALAVERA">MUNICIPALIDAD DISTRITAL DE TALAVERA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TAMBO DE MORA">MUNICIPALIDAD DISTRITAL DE TAMBO DE MORA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TAMBOGRANDE">MUNICIPALIDAD DISTRITAL DE TAMBOGRANDE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TANTA">MUNICIPALIDAD DISTRITAL DE TANTA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TAPO">MUNICIPALIDAD DISTRITAL DE TAPO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TARICA">MUNICIPALIDAD DISTRITAL DE TARICA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TATE">MUNICIPALIDAD DISTRITAL DE TATE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TAUCA">MUNICIPALIDAD DISTRITAL DE TAUCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TAURIPAMPA">MUNICIPALIDAD DISTRITAL DE TAURIPAMPA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TIABAYA">MUNICIPALIDAD DISTRITAL DE TIABAYA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TINGO">MUNICIPALIDAD DISTRITAL DE TINGO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TINGO DE PONASA">MUNICIPALIDAD DISTRITAL DE TINGO DE PONASA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TINICACHI">MUNICIPALIDAD DISTRITAL DE TINICACHI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TINTA">MUNICIPALIDAD DISTRITAL DE TINTA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TIRAPATA">MUNICIPALIDAD DISTRITAL DE TIRAPATA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TNTE. CESAR LOPEZ ROJAS">MUNICIPALIDAD DISTRITAL DE TNTE. CESAR LOPEZ ROJAS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TORATA">MUNICIPALIDAD DISTRITAL DE TORATA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TOURNAVISTA">MUNICIPALIDAD DISTRITAL DE TOURNAVISTA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TUMAN">MUNICIPALIDAD DISTRITAL DE TUMAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TUPAC AMARU INCA">MUNICIPALIDAD DISTRITAL DE TUPAC AMARU INCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TUPE">MUNICIPALIDAD DISTRITAL DE TUPE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE TUTI">MUNICIPALIDAD DISTRITAL DE TUTI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE UCHIZA">MUNICIPALIDAD DISTRITAL DE UCHIZA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE UCO">MUNICIPALIDAD DISTRITAL DE UCO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ULCUMAYO">MUNICIPALIDAD DISTRITAL DE ULCUMAYO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE UMARI">MUNICIPALIDAD DISTRITAL DE UMARI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE UNICACHI">MUNICIPALIDAD DISTRITAL DE UNICACHI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE URACA">MUNICIPALIDAD DISTRITAL DE URACA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE URANMARCA">MUNICIPALIDAD DISTRITAL DE URANMARCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE USQUIL">MUNICIPALIDAD DISTRITAL DE USQUIL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE VALERA">MUNICIPALIDAD DISTRITAL DE VALERA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE VARGAS GUERRA">MUNICIPALIDAD DISTRITAL DE VARGAS GUERRA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE VEGUETA">MUNICIPALIDAD DISTRITAL DE VEGUETA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE VEINTISIETE DE NOVIEMBRE">MUNICIPALIDAD DISTRITAL DE VEINTISIETE DE NOVIEMBRE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE VICHAYAL">MUNICIPALIDAD DISTRITAL DE VICHAYAL</option>
            <option value="MUNICIPALIDAD DISTRITAL DE VICTOR LARCO HERRERA">MUNICIPALIDAD DISTRITAL DE VICTOR LARCO HERRERA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE VILCABAMBA">MUNICIPALIDAD DISTRITAL DE VILCABAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE VILLA RICA">MUNICIPALIDAD DISTRITAL DE VILLA RICA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE VILLA SANTA ANA - LA HUACA">MUNICIPALIDAD DISTRITAL DE VILLA SANTA ANA - LA HUACA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE VIÑAC">MUNICIPALIDAD DISTRITAL DE VIÑAC</option>
            <option value="MUNICIPALIDAD DISTRITAL DE VINCHOS">MUNICIPALIDAD DISTRITAL DE VINCHOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE VIQUES">MUNICIPALIDAD DISTRITAL DE VIQUES</option>
            <option value="MUNICIPALIDAD DISTRITAL DE VISTA ALEGRE">MUNICIPALIDAD DISTRITAL DE VISTA ALEGRE</option>
            <option value="MUNICIPALIDAD DISTRITAL DE WANCHAQ">MUNICIPALIDAD DISTRITAL DE WANCHAQ</option>
            <option value="MUNICIPALIDAD DISTRITAL DE YAMANGO">MUNICIPALIDAD DISTRITAL DE YAMANGO</option>
            <option value="MUNICIPALIDAD DISTRITAL DE YAMBRASBAMBA">MUNICIPALIDAD DISTRITAL DE YAMBRASBAMBA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE YANACANCHA">MUNICIPALIDAD DISTRITAL DE YANACANCHA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE YANAHUARA">MUNICIPALIDAD DISTRITAL DE YANAHUARA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE YAQUERANA">MUNICIPALIDAD DISTRITAL DE YAQUERANA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE YARINACOCHA">MUNICIPALIDAD DISTRITAL DE YARINACOCHA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE YAULI">MUNICIPALIDAD DISTRITAL DE YAULI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE YAUTAN">MUNICIPALIDAD DISTRITAL DE YAUTAN</option>
            <option value="MUNICIPALIDAD DISTRITAL DE YAUYA">MUNICIPALIDAD DISTRITAL DE YAUYA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE YAUYOS">MUNICIPALIDAD DISTRITAL DE YAUYOS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE YAVARI">MUNICIPALIDAD DISTRITAL DE YAVARI</option>
            <option value="MUNICIPALIDAD DISTRITAL DE YUNGA">MUNICIPALIDAD DISTRITAL DE YUNGA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE YURA">MUNICIPALIDAD DISTRITAL DE YURA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE YURACMARCA">MUNICIPALIDAD DISTRITAL DE YURACMARCA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE YUYAPICHIS">MUNICIPALIDAD DISTRITAL DE YUYAPICHIS</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ZAÑA">MUNICIPALIDAD DISTRITAL DE ZAÑA</option>
            <option value="MUNICIPALIDAD DISTRITAL DE ZEPITA">MUNICIPALIDAD DISTRITAL DE ZEPITA</option>
            <option value="MUNICIPALIDAD DISTRITAL DEL NAPO">MUNICIPALIDAD DISTRITAL DEL NAPO</option>
            <option value="MUNICIPALIDAD DISTRITAL HUAMANCACA CHICO">MUNICIPALIDAD DISTRITAL HUAMANCACA CHICO</option>
            <option value="MUNICIPALIDAD DISTRITAL SAMUEL PASTOR">MUNICIPALIDAD DISTRITAL SAMUEL PASTOR</option>
            <option value="MUNICIPALIDAD DISTRITAL SANTO DOMINGO DE ANDA">MUNICIPALIDAD DISTRITAL SANTO DOMINGO DE ANDA</option>
            <option value="MUNICIPALIDAD DISTRITAL VEINTISEIS DE OCTUBRE">MUNICIPALIDAD DISTRITAL VEINTISEIS DE OCTUBRE</option>
            <option value="MUNICIPALIDAD METROPOLITANA DE LIMA">MUNICIPALIDAD METROPOLITANA DE LIMA</option>
            <option value="MUNICIPALIDAD PROVINCIAL ANGARAES">MUNICIPALIDAD PROVINCIAL ANGARAES</option>
            <option value="MUNICIPALIDAD PROVINCIAL ANTONIO RAIMONDI">MUNICIPALIDAD PROVINCIAL ANTONIO RAIMONDI</option>
            <option value="MUNICIPALIDAD PROVINCIAL DATEM DEL MARAÑON">MUNICIPALIDAD PROVINCIAL DATEM DEL MARAÑON</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE ABANCAY">MUNICIPALIDAD PROVINCIAL DE ABANCAY</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE ACOBAMBA">MUNICIPALIDAD PROVINCIAL DE ACOBAMBA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE ACOMAYO">MUNICIPALIDAD PROVINCIAL DE ACOMAYO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE AIJA">MUNICIPALIDAD PROVINCIAL DE AIJA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE ALTO AMAZONAS">MUNICIPALIDAD PROVINCIAL DE ALTO AMAZONAS</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE ANDAHUAYLAS">MUNICIPALIDAD PROVINCIAL DE ANDAHUAYLAS</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE ANTA">MUNICIPALIDAD PROVINCIAL DE ANTA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE AREQUIPA">MUNICIPALIDAD PROVINCIAL DE AREQUIPA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE ASCOPE">MUNICIPALIDAD PROVINCIAL DE ASCOPE</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE ASUNCION">MUNICIPALIDAD PROVINCIAL DE ASUNCION</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE ATALAYA">MUNICIPALIDAD PROVINCIAL DE ATALAYA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE AYABACA">MUNICIPALIDAD PROVINCIAL DE AYABACA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE AYMARAES">MUNICIPALIDAD PROVINCIAL DE AYMARAES</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE AZANGARO">MUNICIPALIDAD PROVINCIAL DE AZANGARO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE BAGUA">MUNICIPALIDAD PROVINCIAL DE BAGUA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE BARRANCA">MUNICIPALIDAD PROVINCIAL DE BARRANCA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE BELLAVISTA">MUNICIPALIDAD PROVINCIAL DE BELLAVISTA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE BOLOGNESI">MUNICIPALIDAD PROVINCIAL DE BOLOGNESI</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE BONGARA">MUNICIPALIDAD PROVINCIAL DE BONGARA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CAJABAMBA">MUNICIPALIDAD PROVINCIAL DE CAJABAMBA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CAJAMARCA">MUNICIPALIDAD PROVINCIAL DE CAJAMARCA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CAJATAMBO">MUNICIPALIDAD PROVINCIAL DE CAJATAMBO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CALCA">MUNICIPALIDAD PROVINCIAL DE CALCA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CAMANA">MUNICIPALIDAD PROVINCIAL DE CAMANA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CANCHIS">MUNICIPALIDAD PROVINCIAL DE CANCHIS</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CANDARAVE">MUNICIPALIDAD PROVINCIAL DE CANDARAVE</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CAÑETE">MUNICIPALIDAD PROVINCIAL DE CAÑETE</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CANGALLO">MUNICIPALIDAD PROVINCIAL DE CANGALLO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CANTA">MUNICIPALIDAD PROVINCIAL DE CANTA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CARABAYA">MUNICIPALIDAD PROVINCIAL DE CARABAYA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CARAVELI">MUNICIPALIDAD PROVINCIAL DE CARAVELI</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CARHUAZ">MUNICIPALIDAD PROVINCIAL DE CARHUAZ</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CARLOS FERMIN FITZCARRALD">MUNICIPALIDAD PROVINCIAL DE CARLOS FERMIN FITZCARRALD</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CASMA">MUNICIPALIDAD PROVINCIAL DE CASMA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CASTILLA">MUNICIPALIDAD PROVINCIAL DE CASTILLA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CASTROVIRREYNA">MUNICIPALIDAD PROVINCIAL DE CASTROVIRREYNA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CAYLLOMA">MUNICIPALIDAD PROVINCIAL DE CAYLLOMA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CELENDIN">MUNICIPALIDAD PROVINCIAL DE CELENDIN</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CHACHAPOYAS">MUNICIPALIDAD PROVINCIAL DE CHACHAPOYAS</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CHANCHAMAYO">MUNICIPALIDAD PROVINCIAL DE CHANCHAMAYO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CHEPEN">MUNICIPALIDAD PROVINCIAL DE CHEPEN</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CHICLAYO">MUNICIPALIDAD PROVINCIAL DE CHICLAYO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CHINCHA">MUNICIPALIDAD PROVINCIAL DE CHINCHA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CHINCHEROS">MUNICIPALIDAD PROVINCIAL DE CHINCHEROS</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CHOTA">MUNICIPALIDAD PROVINCIAL DE CHOTA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CHUCUITO">MUNICIPALIDAD PROVINCIAL DE CHUCUITO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CHUMBIVILCAS">MUNICIPALIDAD PROVINCIAL DE CHUMBIVILCAS</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CHUPACA">MUNICIPALIDAD PROVINCIAL DE CHUPACA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CONCEPCION">MUNICIPALIDAD PROVINCIAL DE CONCEPCION</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CONDESUYOS">MUNICIPALIDAD PROVINCIAL DE CONDESUYOS</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CONDORCANQUI">MUNICIPALIDAD PROVINCIAL DE CONDORCANQUI</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CONTRALMIRANTE VILLAR">MUNICIPALIDAD PROVINCIAL DE CONTRALMIRANTE VILLAR</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CONTUMAZA">MUNICIPALIDAD PROVINCIAL DE CONTUMAZA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CORONEL PORTILLO">MUNICIPALIDAD PROVINCIAL DE CORONEL PORTILLO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CORONGO">MUNICIPALIDAD PROVINCIAL DE CORONGO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE COTABAMBAS">MUNICIPALIDAD PROVINCIAL DE COTABAMBAS</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE CUTERVO">MUNICIPALIDAD PROVINCIAL DE CUTERVO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE DANIEL ALCIDES CARRION">MUNICIPALIDAD PROVINCIAL DE DANIEL ALCIDES CARRION</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE DOS DE MAYO">MUNICIPALIDAD PROVINCIAL DE DOS DE MAYO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE EL COLLAO ">MUNICIPALIDAD PROVINCIAL DE EL COLLAO </option>
            <option value="MUNICIPALIDAD PROVINCIAL DE EL DORADO">MUNICIPALIDAD PROVINCIAL DE EL DORADO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE ESPINAR">MUNICIPALIDAD PROVINCIAL DE ESPINAR</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE FAJARDO">MUNICIPALIDAD PROVINCIAL DE FAJARDO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE FERREÑAFE">MUNICIPALIDAD PROVINCIAL DE FERREÑAFE</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE GRAN CHIMU">MUNICIPALIDAD PROVINCIAL DE GRAN CHIMU</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE GRAU">MUNICIPALIDAD PROVINCIAL DE GRAU</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUACAYBAMBA">MUNICIPALIDAD PROVINCIAL DE HUACAYBAMBA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUALGAYOC">MUNICIPALIDAD PROVINCIAL DE HUALGAYOC</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUALLAGA">MUNICIPALIDAD PROVINCIAL DE HUALLAGA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUAMALIES">MUNICIPALIDAD PROVINCIAL DE HUAMALIES</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUAMANGA">MUNICIPALIDAD PROVINCIAL DE HUAMANGA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUANCABAMBA">MUNICIPALIDAD PROVINCIAL DE HUANCABAMBA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUANCANE">MUNICIPALIDAD PROVINCIAL DE HUANCANE</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUANCAVELICA">MUNICIPALIDAD PROVINCIAL DE HUANCAVELICA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUANCAYO">MUNICIPALIDAD PROVINCIAL DE HUANCAYO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUANTA">MUNICIPALIDAD PROVINCIAL DE HUANTA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUANUCO">MUNICIPALIDAD PROVINCIAL DE HUANUCO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUARAL">MUNICIPALIDAD PROVINCIAL DE HUARAL</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUARAZ">MUNICIPALIDAD PROVINCIAL DE HUARAZ</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUARI">MUNICIPALIDAD PROVINCIAL DE HUARI</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUARMEY">MUNICIPALIDAD PROVINCIAL DE HUARMEY</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUAROCHIRI">MUNICIPALIDAD PROVINCIAL DE HUAROCHIRI</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUAURA">MUNICIPALIDAD PROVINCIAL DE HUAURA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUAYCABAMBA">MUNICIPALIDAD PROVINCIAL DE HUAYCABAMBA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUAYLAS">MUNICIPALIDAD PROVINCIAL DE HUAYLAS</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE HUAYTARA">MUNICIPALIDAD PROVINCIAL DE HUAYTARA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE ICA">MUNICIPALIDAD PROVINCIAL DE ICA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE ILO">MUNICIPALIDAD PROVINCIAL DE ILO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE ISLAY">MUNICIPALIDAD PROVINCIAL DE ISLAY</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE JAEN">MUNICIPALIDAD PROVINCIAL DE JAEN</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE JAUJA">MUNICIPALIDAD PROVINCIAL DE JAUJA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE JULCAN">MUNICIPALIDAD PROVINCIAL DE JULCAN</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE JUNIN">MUNICIPALIDAD PROVINCIAL DE JUNIN</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE LA CONVENCION">MUNICIPALIDAD PROVINCIAL DE LA CONVENCION</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE LA UNION - COTAHUASI">MUNICIPALIDAD PROVINCIAL DE LA UNION - COTAHUASI</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE LAMAS">MUNICIPALIDAD PROVINCIAL DE LAMAS</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE LAMBAYEQUE">MUNICIPALIDAD PROVINCIAL DE LAMBAYEQUE</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE LAMPA">MUNICIPALIDAD PROVINCIAL DE LAMPA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE LAURICOCHA">MUNICIPALIDAD PROVINCIAL DE LAURICOCHA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE LEONCIO PRADO">MUNICIPALIDAD PROVINCIAL DE LEONCIO PRADO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE LORETO - NAUTA">MUNICIPALIDAD PROVINCIAL DE LORETO - NAUTA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE LUCANAS PUQUIO">MUNICIPALIDAD PROVINCIAL DE LUCANAS PUQUIO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE LUYA">MUNICIPALIDAD PROVINCIAL DE LUYA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE MANU">MUNICIPALIDAD PROVINCIAL DE MANU</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE MARAÑON">MUNICIPALIDAD PROVINCIAL DE MARAÑON</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE MARISCAL CACERES">MUNICIPALIDAD PROVINCIAL DE MARISCAL CACERES</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE MARISCAL LUZURIAGA">MUNICIPALIDAD PROVINCIAL DE MARISCAL LUZURIAGA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE MARISCAL NIETO">MUNICIPALIDAD PROVINCIAL DE MARISCAL NIETO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE MARISCAL RAMON CASTILLA">MUNICIPALIDAD PROVINCIAL DE MARISCAL RAMON CASTILLA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE MAYNAS">MUNICIPALIDAD PROVINCIAL DE MAYNAS</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE MOHO">MUNICIPALIDAD PROVINCIAL DE MOHO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE MORROPON CHULUCANAS">MUNICIPALIDAD PROVINCIAL DE MORROPON CHULUCANAS</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE MOYOBAMBA">MUNICIPALIDAD PROVINCIAL DE MOYOBAMBA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE NASCA">MUNICIPALIDAD PROVINCIAL DE NASCA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE OTUZCO">MUNICIPALIDAD PROVINCIAL DE OTUZCO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE OXAPAMPA">MUNICIPALIDAD PROVINCIAL DE OXAPAMPA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE OYON">MUNICIPALIDAD PROVINCIAL DE OYON</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE PACASMAYO">MUNICIPALIDAD PROVINCIAL DE PACASMAYO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE PACHITEA">MUNICIPALIDAD PROVINCIAL DE PACHITEA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE PADRE ABAD">MUNICIPALIDAD PROVINCIAL DE PADRE ABAD</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE PAITA">MUNICIPALIDAD PROVINCIAL DE PAITA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE PALLASCA - CABANA">MUNICIPALIDAD PROVINCIAL DE PALLASCA - CABANA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE PALPA">MUNICIPALIDAD PROVINCIAL DE PALPA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE PARINACOCHAS">MUNICIPALIDAD PROVINCIAL DE PARINACOCHAS</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE PARURO">MUNICIPALIDAD PROVINCIAL DE PARURO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE PASCO">MUNICIPALIDAD PROVINCIAL DE PASCO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE PATAZ">MUNICIPALIDAD PROVINCIAL DE PATAZ</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE PAUCARTAMBO">MUNICIPALIDAD PROVINCIAL DE PAUCARTAMBO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE PICOTA">MUNICIPALIDAD PROVINCIAL DE PICOTA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE PISCO">MUNICIPALIDAD PROVINCIAL DE PISCO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE PIURA">MUNICIPALIDAD PROVINCIAL DE PIURA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE POMABAMBA">MUNICIPALIDAD PROVINCIAL DE POMABAMBA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE PUERTO INCA">MUNICIPALIDAD PROVINCIAL DE PUERTO INCA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE PUNO">MUNICIPALIDAD PROVINCIAL DE PUNO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE PURUS">MUNICIPALIDAD PROVINCIAL DE PURUS</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE QUISPICANCHI">MUNICIPALIDAD PROVINCIAL DE QUISPICANCHI</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE RECUAY">MUNICIPALIDAD PROVINCIAL DE RECUAY</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE REQUENA">MUNICIPALIDAD PROVINCIAL DE REQUENA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE RIOJA">MUNICIPALIDAD PROVINCIAL DE RIOJA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE RODRIGUEZ DE MENDOZA">MUNICIPALIDAD PROVINCIAL DE RODRIGUEZ DE MENDOZA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE SAN ANTONIO DE PUTINA">MUNICIPALIDAD PROVINCIAL DE SAN ANTONIO DE PUTINA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE SAN IGNACIO">MUNICIPALIDAD PROVINCIAL DE SAN IGNACIO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE SAN MARCOS">MUNICIPALIDAD PROVINCIAL DE SAN MARCOS</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE SAN MARTIN">MUNICIPALIDAD PROVINCIAL DE SAN MARTIN</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE SAN PABLO">MUNICIPALIDAD PROVINCIAL DE SAN PABLO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE SAN ROMAN">MUNICIPALIDAD PROVINCIAL DE SAN ROMAN</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE SANCHEZ CARRION">MUNICIPALIDAD PROVINCIAL DE SANCHEZ CARRION</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE SANDIA">MUNICIPALIDAD PROVINCIAL DE SANDIA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE SANTA CRUZ">MUNICIPALIDAD PROVINCIAL DE SANTA CRUZ</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE SANTIAGO DE CHUCO">MUNICIPALIDAD PROVINCIAL DE SANTIAGO DE CHUCO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE SATIPO">MUNICIPALIDAD PROVINCIAL DE SATIPO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE SECHURA">MUNICIPALIDAD PROVINCIAL DE SECHURA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE SUCRE">MUNICIPALIDAD PROVINCIAL DE SUCRE</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE SULLANA">MUNICIPALIDAD PROVINCIAL DE SULLANA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE TACNA">MUNICIPALIDAD PROVINCIAL DE TACNA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE TALARA">MUNICIPALIDAD PROVINCIAL DE TALARA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE TAMBOPATA">MUNICIPALIDAD PROVINCIAL DE TAMBOPATA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE TARMA">MUNICIPALIDAD PROVINCIAL DE TARMA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE TAYACAJA">MUNICIPALIDAD PROVINCIAL DE TAYACAJA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE TAYACAJA-PAMPAS">MUNICIPALIDAD PROVINCIAL DE TAYACAJA-PAMPAS</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE TOCACHE">MUNICIPALIDAD PROVINCIAL DE TOCACHE</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE TRUJILLO">MUNICIPALIDAD PROVINCIAL DE TRUJILLO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE TUMBES">MUNICIPALIDAD PROVINCIAL DE TUMBES</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE UCAYALI">MUNICIPALIDAD PROVINCIAL DE UCAYALI</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE URUBAMBA">MUNICIPALIDAD PROVINCIAL DE URUBAMBA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE UTCUBAMBA">MUNICIPALIDAD PROVINCIAL DE UTCUBAMBA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE VILCASHUAMAN">MUNICIPALIDAD PROVINCIAL DE VILCASHUAMAN</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE VIRU">MUNICIPALIDAD PROVINCIAL DE VIRU</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE YAROWILCA">MUNICIPALIDAD PROVINCIAL DE YAROWILCA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE YAULI">MUNICIPALIDAD PROVINCIAL DE YAULI</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE YAUYOS">MUNICIPALIDAD PROVINCIAL DE YAUYOS</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE YUNGAY">MUNICIPALIDAD PROVINCIAL DE YUNGAY</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE YUNGUYO">MUNICIPALIDAD PROVINCIAL DE YUNGUYO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DE ZARUMILLA">MUNICIPALIDAD PROVINCIAL DE ZARUMILLA</option>
            <option value="MUNICIPALIDAD PROVINCIAL DEL CALLAO">MUNICIPALIDAD PROVINCIAL DEL CALLAO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DEL CUSCO">MUNICIPALIDAD PROVINCIAL DEL CUSCO</option>
            <option value="MUNICIPALIDAD PROVINCIAL DEL SANTA">MUNICIPALIDAD PROVINCIAL DEL SANTA</option>
            <option value="MUNICIPALIDAD PROVINCIAL GENERAL SANCHEZ CERRO">MUNICIPALIDAD PROVINCIAL GENERAL SANCHEZ CERRO</option>
            <option value="MUNICIPALIDAD PROVINCIAL JORGE BASADRE GROHMANN">MUNICIPALIDAD PROVINCIAL JORGE BASADRE GROHMANN</option>
            <option value="MUNICIPALIDAD PROVINCIAL PAUCAR DEL SARA SARA">MUNICIPALIDAD PROVINCIAL PAUCAR DEL SARA SARA</option>
            <option value="MUNICIPALIDAD PROVINCIAL SAN MIGUEL CAJAMARCA">MUNICIPALIDAD PROVINCIAL SAN MIGUEL CAJAMARCA</option>

        </select>
      </div>
      <!-- Filtro -->
      <div class="mb-3">
       <label for="Filtro" class="form-label">Filtro</label>

      <div style="display: flex">
 
          <div >Datos: </div>
          <div id="totalEncontrados"> </div>
      </div>
        
         
        
          <div class="range-filter">
            <input type="number" id="desde2" placeholder="Desde" class="form-control" min="1" value="1">
            <input type="number" id="hasta2" placeholder="Hasta" class="form-control" value="5">
          </div>
      </div>
      <div hidden id="json"></div>
      <!-- Botón de envío -->
      <button type="submit" class="btn btn-primary">Buscar</button>
    </form>
</div>


    <div class="header">
      <div class="sidebar-brand-icon rotate-n-0">
        <img src="img/logo.jpg" class="img-thumbnail">
      </div>   
    </div>
    <div hidden class="container mt-6">
      <div class="form-group">
        <label for="textoBusqueda">Texto de Búsqueda</label>
        <input
          type="text"
          class="form-control"
          id="textoBusqueda"
          placeholder="Escribe algo..."
        />
      </div>
    
    </div>
    
    <div class="container mt-6">
      <div class="table-responsive">

        <div hidden>
          <div id="totalEncontrados"></div>
          <div id="desde1"></div>
          <div id="hasta1"></div>
        </div>

        <div class="search-container">
          <input type="text" id="searchInput" placeholder="Search Sumilla..." class="form-control mb-3">
        </div>


        <button onclick="exportToExcel()">Export to Excel</button>

        <style>
body {
	font-family: 'Montserrat', sans-serif;
}

 
	    /* The switch - the box around the slider */
.switch {
  position: relative;
  display: inline-block;
  width: 60px;
  height: 34px;
}

/* Hide default HTML checkbox */
.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

/* The slider */
.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  -webkit-transition: .4s;
  transition: .4s;
}

.slider:before {
  position: absolute;
  content: "";
  height: 26px;
  width: 26px;
  left: 4px;
  bottom: 4px;
  background-color: white;
  -webkit-transition: .4s;
  transition: .4s;
}

input:checked + .slider {
  background-color: #2196F3;
}

input:focus + .slider {
  box-shadow: 0 0 1px #2196F3;
}

input:checked + .slider:before {
  -webkit-transform: translateX(26px);
  -ms-transform: translateX(26px);
  transform: translateX(26px);
}

/* Rounded sliders */
.slider.round {
  border-radius: 34px;
}

.slider.round:before {
  border-radius: 50%;
}

/* Estilos personalizados para el campo de carga de archivo */
.custom-file {
    position: relative;
    overflow: hidden;
}

/* Estilos para ocultar el campo de carga de archivo nativo */
.custom-file input[type="file"] {
    position: absolute;
    font-size: 100px; /* Hacemos el input más grande que el área visible */
    right: 0;
    top: 0;
    opacity: 0;
}

/* Estilos para la etiqueta del campo de carga de archivo */
.custom-file-label::after {
    content: "Elija un archivo"; /* Texto que se mostrará inicialmente */
}

/* Cambia el texto después de seleccionar un archivo */
.custom-file input[type="file"]:not(:disabled):not([readonly]) ~ .custom-file-label::after {
    content: "Archivo seleccionado: " attr(data-selected-file); /* Muestra el nombre del archivo seleccionado */
}



/* Agrega estilos adicionales según tus necesidades */
.form-card {
	background-color: #f8f9fa;
	padding: 20px;
	border-radius: 10px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	transition: box-shadow 0.3s ease-in-out;
}

.form-card:hover {
	box-shadow: 0 6px 8px rgba(0, 0, 0, 0.2);
}

.form-group input[type="text"],
.form-group input[type="email"],
.form-group input[type="tel"],
.form-group input[type="date"],
.form-group input[type="number"],
.form-group select {
	border: none;
	border-radius: 10px;
	padding: 10px;
	transition: box-shadow 0.3s ease-in-out;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.form-group input[type="text"]:focus,
.form-group input[type="email"]:focus,
.form-group input[type="tel"]:focus,
.form-group input[type="date"]:focus,
.form-group input[type="number"]:focus,
.form-group select:focus {
	outline: none;
	box-shadow: 0 3px 6px rgba(0, 0, 0, 0.2);
}

/* Estilo base para la tabla */
.mi-tabla {
border-collapse: collapse;
width: 100%;
max-width: 800px; /* Ajusta el ancho máximo según tu diseño */
margin: 0 auto;
background-color: #ffffff; /* Cambia el color de fondo según tu preferencia */
box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1); /* Agrega una sombra */
}

/* Estilo para las celdas de encabezado */
.mi-tabla th {
background-color: #E7F3FF; /* Cambia el color de fondo del encabezado */
color: black; /* Cambia el color del texto del encabezado a negro */
font-weight: bold;
height: 50px; /* Ajusta la altura del encabezado según tu preferencia */
text-align: center; /* Centra el texto del encabezado */
}

/* Estilo para las celdas de datos */
.mi-tabla td {
padding: 8px;
text-align: center; /* Alinea el texto al centro según tu preferencia */
}

 
/* Estilo de las filas impares (opcional) */
.mi-tabla tr:nth-child(odd) {
  background-color: #f2f2f2; /* Cambia el color de fondo de las filas impares */
}

/* Estilo de las filas al pasar el mouse */
.mi-tabla tr:hover {
  background-color: #dcdcdc; /* Cambia el color de fondo al pasar el mouse */
}

/*Filtro*/ 
    /* Agrega estilos para el modal */
    .modal {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.5);
      justify-content: center;
      align-items: center;
    }

    .modal-content {
      background-color: #fff;
      padding: 20px;
      border-radius: 5px;
    }

    /* Estilos adicionales para el botón */
    #filterBtn {
      margin: 10px 0;
      padding: 10px;
      cursor: pointer;
    }
</style>

          <button id="filterBtn" onclick="openModal()">Filtro avanzado</button>

          <!-- Modal para el filtro -->
          <div id="filterModal" class="modal">
            <div class="modal-content">
              <label for="columnSelect">Seleccione la columna:</label>
              <select id="columnSelect">
                <option value="0">Sumilla(Descripción)</option>
                <option value="1">Fuente (Instrumento de gestión ambiental / Normas)</option>
                <option value="2">Norma de aprobación</option>
                <option value="3">Denominación</option>
                <option value="4">Fecha de publicación</option>
                <option value="5">Código de Norma</option>
                <option value="6">Ruta</option>
                <option value="7">Link</option>
                <option value="8">Ver</option>
              </select>

              <label for="keywordInput">Palabras clave:</label>
              <input type="text" id="keywordInput" placeholder="Palabras clave">

              <button onclick="applyFilter()">Aceptar</button>
              <button onclick="closeModal()">Cancelar</button>
            </div>
          </div>
<!-- Contador de elementos -->
<div id="elementCount">Elementos: <span id="count">0</span></div>

          <table class="mi-tabla">
            <thead>
              <tr>
                <th class="sortable" onclick="sortTable(0)">Sumilla(Descripción)</th>
                <th class="sortable" onclick="sortTable(1)">Fuente (Instrumento de gestión ambiental / Normas)</th>
                <th class="sortable" onclick="sortTable(2)">Norma de aprobación</th>
                <th class="sortable" onclick="sortTable(3)">Denominación</th>
                <th class="sortable" onclick="sortTable(4)">Fecha de publicación</th>
                <th class="sortable" onclick="sortTable(5)">Código de Norma</th>
                <th class="sortable" onclick="sortTable(6)">Ruta</th>
                <th class="sortable" onclick="sortTable(7)">Link</th>
                <th class="sortable" onclick="sortTable(8)">Ver</th>
              </tr>
            </thead>
            <tbody id="resultados"></tbody>
          </table>
        </div>
    </div>

    <script>

      // Función para actualizar el contador de elementos
      function updateElementCount() {
          const rowCount = document.getElementById('resultados').querySelectorAll('tr').length;
          document.getElementById('count').textContent = rowCount;
        }

      // Llamada inicial para establecer el contador al cargar la página
      updateElementCount();

      function openModal() {
        document.getElementById('filterModal').style.display = 'flex';
      }

      function closeModal() {
        document.getElementById('filterModal').style.display = 'none';
      }

      function applyFilter() {
        const columnIndex = document.getElementById('columnSelect').value;
        const keyword = document.getElementById('keywordInput').value.toLowerCase();

        // Filtrar la tabla según la columna y la palabra clave
        const table = document.querySelector('.mi-tabla');
        const rows = Array.from(table.querySelectorAll('tbody tr'));

        rows.forEach(row => {
          const cellValue = row.cells[columnIndex].textContent.trim().toLowerCase();
          row.style.display = cellValue.includes(keyword) ? '' : 'none';
        });

        closeModal();
      }
    </script>

    <script>
     
      function sortTable(columnIndex) {
        const table = document.querySelector('.mi-tabla');
        const rows = Array.from(table.querySelectorAll('tbody tr'));
        const isAscending = table.rows[0].cells[columnIndex].classList.contains('sorted-asc');

        rows.sort((a, b) => {
          const aValue = a.cells[columnIndex].textContent.trim();
          const bValue = b.cells[columnIndex].textContent.trim();

          if (!isNaN(aValue) && !isNaN(bValue)) {
            return isAscending ? aValue - bValue : bValue - aValue;
          } else {
            return isAscending ? aValue.localeCompare(bValue) : bValue.localeCompare(aValue);
          }
        });

        const ascSortedHeader = table.querySelector('thead tr th.sorted-asc');
        const descSortedHeader = table.querySelector('thead tr th.sorted-desc');

        if (ascSortedHeader) {
          ascSortedHeader.classList.remove('sorted-asc');
        }

        if (descSortedHeader) {
          descSortedHeader.classList.remove('sorted-desc');
        }

        if (isAscending) {
          table.rows[0].cells[columnIndex].classList.add('sorted-desc');
          rows.reverse();
        } else {
          table.rows[0].cells[columnIndex].classList.add('sorted-asc');
        }

        const tbody = table.querySelector('tbody');
        tbody.innerHTML = '';
        rows.forEach(row => tbody.appendChild(row));
      }
 
    </script>

    <script>
      document.addEventListener('DOMContentLoaded', function() {
        var searchInput = document.getElementById('searchInput');

        searchInput.addEventListener('input', function() {
          var filter = this.value.toUpperCase();
          var tableBody = document.getElementById('resultados');
          var tr = tableBody.getElementsByTagName('tr');

          // Loop through all table rows, and hide those that don't match the search query
          for (var i = 0; i < tr.length; i++) {
            var td = tr[i].getElementsByTagName('td')[0]; // Index 0 for the first column
            if (td) {
              var txtValue = td.textContent || td.innerText;
              if (txtValue.toUpperCase().indexOf(filter) > -1) {
                tr[i].style.display = '';
              } else {
                tr[i].style.display = 'none';
              }
            }
          }
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

      function consultarAPI(data) {
        const url = "https://spijwsii.minjus.gob.pe/spij-ext-solr/api/buscar";
        const token =
          "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzcGlqZXh0IiwidGlwbyI6IjEiLCJleHAiOjE2OTYxOTA4NzIsImlhdCI6MTY5NjEwNDQ3Mn0.WIw0j7EJFVXBoxVz8AnHPQgoS39rBI_Lo1r9yyLAxes";
        const valorInput = document.getElementById("textoBusqueda").value;
        const textBusqueda = valorInput ? valorInput : null;
        console.log("el valor de la data es :"+data)
        let body = JSON.stringify({
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
          hasta: 10,
        });
        if(data !== undefined){
          console.log(data);
      
          body = data;
          console.log(data);
        } 
       

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
            const cantidad = data.totalEncontrados;
            const resultados = data.resultados;
            const desde = data.desde;
            const hasta = data.hasta;
            console.log(desde)
            console.log(hasta)
            document.getElementById('totalEncontrados').textContent = cantidad;
            document.getElementById('desde1').textContent = desde;
            document.getElementById('hasta1').textContent = hasta;
            const resultadosContainer = document.getElementById("resultados");

            resultadosContainer.innerHTML = "";

      
            resultados.forEach((resultado) => {
                const row = document.createElement("tr");

                const aspectoAmbiental = document.createElement("td");
                aspectoAmbiental.textContent = resultado.sumilla.replace(/<[^>]*>/g, '');
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

      function exportToExcel() {
        // Get the table element
        let table = document.querySelector('.table');

        // Convert the table to a workbook
        let workbook = XLSX.utils.table_to_book(table, {sheet: "Sheet1"});

        // Define filename for the Excel file
        let filename = 'exported_table.xlsx';

        // Write the workbook and initiate download
        XLSX.writeFile(workbook, filename);
      }
    </script>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>


</body>
</html>


<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>

<!-- Select2 JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>

<!-- Bootstrap JS -->
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>

<script>
    $(document).ready(function() {
  const dispositivoLegal = [
    "ACUERDO", "ANEXO", "DECRETO DE ALCALDIA", "DECRETO REGIONAL", "DECRETOS VARIOS",
    "RESOLUCION VARIAS", "RESOLUCION JEFATURAL", "RESOLUCION EJECUTIVA", "RESOLUCION DIRECTORAL",
    "RESOLUCION DE ALCALDIA", "RESOLUCION ADMINISTRATIVA", "ORDENANZA", "FE DE ERRATAS",
    "EDICTO", "DIRECTIVA"
  ];

  // Inicializar select2
  $('.select2-multiple').select2({
    placeholder: "Seleccione y/o digite",
    data: dispositivoLegal.map((item, index) => {
      return { id: index, text: item };
    })
  });
});

  // Función para obtener los valores seleccionados
  function obtenerValoresSeleccionados() {
    var valoresSeleccionados = $('#entrada').select2('data');
    return valoresSeleccionados.map(function(item) {
      return item.text;
    });
  }

</script>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    // Inicializar Select2
   // $('#sector').select2();
  });

 
  // Asignar un evento 'submit' al formulario
document.querySelector('form').addEventListener('submit', function(event) {
  event.preventDefault(); // Previene el envío del formulario
 
  function toJSONDisplay(jsonObj) {
  // Convert JSON object to string
  let jsonString = JSON.stringify(jsonObj, null, 2);

  // Remove quotes from keys in JSON string
  let displayString = jsonString.replace(/"([^"]+)":/g, '$1:');

  return displayString;
}

// Function to get selected values, replace this with your actual implementation
function obtenerValoresSeleccionados(id) {
  // This is a placeholder function. You should replace it with your actual function
  // that retrieves the selected values for the given id.
  var selected = document.querySelectorAll(`#${id} option:checked`);
  var values = Array.from(selected).map(el => el.value);
  return values;
}

  const desdeInput = document.getElementById('desde2').value;
  const hastaInput = document.getElementById('hasta2').value;
  // Crear el objeto base para el JSON
  var jsonData = {
  filtros: {
    buscarHistorico: false,
    busquedaSugerida: false,
    numeroDispositivoLegal: document.getElementById('numeroNorma').value,
    dispositivoLegal:  obtenerValoresSeleccionados(), // Asumiendo que se llenará después con valores apropiados
    tomo: { id: "" , nombre: "" },
    materia: { id: "" , nombre: ""  },
    agrupacion: ["LEGISLACIÓN EMITIDA POR GOBIERNOS LOCALES Y REGIONALES"], // Asumiendo que se llenará después con valores apropiados
    sector:  obtenerValoresSeleccionados('sector').length === 1 && obtenerValoresSeleccionados('sector')[0] === "" ? [] : obtenerValoresSeleccionados('sector'),
    subSector: { id: "" , nombre: ""  },
    orden:  getOrdenValue()
  },
  facetsSeleccionadas: {
    fechaPublicacionGap: { numero: 10, unidad: "YEAR" }
  },
  tipoNorma: "NR",
  textoBusqueda: document.getElementById('contenido').value === "" ? null : document.getElementById('contenido').value,
  textoSumilla: document.getElementById('sumillas').value === "" ? null : document.getElementById('sumillas').value,
  desde: parseInt(desdeInput, 10),
    hasta: parseInt(hastaInput, 10),
};

 


function getOrdenValue() {
  var ordenSelect = document.getElementById('ordenarPor');
  var selectedValue = ordenSelect.options[ordenSelect.selectedIndex].value;
  return selectedValue !== "Elige una opción" ? selectedValue : "1"; // Default to "1"
}

document.getElementById('ordenarPor').addEventListener('change', function() {
  jsonData.filtros.orden = getOrdenValue();
});


var selectedSectors = document.querySelectorAll('#sector option:checked');
var values = Array.from(selectedSectors).map(el => el.value).filter(value => value !== "");
jsonData.filtros.sector = values.length > 0 ? values : [];

  // Imprimir el objeto JSON en el div con id 'json'
  document.getElementById('json').textContent = JSON.stringify(jsonData, null, 2);
 
  const data =  document.getElementById('json').textContent;
        console.log(data);
      
        consultarAPI(data);
});
</script>
<script>
  function toggleSidebar() {
    var sidebar = document.getElementById("sidebar");
    if (sidebar.style.width === "300px") {
        sidebar.style.width = "0";
    } else {
        sidebar.style.width = "300px";
    }
}
</script>

 