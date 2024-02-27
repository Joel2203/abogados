<?php include_once "includes/header.php"; ?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Normas y Sumillas del Día</title>
 
    <style>
        .custom-box {
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 150px;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <div class="container d-flex justify-content-center align-items-center vh-100">
        <div class="custom-box">
            <h1 class="mb-4">Normas del Día</h1>
            <form id="form" class="mb-4">
                <div class="mb-3">
                    <label for="fecha" class="form-label">Seleccione una fecha:</label>
                    <input type="date" id="fecha" class="form-control" required   max="<?php echo date('Y-m-d'); ?>">
                </div>
                <button type="submit" class="btn btn-primary">Generar Enlace de Normas</button>
            </form>
            <div id="resultadoNormas"></div>
            <hr>
            <h1 class="mb-4">Sumillas del Día</h1>
            <form id="sumillas-form" class="mb-4">
                <div class="mb-3">
                    <label for="fechaSumillas" class="form-label">Seleccione una fecha:</label>
                    <input type="date" id="fechaSumillas" class="form-control" required   max="<?php echo date('Y-m-d'); ?>">
                </div>
                <button type="submit" class="btn btn-primary">Generar Enlace de Sumillas</button>
            </form>
            <div id="resultadoSumilla"></div>
        </div>
    </div>

    <script>
        document.getElementById('form').addEventListener('submit', function(e) {
            e.preventDefault();

            var fechaInput = document.getElementById('fecha').value;
            if (!fechaInput) {
                alert('Por favor, seleccione una fecha.');
                return;
            }

            var fechaParts = fechaInput.split('-');
            var dia = fechaParts[2];
            var mes = fechaParts[1];
            var anio = fechaParts[0].substring(2);

            var fechaFormateada = dia + mes + anio;

            var resultadoNormas = document.getElementById('resultadoNormas');
            resultadoNormas.innerHTML = 'Fecha en formato ddmmyy: ' + fechaFormateada;

            var nuevoEnlace = "http://spij.minjus.gob.pe/Normas/textos/" + fechaFormateada + "T.pdf";
            window.open(nuevoEnlace, '_blank');
        });

        document.getElementById('sumillas-form').addEventListener('submit', function(e) {
            e.preventDefault();

            var fechaSumillasInput = document.getElementById('fechaSumillas').value;
            if (!fechaSumillasInput) {
                alert('Por favor, seleccione una fecha para las Sumillas.');
                return;
            }

            var fechaSumillasParts = fechaSumillasInput.split('-');
            var diaSumillas = fechaSumillasParts[2];
            var mesSumillas = fechaSumillasParts[1];
            var anioSumillas = fechaSumillasParts[0].substring(2);

            var fechaSumillasFormateada = diaSumillas + mesSumillas + anioSumillas;

            var resultadoSumilla = document.getElementById('resultadoSumilla');
            resultadoSumilla.innerHTML = 'Fecha en formato ddmmyy para sumillas: ' + fechaSumillasFormateada;

            var nuevoEnlace = "http://spij.minjus.gob.pe/Normas/sumillas/" + fechaSumillasFormateada + "S.pdf";
            window.open(nuevoEnlace, '_blank');
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
 
</body>
</html>

<?php include_once "includes/footer.php"; ?>