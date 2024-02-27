<?php include_once "includes/header.php"; ?>

<?php 
if(isset($_GET['id'])) {
  // Obtiene el valor de 'id'
  $id = $_GET['id'];
  
  // Aquí puedes usar la variable $id como necesites
  echo "El valor de 'id' es: " . $id;
} else {
  echo "No se proporcionó el valor de 'id'";
}
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Conversor a Word y PDF</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.4.0/jspdf.umd.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet">

 

    <!-- Bootstrap JS (Opcional, si necesitas funcionalidades JS de Bootstrap) -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.0.7/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

  </head>
  <style>
    body {
      font-family: 'Montserrat', sans-serif;
    }
    .WordSection1 {
    padding: 40px;
    border: 1px solid #ccc;
    border-radius: 10px;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
    background-color: #f9f9f9;
    font-family: Arial, sans-serif;
  }

  .table-bordered {
    border: 1px solid #ddd;
    background-color: #fff; /* Fondo blanco */
  }

  .table-bordered td {
    border: 1px solid #ddd;
    padding: 20px;
  }

  .table-bordered th {
    border: 1px solid #ddd;
    padding: 8px;
    background-color: #f2f2f2;
    color: #333; /* Color de texto oscuro */
  }
  button {
      font-family: 'Montserrat', sans-serif;
      font-size: 10px;
      padding: 8px 16px;
      background-color: #774642;
      color: #fff;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    .modal {
    display: none;
    position: fixed;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgb(0,0,0);
    background-color: rgba(0,0,0,0.4);
    padding-top: 60px;
  }

  .modal-content {
    background-color: #fefefe;
    margin: 5% auto;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
  }

  .close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
  }

  .close:hover,
  .close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
  }

  </style>
  <body>
    <button id="convertToWord">Convertir a Word</button>
    <button id="convertToPDF">Convertir a PDF</button>
    <button onclick="location.reload();">Recargar</button>
    <button onclick="openModal()">Fuentes</button>

    <!-- El modal -->
    <div id="myModal" class="modal">
      <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <label for="fontType">Tipo de Fuente:</label>
        <select id="fontType">
          <option value="Arial, sans-serif">Arial</option>
          <option value="'Times New Roman', serif">Times New Roman</option>
          <option value="'Courier New', monospace">Courier New</option>
          <option value="Montserrat, sans-serif">Montserrat</option>
        </select><br><br>
        <label for="fontSize">Tamaño de Letra:</label>
        <input type="number" id="fontSize" value="15"><br><br>
        <button onclick="applyChanges()">Aceptar</button>
      </div>
    </div>
     <!-- Resumir -->
     <div id="myModalResomer" class="modal">
      <div class="modal-content">

        <span class="close" onclick="closeModal1(); ">&times;</span>

 

          <div id="ResumirText"></div>
      </div>
    </div>

    <button onclick="window.history.back()">Atrás</button>

    <div class="WordSection1">
      <!-- El contenido se llenará aquí -->
    </div>
    <div id="summarizeText">
      <!-- El contenido se llenará aquí -->
    </div>
 
    <script>
       var id = "<?php echo $id ?>";
      fetch(
        "https://spijwsii.minjus.gob.pe/spij-ext-back/api/procesarword/"+id
      )
        .then((response) => response.text())
        .then((data) => {
  var parser = new DOMParser();
  var doc = parser.parseFromString(data, "text/html");

  // Extraer el contenido de las etiquetas <p> en el documento
  var paragraphs = Array.from(doc.querySelectorAll(".MsoNormal"));

  paragraphs.forEach((paragraph) => {
    var text = paragraph.textContent || paragraph.innerText;

    if (text.includes("Artículo Primero") || 
        text.includes("Artículo Segundo") || 
        text.includes("Artículo Tercero") || 
        text.includes("Artículo Cuarto") || 
        text.includes("Artículo Quinto") || 
        text.includes("Artículo Sexto")  || 
        text.includes("Artículo Séptimo") ||
        text.includes("Artículo Octavo") ||
        text.includes("Artículo Noveno") ||
        text.includes("Artículo Decimo")     ) {
      
      var table = document.createElement("table");
      table.classList.add("table", "table-bordered");

      var row = document.createElement("tr");
      var cell = document.createElement("td");
      cell.innerHTML = text.replace(/&nbsp;|<span lang="ES-MX" style="font-size:10\.0pt;font-family:Arial,sans-serif"><\/span>/g, ''); // Eliminar &nbsp; y span vacío
      row.appendChild(cell);
      table.appendChild(row);

      // Agregar la tabla al elemento con clase "WordSection1"
      var wordSection1 = document.querySelector(".WordSection1");
      wordSection1.appendChild(table);
    } else {
      // Agregar el párrafo normal
      var paragraphElement = document.createElement("p");
      paragraphElement.innerHTML = paragraph.innerHTML;

      // Eliminar &nbsp; y span vacío del párrafo
      paragraphElement.innerHTML = paragraphElement.innerHTML.replace(/&nbsp;|<span lang="ES-MX" style="font-size:10\.0pt;font-family:Arial,sans-serif"><\/span>/g, '');

      // Agregar el párrafo al elemento con clase "WordSection1"
      var wordSection1 = document.querySelector(".WordSection1");
      wordSection1.appendChild(paragraphElement);
    }
  });
});

      function openResumen() {
     
        var content = $(".WordSection1").html(); // Obtén el contenido

        var contentSinHTMLyNBSP = eliminarEtiquetasHTML(content); // Elimina etiquetas HTML

        // Crea un nuevo objeto FormData
        var formData = new FormData();

        // Añade los campos al formData
        formData.append('lang', 'es');
        formData.append('data', contentSinHTMLyNBSP);
        formData.append('countWord', '100');
        formData.append('percnt', '5');
        formData.append('min_length', '100');
        formData.append('max_length', '200');
        formData.append('sorder', 'no');
        formData.append('captcha', '');
        formData.append('mode', '1');


        event.preventDefault(); // Previene la acción por defecto del formulario

        fetch(
          "https://cors-anywhere.herokuapp.com/https://www.paraphraser.io/frontend/summarizerBeta",
          {
            method: "POST",
            body: formData,
          }
        )
          .then((response) => response.json())
          .then((data) => {
            const extract = data.result;
            const jsonObject = JSON.parse(extract);

            const contentText = jsonObject.content.replace(
              /[^a-zA-Z0-9áéíóúüñÁÉÍÓÚÜÑ\s.,;:()"-]/g,
              ""
            );
            console.log(contentText);

            document.getElementById("ResumirText").innerHTML = contentText;
            // Mostrar el contenido en el modal
            //mostrarEnModal(contentText);
          });
      }

      function openModal1() {
        var modal = document.getElementById("myModalResomer");
        modal.style.display = "block";
        openResumen();
      }

      function closeModal1() {
        var modal = document.getElementById("myModalResomer");
        modal.style.display = "none";
      }
 
      function openModal() {
        var modal = document.getElementById("myModal");
        modal.style.display = "block";
      }

      function closeModal() {
        var modal = document.getElementById("myModal");
        modal.style.display = "none";
      }

      function applyChanges() {
        var fontType = document.getElementById("fontType").value;
        var fontSize = document.getElementById("fontSize").value;

        var wordSection1 = document.querySelector(".WordSection1");
        wordSection1.style.fontFamily = fontType;
        wordSection1.style.fontSize = fontSize + "px";

        const casteado = "";

        var spans = wordSection1.querySelectorAll('span[style*="font-size:10.0pt;font-family:Arial,sans-serif"]');
     
         spans.forEach(function(span) {
      var style = span.getAttribute("style");
      var styleArray = style.split(";");
      var fontStyles = styleArray.filter(function(style) {
        return style.includes("font-family") || style.includes("font-size");
      }).join("; ");
      
    
      
      span.style.fontSize = fontSize + "px";
      span.style.fontFamily = fontType;
      span.style.display = "block"; // Hacer que los spans se muestren en bloques separados
    });

        closeModal();
      }

 

      // Funciones de conversión
      $("#convertToWord").click(function () {
        var content = $(".WordSection1").html();
        var contentSinHTMLyNBSP = eliminarEtiquetasHTML(content); // Aplicar función de eliminación
        var blob = new Blob([contentSinHTMLyNBSP], {
          type: "application/msword",
        });
        var link = document.createElement("a");
        link.href = window.URL.createObjectURL(blob);
        link.download = "documento.doc";
        link.click();
      });

      $("#convertToPDF").click(function () {
        window.print();
      });

      $("#summarize").click(function () {
        var textoConHTML = $(".WordSection1").html();
        var textoSinHTMLyNBSP = eliminarEtiquetasHTML(textoConHTML);
        console.log("@BruCorp");
        console.log(textoSinHTMLyNBSP);

        var requestOptions = {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer gAAAAABlLERPslMMt4aE9-yrMZlC42x9Zo-gD9pqyfA9sPggvXPoafG89-hGEW_QKhYlyvPH-bS01vSqEUntbWl8t772iET-VacDW9Xx4PV82xoeycGhAFzQj6pjYC3ovzCzUGMqeIW-'
                },
                body: JSON.stringify({
                    "max_tokens": 512,
                    "mode": "default",
                    "model": "gpt-3.5-turbo-16k",
                    "n": 1,
                    "source_lang": "es",
                    "target_lang": "es",
                    "temperature": 0.7,
                    "text": textoSinHTMLyNBSP
                })
            };

            fetch('https://api.textcortex.com/v1/texts/summarizations', requestOptions)
            .then(response => response.json())
            .then(data => {
                var textResult = data.data.outputs[0].text; // Obtiene el texto del resultado
                document.getElementById('summarizeText').innerHTML = '<h2>Resultado:</h2>' + textResult;
                  // Muestra el resultado en el HTML
            })
            .catch(error => console.error('Error:', error));
      });
    </script>

    <script>
      function eliminarEtiquetasHTML(texto) {
        // Primero, eliminamos las etiquetas HTML
        var textoSinHTML = texto.replace(/<\/?[^>]+(>|$)/g, "");

        // Luego, eliminamos los &nbsp;
        return textoSinHTML.replace(/&nbsp;/g, "");
      }

     
     
    </script>
  </body>
</html>

<?php include_once "includes/footer.php"; ?>