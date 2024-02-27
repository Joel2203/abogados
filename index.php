<?php
$alert = '';
session_start();
if (!empty($_SESSION['active'])) {
  header('location: sistema/');
} else {
  if (!empty($_POST)) {
    if (empty($_POST['usuario']) || empty($_POST['clave'])) {
      $alert = '<div class="alert alert-danger" role="alert">
  Ingrese su usuario y su clave
</div>';
    } else {
      require_once "conexion.php";
      $user = mysqli_real_escape_string($conexion, $_POST['usuario']);
      $clave = md5(mysqli_real_escape_string($conexion, $_POST['clave']));
      $query = mysqli_query($conexion, "SELECT u.idusuario, u.nombre, u.correo,u.usuario,r.idrol,r.rol FROM usuario u INNER JOIN rol r ON u.rol = r.idrol WHERE u.usuario = '$user' AND u.clave = '$clave'");
      mysqli_close($conexion);
      $resultado = mysqli_num_rows($query);
      if ($resultado > 0) {
        $dato = mysqli_fetch_array($query);
        $_SESSION['active'] = true;
        $_SESSION['idUser'] = $dato['idusuario'];
        $_SESSION['nombre'] = $dato['nombre'];
        $_SESSION['email'] = $dato['correo'];
        $_SESSION['user'] = $dato['usuario'];
        $_SESSION['rol'] = $dato['idrol'];
        $_SESSION['rol_name'] = $dato['rol'];
        header('location: sistema/');
      } else {
        $alert = '<div class="alert alert-danger" role="alert">
              Usuario o Contraseña Incorrecta
            </div>';
        session_destroy();
      }
    }
  }
}
?>
<!DOCTYPE html>
<html lang="en">

<head>

  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">
  <link rel="icon" href="img/logo.jpg">

  <title>Virtual Business</title>

  <!-- Custom fonts for this template-->
  <link href="sistema/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  <!-- Custom styles for this template-->
  <link href="sistema/css/sb-admin-2.min.css" rel="stylesheet">
  <link rel="icon" href="img/logo.jpg">

<!-- Agrega cualquier otro estilo o fuente que desees utilizar -->
<style>
        body {
            background-color: #f8f9fa; /* Color de fondo */
            height: 100vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card {
            border: none;
            border-radius: 15px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            max-width: 500px;
        }

        .card-img {
            width: 100%;
            height: auto;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }

        .card-body {
            padding: 30px;
            flex-grow: 1;
        }

        .login-title {
            font-size: 28px;
            font-weight: 700;
            color: #333;
            text-align: center;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-control {
            border-radius: 15px;
            padding: 15px;
            font-size: 18px;
        }

        .btn-primary {
            background-color: #C01E1E;
            border: none;
            border-radius: 15px;
            padding: 15px;
            font-size: 20px;
            font-weight: 600;
        }

        .btn-primary:hover {
            background-color: #0056b3;
        }
    </style>

</head>

<body class="bg-gradient-primary">

<div class="card shadow-lg">
    <img src="sistema/img/logo.jpg" class="card-img" alt="Logo">
    <div class="card-body">
        <h1 class="login-title">Iniciar Sesión</h1>
        <form class="user" method="POST">
            <?php echo isset($alert) ? $alert : ""; ?>
            <div class="form-group">
                <input type="text" class="form-control" placeholder="Usuario" name="usuario">
            </div>
            <div class="form-group">
                <input type="password" class="form-control" placeholder="Contraseña" name="clave">
            </div>
            <input type="submit" value="Iniciar Sesión" class="btn btn-primary btn-block">
        </form>
    </div>
</div>

  <!-- Bootstrap core JavaScript-->
  <script src="sistema/vendor/jquery/jquery.min.js"></script>
  <script src="sistema/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

  <!-- Core plugin JavaScript-->
  <script src="sistema/vendor/jquery-easing/jquery.easing.min.js"></script>

  <!-- Custom scripts for all pages-->
  <script src="sistema/js/sb-admin-2.min.js"></script>

</body>

</html>