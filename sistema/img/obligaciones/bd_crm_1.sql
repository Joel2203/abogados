-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 01-02-2024 a las 17:04:08
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bd_crm_1`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_precio_producto` (IN `n_cantidad` INT, IN `n_precio` DECIMAL(10,2), IN `codigo` INT)   BEGIN
DECLARE nueva_existencia int;
DECLARE nuevo_total decimal(10,2);
DECLARE nuevo_precio decimal(10,2);

DECLARE cant_actual int;
DECLARE pre_actual decimal(10,2);

DECLARE actual_existencia int;
DECLARE actual_precio decimal(10,2);

SELECT precio, existencia INTO actual_precio, actual_existencia FROM producto WHERE codproducto = codigo;

SET nueva_existencia = actual_existencia + n_cantidad;
SET nuevo_total = n_precio;
SET nuevo_precio = nuevo_total;

UPDATE producto SET existencia = nueva_existencia, precio = nuevo_precio WHERE codproducto = codigo;

SELECT nueva_existencia, nuevo_precio;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_detalle_temp` (`codigo` INT, `cantidad` INT, `token_user` VARCHAR(50))   BEGIN
DECLARE precio_actual decimal(10,2);
SELECT precio INTO precio_actual FROM producto WHERE codproducto = codigo;
INSERT INTO detalle_temp(token_user, codproducto, cantidad, precio_venta) VALUES (token_user, codigo, cantidad, precio_actual);
SELECT tmp.correlativo, tmp.codproducto, p.descripcion, tmp.cantidad, tmp.precio_venta FROM detalle_temp tmp INNER JOIN producto p ON tmp.codproducto = p.codproducto WHERE tmp.token_user = token_user;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `data` ()   BEGIN
    DECLARE usuarios INT;
    DECLARE clientes INT;
    DECLARE proveedores INT;
    DECLARE productos INT;
    DECLARE ventas INT;

    SELECT COUNT(*) INTO usuarios FROM usuario;
    SELECT COUNT(*) INTO clientes FROM cliente;
    SELECT COUNT(*) INTO proveedores FROM proveedor;
    SELECT COUNT(*) INTO productos FROM producto;
    SELECT COUNT(*) INTO ventas FROM factura WHERE fecha > CURDATE();

    SELECT usuarios, clientes, proveedores, productos, ventas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRol` (IN `idrol1` INT)   BEGIN
  DECLARE existUsuario INT;
  DECLARE existRolxPermiso INT;

 -- Verificar si el idRol existe en la tabla de usuarios
  IF EXISTS (SELECT * FROM usuario WHERE rol = idrol1) THEN
    SELECT 'El rol no puede ser eliminado. Existen usuarios asignados a este rol.' AS Mensaje;
  ELSE
        IF (SELECT count(*) FROM usuario WHERE rol = idrol1) > 0 THEN
    SELECT 'No se puede eliminar el rol. Hay usuarios asignados a este rol.' AS Mensaje;
  ELSE
    -- Eliminar el rolxpermiso correspondiente al idRol
    DELETE FROM rolxpermisos WHERE idRol = idrol1;
    
    -- Eliminar el rol
    DELETE FROM rol WHERE idRol = idrol1;
  END IF;  
  
    SELECT 'El rol fue eliminado correctamente.' AS Mensaje;
  END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `del_detalle_temp` (`id_detalle` INT, `token` VARCHAR(50))   BEGIN
DELETE FROM detalle_temp WHERE correlativo = id_detalle;
SELECT tmp.correlativo, tmp.codproducto, p.descripcion, tmp.cantidad, tmp.precio_venta FROM detalle_temp tmp INNER JOIN producto p ON tmp.codproducto = p.codproducto WHERE tmp.token_user = token;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procesar_venta` (IN `cod_usuario` INT, IN `cod_cliente` INT, IN `token` VARCHAR(50))   BEGIN
DECLARE factura INT;
DECLARE registros INT;
DECLARE total DECIMAL(10,2);
DECLARE nueva_existencia int;
DECLARE existencia_actual int;

DECLARE tmp_cod_producto int;
DECLARE tmp_cant_producto int;
DECLARE a int;
SET a = 1;

CREATE TEMPORARY TABLE tbl_tmp_tokenuser(
	id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cod_prod BIGINT,
    cant_prod int);
SET registros = (SELECT COUNT(*) FROM detalle_temp WHERE token_user = token);
IF registros > 0 THEN
INSERT INTO tbl_tmp_tokenuser(cod_prod, cant_prod) SELECT codproducto, cantidad FROM detalle_temp WHERE token_user = token;
INSERT INTO factura (usuario,codcliente) VALUES (cod_usuario, cod_cliente);
SET factura = LAST_INSERT_ID();

INSERT INTO detallefactura(nofactura,codproducto,cantidad,precio_venta) SELECT (factura) AS nofactura, codproducto, cantidad,precio_venta FROM detalle_temp WHERE token_user = token;
WHILE a <= registros DO
	SELECT cod_prod, cant_prod INTO tmp_cod_producto,tmp_cant_producto FROM tbl_tmp_tokenuser WHERE id = a;
    SELECT existencia INTO existencia_actual FROM producto WHERE codproducto = tmp_cod_producto;
    SET nueva_existencia = existencia_actual - tmp_cant_producto;
    UPDATE producto SET existencia = nueva_existencia WHERE codproducto = tmp_cod_producto;
    SET a=a+1;
END WHILE;
SET total = (SELECT SUM(cantidad * precio_venta) FROM detalle_temp WHERE token_user = token);
UPDATE factura SET totalfactura = total WHERE nofactura = factura;
DELETE FROM detalle_temp WHERE token_user = token;
TRUNCATE TABLE tbl_tmp_tokenuser;
SELECT * FROM factura WHERE nofactura = factura;
ELSE
SELECT 0;
END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `account`
--

CREATE TABLE `account` (
  `idAccount` int(11) NOT NULL,
  `cuenta` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `ciudad` varchar(255) DEFAULT NULL,
  `contacto_principal` varchar(255) DEFAULT NULL,
  `secot` varchar(255) DEFAULT NULL,
  `propietario` varchar(255) DEFAULT NULL,
  `origen_cliente` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `account`
--

INSERT INTO `account` (`idAccount`, `cuenta`, `direccion`, `ciudad`, `contacto_principal`, `secot`, `propietario`, `origen_cliente`) VALUES
(1, 'A & G Seguridad Integral Sociedad Anonima Cerrada', 'LOS PRECURSORES NRO. 485 (ALT DE LA CDRA 3 AV FAUCETT) LIMA - LIMA - SAN MIGUEL', 'Lima', 'Joel Julca', 'Servicios', 'Mia Arecco', 'Generación'),
(2, 'Oficinas Integrales', 'Lima', '', '', '', '', ''),
(3, 'AB Technology SAC', 'Calle Marcela Castro 634 Urb. Tupac Amaru San Luis', 'Lima', 'Erick Vivas', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Marca'),
(4, 'ACADEMIC COMMUNITY CENTRO DE CAPACITACIÓN ALTA DIRECCIÓN Y ESPECIALIZACIÓN MULTIDISCIPLINARIA S.A.C.', 'ISLA SANTA LUCIA MZA. F4 LOTE. 5 DPTO. 301 URB. LOS CEDROS DE VILLA', 'Lima', 'DE LA CRUZ UCEDA, CHRISTIAM MEDARDO', 'Educación', 'Mia Arecco', 'Generación'),
(5, 'Adecco Peru S.A', 'Av. Circunvalacion Club Golf Nro. 206', 'Lima', 'Geraldine Fierro Yantas', 'Servicios', 'Mia Arecco', 'Marketing Last Call'),
(6, 'Administración Y Gerencia En Minería Y Construcción Sociedad Anónima Cerrada - Adgeminco', 'Cal.Fermin Tanguis Nro. 145 Dpto. 1101 Urb. Santa Catalina La Victoria', 'Lima', 'Jorge Ojeda', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(7, 'Alimentos Procesados Frescos Y Congelados S.A.C.', 'Car.Autop. Panam. Sur Km. 18.5 Z.I. La Concordia Lima - Lima - Chorrillos', 'Lima', 'Rafael Aljovín', 'Alimenticia', 'Mia Arecco', 'Generación'),
(8, 'Alquimodul Sociedad Anonima Cerrada', 'CAL.PROLONGACION RAMON CASTILLA MZA. G LOTE. 31 FND. EX FUNDO LAS SALINAS LIMA - LIMA - LURIN', 'LIMA', 'Ronel Chauca', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(9, 'Alsavi S.A.C.', 'JR. DOMINGO MARTINEZ LUJAN NRO. 935 (ANTES JR SAN FELIPE 935) LIMA - LIMA - SURQUILLO', 'LIMA', 'Jult Pareja', 'Transporte', 'Mia Arecco', 'Generación'),
(10, 'Altasalud S.A.C.', 'AV. DEL PARQUE SUR NRO. 325 URB. CORPAC LIMA - LIMA - SAN ISIDRO', 'LIMA', 'César Vasquez', 'Salud', 'Mia Arecco', 'Generación'),
(11, 'Amg-Auplata Mining Group Peru S.A.C.', 'Av. Alfredo Benavides Nro. 1555 Int. 403, Miraflores', 'Lima', 'Guillermo Vegas', 'Industrial', 'Mia Arecco', 'Generación'),
(12, 'Amilla Ingenieros', 'Calle Alicante125 Mayorazgo Ate', 'Lima', 'Anthony Alcalá', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Marca'),
(13, 'Ancro S.R.L.', 'Av. Los Cipreses Nro. 250 Urb. Los Ficus', 'Lima', 'Gustavo Medina', 'Otro', 'Mia Arecco', 'Generación'),
(14, 'Anders Perú S.A.C.', 'paseo del bosque 500 oficina 301santiago de surco', 'Lima', 'Manuel Otero', 'Industrial', 'Mia Arecco', 'Generación'),
(15, 'Andes Seguridad S.A.C.', 'CAL.DEAN SAAVEDRA NRO. 170 URB. MARANGA (AL COSTADO DEL ICPNA DE AV. LA MARINA) LIMA - LIMA - SAN MIGUEL', 'Lima', 'Guillermo Llamoja', 'Servicios', 'Mia Arecco', 'Generación'),
(16, 'Anypsa Corporation S.A.', 'Car.Chillon Trapiche Mza. S/N Lote. 69 Urb. Los Huertos De Tungasuca Carabayllo', 'Lima', 'Nemecio Torvisco Palomino', 'Industrial', 'Mia Arecco', 'Generación'),
(17, 'Aom Suministros Industriales', 'JR. CRUZ DEL SUR NRO. 140 INT. 1503 URB. LOS GRANADOS LIMA - LIMA - SANTIAGO DE SURCO', 'Lima', 'Jorge Maldonado', 'Industrial', 'Mia Arecco', 'Generación'),
(18, 'Arbe Abogados Sociedad Anonima Cerrada', 'Cal. Amador Merino Reyna Nro. 307 Int. 1101 (Interior 1101a - Edificio Nacional)', 'Lima', 'Jorge Luis Maldonado', 'Servicios', 'Mia Arecco', 'Generación'),
(19, 'Arcotecho Peru S.A.C', 'Av. Circunvalacion Club Golf Los Incas Nro. 206 Int. 806a Santiago De Surco', 'Lima', 'Oscar Segura', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(20, 'Arellano investigación De Marketing S.A.', 'Av. Paseo De La Republica Nro. 3952 Miraflores', 'Lima', 'Iván Arturo Velásquez Ríos', 'Servicios', 'Mia Arecco', 'Generación'),
(21, 'Ascensores Gs&F Sociedad Anonima Cerrada', 'CAL.RICARDO ANGULO NRO. 856 URB. CORPAC (MINISTERIO DEL INTERIOR) LIMA - LIMA - SAN ISIDRO', 'Lima', 'Carlos LLanos', 'Industrial', 'Mia Arecco', 'Generación'),
(22, 'Asociación Deportiva Los Inkas Golf Club', 'Av. Circunvalacion Del Golf Nro. 950 Res. Monterrico (Circunvalacion Del Golf Los Inkas 950) Santiago De Surco', 'Lima', 'César Chambergo', 'Servicios', 'Mia Arecco', 'Generación'),
(23, 'Astah S.A.C.', 'Mza. H16 Lote. 5f Urb. Las Delicias De Villa Chorrillos', 'Lima', 'Omar Hernandez Int TI', 'Servicios', 'Mia Arecco', 'Generación'),
(24, 'Aviation Security Group', 'Av. del Pinar 180 oficina 403 Chacarilla del estanque, Santiago de Surco', 'Lima', 'Ivan Ortiz', 'Servicios', 'Mia Arecco', 'Generación'),
(25, 'Axis Gl Agencia de Aduana S.A.C', 'Jr. Huandoy Nro. 594 Int. 3pis (3er Piso.) San Miguel', 'LIMA', 'Cristopher More', 'Transporte', 'Mia Arecco', 'Generación'),
(26, 'B & L Asociados', 'San Martin 472, Miraflores', 'Lima', 'Miguel Chávez', 'Servicios', 'Mia Arecco', 'Generación'),
(27, 'B Motors S.A.C.', 'Sub Sector 6a Mza. M1 Lote. 15a C.H. Monserrate - Iv Etapa (Av. Costa Rica) La Libertad Trujillo', 'Trujillo', 'Hans Barboza', 'Servicios', 'Mia Arecco', 'Generación'),
(28, 'Bafur S C R Ltda', 'Jr. Julian Arias Araguez Nro. 250, Miraflores', 'Lima', 'Erick Huaricallo', 'Servicios', 'Mia Arecco', 'Generación'),
(29, 'Bastis S.R.L', 'AV. JAVIER PRADO ESTE NRO. 444 INT. 1902 (FRENTA A LA CLINICA JAVIER PRADO) LIMA - LIMA - SAN ISIDRO', 'Lima', 'Luis Zapana', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(30, 'Bcd Travel S.A.', 'Av. Alfredo Benavides Nro. 1850 Urb. El Rosedal (Piso 9) Miraflores', 'Lima', 'Dany Rodriguez', 'Servicios', 'Mia Arecco', 'Generación'),
(31, 'Begas Ingenieros SAC', 'Calle Montecarlo 167 San Miguel', 'Lima', 'César Rivera', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Marca'),
(32, 'Bilingual S.A.C.', 'Avenida Paseo de la República 3195 San Isidro lima', 'Lima', 'David Mego Torres', 'Servicios', 'Mia Arecco', 'Generación'),
(33, 'Bio S.A.C.', 'AV. EL DERBY NRO. 254 INT. 708 LIMA - LIMA - SANTIAGO DE SURCO', 'LIMA', 'Nils Angeldonis', 'Telecomunicaciones', 'Mia Arecco', 'Generación'),
(34, 'Biznes Sac.', 'CAL.ENRIQUE ENCINAS FRANCO NRO. 284 INT. 601 URB. SANTA CATALINA (ENTRE AV DEL AIRE Y AVIACION) LIMA - LIMA - LA VICTORIA', 'Lima', 'Giani Fritas', 'Telecomunicaciones', 'Mia Arecco', 'Generación'),
(35, 'Bodegas y Viñedos Tabernero S.A.C.', 'AV. 28 DE JULIO NRO. 753 DPTO. 302 URB. OCHARAN LIMA - LIMA - MIRAFLORES', 'Lima', 'Nilton Santos', 'Industrial', 'Mia Arecco', 'Generación'),
(36, 'Bonavista S.A.C', 'JR. SAN AGUSTIN NRO. 186 URB. SURQUILLO (ALTURA CDRA. 50 AV.PASEO DE LA REPUBLICA) LIMA - LIMA - SURQUILLO', 'LIMA', 'Milagros Cahuana', 'Industrial', 'Mia Arecco', 'Generación'),
(37, 'Brandint SAC', 'Av. Santa Lucia Nro. 143 Urb. Industrial La Aurora ATE', 'Lima', 'Raúl La Rosa', 'Industrial', 'Mia Arecco', 'Generación'),
(38, 'CAFERMA S.A.C.', 'Cal. Virrey Manuel Amat Nro. 202', 'Lima', 'Javier Cole', 'Servicios', 'Mia Arecco', 'Generación'),
(39, 'Calzados Azaleia Perú S.A', 'Av. Prolongación Arica 2248 Lima', 'Lima', 'José Juarez', 'Industrial', 'Mia Arecco', 'Generación'),
(40, 'Cámara de Formación Profesional', 'Av. Carlos Izaguirre Mza. H-1 Lote. 23 Urb. San Francisco De Cayran San Martin De Porres', 'Lima', 'Jorge Aquino Donayre', 'Educación', 'Mia Arecco', 'Generación'),
(41, 'Carpicentro SAC', 'Av. Gerardo Unger 3209, LIMA, LIMA 28', 'Lima', 'Omar Mullisaca', 'Industrial', 'Mia Arecco', 'Marca'),
(42, 'Carrusel Representaciones SAC', 'CAL.SCHELL NRO. 319 INT. 203 (CRUCE CON CDRA.4 DE AV. LARCO) LIMA - LIMA - MIRAFLORES', 'Lima', 'Jose Luis Almonacid Aquino', 'Otro', 'Mia Arecco', 'Generación'),
(43, 'Celicon Ingenieros S.A.C.', 'CAL.CHIMBOTE NRO. 403 URB. SAN MARTIN DE SOCABAYA AREQUIPA - AREQUIPA - SOCABAYA', 'Arequipa', 'Harry Carrasco', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(44, 'Centex Instrumentacion y Equipos S.A.C.', 'Alexander Fleming 187 Santiago de Surco', 'Lima', 'Jean Pierre Jiménez Cuadros', 'Energía', 'Mia Arecco', 'Generación'),
(45, 'Centrality SAC', 'JR. EL ALAMO NRO. 289 DPTO. 405 URB. CENTRO COMERCIAL MONTERRICO LIMA - LIMA - SANTIAGO DE SURCO', 'LIMA', 'Milagros Cahuana', 'Otro', 'Mia Arecco', 'Generación'),
(46, 'Centro Empresarial Juan De Arona SAC', 'AV. JAVIER PRADO ESTE NRO. 444 INT. 1902 LIMA - LIMA - SAN ISIDRO', 'Lima', 'Luis Zapana', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(47, 'Centros de Salud Peruanos Sac', '20602393934', 'AV. ALFREDO MENDIOLA NRO. 6301 URB. SANTA LUISA LIMA - LIMA - LOS OLIVOS', 'Aurelio Valverde', 'Salud', 'Mia Arecco', 'Generación'),
(48, 'Century Ecological Corporation S.A.C. ECOCENTURY', 'Alm. del Premio Real Mz.P1 Lt. 1, Chorillos', 'LIMA', 'Carlos Valderrama', 'Servicios', 'Mia Arecco', 'Generación'),
(49, 'China Minmetals Noferrous Metals Perú', 'Av. El Derby Nro. 055 Int. 902 (Torre 1) Santiago De Surco', 'Lima', 'Jessica Lecaros', 'Industrial', 'Mia Arecco', 'Generación'),
(50, 'Cineplex S.A', 'AV. JOSE LARCO NRO. 663 INT. 401 (PISOS 4-5) LIMA - LIMA - MIRAFLORES', 'Lima', 'Eddy Sandoval', 'Entretenimiento', 'Mia Arecco', 'Generación'),
(51, 'Clínica Médica Cayetano Heredia', 'Av. Honorio Delgado Nro. 370 Urb. Ingenieria San Martin De Porres', 'LIma', 'Carlos Moyano Valencia', 'Salud', 'Mia Arecco', 'Generación'),
(52, 'Club Tennis las Terrazas Miraflores', 'MLC.28 DE JULIO NRO. 390 URB. CERCADO DE MIRAFLORES LIMA - LIMA - MIRAFLORES', 'LIMA', 'Jonathan Uriol', 'Otro', 'Mia Arecco', 'Generación'),
(53, 'Colegio de Abogados de Lima', 'Avenida Santa cruz LIMA - LIMA - MIRAFLORES', 'LIMA', 'Lariza Jauregui', 'Servicios', 'Mia Arecco', 'Generación'),
(54, 'Comercial Industrial Delta SA', 'Av. Pedro Miota 910 San Juan de Miraflores', 'Lima', 'Luis Mendoza', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(55, 'Compañia Minera Lincuna S.A.', 'Av. Republica de Colombia Nro. 791 Dpto. 804 (Frente al Colegio Alfonso Ugarte), San Isidro', 'Lima', 'Juan Jaimes', 'Otro', 'Mia Arecco', 'Generación'),
(56, 'Compunexis Perú E.I.R.L', 'JR. BOLIVAR NRO. 1258 LA LIBERTAD - SANCHEZ CARRION - HUAMACHUCO', 'Huamachuco', 'Wilman Gonzales', 'Servicios', 'Mia Arecco', 'Generación'),
(57, 'Comunica-2 S.A.C.', 'CAL.OMICRON NRO. 218 URB. PARQUE INTERNACIONAL DE INDUSTRIA Y COMERCIO (AV. OSCAR R. BENAVIDES CUADRA 52) PROV. CONST. DEL CALLAO - PROV. CONST. DEL CALLAO - CALLAO', 'Callao', 'Bertha Vilca', 'Servicios', 'Mia Arecco', 'Base de datos Last Call'),
(58, 'Concesionaria Puerto Amazonas', 'Javier Prado Este 4135 oficina 701 Santiago de Surco', 'Lima', 'Omar Hernandez', 'Transporte', 'Mia Arecco', 'Generación'),
(59, 'Consejeros y Corredores de Seguros S.A.', 'AV. JAVIER PRADO ESTE NRO. 488 INT. 602 (EDIFICIO TORRE ORQUIDEAS) LIMA - LIMA - SAN ISIDRO', 'LIMA', 'Joel Mayta Aguilar', 'Servicios', 'Mia Arecco', 'Generación'),
(60, 'Consorcio Rovella - Inmac', 'Av. Dionisio derteano 184, departamento 801', 'Lima', 'Renzo Castillo', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Marca'),
(61, 'Consorcio Transito Ciudadano', 'Av. Federico Fernandini Nro. 471, Callao', 'Lima', 'Raul Trelles', 'Transporte', 'Mia Arecco', 'Generación'),
(62, 'Cooperativa de Ahorro y Credito la Portuaria', 'Avenida Sáenz Peña 333 piso 1 Callao', 'Callao', 'Leonidas Samanez', 'Financiera', 'Mia Arecco', 'Generación'),
(63, 'Copep del Perú SAC', 'AV. BENAVIDES NRO. 1555 DPTO. 604 (ALTURA CDRA 61 REPÚBLICA DE PANAMÁ) LIMA - LIMA - MIRAFLORES', 'Lima', 'Jorge Matta', 'Industrial', 'Mia Arecco', 'Generación'),
(64, 'Corp. Aguilas Del Sol S.A.C.', 'Cal.Los Nogales Nro. 224 Urb. Fatima La Libertad Victor Larco Herrera', 'Trujillo', 'Pierre Urruchi', 'Transporte', 'Mia Arecco', 'Generación'),
(65, 'Corp. Electromecánica en Ing. Y Constr. S.A.C.', 'Calle Chimbote 403 Socabaya', 'Arequipa', 'Harry Carrasco Romero', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(66, 'Corpol S.A.C.', 'AV. INDUSTRIAL NRO. 160 URB. LA AURORA (ALTURA CDRA 1 AV LAS TORRES) LIMA - LIMA - ATE', 'LIMA', 'Orlando Pihue', 'Industrial', 'Mia Arecco', 'Generación'),
(67, 'Corporacion Life S.A.C.', 'Av. Cordillera Central Mza. C-13 Lote. 2 Urb. Las Delicias De Villa (3era Zona) Chorrillos', 'Lima', 'Mario Aranda', 'Alimenticia', 'Mia Arecco', 'Generación'),
(68, 'Corporación LITEC', 'CAL.LOS AYMARAS NRO. 189 URB. EL DERBY - MONTERRICO (A ESPALDA DE LA COMISARIA DE MONTERRICO) LIMA - LIMA - SANTIAGO DE SURCO', 'Lima', 'José Carvajal', 'Industrial', 'Mia Arecco', 'Generación'),
(69, 'Corporacion Textil Spain & Espinoza', 'MZA. E LOTE. 33 ASOC LOS JARDINES DE SAN (ASOC PROP LOS JARDINES DE SAN VICENTE) LIMA - LIMA - SAN JUAN DE LURIGANCHO', 'Lima', 'Yenny Espinoza', 'Industrial', 'Mia Arecco', 'Generación'),
(70, 'Corporate International Partners', 'Av. Mariscal La Mar Nro. 1120 Int. 101 Miraflores', 'Lima', 'Luz Villena Chavez', 'Servicios', 'Mia Arecco', 'Generación'),
(71, 'Corporation Withmory SRL', 'Av. Nicolas Arriola 2216', 'Lima', 'Víctor Napa', 'Industrial', 'Mia Arecco', 'Marca'),
(72, 'Cp Group SAC', 'AV. J.PRADO ESTE NRO. 1238 URB. CORPAC (ALT.CLINICA RICARDO PALMA) LIMA - LIMA - SAN ISIDRO', 'Lima', 'Maycohol Ayra', 'Servicios', 'Mia Arecco', 'Generación'),
(73, 'Crosland Automotriz S.A.C.', 'Av. Augusto Perez Aranibar 1872 San Isidro', 'Lima', 'Eduardo Bazalar Pizarro', 'Industrial', 'Mia Arecco', 'Generación'),
(74, 'Crosland Logistica S.A.C.', 'Av. Augusto Perez Aranibar Nro. 1872', 'Lima', 'Eduardo Bazalar Pizarro', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(75, 'Curtiduria el Porvenir S A', 'Jr. Conchucos Nro. 637, Lima', 'Lima', 'Enrique Ruiz', 'Industrial', 'Mia Arecco', 'Generación'),
(76, 'Danilo Diesel E.I.R.L.', 'AV. JAVIER PRADO ESTE NRO. 312 INT. 602 LIMA - LIMA - SAN ISIDRO', 'LIMA', 'Lizbeth Trujillo Levano', 'Industrial', 'Mia Arecco', 'Generación'),
(77, 'Data System & Global Services SAC', 'CAL.MONTE ROSA NRO. 256 INT. 1001 URB. CHACARILLA DEL ESTANQUE LIMA - LIMA - SANTIAGO DE SURCO', 'LIMA', 'Leo Gonzales', 'Servicios', 'Mia Arecco', 'Generación'),
(78, 'Delycorp sac', 'Lima', 'Lima', 'Angel Ponce', 'Otro', 'Mia Arecco', 'Marca'),
(79, 'Dent Import S:A', 'JR. TEODORO CARDENAS NRO. 155 URB. SANTA BEATRIZ (EDIFICIO 1ER PISO) LIMA - LIMA - LIMA', 'Lima', 'Henry Valle', 'Industrial', 'Mia Arecco', 'Generación'),
(80, 'Dentons Gallo Barrios & Pickmann SRL', 'General Córdova 313 Miraflores', 'Lima', 'José Tasayco', 'Servicios', 'Mia Arecco', 'Generación'),
(81, 'Derk S.A.C.', '0', 'LIMA', 'Henry Zavalaga Cusicahua', 'Otro', 'Mia Arecco', 'Generación'),
(82, 'Dimaco S.A.C.', 'Cal. Bonifaz Nro. 108, arequipa', 'Arequipa', 'Eduardo Gonzales', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(83, 'Dimerc Peru S.A.C.', 'AV. ANDRES AVELINO CACERES NRO. 320 (CRUCE CON IRRIBARREN) LIMA - LIMA - MIRAFLORES', 'LIMA', 'Renzo Miranda', 'Industrial', 'Mia Arecco', 'Generación'),
(84, 'Diphasac S.A.C.', 'CAL.BREA Y PARIÑAS NRO. 102 INT. 304 URB. TAMBO DE MONTERRICO LIMA - LIMA - SANTIAGO DE SURCO', 'LIMA', 'Juan Diego Diaz', 'Salud', 'Mia Arecco', 'Generación'),
(85, 'Distribuciones Y Representaciones Limatambo S.R.L.', 'Cal.Victor Alzamora Nro. 304 Urb. Barrio Medico Surquillo', 'Lima', 'Víctor LLocya', 'Servicios', 'Mia Arecco', 'Generación'),
(86, 'Distribuidora Drogueria Alfaro', 'Av. De Los Insurgentes Nro. 1086 San Miguel', 'Lima', 'Richard Santos Manrique', 'Alimenticia', 'Mia Arecco', 'Generación'),
(87, 'Distribuidora Linares S.A.C.', 'Mza. I Lote. A Sec. Valdivia Alta Uc Par 220 Iii 6-12 La Libertad', 'Trujillo', 'Carlos Valverde Huaman', 'Alimenticia', 'Mia Arecco', 'Generación'),
(88, 'Distribuidora Yupupu SRL', 'Mza. C Lote. 15 Z.I. Parque Industrial Lambayeque', 'Pimentel', 'Yaritza Infantes', 'Transporte', 'Mia Arecco', 'Marca'),
(89, 'Doktuz SAC', 'Av. la Marina 3299 Urb. Maranga San Miguel', 'Lima', 'Carlos Baldera', 'Salud', 'Mia Arecco', 'Marca'),
(90, 'Dreams Corporation S.A.C.', 'AV. ALFREDO BENAVIDES NRO. 509 URB. LEURO LIMA - LIMA - MIRAFLORES', 'LIMA', 'Cesar Vasquez', 'Entretenimiento', 'Mia Arecco', 'Generación'),
(91, 'Duna Corp', 'Lima', 'Lima', 'Alexander Cuadros', 'Otro', 'Mia Arecco', 'Marca'),
(92, 'Dynaflux', 'Jr. las Cascadas Nro. 325, La Molina', 'Lima', 'Francisco Cabanillas', 'Industrial', 'Mia Arecco', 'Generación'),
(93, 'E Y C Metalikas Sociedad Anonima Cerrada', 'AV. EL BOSQUE NRO. 668 URB. CANTO GRANDE (MZ D LT18) LIMA - LIMA - SAN JUAN DE LURIGANCHO', 'LIMA', 'Raul Chavez', 'Industrial', 'Mia Arecco', 'Generación'),
(94, 'E.TORRES Y TORRES LARA & ASOC.ABOG.SCRL', 'Cal. Cañon del Pato Nro. 103 (Alt. Cdra 5 Av. Caminos del Inca), Surco', 'LIMA', 'Maria Del Pilar Torres', 'Servicios', 'Mia Arecco', 'Generación'),
(95, 'Ebiz S.A.C.', 'Av. Arica Nro. 785, Breña', 'Lima', 'Felipe Quispe', 'Servicios', 'Mia Arecco', 'Generación'),
(96, 'Eco Sac', 'NRO. S/N CAS. CHAPAIRA (FRENTE A CASERIO CHAPAIRA) PIURA - PIURA - CASTILLA', 'Piura', 'Roberto Panta', 'Industrial', 'Mia Arecco', 'Generación'),
(97, 'Empresa Agroindustrial Pomalca S.A.A.', 'Carretera a Chongoyape KM. 07 Pomalca Lambayeque', 'Chiclayo', 'Paul Giraldo', 'Servicios', 'Mia Arecco', 'Generación'),
(98, 'Enotria S.A.', 'Av. Nicolas Ayllon Nro. 2890 Fnd. Vasquez (Carr.Central Km.0 Esq.Via Evitamiento) Ate', 'Lima', 'David Roman', 'Servicios', 'Mia Arecco', 'Generación'),
(99, 'Escuela de Derecho LP SAC', 'Av. Faustino Sánchez Carrión 607 int 502 Jesus maría', 'Lima', 'Javier García', 'Educación', 'Mia Arecco', 'Marca'),
(100, 'Esmeralda Corp S.A.C.', 'AV. AUTOP PANAMERICANA SUR KM. 18.5 MZA. G LOTE. 01 Z.I. LA CONCORDIA (ALT. PARADERO LECHON) LIMA - LIMA - SAN JUAN DE MIRAFLORES', 'LIMA', 'Ana Asto', 'Servicios', 'Mia Arecco', 'Generación'),
(101, 'Especialidades Médicas Universal S.A.', 'Jr. Eduardo Ordonez Nro. 468 (Alt.Cdra.34 Av. Aviacion) San Borja', 'Lima', 'Edison Cano', 'Salud', 'Mia Arecco', 'Generación'),
(102, 'Estudio Aguado y Ruiz Sociedad Civil de Responsabilidad Limitada', 'AV. CAMINO REAL NRO. 390 DPTO. 1701 INT. B URB. CENTRO COMERCIAL CAMINO REAL LIMA - LIMA - SAN ISIDRO', 'Lima', 'José Aguado', 'Servicios', 'Mia Arecco', 'Generación'),
(103, 'Etsa Peru S.A.', 'Cal.San Carlos Nro. 198 Urb. Santa Martha (Mz. A Lt 3 Y 4 - Ex Nro. 120) Ate', 'Lima', 'Jhon Miranda', 'Industrial', 'Mia Arecco', 'Generación'),
(104, 'Explosupport Sac', 'Av. J.Prado Este Nro. 1238, san isidro', 'LIMA', 'Maycohol Ayra', 'Industrial', 'Mia Arecco', 'Generación'),
(105, 'Exxoda tecnología E.I.R.L.', 'Av. El Carmen Nro. 689 Dpto. 304 Urb. San Roque Santiago De Surco', 'Lima', 'Consuelo Rodriguez Chacón', 'Servicios', 'Mia Arecco', 'Generación'),
(106, 'Forestal Santa Rosa SAC', 'AV. VICTOR MALASQUEZ NRO. 502 (QUEBRADA RETAMAL-MANCHAY) LIMA - LIMA - PACHACAMAC', 'Lima', 'Alberto Prado', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(107, 'Franquicias Alimentarias S.A. | T.G.I Friday\'S', 'AV. CIRCUNVALACION DEL GOLF LOS INCAS NRO. 134 INT. 402 URB. CLUB GOLF LOS INCAS (EDIFICIO PANORAMA TORRE 2) LIMA - LIMA - SANTIAGO DE SURCO', 'LIMA', 'Christian Mercado', 'Servicios', 'Mia Arecco', 'Generación'),
(108, 'Funeraria Jardines S.a - Funjar', 'AV. SAN BORJA SUR NRO. 1190 DPTO. 301 LIMA - LIMA - SAN BORJA', 'Lima', 'Fausto Malasquez', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(109, 'Gambell Trading SAC', 'AV. CAMINOS DEL INCA NRO. 670 URB. TAMBO DE MONTERRICO (QUINTO PISO-OFICINA 02) LIMA - LIMA - SANTIAGO DE SURCO', 'Lima', 'Mirella Chavez', 'Otro', 'Mia Arecco', 'Generación'),
(110, 'Gamma Cargo S.A.C.', 'Cal.Padre Urraca Nro. 276 Int. 101 Urb. Maranga', 'Lima', 'Ronald Céspedes', 'Transporte', 'Mia Arecco', 'Generación'),
(111, 'Gaval Soluciones SAC', 'Jr. La Igualdad 7759 urb. Pro Los Olivos', 'Lima', 'Manuel Guzman', 'Telecomunicaciones', 'Mia Arecco', 'Marca'),
(112, 'Gestora Peruana De Hospitales S.A.', 'Av. Javier Prado Este Nro. 560 Dpto. 2302 San Isidro', 'Lima', 'Jorge Luis Maldonado Alania', 'Salud', 'Mia Arecco', 'Generación'),
(113, 'Global Administración y Negocios S.R.L.', 'AV. JAVIER PRADO ESTE NRO. 444 (PISO 1902) LIMA - LIMA - SAN ISIDRO', 'Lima', 'Luis Zapana', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(114, 'Grupo Forte S.A.C.', 'AV. ALEXANDER FLEMING NRO. 412 DPTO. T II URB. INDUSTRIAL SANTA ROSA LIMA - LIMA - ATE', 'LIMA', 'Sander Salvador', 'Industrial', 'Mia Arecco', 'Generación'),
(115, 'Grupo Merpes Peru S.A.C.', 'CAL.MARIE CURIE NRO. 410 URB. INDUSTRIAL SANTA ROSA (AL COSTADO DE PETROAMERICA) LIMA - LIMA - ATE', 'LIMA', 'Edixon Manuel Perez Godoy', 'Otro', 'Mia Arecco', 'Generación'),
(116, 'Grupo Odisea S.A.C', 'AV. EVITAMIENTO NRO. 1559 URB. SAN FRANCISCO LIMA - LIMA - ATE', 'LIMA', 'Jonnathan Malca', 'Servicios', 'Mia Arecco', 'Generación'),
(117, 'Grupo Vivargo S.A.C.', 'Avenida Premio Real lote 4 urb. Huertos de Villa (Ref: Granja Villa) Chorrillos', 'LIMA', 'Aron Rojas', 'Transporte', 'Mia Arecco', 'Generación'),
(118, 'GTLS S.A.C.', 'Calle Alfonso Cobian 179 Barranco', 'Lima', 'Martin Sullón Zapata', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(119, 'Hass Peru SA', 'Jirón Diego de Almagro 537 La Libertad, Trujillo', 'Trujillo', 'Luis Figueroa Valdivia', 'Agrícola', 'Mia Arecco', 'Generación'),
(120, 'Hispasat', 'Jr. Carlos Baca Flor 307 dpto 301 Magdalena', 'Lima', 'Sebastian Cebreros', 'Energía', 'Mia Arecco', 'Marca'),
(121, 'Hospitapp Sociedad Anonima Cerrada', 'CAL.CORONEL JUAN CASTILLA NRO. 152 INT. 301 URB. LAS GARDENIAS LIMA - LIMA - SANTIAGO DE SURCO', 'Lima', 'Jose María Coronel', 'Servicios', 'Mia Arecco', 'Generación'),
(122, 'Huemura S.A.C.', 'AV. TEODORO VALCARCEL NRO. 1007 URB. SANTA LEONOR LA LIBERTAD - TRUJILLO - TRUJILLO', 'Trujillo', 'Jorge Avila', 'Otro', 'Mia Arecco', 'Base de datos Last Call'),
(123, 'Huk Distribuciones S.A.C.', 'Av. 28 de Julio 1044 Miraflores', 'LIMA', 'Moises Cruzado', 'Servicios', 'Mia Arecco', 'Generación'),
(124, 'I. E. José Faustino Sánchez Carrión', 'Av. Moche1020 urb. Torres Araujo', 'La libertad', 'Rubén Puerta', 'Educación', 'Mia Arecco', 'Marca'),
(125, 'Imanay Consultoria y Servicios Generales E.I.R.L.', 'NRO. 419 URB. SANTA ROSA (FT PUERTA AUDITORIO IE SANTA ANA 1ER PIS) CUSCO - CUSCO - WANCHAQ', 'Cusco', 'Renzo Castillo', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(126, 'Importadora Industrial Corpus S.R.L.', 'AV. OSCAR R. BENAVIDES NRO. 1473 Z.I. CHACRA RIOS LIMA - LIMA - LIMA', 'LIMA', 'Jose Granados', 'Servicios', 'Mia Arecco', 'Generación'),
(127, 'Impresso Grafica S.A', 'Av. Mariscal la Mar Nro. 585, miraflores', 'Lima', 'Enrique Lanata', 'Servicios', 'Mia Arecco', 'Generación'),
(128, 'Inca One Metals Peru S.A.', 'Calle Los Tulipanes 147 san isidro', 'Lima', 'Omar Hernandez', 'Industrial', 'Mia Arecco', 'Generación'),
(129, 'Inca Rail S.A.C.', 'Av. Augusto Perez Aranibar Nro. 1872 San Isidro', 'Lima', 'Paul Gamarra', 'Servicios', 'Mia Arecco', 'Generación'),
(130, 'Industrias Meier S.A.C.', 'Cal. Alcanfores 140-142 Nro. 706, Miraflores', 'Lima', 'César Peñaloza', 'Industrial', 'Mia Arecco', 'Generación'),
(131, 'Industrias Peruanas Santa Julia Sociedad Anonima Cerrada', 'MZA. A LOTE. 11 OTR. TRABAJ. TEXTIL VITARTE LIMA - LIMA - ATE', 'LIMA', 'Cristian Yamil Molina López', 'Servicios', 'Mia Arecco', 'Generación'),
(132, 'Inka Agri Resources SAC', 'Av. La Encalada 1388 oficina 703 Santiago de Surco', 'Lima', 'Henry Gómez', 'Agrícola', 'Mia Arecco', 'Generación'),
(133, 'Inka Crops S.A.', 'AV. EL SANTUARIO NRO. 1127 URB. ZARATE LIMA - LIMA - SAN JUAN DE LURIGANCHO', 'LIMA', 'Victor Andres Abusada', 'Alimenticia', 'Mia Arecco', 'Generación'),
(134, 'Inmac', 'Av Dionisio Derteano 184, San Isidro 15047, Perú', 'San Isidro', 'Renzo Castillo', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Marca'),
(135, 'Inmobiliaria Maritima S A', 'CAL.41 NRO. 894 INT. P.5 URB. CORPAC (PISO 5) LIMA - LIMA - SAN ISIDRO', 'Lima', 'Victor Morales', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(136, 'Inversiones Don Quijote SAC', 'Av. Alfredo Benavides Nro. 300 Miraflores', 'Lima', 'Raul Limaymanta Contreras', 'Servicios', 'Mia Arecco', 'Generación'),
(137, 'Inversiones Kayser S.A.C.', 'CAL.MONASTERIO S/N LOTE. C OTR. PREDIO SAN VICENTE PARCELA B-63 SUB LOTE C (CRUCE AV.SAN PEDRO S/N CON CL.MONASTERIO) LIMA - LIMA - LURIN', 'LIMA', 'Oscar Perez', 'Industrial', 'Mia Arecco', 'Generación'),
(138, 'Inversiones Rodalfa S.A.C', 'Cal. los Jazmines Nro. 178, surco', 'Lima', 'Richard Yucra', 'Servicios', 'Mia Arecco', 'Generación'),
(139, 'Inversiones y Negociaciones del Prado E.I.R.L.', 'CAL.GERMAN SCHREIBER NRO. 210 INT. 302 URB. SANTA ANA LIMA - LIMA - SAN ISIDRO', 'LIMA', 'Mirtha Oshiro', 'Otro', 'Mia Arecco', 'Generación'),
(140, 'Jzg Abogados E.I.R.L.', 'AV. BOULEVARD DE SURCO NRO. 1052 DPTO. 502 URB. LAS BEGONIAS LIMA - LIMA - SAN BORJA', 'LIMA', 'Frank Zamora', 'Servicios', 'Mia Arecco', 'Generación'),
(141, 'Kbr Ingenieros S.A', 'Pj. Materiales Nro. 620, Lima', 'Lima', 'Johan García', 'Otro', 'Mia Arecco', 'Generación'),
(142, 'Kubiqo Administradora De Inmuebles S.A.C', 'Av. Angamos Oeste Nro. 1585 Int. 302 Urb. America, Miraflores', 'Lima', 'Eick Sánchez', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(143, 'Kuntur Pharma', 'Av. Industrial Nro. 184 Urb. Industrial La Aurora (Alt. Cdra. 1 De La Av Las Torres) Ate', 'Lima', 'Carlos Moreno Carrión', 'Salud', 'Mia Arecco', 'Generación'),
(144, 'L.P.M. Contadores y Asesores S.A.', 'Jr. Elias Aguirre 141 miraflores', 'Lima', 'Lincoln Palacios', 'Servicios', 'Mia Arecco', 'Generación'),
(145, 'Laboratorios Veterinarios GAMMAVET S.A.C.', 'Av. Circunvalación Golf Los Incas 134 torre 1 Of. 706', 'Santiago de Surco', 'Omar Hernandez Int TI', 'Agrícola', 'Mia Arecco', 'Generación'),
(146, 'Ladersam Consultores', 'Calle Los Gavilanes 159, San Isidro', 'Lima', 'Raul Abusabal', 'Servicios', 'Mia Arecco', 'Generación'),
(147, 'Lima Bus Internacional 1 S.A.', 'AV. LOS INCAS NRO. 0 (FINAL PARQUE SINCHI ROCA) LIMA - LIMA - COMAS', 'LIMA', 'Luis Diaz', 'Transporte', 'Mia Arecco', 'Generación'),
(148, 'Link Tek SAC', 'Av. Manuel Olguin Nro. 211 Int. 1003, Surco', 'Lima', 'José Carlos Montenegro', 'Servicios', 'Mia Arecco', 'Generación'),
(149, 'Malvex del Perú S.A.', 'Avenida Javier Prado Este 1169 la Victoria', 'Lima', 'Anna Malmstrom', 'Industrial', 'Mia Arecco', 'Generación'),
(150, 'Mant.Const.Y Proyectos Grales S.A.C.', 'Av. Del Parque Sur Nro. 668 Urb. Corpac San isidro', 'Lima', 'Julian Macedo', 'Servicios', 'Mia Arecco', 'Generación'),
(151, 'Mas Value SAC', 'Av. Circunvalacion Del Golf Los Incas Nro. 134 Santiago De Surco', 'Lima', 'Alina Sandoval', 'Servicios', 'Mia Arecco', 'Generación'),
(152, 'Matritech S.A.C.', 'JR. CAJAMARQUILLA NRO. 1497 URB. ZARATE LIMA - LIMA - SAN JUAN DE LURIGANCHO', 'Lima', 'Daniel Zegarra', 'Industrial', 'Mia Arecco', 'Generación'),
(153, 'Mediterranea De Catering S.L.U. Sucursal Perú', 'Av. Rivera Navarrete Nro. 765 Dpto. 102 San Isidro', 'Lima', 'Jorge Maldonado Alania', 'Alimenticia', 'Mia Arecco', 'Generación'),
(154, 'Meg Peru S.A.C.', 'JR. LIBERTAD NRO. 2365 URB. MIRAMAR LIMA - LIMA - SAN MIGUEL', 'Lima', 'Zaida Hinostroza', 'Telecomunicaciones', 'Mia Arecco', 'Generación'),
(155, 'Mini Bf Peru S.A.C.', 'Andres Reyes 338 Piso 2', 'Lima', 'Carlos Ramos Loo', 'Retail', 'Mia Arecco', 'Generación'),
(156, 'Miranda & Amado Abogados S. Civil De R.L', 'Av. Jose Larco Nro. 1301 Miraflores', 'Lima', 'Miguel Panta', 'Otro', 'Mia Arecco', 'Generación'),
(157, 'MOBILE DATA SOLUTIONS S.A.C.', 'Loma del Pilar 130, Surco', 'Lima', 'Mario Durand', 'Servicios', 'Mia Arecco', 'Generación'),
(158, 'Modernizacion De La Gestion De Los Recursos Hidricos', 'Av. Pablo Carriquiry Nro. 272 Urb. El Palomar San Isidro', 'Lima', 'Marco Antonio Olortiga Barba', 'Gobierno', 'Mia Arecco', 'Generación'),
(159, 'Monark Peru S.A.', 'Avenida Elmer Faucett 1920 Callao', 'Callao', 'Anibal Fernandez', 'Industrial', 'Mia Arecco', 'Generación'),
(160, 'Mt Industrial S.A.C.', 'Av. Argentina Nro. 2317, Callao', 'Callao', 'Cristian Cano', 'Industrial', 'Mia Arecco', 'Generación'),
(161, 'Multi Top S.A.C.', 'AV. IQUITOS NRO. 619 LIMA - LIMA - LA VICTORIA', 'Lima', 'Kid Rivera', 'Industrial', 'Mia Arecco', 'Generación'),
(162, 'Multicosailor SAC', 'AV. LOS CIRUELOS NRO. 560 URB. SEMI RUSTICA CANTO GRANDE (PARADERO EDELNOR) LIMA - LIMA - SAN JUAN DE LURIGANCHO', 'Lima', 'Moises Ayala', 'Transporte', 'Mia Arecco', 'Generación'),
(163, 'Naos Peru S.A.C.', 'Cal.Almirante Lord Cochrane Nro. 334 Urb. Chacarilla Santa Cruz Miraflores', 'Lima', 'Jonathan Olortiga', 'Industrial', 'Mia Arecco', 'Generación'),
(164, 'Neuma Peru', 'AV. NICOLAS DE AYLLON NRO. 2142 URB.INDUST.SANTA LUCIA LIMA - LIMA - ATE', 'LIMA', 'Manuel Caja', 'Industrial', 'Mia Arecco', 'Generación'),
(165, 'Nuevo Mundo Lima Hotel S.A.C.', 'Av. Felipe Pardo Y Aliaga Nro. 330 Urb. Chacarilla Santa Cruz San Isidro', 'Lima', 'Antonio Borda', 'Servicios', 'Mia Arecco', 'Generación'),
(166, 'Numay S.A.', 'Av. Republica De Panama Nro. 3591 Int. 401 San Isidro', 'Lima', 'Carlos Arévalo', 'Servicios', 'Mia Arecco', 'Generación'),
(167, 'Oceano Seafood', 'Av. Manuel Olguin Nro. 211 Int. 4 (Torre Omega-Piso 4) Santiago De Surco', 'Lima', 'Luis Velasquez', 'Alimenticia', 'Mia Arecco', 'Generación'),
(168, 'Oficinas Integrales SAC', 'Av. Rivera Navarrete 395 Of. 403 San Isidro', 'Lima', 'Lidia Pérez Cuadros', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(169, 'Ol los Andes S.A.C.', 'Pj. Belen Nro. 107', 'Arequipa', 'Daniel Pando', 'Servicios', 'Mia Arecco', 'Generación'),
(170, 'Oleaginosas del Perú S.A.', 'Caserío Villa Palma Nueva Bambamarca Tocache, San Martín.', 'San Martín', 'Elvis Raúl Mendoza Atero', 'Agrícola', 'Mia Arecco', 'Marketing Last Call'),
(171, 'Operaciones turísticas Peruanas S.A.C.', 'Cal.Colon Nro. 115 Urb. Miraflores (Cruce Colon Y Benavides) Miraflores', 'Lima', 'Raul Limaymanta Contreras', 'Servicios', 'Mia Arecco', 'Generación'),
(172, 'Palacios & Asociados Agentes de Aduanas', 'JR. LAMBAYEQUE NRO. 210 URB. SANTA MARINA PROV. CONST. DEL CALLAO - PROV. CONST. DEL CALLAO - CALLAO', 'Callao', 'Luis Andonayre Linares', 'Servicios', 'Mia Arecco', 'Generación'),
(173, 'Paredes Cano & Asociados Sociedad Civil de Responsabilidad Limitada', 'CAL.SOR MATE NRO. 120 URB. BENAVIDES (ESQUINA CON AV. ALFREDO BENAVIDES 2496) LIMA - LIMA - MIRAFLORES', 'Lima', 'Patricia Orosco', 'Servicios', 'Mia Arecco', 'Generación'),
(174, 'Perufarma S A', 'JR. STA FRANCISCA ROMANA NRO. 1092 URB. PANDO III ETAPA (ENTRE LA AV. UNIVERSITARIA Y VENEZUELA) LIMA - LIMA - LIMA', 'Lima', 'Fernando Cordova', 'Salud', 'Mia Arecco', 'Generación'),
(175, 'Port Logistic S.A.C.', 'Av. Manuel Olguin Nro. 211 Int. 401- Urb. Los Granados Santiago De Surco', 'Lima', 'Jonathan Muñoz', 'Transporte', 'Mia Arecco', 'Generación'),
(176, 'Praeveni SAC', 'Av. Alberto Del Campo Nro. 411 Int. 1202 Urb. Campo De Polo San Isidro', 'Lima', 'Omar Hernandez Int TI', 'Salud', 'Mia Arecco', 'Generación'),
(177, 'Presidencia Del Consejo De Ministros', 'Palacio de Gobierno Lima', 'Lima', 'Angel Moquillaza', 'Gobierno', 'Mia Arecco', 'Generación'),
(178, 'Productora de Alimentos Uno', 'AV. SANTA ROSA NRO. 476 URB. LA AURORA LIMA - LIMA - ATE', 'Lima', 'Hector Mateo', 'Industrial', 'Mia Arecco', 'Generación'),
(179, 'Productos El Cedro SAC', 'CAL.FEDERICO VILLARREAL NRO. 022 (ESPALDA CDRA 32 AV. PETIT THOUARS) LIMA - LIMA - SAN ISIDRO', 'San Isidro', 'Andrés Mufarech', 'Industrial', 'Mia Arecco', 'Generación'),
(180, 'Productos Naturales de Exportación (PRONEX)', 'Jirón los Titanes 236 La Campiña Chorrillos', 'Lima', 'Aldo Henry Nuñez Durand', 'Alimenticia', 'Mia Arecco', 'Generación'),
(181, 'Programa de las Naciones Unidas Para el Desarrollo', 'Av. Jorge Chávez 275 miraflores', 'Lima', 'Donny Chumpitaz', 'Otro', 'Mia Arecco', 'Generación'),
(182, 'Promotora Y Servicios Lambayeque SAC', 'Cal.Antolin Flores Nro. 1580 C.P. Villa San Juan (Carretera Panamericana Norte Km 37)', 'Lambayeque', 'William Heredia', 'Agrícola', 'Mia Arecco', 'Generación'),
(183, 'Q.P.R. Sac', 'Avenida General Cordova 1145 Miraflores, lima', 'Lima', 'Luis Victor', 'Servicios', 'Mia Arecco', 'Generación'),
(184, 'Qual Media S.A.C', 'AV. ARMENDARIZ NRO. 480 INT. 7 LIMA - LIMA - MIRAFLORES', 'LIMA', 'Rudy Trigoso', 'Servicios', 'Mia Arecco', 'Generación'),
(185, 'Rebaza & Alcazar Abogados Sociedad Civil de Responsabilidad Limitada', 'AV. VICTOR ANDRES BELAUNDE NRO. 147 DPTO. 201 INT. 301 URB. EL ROSARIO (VIA PRINCIPAL 133, EDIFICIO REAL 2) LIMA - LIMA - SAN ISIDRO', 'LIMA', 'José Plasencia', 'Servicios', 'Mia Arecco', 'Generación'),
(186, 'Renzo Costa S.A.C.', 'AV. DOS DE MAYO NRO. 674 URB. ORRANTIA (ALT.CDRA 7 AV.JAVIER PRADO OESTE) LIMA - LIMA - SAN ISIDRO', 'San Isidro', 'Erika Zevallos', 'Retail', 'Mia Arecco', 'Generación'),
(187, 'Reparaciones y Servicios del Sur S.A.C', 'AV. ALFONSO UGARTE NRO. 250 AREQUIPA - AREQUIPA - AREQUIPA', 'Lima', 'Ronald Castro', 'Industrial', 'Mia Arecco', 'Generación'),
(188, 'Representaciones Vargas S.A.', 'JR. TARAPACA NRO. 969 URB. CERCADO DE PUCALLPA', 'Pucallpa', 'Cristopher Querevalu', 'Financiera', 'Mia Arecco', 'Generación'),
(189, 'Research Engineering And Development S.A.C.', 'Mza. B Lote. 20 Asoc.Prog Viv Retamas (Km 28.5 De La Panamericana Norte) Puente Piedra', 'Lima', 'Andres Marcos Murga Robles', 'Telecomunicaciones', 'Mia Arecco', 'Generación'),
(190, 'Reymosa S.A.', 'PJ. MATERIALES NRO. 630 URB. INDUSTRIAL WIESE LIMA - LIMA - LIMA', 'LIMA', 'Johan García', 'Industrial', 'Mia Arecco', 'Generación'),
(191, 'S.G Natclar S.A.C', 'Calle los colibries104 Limatambo San Isidro', 'Lima', 'Bleker Palomino Miranda', 'Salud', 'Mia Arecco', 'Generación'),
(192, 'Serpac Agencias S.A.C.', 'AV. DEL PINAR NRO. 152 (OF 901) LIMA - LIMA - SANTIAGO DE SURCO', 'LIMA', 'Cesar Camones', 'Transporte', 'Mia Arecco', 'Generación'),
(193, 'Servicios Corporativos de Distribucion S.A.C.', 'CAL.ALVAREZ CALDERON NRO. 207 DPTO. 301 (ENTRE AVIACIÓN Y ANGAMOS) LIMA - LIMA - SAN BORJA', 'LIMA', 'Jorge Azana', 'Telecomunicaciones', 'Mia Arecco', 'Generación'),
(194, 'Shoe Trade', 'Cal. 5 Mza. D Lote. 2 Coo. las Vertientes (Cruce Calle 5 con Av el Sol)', 'Lima', 'Juan Carlos Velasquez', 'Retail', 'Mia Arecco', 'Generación'),
(195, 'SIGNO VIAL PERU S.A.C.', 'Cal. Alcanfores Nro. 142 Int. 301, Miraflores', 'Lima', 'Alexander Trigoso', 'Servicios', 'Mia Arecco', 'Generación'),
(196, 'SIIGO DEL PERU S.A.C.', 'CAL.LOS ALGARROBOS NRO. 517 URB. LOS JARDINES LIMA - LIMA - SAN MARTIN DE PORRES', 'LIMA', 'Yuri Tafur', 'Financiera', 'Mia Arecco', 'Generación'),
(197, 'SN FREIGHT SHIPPING SOCIEDAD ANONIMA CERRADA', 'AV. OSCAR BENAVIDES 4595 OF. 201', 'LIMA', 'Jose sisniegas', 'Otro', 'Mia Arecco', 'Generación'),
(198, 'Socopur S.A.C.', 'AV. CENTENARIO NRO. 721 UCAYALI - CORONEL PORTILLO - CALLERIA', 'Ucayali', 'Romulo Hernandez', 'Otro', 'Mia Arecco', 'Generación'),
(199, 'Soft Group Sac', 'AV. MARISCAL JOSE DE LA MAR NRO. 1263 INT. 702A URB. SANTA CRUZ LIMA - LIMA - MIRAFLORES', 'LIMA', 'Abel Muro', 'Otro', 'Mia Arecco', 'Generación'),
(200, 'Soluciones Prediales S.A.C.', 'Av. Parque Norte 830 piso 03, Urb. Corpac - San Isidro', 'Lima', 'Franco Cabrera', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(201, 'Solum logistics S.A.C.', 'Manuel Olguin 335', 'Santiago de surco', 'Mónica Gutiérrez', 'Transporte', 'Mia Arecco', 'Generación'),
(202, 'Steelser SAC', 'Av. Circunvalacion del Club Golf Los Incas Nro 134', 'Lima', 'Pool Cano', 'Industrial', 'Mia Arecco', 'Marca'),
(203, 'Swiss Capitals', 'Av. Benavides N°1944 Miraflores - Lima Perú', 'Lima', 'Fabián Sánchez', 'Otro', 'Mia Arecco', 'Marca'),
(204, 'TC DEVELOPMENT SOCIEDAD COMERCIAL DE RESPONSABILIDAD LIMITADA - TC DEVELOPMENT S.R.L.', 'AV. JAVIER PRADO ESTE NRO. 444 (PISO 1902) LIMA - LIMA - SAN ISIDRO', 'Lima', 'Luis Zapana', 'Construcción e Inmobiliaria', 'Mia Arecco', 'Generación'),
(205, 'Tech Industrias Globales S.R.L.', 'Lima', 'Lima', 'Johan Inocente', 'Otro', 'Mia Arecco', 'Marca'),
(206, 'Telemática Ingenieros SRL', 'Lima', 'Lima', 'Arturo Cervantes', 'Otro', 'Mia Arecco', 'Marca'),
(207, 'Templados LIMATAMBO S.A.C.', 'Av. Proceres De La Independencia Mza. N1 Lote. 2 Apv. Los Pinos San Juan De Lurigancho', 'Lima', 'Randolph Mendoza', 'Industrial', 'Mia Arecco', 'Generación'),
(208, 'Terminales Portuarios Peruanos SAC', 'Av. Néstor Gambetta Km. 14.3 Ex. Fundo Márquez (Ref. Paradero Oceánica)', 'Callao', 'Marco Dioses', 'Transporte', 'Mia Arecco', 'Generación'),
(209, 'TLI Aduanas S.A.C.', 'Jr. Nicolás de Piérola 269 Bellavista Callao', 'Callao', 'Carlos Ovalle', 'Transporte', 'Mia Arecco', 'Generación'),
(210, 'Tomocorp S.A.C.', 'CAL.5 MZA. D LOTE. 5 URB. LOTIZ. LAS VEGAS (AV. SAN LORENZO - COMPLEJO EL MUNDIALITO) LIMA - LIMA - PUENTE PIEDRA', 'LIMA', 'Mario Garcia', 'Otro', 'Mia Arecco', 'Generación'),
(211, 'Transmares Representaciones Maritimas SAC', 'Av. Circunvalación del Golf los Incas 154, Santiago de Surco, Lima - Perú', 'Santiago de Surco', 'Gerald Tagle Evans', 'Transporte', 'Mia Arecco', 'Generación'),
(212, 'Transtotal Agencia Maritima S.A.', 'Amador Merino Reyna Nro. 267 San Isidro Int. 1002 San Isidro', 'Lima', 'Christian Lopez', 'Transporte', 'Mia Arecco', 'Generación'),
(213, 'Transvial Lima S.A.C.', 'Av. Miro Quesada Nro. 427 Dpto. 304 (Cuadra 8 de Javier Prado Oeste)', 'Lima', 'Ronald Suarez', 'Transporte', 'Mia Arecco', 'Generación'),
(214, 'Tribunal Constitucional', 'Jr. Ancash Nro. 390', 'Lima', 'Ariel Rodriguez', 'Gobierno', 'Mia Arecco', 'Marca'),
(215, 'Unamad', 'Perú', 'Perú', 'Nancy Huaman', 'Educación', 'Mia Arecco', 'Marca'),
(216, 'Unibell S.A.C.', 'Av. Javier Prado Oeste Nro. 147 San Isidro5', 'Lima', 'Carmen Bernabel Espiritu', 'Industrial', 'Mia Arecco', 'Generación'),
(217, 'Vicco S.A.', 'Av. Separadora Industrial Nro. 1805 Urb. Ind.El Artesano (Frente Clinica Montefiori) Ate', 'Lima', 'Alexis Luna Aleman', 'Industrial', 'Mia Arecco', 'Generación'),
(218, 'Vitaltec S.A.C.', 'Cal. Mariscal Caceres Nro. 132 - Surco', 'LIMA', 'Lissy Pacheco', 'Salud', 'Mia Arecco', 'Generación'),
(219, 'Vsi Industrial S.A.C.', 'AV. B SUB-LOTE A1-3-2-B NRO. . LOTE. .. URB. INDUSTRIAL LAS PRADERAS LIMA - LIMA - LURIN', 'Lima', 'Oscar Mejia', 'Industrial', 'Mia Arecco', 'Generación'),
(220, 'Workpartners Peru S.A.C.', 'Av. Jose Pardo Nro. 434 Int. 501, Miraflores', 'Lima', 'Gabriela Ramirez', 'Servicios', 'Mia Arecco', 'Generación'),
(221, 'Wt Sourcing Peru S.A.C. Bic', 'CAL.ALDABAS NRO. 540 INT. 301 URB. LAS GARDENIAS LIMA - LIMA - SANTIAGO DE SURCO', 'Lima', 'Juan Carlos Seminario', 'Industrial', 'Mia Arecco', 'Generación'),
(222, 'Xirrus Tec SAC', 'AV. PASEO DE LA BREÑA NRO. 478 HUANCAYO CERCADO (OFICINA 301) JUNIN - HUANCAYO - HUANCAYO', 'Huancayo', 'José Chavez', 'Otro', 'Mia Arecco', 'Generación'),
(223, 'Cuentabruno', 'Dirección', 'Ciudad', 'Contacto', 'Secot', 'Mia', 'Marca');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `activities`
--

CREATE TABLE `activities` (
  `idActivities` int(11) NOT NULL,
  `asunto` varchar(255) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `fechaInicio` datetime DEFAULT NULL,
  `fechaFin` datetime DEFAULT NULL,
  `COD_idContact` int(11) DEFAULT NULL,
  `COD_idAccount` int(11) DEFAULT NULL,
  `COD_idusuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `allproduct`
--

CREATE TABLE `allproduct` (
  `idAllproduct` int(11) NOT NULL,
  `Producto` varchar(255) DEFAULT NULL,
  `Fecha de modificación` datetime DEFAULT NULL,
  `Nombre` varchar(255) DEFAULT NULL,
  `Fabricante` varchar(255) DEFAULT NULL,
  `Id. de producto` varchar(255) DEFAULT NULL,
  `Precio listado` varchar(255) DEFAULT NULL,
  `Segmento` varchar(255) DEFAULT NULL,
  `Lista de precios predeterminada` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `allproduct`
--

INSERT INTO `allproduct` (`idAllproduct`, `Producto`, `Fecha de modificación`, `Nombre`, `Fabricante`, `Id. de producto`, `Precio listado`, `Segmento`, `Lista de precios predeterminada`) VALUES
(1, '9a52656f-f216-ec11-b6e7-000d3a88538e', '2022-01-12 15:27:00', 'Project Server 2019', 'Microsoft', 'DG7GMGF0F4MH', '7613,88 US$', 'Comercial', 'Microsoft\r\n'),
(2, 'd5f6bad5-3bbc-ec11-983f-000d3a8888a9', '2022-04-14 21:43:00', 'Cisco Umbrella Insights (1000-2499)', 'Otro', 'CISCOSINID', '42.960,00 US$', 'Comercial', 'Otros\r\n'),
(3, 'e6f0f14c-eb5d-ec11-8f8f-000d3a889cde', '2021-12-15 21:17:00', 'Endpoint Protection, Subscription License with Support, 100-499 Devices 1 Year', 'Otro', 'SEP-SUB-100-499', '18,93 US$', 'Comercial', 'Symantec\r\n'),
(4, 'd03b9653-eb5d-ec11-8f8f-000d3a889cde', '2022-03-24 15:34:00', 'Dynamics 365 Sales Professional (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LFN5-A/M', '65,00 US$', 'Comercial', 'Microsoft\r\n'),
(5, '4daf31ed-c569-ed11-81ac-000d3a889d88', '2022-11-21 18:00:00', 'Dynamics 365 Sales Enterprise (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LFF1-A/M', '89,06 US$', 'Comercial', 'Microsoft\r\n'),
(6, '6f4ebdd9-5976-ed11-81ac-000d3a889d88', '2022-12-07 18:07:00', 'Common Data Service Database Capacity (Mensual)', 'Microsoft', 'CFQ7TTC0LHRL - M', '36,00 US$', 'Comercial', 'Microsoft\r\n'),
(7, '98770c7c-86fc-ec11-82e5-000d3a889d88', '2022-07-05 17:50:00', 'Premier Pro - Pro for Teams (Nivel 1) (Anual)', 'Adobe', '65272483BB01A12 - A', '459,00 US$', 'Comercial', 'Adobe\r\n'),
(8, '46c64b03-88fc-ec11-82e5-000d3a889d88', '2022-07-05 17:31:00', 'Adobe Stock Team 40 assets per month (Nivel 1)', 'Adobe', '65274059BC01A12 - A', '1083,00 US$', 'Comercial', 'Adobe\r\n'),
(9, '6abb9b7d-88fc-ec11-82e5-000d3a889d88', '2022-07-05 17:35:00', 'Adobe Stock Team 150 assets per month (Nivel 1)', 'Adobe', '65296402BA13A12 - A', '1500,00 US$', 'Comercial', 'Adobe\r\n'),
(10, '7936eb96-8afc-ec11-82e5-000d3a889d88', '2022-07-05 17:49:00', 'Creative Cloud for teams All Apps Education Named license (Nivel 1) (Anual)', 'Adobe', '65272483BB01A12 - A - 12', '507,00 US$', 'Comercial', 'Adobe\r\n'),
(11, '8143a51f-37fd-ec11-82e5-000d3a889d88', '2022-07-06 15:45:00', 'Kaspersky Hybrid Cloud Security (5-9 Nodos)-Base - Trianual', 'Kaspersky', 'KL4255DA*FS - T', '490,00 US$', 'Comercial', 'Kaspersky\r\n'),
(12, 'ec4ad13f-38fd-ec11-82e5-000d3a889d88', '2022-07-06 14:33:00', 'Kaspersky Total Security for Business (250-499 Nodos) Trianual', 'Kaspersky', 'KL4869DATTR-N6', '47,78 US$', 'Comercial', 'Kaspersky\r\n'),
(13, '95e9d324-3cfd-ec11-82e5-000d3a889d88', '2022-07-06 15:01:00', 'Kaspersky Endpoint Security for Business Select (20-24 Nodos)', 'Kaspersky', 'KL4863DA*FS -N3', '57,50 US$', 'Comercial', 'Kaspersky\r\n'),
(14, '957f8d00-07fe-ec11-82e5-000d3a889d88', '2022-07-07 15:12:00', 'Kaspersky Endpoint Security for Business Select (25-49 Nodos) Trianual', 'Kaspersky', 'KL4863DA*TS-3Y', '115,00 US$', 'Comercial', 'Kaspersky\r\n'),
(15, '052183f8-07fe-ec11-82e5-000d3a889d88', '2022-07-07 15:19:00', 'Kaspersky Scan Engine', 'Kaspersky', 'KL6916DHBFS - 1Y', '11.666,66 US$', 'Comercial', 'Kaspersky\r\n'),
(16, 'da866651-08fe-ec11-82e5-000d3a889d88', '2022-07-07 15:21:00', 'Kaspersky Scan Engine-Trianual', 'Kaspersky', 'KL6916DHBFS - 3Y', '23.658,33 US$', 'Comercial', 'Kaspersky\r\n'),
(17, 'dc6cc249-4904-ed11-82e6-000d3a889d88', '2022-07-15 14:23:00', '3DS MAX 1-SINGLE USER SUBSCRIPTION RENEWAL (Anual)', 'Autodesk', '128F1-001355-L890', '1450,00 US$', 'Comercial', 'Autodesk\r\n'),
(18, '9850a6d5-2f09-ed11-82e6-000d3a889d88', '2022-07-21 20:15:00', 'Microsoft 365 F1 (Mensual)', 'Microsoft', 'CFQ7TTC0MBMD - M', '2,76 US$', 'Comercial', 'Microsoft\r\n'),
(19, 'ae77a98e-3409-ed11-82e6-000d3a889d88', '2022-07-21 20:44:00', 'D&M COLLECTION 1-YEAR SINGLE USER RENEWAL (Anual)', 'Autodesk', '02JI1-005995-L403', '3400,00 US$', 'Comercial', 'Autodesk\r\n'),
(20, '7f0a120d-e4b2-ed11-83fd-000d3a889d88', '2023-02-22 19:07:00', 'Habilitaci?n M365 - Migraci?n de Buz?n Compartido', 'Last Call', 'L51', '22,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(21, 'f58d5492-eede-ed11-8847-000d3a889d88', '2023-04-19 20:32:00', '3D Modeling Software Pricing | 3D Design Program Cost | SketchUp SketchUp Pro-1 A?o', 'Otro', 'SketchUp-1Y', '460,00 US$', 'Comercial', 'Otros\r\n'),
(22, '0ec0bba9-02df-ed11-8847-000d3a889d88', '2023-04-19 22:38:00', 'Windows Server 2022 Remote Desktop Services - 1 User CAL 1 Year', 'Microsoft', 'DG7GMGF0D7HX - 1Y', '110,50 US$', 'Comercial', 'Microsoft\r\n'),
(23, '1f879838-425c-ed11-9562-000d3a889d88', '2022-11-04 13:13:00', 'Dynamics 365 Customer Service Enterprise (Anual)', 'Microsoft', 'CFQ7TTC0LFDZ-A', '225,00 US$', 'Comercial', 'Microsoft\r\n'),
(24, 'b80f4491-425c-ed11-9562-000d3a889d88', '2022-11-04 13:16:00', 'Dynamics 365 Remote Assist (Anual)', 'Microsoft', 'CFQ7TTC0LF90-A', '780,00 US$', 'Comercial', 'Microsoft\r\n'),
(25, 'b43c96f2-425c-ed11-9562-000d3a889d88', '2022-11-04 13:20:00', 'Dynamics 365 Sales Enterprise (Anual)', 'Microsoft', 'CFQ7TTC0LFF1-A', '1068,75 US$', 'Comercial', 'Microsoft\r\n'),
(26, '45c45b8f-435c-ed11-9562-000d3a889d88', '2022-11-04 13:22:00', 'Dynamics 365 Team Member (Anual)', 'Microsoft', 'CFQ7TTC0LFNJ-A', '90,00 US$', 'Comercial', 'Microsoft\r\n'),
(27, 'a4c55240-445c-ed11-9562-000d3a889d88', '2022-11-04 20:38:00', 'Power Automate per user with attended RPA plan (Anual)', 'Microsoft', 'CFQ7TTC0LSGZ - A', '450,00 US$', 'Comercial', 'Microsoft\r\n'),
(28, '7fb9192d-f360-ed11-9562-000d3a889d88', '2022-11-10 12:29:00', 'Dynamics 365 Guides (Anual)', 'Microsoft', 'CFQ7TTC0LGV7-A', '780,00 US$', 'Comercial', 'Microsoft\r\n'),
(29, 'eee95170-f360-ed11-9562-000d3a889d88', '2022-11-10 12:31:00', 'Dynamics 365 Guides (Mensual)', 'Microsoft', 'CFQ7TTC0LGV7-M', '78,00 US$', 'Comercial', 'Microsoft\r\n'),
(30, 'aad94bd9-ad65-ed11-9562-000d3a889d88', '2022-11-16 12:56:00', 'Power Apps per app plan (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LHQM - A/M', '9,38 US$', 'Comercial', 'Microsoft\r\n'),
(31, 'a42b7e9a-0823-ed11-9db2-000d3a889d88', '2022-08-23 17:27:00', 'Windows Server 2022 CAL - 1 Device CAL - 1 year', 'Microsoft', 'DG7GMGF0D5VX - 1', '15,70 US$', 'Comercial', 'Microsoft\r\n'),
(32, '1a2c5dfe-b723-ed11-9db2-000d3a889d88', '2022-08-24 14:29:00', 'Power Apps per app plan (Anual)', 'Microsoft', 'CFQ7TTC0LHQM - A', '112,50 US$', 'Comercial', 'Microsoft\r\n'),
(33, '1d10e893-00db-ed11-a7c6-000d3a889d88', '2023-04-14 20:15:00', 'ComponentOne Studio Enterprise 2023 v1 New Perpetual Licenses- 1 Developer License (1Year) And Platinum Support', 'Otro', 'CS-513075-1399598', '3001,24 US$', 'Comercial', 'Component Source\r\n'),
(34, 'ab05ccf6-01db-ed11-a7c6-000d3a889d88', '2023-04-14 20:22:00', 'ComponentOne Studio Enterprise 2023 v1 New Perpetual Licenses- 1 Developer License (1Year)', 'Otro', 'CS-513075-1399597', '2500,00 US$', 'Comercial', 'Component Source\r\n'),
(35, '5977c223-ced3-ed11-a7c7-000d3a889d88', '2023-04-05 16:24:00', 'Exchange Online Archiving for Exchange Online (Anual)', 'Microsoft', 'CFQ7TTC0LH0J - A', '36,00 US$', 'Comercial', 'Microsoft\r\n'),
(36, '6d123e38-00a7-ed11-aad0-000d3a889d88', '2023-02-07 16:05:00', 'Microsoft Teams Premium (Anual)', 'Microsoft', 'CFQ7TTC0RM8K - A', '120,00 US$', 'Comercial', 'Microsoft\r\n'),
(37, '0d1bce8e-00a7-ed11-aad0-000d3a889d88', '2023-02-07 16:03:00', 'Microsoft Teams Premium (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0RM8K - A/M', '10,00 US$', 'Comercial', 'Microsoft\r\n'),
(38, 'd41901f0-00a7-ed11-aad0-000d3a889d88', '2023-02-07 16:04:00', 'Microsoft Teams Premium (Mensual)', 'Microsoft', 'CFQ7TTC0RM8K - M', '12,00 US$', 'Comercial', 'Microsoft\r\n'),
(39, '3c26165b-dfa0-ed11-aad1-000d3a889d88', '2023-01-30 20:57:00', 'SPREADJS 15 - 1 DEVELOPER LICENSE - 1 YEAR MAINTENANCE RENEWAL', 'Otro', 'CS-552403-1331455', '1227,00 US$', 'Comercial', 'Otros\r\n'),
(40, '9b1dc1f2-dfa0-ed11-aad1-000d3a889d88', '2023-01-30 20:58:00', 'SPREADJS 15 - DEPLOYMENT LICENSE - THREE (3) TO FIVE (5) HOSTNAME - ANNUAL RENEWAL', 'Otro', 'CS-552403-1331476', '2551,00 US$', 'Comercial', 'Otros\r\n'),
(41, '3f7195da-6ea1-ed11-aad1-000d3a889d88', '2023-01-31 14:24:00', 'TeamViewer Business', 'TeamViewer', 'S321', '430,00 US$', 'Comercial', 'TeamViewer\r\n'),
(42, '1cc9711b-70a1-ed11-aad1-000d3a889d88', '2023-01-31 14:05:00', 'FORTIGATE-50E 1 YEAR', 'Otro', 'FC-10-0050E-950-02-12', '792,00 US$', 'Comercial', 'Fortinet\r\n'),
(43, '2d830602-73a1-ed11-aad1-000d3a889d88', '2023-01-31 14:26:00', 'TENSOR AGENTS', 'TeamViewer', 'TVTAD001', '500,00 US$', 'Comercial', 'TeamViewer\r\n'),
(44, '09c12577-73a1-ed11-aad1-000d3a889d88', '2023-01-31 14:28:00', 'TENSOR REMOTE WORKER', 'TeamViewer', 'TVTAD400', '33,33 US$', 'Comercial', 'TeamViewer\r\n'),
(45, '88653f40-86c9-ed11-b596-000d3a889d88', '2023-03-23 14:35:00', 'DbForge Studio for PostgreSQL Perpetual Licenses - Standard 1 1 User License - with 3 Year Subscription', 'Otro', 'CS-555452-1392415', '520,25 US$', 'Comercial', 'Component Source\r\n'),
(46, '0fb99995-87c9-ed11-b596-000d3a889d88', '2023-03-23 14:35:00', 'DbForge Studio for MySQL Perpetual Licenses - Standard 1 User License - with 3 Year Subscription', 'Otro', 'CS-532064-1273468', '701,25 US$', 'Comercial', 'Component Source\r\n'),
(47, 'e1fe51aa-d940-ed11-bba3-000d3a889d88', '2022-09-30 16:06:00', 'Microsoft Viva Insights (Anual)', 'Microsoft', 'CFQ7TTC0LHWF - A', '48,00 US$', 'Comercial', 'Microsoft\r\n'),
(48, '94c3fc8c-e0fe-ec11-82e6-000d3a889e1f', '2022-07-08 17:09:00', 'Power Automate per user with attended RPA plan (Mensual)', 'Microsoft', 'CFQ7TTC0LSGZ - M', '48,00 US$', 'Comercial', 'Microsoft\r\n'),
(49, '02f639db-7700-ed11-82e6-000d3a889e1f', '2022-07-10 17:44:00', 'Office 365 A3 For Student (Mensual)', 'Microsoft', '1b6263c0-b8fd-4706-98db-89d2ace5c1bf - M', '2,90 US$', 'Comercial', 'Microsoft - Educaci?n\r\n'),
(50, '6ed78bba-8200-ed11-82e6-000d3a889e1f', '2022-07-10 19:02:00', 'Visio Plan 1 (Mensual)', 'Microsoft', 'CFQ7TTC0HD33 - M', '5,00 US$', 'Comercial', 'Microsoft\r\n'),
(51, '189e9b24-2517-ed11-b83f-000d3a889e1f', '2023-02-21 21:58:00', 'Office 365 Extra File Storage - (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LHS9 - A/M', '0,20 US$', 'Comercial', 'Microsoft\r\n'),
(52, '53d5c56e-2517-ed11-b83f-000d3a889e1f', '2022-08-08 14:22:00', 'Office 365 Extra File Storage - (Mensual)', 'Microsoft', 'CFQ7TTC0LHS9 - M', '0,24 US$', 'Comercial', 'Microsoft\r\n'),
(53, '3d2fd701-36f2-ec11-bb3c-000d3a889e1f', '2022-06-22 14:18:00', 'Kaspersky Endpoint Security for Business Select (250-499 Nodos) Trianual Renewal', 'Kaspersky', 'KL4863DA*TS-N6', '50,00 US$', 'Comercial', 'Kaspersky\r\n'),
(54, 'b219ae7d-37f2-ec11-bb3c-000d3a889e1f', '2022-06-22 14:29:00', 'Kaspersky Endpoint Security for Business Select (15-19 Nodos)-Bianual - Renewal', 'Kaspersky', 'KL4742DA*DR-N2', '72,50 US$', 'Comercial', 'Kaspersky\r\n'),
(55, 'ad6117c2-39f2-ec11-bb3c-000d3a889e1f', '2022-06-22 14:45:00', 'Kaspersky Endpoint Security for Business Select (25-49 Nodos) Bianual Renewal', 'Kaspersky', 'KL4863DA*DS-N3', '60,00 US$', 'Comercial', 'Kaspersky\r\n'),
(56, '213c23a4-3bf2-ec11-bb3c-000d3a889e1f', '2022-06-22 14:59:00', 'Kaspersky Endpoint Security Cloud Plus (150-249 Nodos) Bianual - Renewal', 'Kaspersky', 'KL4743DASDS*DS-N7-', '50,83 US$', 'Comercial', 'Kaspersky\r\n'),
(57, '01ae1855-3df2-ec11-bb3c-000d3a889e1f', '2022-06-22 15:19:00', 'Kaspersky Endpoint Security Cloud (50-99 Nodos) - Bianual - Renewal', 'Kaspersky', 'KL4741DA*DR-N5', '37,50 US$', 'Comercial', 'Kaspersky\r\n'),
(58, '4ce4bd34-3ff2-ec11-bb3c-000d3a889e1f', '2022-06-22 15:23:00', 'Kaspersky Endpoint Security for Business Select (10-19 Nodos)-202206221523054770', 'Kaspersky', 'KL4863DA*FS-N1-202206221523054770', '66,67 US$', 'Comercial', '\r\n'),
(59, '6fd45d4d-3ff2-ec11-bb3c-000d3a889e1f', '2022-06-22 15:25:00', 'Kaspersky Endpoint Security for Business Select (10-14 Nodos)-Bianual - Renewal', 'Kaspersky', 'KL4863DA*DS-N1', '70,00 US$', 'Comercial', 'Kaspersky\r\n'),
(60, '4f19658f-40f2-ec11-bb3c-000d3a889e1f', '2022-06-22 15:34:00', 'Kaspersky Endpoint Security for Business Select (50-99 Nodos)-Bianual - Renewal', 'Kaspersky', 'KL4863DA*DS-N3-BI', '70,00 US$', 'Comercial', 'Kaspersky\r\n'),
(61, '3c34b2e2-41f2-ec11-bb3c-000d3a889e1f', '2022-06-22 15:43:00', 'Kaspersky Small Office Security (5-9 Nodos)- Bianual - Renewal', 'Kaspersky', 'KL4542DA*DR-N1', '43,33 US$', 'Comercial', 'Kaspersky\r\n'),
(62, '9b2acbc0-49f2-ec11-bb3c-000d3a889e1f', '2022-06-22 16:52:00', 'Kaspersky Small Office Security (5-9 Nodos)-Base', 'Kaspersky', 'KL4542DA*FR-N1 - BA', '35,83 US$', 'Comercial', 'Kaspersky\r\n'),
(63, 'b8c12246-4cf2-ec11-bb3c-000d3a889e1f', '2022-06-22 17:01:00', 'Kaspersky Endpoint Security for Business Advanced (25-49 Nodos)-Bianual - Renewal', 'Kaspersky', 'KL4867DA*DR-N2-BI', '84,17 US$', 'Comercial', 'Kaspersky\r\n'),
(64, '2a05e2e2-4ef2-ec11-bb3c-000d3a889e1f', '2022-06-22 18:48:00', 'Kaspersky Small Office Security (15-19 Nodos)- Renewal', 'Kaspersky', 'KL4542DA*FR-N1Y', '25,00 US$', 'Comercial', 'Kaspersky\r\n'),
(65, '46bf2960-2670-ed11-81ac-000d3a88c3ac', '2022-11-29 20:44:00', 'Windows GGWA - Windows 11 Home (Edu) - Legalization Get Genuine', 'Microsoft', 'DG7GMGF0L4TL-EDU', '158,00 US$', 'Comercial', 'Microsoft - Educaci?n\r\n'),
(66, 'a8677e1d-5f7a-ed11-81ad-000d3a88c3ac', '2022-12-12 20:55:00', 'Microsoft Azure DNS (Mensual)', 'Microsoft', 'DNS - M', '6,00 US$', 'Comercial', 'Microsoft\r\n'),
(67, '20878f71-5f7a-ed11-81ad-000d3a88c3ac', '2022-12-12 20:57:00', 'Microsoft Azure DNS (Anual)', 'Microsoft', 'DNS - A', '70,00 US$', 'Comercial', 'Microsoft\r\n'),
(68, 'b989dd1f-50dd-ed11-8847-000d3a88c3ac', '2023-04-17 18:49:00', 'Endpoint Security Complete (New SES/SEP), Hybrid Subscription License with Support, Per Device, 1Y', 'Otro', 'SESC-SES-SUB', '71,97 US$', 'Comercial', 'Symantec\r\n'),
(69, '1439e879-0556-ed11-9561-000d3a88c3ac', '2022-10-27 14:44:00', 'Kaspersky Endpoint Security Cloud Pro-Base (10-14 Nodos) Anual', 'Kaspersky', 'KL4746*DA-N1', '88,33 US$', 'Comercial', 'Kaspersky\r\n'),
(70, '0e9a6b94-0656-ed11-9561-000d3a88c3ac', '2022-10-27 14:49:00', 'Kaspersky Endpoint Security Cloud Plus (150-249 Nodos) Bianual - Renewal-202210271449458542', 'Kaspersky', 'KL4743DASDS*DS-N7--202210271449458542', '50,83 US$', 'Comercial', '\r\n'),
(71, '7f3a3f50-985f-ed11-9562-000d3a88c3ac', '2023-02-21 21:38:00', 'Microsoft Teams Essentials (Mensual)', 'Microsoft', 'CFQ7TTC0JN4R - M', '4,80 US$', 'Comercial', 'Microsoft\r\n'),
(72, '2bd77a35-f166-ed11-9562-000d3a88c3ac', '2022-11-18 03:35:00', 'Microsoft Defender for Endpoint Plan 2 (Anual)', 'Microsoft', 'CFQ7TTC0LGV0 - A', '62,40 US$', 'Comercial', 'Microsoft\r\n'),
(73, '5a515d6b-f166-ed11-9562-000d3a88c3ac', '2022-11-18 03:35:00', 'Microsoft Defender for Endpoint Plan 1 (Anual)', 'Microsoft', 'CFQ7TTC0J1GB - A', '36,00 US$', 'Comercial', 'Microsoft\r\n'),
(74, 'cedd3094-6b28-ed11-9db2-000d3a88c3ac', '2022-08-30 13:58:00', 'KeyShot Pro Subscription (Anual)', 'Otro', 'KEY-1', '2160,00 US$', 'Comercial', 'Otros\r\n'),
(75, '44c460f0-3ecf-ed11-a7c6-000d3a88c3ac', '2023-03-30 21:08:00', 'Visual Studio Ent MSDN ALng SA OLV NL 1Y Aq Y1 AP OVS', 'Microsoft', 'MX3-00133', '2130,64 US$', 'Comercial', 'Microsoft\r\n'),
(76, '04719d3e-dbcf-ed11-a7c6-000d3a88c3ac', '2023-03-31 15:49:00', 'Kaspersky Endpoint Security Cloud (20-24 Nodos) Base Plus 2Year', 'Kaspersky', 'KL4742DA*D8', '46,81 US$', 'Comercial', 'Kaspersky\r\n'),
(77, '808851be-19d3-ed11-a7c7-000d3a88c3ac', '2023-04-04 18:51:00', 'Anydesk - Solo', 'Otro', 'TC-Anydesk', '240,00 US$', 'Comercial', 'Otros\r\n'),
(78, 'bd1cd156-f6a7-ed11-aad0-000d3a88c3ac', '2023-02-08 21:21:00', 'Acrobat Pro DC for teams New - Nivel 3 (Anual)', 'Adobe', '65324056BA03A12', '286,42 US$', 'Comercial', 'Adobe\r\n'),
(79, '8de4d363-049c-ed11-aad1-000d3a88c3ac', '2023-01-24 16:31:00', 'Common Data Service log Capacity (Mensual)', 'Microsoft', 'CFQ7TTC0HBSL - M', '12,00 US$', 'Comercial', 'Microsoft\r\n'),
(80, '8e7a1c2b-1f4f-ed11-bba3-000d3a88c3ac', '2022-10-18 19:59:00', 'AutoturnPro -(Anual)', 'Otro', 'AUTO-A', '1450,00 US$', 'Comercial', 'Otros\r\n'),
(81, '0b9bb1c7-48e0-ec11-bb3d-000d3a88d283', '2022-05-30 18:47:00', 'Visio Plan 1 for faculty', 'Microsoft', '06312e72-b89a-42ad-bd9a-b13c72b16526', '0,75 US$', 'Comercial', 'Microsoft\r\n'),
(82, 'eb59fc21-49e0-ec11-bb3d-000d3a88d283', '2022-05-30 18:49:00', 'Visio Plan 2 for faculty', 'Microsoft', '0198ee56-db84-4f71-a798-f5a497ce20d6', '1,66 US$', 'Comercial', 'Microsoft\r\n'),
(83, '950c9f6f-49e0-ec11-bb3d-000d3a88d283', '2022-05-30 18:51:00', 'Visio Plan 2 for students', 'Microsoft', '37b24fc8-36d6-48ff-b7cd-19734aac6095', '1,29 US$', 'Comercial', 'Microsoft\r\n'),
(84, '528d5694-ad4c-ec11-8f8e-000d3a88d52d', '2022-03-10 16:13:00', 'Office 365 A3 For Faculty (Anualidad con Pago Mensual)', 'Microsoft', '7eb5101b-b893-4d63-92ca-72df3c71fafc-M', '3,25 US$', 'Comercial', 'Microsoft - Educaci?n\r\n'),
(85, '42f58413-ac53-ec11-8f8e-000d3a88dcfb', '2023-02-21 21:38:00', 'Microsoft Teams Essentials (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0JN4R - A/M', '4,00 US$', 'Comercial', 'Microsoft\r\n'),
(86, 'd2e4e07b-ac53-ec11-8f8e-000d3a88dcfb', '2023-02-21 21:37:00', 'Microsoft Teams Essentials (Anual)', 'Microsoft', 'CFQ7TTC0JN4R - A', '48,00 US$', 'Comercial', 'Microsoft\r\n'),
(87, 'b751957d-e673-ec11-8943-000d3a8901fd', '2022-01-12 20:44:00', 'Acrobat Standard DC for teams New - Nivel 2 (Trianual)', 'Adobe', '65297914BA02A12 - T', '582,31 US$', 'Comercial', 'Adobe\r\n'),
(88, 'd0047595-6f74-ec11-8943-000d3a8901fd', '2022-01-13 12:58:00', 'Microsoft 365 Apps for Students (11 Meses)', 'Microsoft', '5699c6f3-cc7a-4212-9042-8f85ce30f4e0 -11', '16,74 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(89, 'e95fe800-c777-ec11-8943-000d3a8901fd', '2022-01-17 18:56:00', 'Kaspersky Endpoint Security Cloud Plus (50-99 Nodos) Ampliacion', 'Kaspersky', 'KL4743DA*FS-N5-A', '39,00 US$', 'Comercial', 'Kaspersky\r\n'),
(90, '796823c8-61d8-ec11-a7b5-000d3ac0327c', '2022-05-20 17:29:00', 'Windows Server 2022 Standard - 8 Core License Pack 1 Year', 'Microsoft', 'DG7GMGF0D5RK - A', '417,07 US$', 'Comercial', 'Microsoft\r\n'),
(91, 'c056bf7b-6bdc-ec11-a7b5-000d3ac0327c', '2022-05-25 20:46:00', 'Certificado SSL', 'Microsoft', 'SSL', '70,00 US$', 'Comercial', 'Microsoft\r\n'),
(92, '018c1707-6fdc-ec11-a7b5-000d3ac0327c', '2022-05-25 21:10:00', 'Enscape 3D', 'Otro', 'Ens-3D', '1200,00 US$', 'Comercial', 'Otros\r\n'),
(93, '09f7729b-67b5-ea11-a812-000d3ac04131', '2022-03-16 21:36:00', 'Windows Server 2022 Standard - 2 Core License Pack', 'Microsoft', 'DG7GMGF0D5RK', '163,63 US$', 'Comercial', 'Microsoft\r\n'),
(94, '6032f721-68b5-ea11-a812-000d3ac04131', '2022-01-12 14:57:00', 'Office LTSC Professional Plus 2021', 'Microsoft', 'DG7GMGF0D7FX - C', '751,19 US$', 'Comercial', 'Microsoft\r\n'),
(95, '4735219c-68b5-ea11-a812-000d3ac04131', '2022-01-12 15:18:00', 'Office LTSC Standard 2021', 'Microsoft', 'DG7GMGF0D7FZ - C', '550,38 US$', 'Comercial', 'Microsoft\r\n'),
(96, '0d2b83d8-68b5-ea11-a812-000d3ac04131', '2022-01-12 15:20:00', 'Office LTSC Standard for Mac 2021', 'Microsoft', 'DG7GMGF0D7D1 - C', '550,38 US$', 'Comercial', 'Microsoft\r\n'),
(97, '4808bc27-69b5-ea11-a812-000d3ac04131', '2022-01-12 15:25:00', 'Project Professional 2021', 'Microsoft', 'DG7GMGF0D7D7', '1380,19 US$', 'Comercial', 'Microsoft\r\n'),
(98, '24bc4a7d-69b5-ea11-a812-000d3ac04131', '2022-03-16 21:26:00', 'SQL Server 2019 - 1 Device CAL', 'Microsoft', 'DG7GMGF0FKZW - D', '255,00 US$', 'Comercial', 'Microsoft\r\n'),
(99, '2e69eba1-69b5-ea11-a812-000d3ac04131', '2022-03-16 21:25:00', 'SQL Server 2019 - 1 User CAL', 'Microsoft', 'DG7GMGF0FKZW - U', '255,00 US$', 'Comercial', 'Microsoft\r\n'),
(100, 'ad9b220b-6ab5-ea11-a812-000d3ac04131', '2023-04-10 20:31:00', 'SQL Server 2022 Enterprise Core - 2 Core License Pack', 'Microsoft', 'DG7GMGF0M7XV', '18.477,94 US$', 'Comercial', 'Microsoft\r\n'),
(101, '8ed76836-6ab5-ea11-a812-000d3ac04131', '2023-01-27 14:30:00', 'SQL Server 2022 Standard Edition', 'Microsoft', 'DG7GMGF0M80J', '1205,94 US$', 'Comercial', 'Microsoft\r\n'),
(102, '13e80e6e-6ab5-ea11-a812-000d3ac04131', '2023-01-27 14:33:00', 'SQL Server 2022 Standard Core - 2 Core License Pack', 'Microsoft', 'DG7GMGF0M7XW', '4819,50 US$', 'Comercial', 'Microsoft\r\n'),
(103, '82a861bd-6ab5-ea11-a812-000d3ac04131', '2020-06-23 16:01:00', 'Visio Professional 2019', 'Microsoft', 'D87-07499', '643,10 US$', 'Comercial', 'Microsoft\r\n'),
(104, '299283e2-6ab5-ea11-a812-000d3ac04131', '2020-06-23 16:02:00', 'Visio Standard 2019', 'Microsoft', 'D86-05868', '334,96 US$', 'Comercial', 'Microsoft\r\n'),
(105, 'f6404c1c-6cb5-ea11-a812-000d3ac04131', '2021-03-25 16:17:00', 'Visual Studio Professional 2019', 'Microsoft', 'C5E-01380', '607,16 US$', 'Comercial', 'Microsoft\r\n'),
(106, 'f0b06a65-6cb5-ea11-a812-000d3ac04131', '2022-03-17 00:07:00', 'Windows Server 2022 Remote Desktop Services - 1 Device CAL', 'Microsoft', 'DG7GMGF0D7HX - D', '176,38 US$', 'Comercial', 'Microsoft\r\n'),
(107, '17785a96-6cb5-ea11-a812-000d3ac04131', '2022-03-17 00:09:00', 'Windows Server 2022 Remote Desktop Services - 1 User CAL', 'Microsoft', 'DG7GMGF0D7HX - U', '176,38 US$', 'Comercial', 'Microsoft\r\n'),
(108, '219fe69f-72b5-ea11-a812-000d3ac04131', '2023-01-30 20:45:00', 'SQL Server Standard Edition 2019 (Gobierno)', 'Microsoft', '228-11487', '866,80 US$', 'Gobierno', 'Microsof\r\n'),
(109, 'c565d5d5-72b5-ea11-a812-000d3ac04131', '2023-01-30 20:45:00', 'SQL Server Standard Core 2019 (Gobierno)', 'Microsoft', '7NQ-01581', '3466,14 US$', 'Gobierno', 'Microsof\r\n'),
(110, '6b26b41d-73b5-ea11-a812-000d3ac04131', '2023-01-30 20:45:00', 'Windows Server RDS CAL 2019 - Device (Gobierno)', 'Microsoft', '6VC-03765', '105,07 US$', 'Gobierno', 'Microsof\r\n'),
(111, '8a40a665-73b5-ea11-a812-000d3ac04131', '2023-01-30 20:45:00', 'Windows Server RDS CAL 2019 - User (Gobierno)', 'Microsoft', '6VC-03766', '126,38 US$', 'Gobierno', 'Microsof\r\n'),
(112, '3741af9b-73b5-ea11-a812-000d3ac04131', '2023-01-30 20:44:00', 'Windows Server CAL 2019 - Device (Gobierno)', 'Microsoft', 'R18-05785', '27,68 US$', 'Gobierno', 'Microsof\r\n'),
(113, '71fcbfcb-73b5-ea11-a812-000d3ac04131', '2023-01-30 20:44:00', 'Windows Server CAL 2019 - User (Gobierno)', 'Microsoft', 'R18-05786', '35,12 US$', 'Gobierno', 'Microsof\r\n'),
(114, 'ce953808-74b5-ea11-a812-000d3ac04131', '2023-01-30 20:44:00', 'Windows Server Datacenter 2019 - 16 Core (Gobierno)', 'Microsoft', '9EA-01062', '5928,79 US$', 'Gobierno', 'Microsof\r\n'),
(115, '475f5b5c-74b5-ea11-a812-000d3ac04131', '2023-01-30 20:43:00', 'Windows Server Datacenter 2019 - 2 Core (Gobierno)', 'Microsoft', '9EA-01063', '741,59 US$', 'Gobierno', 'Microsof\r\n'),
(116, '3c44389e-74b5-ea11-a812-000d3ac04131', '2023-01-30 20:43:00', 'Windows Server Essentials 2019 (Gobierno)', 'Microsoft', 'G3S-01268', '483,10 US$', 'Gobierno', 'Microsof\r\n'),
(117, '891b3ad4-74b5-ea11-a812-000d3ac04131', '2023-01-30 20:42:00', 'Windows Server Standard 2019 - 16 Core (Gobierno)', 'Microsoft', '9EM-00670', '830,11 US$', 'Gobierno', 'Microsof\r\n'),
(118, '58c4291c-75b5-ea11-a812-000d3ac04131', '2023-01-30 20:42:00', 'Windows Server Standard 2019 - 2 Core (Gobierno)', 'Microsoft', '9EM-00671', '105,25 US$', 'Gobierno', 'Microsof\r\n'),
(119, '286c2805-83b5-ea11-a812-000d3ac04131', '2022-01-12 15:22:00', 'Office LTSC Standard for Mac 2021 - Academico', 'Microsoft', 'DG7GMGF0D7D1 - Edu', '81,81 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(120, '7d5d5464-87b5-ea11-a812-000d3ac04131', '2022-01-12 15:12:00', 'Office LTSC Professional Plus 2021 - Academico', 'Microsoft', 'DG7GMGF0D7FX - Edu', '112,63 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(121, '19509630-88b5-ea11-a812-000d3ac04131', '2022-01-12 14:44:00', 'Office LTSC Standard 2021 - Academico', 'Microsoft', 'DG7GMGF0D7FZ - Edu', '81,81 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(122, '4f27fddd-8cb5-ea11-a812-000d3ac04131', '2020-06-23 20:07:00', 'SQL CAL 2019 - Device (Educaci?n)', 'Microsoft', '359-06846', '55,32 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(123, '29931d32-8db5-ea11-a812-000d3ac04131', '2020-06-23 20:08:00', 'SQL CAL 2019 - User (Educaci?n)', 'Microsoft', '359-06848', '55,32 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(124, '56491556-8db5-ea11-a812-000d3ac04131', '2020-06-23 20:09:00', 'SQL Server Enterprise Core 2019 (Educaci?n)', 'Microsoft', '7JQ-01593', '3639,98 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(125, '256e2886-8db5-ea11-a812-000d3ac04131', '2020-06-23 20:10:00', 'SQL Server Standard Core 2019 (Educaci?n)', 'Microsoft', '7NQ-01550', '949,32 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(126, '517466b6-8db5-ea11-a812-000d3ac04131', '2020-06-23 20:12:00', 'SQL Server Standard Edition 2019 (Educaci?n)', 'Microsoft', '228-11468', '237,74 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(127, '80bb2aa7-90b5-ea11-a812-000d3ac04131', '2020-06-23 20:33:00', 'Windows Home 10 Legalization GetGenuine (Educaci?n)', 'Microsoft', 'KW9-00311', '138,31 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(128, '6f34a0e9-90b5-ea11-a812-000d3ac04131', '2020-06-23 20:35:00', 'Windows Server RDS CAL 2019 - Device (Educaci?n)', 'Microsoft', '6VC-03726', '26,91 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(129, 'd2ce376e-91b5-ea11-a812-000d3ac04131', '2020-06-23 20:38:00', 'Windows Server RDS CAL 2019 - User (Educaci?n)', 'Microsoft', '6VC-03728', '26,91 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(130, 'e63ad458-92b5-ea11-a812-000d3ac04131', '2020-06-23 20:46:00', 'Windows Server CAL 2019 - Device Students (Educaci?n)', 'Microsoft', 'R18-05736', '0,75 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(131, '75e64095-92b5-ea11-a812-000d3ac04131', '2020-06-23 20:46:00', 'Windows Server CAL 2019 - User Students (Educaci?n)', 'Microsoft', 'R18-05738', '0,75 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(132, '183652bf-92b5-ea11-a812-000d3ac04131', '2020-06-23 20:48:00', 'Windows Server CAL 2019 - Device (Educaci?n)', 'Microsoft', 'R18-05746', '8,67 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(133, '392f691e-b0b5-ea11-a812-000d3ac04131', '2020-06-24 00:19:00', 'Windows Server CAL 2019 - User (Educaci?n)', 'Microsoft', 'R18-05748', '8,67 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(134, 'b00304d0-b0b5-ea11-a812-000d3ac04131', '2020-06-24 00:23:00', 'Windows Server Datacenter 2019 - 16 Core (Educaci?n)', 'Microsoft', '9EA-01023', '1629,95 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(135, '83cd0f06-b1b5-ea11-a812-000d3ac04131', '2020-06-24 00:24:00', 'Windows Server Datacenter 2019 - 2 Core (Educaci?n)', 'Microsoft', '9EA-01025', '203,80 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(136, '70554030-b1b5-ea11-a812-000d3ac04131', '2020-06-24 00:25:00', 'Windows Server Essentials 2019 (Educaci?n)', 'Microsoft', 'G3S-01249', '132,48 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(137, 'd3197754-b1b5-ea11-a812-000d3ac04131', '2020-06-24 00:26:00', 'Windows Server Standard 2019 - 16 Core (Educaci?n)', 'Microsoft', '9EM-00631', '257,33 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(138, 'ee197754-b1b5-ea11-a812-000d3ac04131', '2020-06-24 00:27:00', 'Windows Server Standard 2019 - 2 Core (Educaci?n)', 'Microsoft', '9EM-00633', '32,60 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(139, '9400490c-97b6-ea11-a812-000d3ac05981', '2023-02-21 21:56:00', 'Azure Active Directory Premium P1 (Anual)', 'Microsoft', 'CFQ7TTC0LFLS - A', '72,00 US$', 'Comercial', 'Microsoft\r\n'),
(140, 'abda551e-97b6-ea11-a812-000d3ac05981', '2023-02-21 21:56:00', 'Azure Active Directory Premium P1 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LFLS - A/M', '6,00 US$', 'Comercial', 'Microsoft\r\n'),
(141, '5a2cbe42-97b6-ea11-a812-000d3ac05981', '2023-02-21 21:56:00', 'Azure Active Directory Premium P2 (Anual)', 'Microsoft', 'CFQ7TTC0LFK5 - A', '108,00 US$', 'Comercial', 'Microsoft\r\n'),
(142, '7ef0e160-97b6-ea11-a812-000d3ac05981', '2023-02-21 21:56:00', 'Azure Active Directory Premium P2 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LFK5 - A/M', '9,00 US$', 'Comercial', 'Microsoft\r\n'),
(143, '5261fef7-97b6-ea11-a812-000d3ac05981', '2023-02-21 21:57:00', 'Azure Information Protection Premium P1 (Anual)', 'Microsoft', 'CFQ7TTC0LH9J - A', '24,00 US$', 'Comercial', 'Microsoft\r\n'),
(144, 'cc0ff9fd-97b6-ea11-a812-000d3ac05981', '2023-02-21 21:57:00', 'Azure Information Protection Premium P1 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LH9J - A/M', '2,00 US$', 'Comercial', 'Microsoft\r\n'),
(145, '0ef6fd3f-98b6-ea11-a812-000d3ac05981', '2022-03-17 02:26:00', 'Enterprise Mobility + Security E3 (Anual)', 'Microsoft', 'CFQ7TTC0LHT4 - A', '127,50 US$', 'Comercial', 'Microsoft\r\n'),
(146, '95ccf563-98b6-ea11-a812-000d3ac05981', '2022-03-17 02:28:00', 'Enterprise Mobility + Security E3 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LHT4 - A/M', '10,63 US$', 'Comercial', 'Microsoft\r\n'),
(147, '0928e775-98b6-ea11-a812-000d3ac05981', '2022-03-17 02:32:00', 'Enterprise Mobility + Security E5 (Anual)', 'Microsoft', 'CFQ7TTC0LFJ1 - A', '198,00 US$', 'Comercial', 'Microsoft\r\n'),
(148, '2a7cff8d-98b6-ea11-a812-000d3ac05981', '2022-03-17 02:32:00', 'Enterprise Mobility + Security E5 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LFJ1 - A/M', '16,50 US$', 'Comercial', 'Microsoft\r\n'),
(149, '411159f4-98b6-ea11-a812-000d3ac05981', '2022-03-16 20:53:00', 'Exchange Online Plan 1 (Anual)', 'Microsoft', 'CFQ7TTC0LH16 - A', '48,00 US$', 'Comercial', 'Microsoft\r\n'),
(150, 'cfbe2f30-99b6-ea11-a812-000d3ac05981', '2022-03-16 20:53:00', 'Exchange Online Plan 1 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LH16 - A/M', '4,00 US$', 'Comercial', 'Microsoft\r\n'),
(151, '68453548-99b6-ea11-a812-000d3ac05981', '2022-03-16 20:58:00', 'Exchange Online Plan 2 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LH1P - A/M', '8,00 US$', 'Comercial', 'Microsoft\r\n'),
(152, '1a22c266-99b6-ea11-a812-000d3ac05981', '2022-03-16 20:57:00', 'Exchange Online Plan 2 (Anual)', 'Microsoft', 'CFQ7TTC0LH1P - A', '96,00 US$', 'Comercial', 'Microsoft\r\n'),
(153, '0c6fbaf1-99b6-ea11-a812-000d3ac05981', '2022-03-16 21:03:00', 'Exchange Online Kiosk (Anual)', 'Microsoft', 'CFQ7TTC0LH0L - A', '24,00 US$', 'Comercial', 'Microsoft\r\n'),
(154, '17b1ee0f-9ab6-ea11-a812-000d3ac05981', '2022-03-16 21:03:00', 'Exchange Online Kiosk (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LH0L - A/M', '2,00 US$', 'Comercial', 'Microsoft\r\n'),
(155, '8caec858-9ab6-ea11-a812-000d3ac05981', '2022-03-17 02:17:00', 'Microsoft Intune (Anual)', 'Microsoft', 'CFQ7TTC0LCH4 - A', '96,00 US$', 'Comercial', 'Microsoft\r\n'),
(156, 'f7c2da76-9ab6-ea11-a812-000d3ac05981', '2022-03-17 02:22:00', 'Microsoft Intune (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LCH4 - A/M', '8,00 US$', 'Comercial', 'Microsoft\r\n'),
(157, '50ba4668-9bb6-ea11-a812-000d3ac05981', '2022-03-16 13:14:00', 'Microsoft 365 Apps for business (Anual)', 'Microsoft', 'CFQ7TTC0LH1G - A', '99,00 US$', 'Comercial', 'Microsoft\r\n'),
(158, '94248a98-9bb6-ea11-a812-000d3ac05981', '2023-02-27 01:30:00', 'Microsoft 365 Apps for business (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LH1G - A/M', '8,25 US$', 'Comercial', 'Microsoft\r\n'),
(159, '4020a6b0-9bb6-ea11-a812-000d3ac05981', '2022-03-16 13:21:00', 'Microsoft 365 Apps for enterprise (Anual)', 'Microsoft', 'CFQ7TTC0LGZT - A', '144,00 US$', 'Comercial', 'Microsoft\r\n'),
(160, '63b4dbce-9bb6-ea11-a812-000d3ac05981', '2022-03-16 13:21:00', 'Microsoft 365 Apps for enterprise (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LGZT - A/M', '12,00 US$', 'Comercial', 'Microsoft\r\n'),
(161, '09123130-9cb6-ea11-a812-000d3ac05981', '2020-06-25 04:28:00', 'Microsoft 365 Audio Conferencing (Anual)', 'Microsoft', 'c94271d8-b431-4a25-a3c5-a57737a1c909', '60,00 US$', 'Comercial', 'Microsoft\r\n'),
(162, 'bef63a48-9cb6-ea11-a812-000d3ac05981', '2022-03-10 16:16:00', 'Microsoft 365 Audio Conferencing (Anualidad con Pago Mensual)', 'Microsoft', 'c94271d8-b431-4a25-a3c5-a57737a1c909-M', '5,00 US$', 'Comercial', 'Microsoft\r\n'),
(163, 'dd818bb4-9cb6-ea11-a812-000d3ac05981', '2022-03-16 13:06:00', 'Microsoft 365 Business Basic (Anual)', 'Microsoft', 'CFQ7TTC0LH18 - A', '72,00 US$', 'Comercial', 'Microsoft\r\n'),
(164, 'de74acd8-9cb6-ea11-a812-000d3ac05981', '2022-03-16 13:06:00', 'Microsoft 365 Business Basic (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LH18 - A/M', '6,00 US$', 'Comercial', 'Microsoft\r\n'),
(165, '4b9dc2ea-9cb6-ea11-a812-000d3ac05981', '2022-03-16 13:10:00', 'Microsoft 365 Business Premium (Anual)', 'Microsoft', 'CFQ7TTC0LCHC - A', '264,00 US$', 'Comercial', 'Microsoft\r\n'),
(166, '3fcaaf02-9db6-ea11-a812-000d3ac05981', '2022-03-16 13:11:00', 'Microsoft 365 Business Premium (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LCHC - A/M', '22,00 US$', 'Comercial', 'Microsoft\r\n'),
(167, 'ba3aae14-9db6-ea11-a812-000d3ac05981', '2022-03-16 13:05:00', 'Microsoft 365 Business Standard (Anual)', 'Microsoft', 'CFQ7TTC0LDPB - A', '150,00 US$', 'Comercial', 'Microsoft\r\n'),
(168, '90f3c032-9db6-ea11-a812-000d3ac05981', '2022-03-16 12:59:00', 'Microsoft 365 Business Standard (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LDPB - A/M', '12,50 US$', 'Comercial', 'Microsoft\r\n'),
(169, 'e3213d9f-9db6-ea11-a812-000d3ac05981', '2022-03-01 16:38:00', 'Microsoft 365 E3 (Anual)', 'Microsoft', '2b3b8d2d-10aa-4be4-b5fd-7f2feb0c3091', '432,00 US$', 'Comercial', 'Microsoft\r\n'),
(170, '0b1ecbc9-9db6-ea11-a812-000d3ac05981', '2022-03-10 16:17:00', 'Microsoft 365 E3 (Anualidad con Pago Mensual)', 'Microsoft', '2b3b8d2d-10aa-4be4-b5fd-7f2feb0c3091-M', '36,00 US$', 'Comercial', 'Microsoft\r\n'),
(171, 'ec91ccf4-9db6-ea11-a812-000d3ac05981', '2022-12-21 21:18:00', 'Microsoft 365 E5 (Anual)', 'Microsoft', 'CFQ7TTC0LFLZ - A', '690,00 US$', 'Comercial', 'Microsoft\r\n'),
(172, '9810e712-9eb6-ea11-a812-000d3ac05981', '2022-12-21 21:18:00', 'Microsoft 365 E5 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LFLZ A/M', '57,50 US$', 'Comercial', 'Microsoft\r\n'),
(173, '209ba867-9eb6-ea11-a812-000d3ac05981', '2022-07-21 19:58:00', 'Microsoft 365 F1 (Anual)', 'Microsoft', '1ce4a4ba-65f7-49e7-bb28-d92d07d58b86', '27,60 US$', 'Comercial', 'Microsoft\r\n'),
(174, '2a9ad47f-9eb6-ea11-a812-000d3ac05981', '2022-07-21 20:18:00', 'Microsoft 365 F1 (Anualidad con Pago Mensual)', 'Microsoft', '1ce4a4ba-65f7-49e7-bb28-d92d07d58b86-M', '2,30 US$', 'Comercial', 'Microsoft\r\n'),
(175, 'ecc91a98-9eb6-ea11-a812-000d3ac05981', '2023-02-21 21:47:00', 'Microsoft 365 F3 (Anual)', 'Microsoft', 'CFQ7TTC0LH05 - A', '120,00 US$', 'Comercial', 'Microsoft\r\n'),
(176, '748e13b6-9eb6-ea11-a812-000d3ac05981', '2023-02-21 21:48:00', 'Microsoft 365 F3 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LH05 - A/M', '10,00 US$', 'Comercial', 'Microsoft\r\n'),
(177, 'aeb39810-9fb6-ea11-a812-000d3ac05981', '2020-06-25 04:48:00', 'Microsoft Cloud App Security (Anual)', 'Microsoft', 'dbd10351-5631-4a01-a643-00e8ff14e7b2', '42,00 US$', 'Comercial', 'Microsoft\r\n'),
(178, 'fe57a622-9fb6-ea11-a812-000d3ac05981', '2022-03-10 16:18:00', 'Microsoft Cloud App Security (Anualidad con Pago Mensual)', 'Microsoft', 'dbd10351-5631-4a01-a643-00e8ff14e7b2-M', '3,50 US$', 'Comercial', 'Microsoft\r\n'),
(179, '6d253483-9fb6-ea11-a812-000d3ac05981', '2020-06-25 04:51:00', 'Microsoft Defender Advanced Threat Protection (Anual)', 'Microsoft', 'e2dcab13-1365-417a-b624-4901e2b252f5', '63,00 US$', 'Comercial', 'Microsoft\r\n'),
(180, 'b2958c9b-9fb6-ea11-a812-000d3ac05981', '2022-03-10 16:19:00', 'Microsoft Defender Advanced Threat Protection (Anualidad con Pago Mensual)', 'Microsoft', 'e2dcab13-1365-417a-b624-4901e2b252f5-M', '5,25 US$', 'Comercial', 'Microsoft\r\n'),
(181, '6353e1c5-9fb6-ea11-a812-000d3ac05981', '2023-02-21 21:36:00', 'Microsoft Defender for Office 365 (Plan 1) (Anual)', 'Microsoft', 'CFQ7TTC0LH04 - A', '23,70 US$', 'Comercial', 'Microsoft\r\n'),
(182, 'c37719e4-9fb6-ea11-a812-000d3ac05981', '2023-02-21 21:36:00', 'Microsoft Defender for Office 365 (Plan 1) (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LH04 - A/M', '1,98 US$', 'Comercial', 'Microsoft\r\n'),
(183, '7d0f37fc-9fb6-ea11-a812-000d3ac05981', '2023-02-21 21:36:00', 'Microsoft Defender for Office 365 (Plan 2) (Anual)', 'Microsoft', 'CFQ7TTC0LHXH - A', '59,26 US$', 'Comercial', 'Microsoft\r\n'),
(184, '4d6b2b14-a0b6-ea11-a812-000d3ac05981', '2023-02-21 21:37:00', 'Microsoft Defender for Office 365 (Plan 2) (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LHXH - A/M', '4,94 US$', 'Comercial', 'Microsoft\r\n'),
(185, '112f6362-a0b6-ea11-a812-000d3ac05981', '2022-03-16 13:22:00', 'Office 365 E1 (Anual)', 'Microsoft', 'CFQ7TTC0LF8Q - A', '120,00 US$', 'Comercial', 'Microsoft\r\n'),
(186, '948f09e1-a0b6-ea11-a812-000d3ac05981', '2022-03-16 13:22:00', 'Office 365 E1 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LF8Q - A/M', '10,00 US$', 'Comercial', 'Microsoft\r\n'),
(187, '8e8bfd16-a1b6-ea11-a812-000d3ac05981', '2022-03-16 13:23:00', 'Office 365 E3 (Anual)', 'Microsoft', 'CFQ7TTC0LF8R - A', '276,00 US$', 'Comercial', 'Microsoft\r\n'),
(188, '63736135-a1b6-ea11-a812-000d3ac05981', '2022-03-16 13:23:00', 'Office 365 E3 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LF8R - A/M', '23,00 US$', 'Comercial', 'Microsoft\r\n'),
(189, 'bcfb726b-a1b6-ea11-a812-000d3ac05981', '2023-03-29 12:28:00', 'Office 365 E5 (Anual)', 'Microsoft', 'CFQ7TTC0LF8S', '456,00 US$', 'Comercial', 'Microsoft\r\n'),
(190, 'da649c83-a1b6-ea11-a812-000d3ac05981', '2023-03-29 12:28:00', 'Office 365 E5 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LF8S - M', '38,00 US$', 'Comercial', 'Microsoft\r\n'),
(191, 'c500afc5-a1b6-ea11-a812-000d3ac05981', '2023-02-21 21:47:00', 'Office 365 F3 (Anual)', 'Microsoft', 'CFQ7TTC0LGZW - A', '48,00 US$', 'Comercial', 'Microsoft\r\n'),
(192, '2dcda9e3-a1b6-ea11-a812-000d3ac05981', '2023-02-21 21:47:00', 'Office 365 F3 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LGZW - A/M', '4,00 US$', 'Comercial', 'Microsoft\r\n'),
(193, '859ff36d-a2b6-ea11-a812-000d3ac05981', '2022-03-17 01:45:00', 'OneDrive for Business Plan 1 (Anual)', 'Microsoft', 'CFQ7TTC0LHSV - A', '60,00 US$', 'Comercial', 'Microsoft\r\n'),
(194, 'd2b2ef85-a2b6-ea11-a812-000d3ac05981', '2022-03-17 01:45:00', 'OneDrive for Business Plan 1 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LHSV - A/M', '5,00 US$', 'Comercial', 'Microsoft\r\n'),
(195, '342824aa-a2b6-ea11-a812-000d3ac05981', '2022-03-17 01:48:00', 'OneDrive for Business Plan 2 (Anual)', 'Microsoft', 'CFQ7TTC0LH1M - A', '120,00 US$', 'Comercial', 'Microsoft\r\n'),
(196, 'd94d47c2-a2b6-ea11-a812-000d3ac05981', '2022-03-17 01:49:00', 'OneDrive for Business Plan 2 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LH1M - A/M', '10,00 US$', 'Comercial', 'Microsoft\r\n'),
(197, '503463ec-a2b6-ea11-a812-000d3ac05981', '2023-04-10 14:38:00', 'Power BI Pro (Anual)', 'Microsoft', 'CFQ7TTC0LHSF - A', '120,00 US$', 'Comercial', 'Microsoft\r\n'),
(198, '37ccb604-a3b6-ea11-a812-000d3ac05981', '2022-03-16 13:24:00', 'Power BI Pro (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LHSF - A/M', '10,00 US$', 'Comercial', 'Microsoft\r\n'),
(199, 'a380a634-a3b6-ea11-a812-000d3ac05981', '2022-03-16 21:08:00', 'Project Plan 1 (Anual)', 'Microsoft', 'CFQ7TTC0HDB1 - A', '120,00 US$', 'Comercial', 'Microsoft\r\n'),
(200, '6e97d058-a3b6-ea11-a812-000d3ac05981', '2022-03-16 21:08:00', 'Project Plan 1 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0HDB1 - A/M', '10,00 US$', 'Comercial', 'Microsoft\r\n'),
(201, '2d82e376-a3b6-ea11-a812-000d3ac05981', '2022-03-16 21:10:00', 'Project Plan 3 (Anual)', 'Microsoft', 'CFQ7TTC0HDB0 - A', '360,00 US$', 'Comercial', 'Microsoft\r\n'),
(202, 'e0f7fd8e-a3b6-ea11-a812-000d3ac05981', '2022-03-16 21:11:00', 'Project Plan 3 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0HDB0 - A/M', '30,00 US$', 'Comercial', 'Microsoft\r\n'),
(203, 'd194f9be-a3b6-ea11-a812-000d3ac05981', '2022-03-16 21:13:00', 'Project Plan 5 (Anual)', 'Microsoft', 'CFQ7TTC0HD9Z - A', '660,00 US$', 'Comercial', 'Microsoft\r\n'),
(204, '368febd6-a3b6-ea11-a812-000d3ac05981', '2022-03-16 21:13:00', 'Project Plan 5 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0HD9Z - A/M', '55,00 US$', 'Comercial', 'Microsoft\r\n'),
(205, 'f88efc06-a4b6-ea11-a812-000d3ac05981', '2022-03-17 01:36:00', 'SharePoint Online Plan 1 (Anual)', 'Microsoft', 'CFQ7TTC0LH0N - A', '60,00 US$', 'Comercial', 'Microsoft\r\n'),
(206, '33f63225-a4b6-ea11-a812-000d3ac05981', '2022-03-17 01:37:00', 'SharePoint Online Plan 1 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LH0N - A/M', '5,00 US$', 'Comercial', 'Microsoft\r\n'),
(207, 'bb042f37-a4b6-ea11-a812-000d3ac05981', '2022-03-17 01:40:00', 'SharePoint Online Plan 2 (Anual)', 'Microsoft', 'CFQ7TTC0LH14 - A', '120,00 US$', 'Comercial', 'Microsoft\r\n'),
(208, 'e9ce3449-a4b6-ea11-a812-000d3ac05981', '2022-03-17 01:41:00', 'SharePoint Online Plan 2 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LH14 - A/M', '10,00 US$', 'Comercial', 'Microsoft\r\n'),
(209, 'f0778c8b-a4b6-ea11-a812-000d3ac05981', '2023-02-21 21:53:00', 'Visio Plan 1 (Anual)', 'Microsoft', 'CFQ7TTC0HD33 - A', '60,00 US$', 'Comercial', 'Microsoft\r\n'),
(210, '00b973af-a4b6-ea11-a812-000d3ac05981', '2022-07-10 19:01:00', 'Visio Plan 1 (Anualidad de pago Mensual)', 'Microsoft', 'CFQ7TTC0HD33 - A/M', '5,00 US$', 'Comercial', 'Microsoft\r\n'),
(211, '3580bfd3-a4b6-ea11-a812-000d3ac05981', '2023-02-21 21:53:00', 'Visio Plan 2 (Anual)', 'Microsoft', 'CFQ7TTC0HD32 - A', '180,00 US$', 'Comercial', 'Microsoft\r\n'),
(212, '70240710-a5b6-ea11-a812-000d3ac05981', '2023-02-21 21:52:00', 'Visio Plan 2 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0HD32 - A/M', '15,00 US$', 'Comercial', 'Microsoft\r\n'),
(213, '2c0d3540-a5b6-ea11-a812-000d3ac05981', '2022-03-17 00:47:00', 'Windows 10/11 Enterprise E3 (Anual)', 'Microsoft', 'CFQ7TTC0LGTX - A', '84,00 US$', 'Comercial', 'Microsoft\r\n'),
(214, 'a0f04e5e-a5b6-ea11-a812-000d3ac05981', '2022-03-17 00:49:00', 'Windows 10/11 Enterprise E3 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LGTX - A/M', '7,00 US$', 'Comercial', 'Microsoft\r\n'),
(215, '8865448e-a5b6-ea11-a812-000d3ac05981', '2022-03-17 00:54:00', 'Windows 10/11 Enterprise E3 VDA (Anual)', 'Microsoft', 'CFQ7TTC0LGTX - A - VDA', '158,40 US$', 'Comercial', 'Microsoft\r\n'),
(216, '61ba85be-a5b6-ea11-a812-000d3ac05981', '2022-03-17 00:56:00', 'Windows 10/11 Enterprise E3 VDA (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LGTX - A/M - VDA', '13,20 US$', 'Comercial', 'Microsoft\r\n'),
(217, 'eed988ee-a5b6-ea11-a812-000d3ac05981', '2022-03-17 01:03:00', 'Windows 10/11 Enterprise E5 (Anual)', 'Microsoft', 'CFQ7TTC0LFNW - A', '135,30 US$', 'Comercial', 'Microsoft\r\n'),
(218, 'a2a1e00c-a6b6-ea11-a812-000d3ac05981', '2022-03-17 01:05:00', 'Windows 10/11 Enterprise E5 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LFNW - A/M', '11,28 US$', 'Comercial', 'Microsoft\r\n'),
(219, 'b9541179-a6b6-ea11-a812-000d3ac05981', '2022-01-12 15:28:00', 'Project Standard 2021', 'Microsoft', 'DG7GMGF0D7D8', '830,88 US$', 'Comercial', 'Microsoft\r\n'),
(220, '66103b0c-f5b6-ea11-a812-000d3ac05981', '2022-11-02 16:40:00', 'Acrobat Sign Solutions for enterprise (Nivel 1) (1-999)', 'Adobe', '65305555BAT1B12', '4,91 US$', 'Comercial', 'Adobe\r\n'),
(221, 'aa665773-f5b6-ea11-a812-000d3ac05981', '2022-11-02 16:40:00', 'Acrobat Sign Solutions for enterprise (Nivel 2) (1000-2499)', 'Adobe', '65305555BAT2B12', '3,44 US$', 'Comercial', 'Adobe\r\n'),
(222, '7d6e4cb5-f5b6-ea11-a812-000d3ac05981', '2022-11-02 18:40:00', 'Acrobat Sign Solutions for enterprise (Nivel 3) (2500 - 4999)', 'Adobe', '65305555BAT3B12', '2,95 US$', 'Comercial', 'Adobe\r\n'),
(223, 'e9ef40e5-f5b6-ea11-a812-000d3ac05981', '2021-03-26 19:07:00', 'Adobe Sign for enterprise (Nivel 4)', 'Adobe', '65305555BAT4A12', '2,70 US$', 'Comercial', 'Adobe\r\n'),
(224, 'de347df2-f7b6-ea11-a812-000d3ac05981', '2021-03-26 19:07:00', 'Adobe Sign for Business (Nivel 1)', 'Adobe', '65305627BAT1A12', '3,75 US$', 'Comercial', 'Adobe\r\n'),
(225, 'd9f07e2e-f8b6-ea11-a812-000d3ac05981', '2022-07-29 17:03:00', 'Adobe Sign for Business (Nivel 2)', 'Adobe', '65305627BAT2B12', '2,63 US$', 'Comercial', 'Adobe\r\n'),
(226, '29ab1795-f8b6-ea11-a812-000d3ac05981', '2021-03-26 19:09:00', 'Adobe Sign for Business (Nivel 3)', 'Adobe', '65305627BAT3A12', '2,25 US$', 'Comercial', 'Adobe\r\n'),
(227, '2652a074-f9b6-ea11-a812-000d3ac05981', '2021-03-26 19:10:00', 'Adobe Sign for Business (Nivel 4)', 'Adobe', '65305627BAT4A12', '2,08 US$', 'Comercial', 'Adobe\r\n'),
(228, 'ad23ec7a-fbb6-ea11-a812-000d3ac05981', '2023-04-17 14:13:00', 'Acrobat Pro DC for teams New - Nivel 1 (Anual)', 'Adobe', '65324056BA01A12', '318,16 US$', 'Comercial', 'Adobe\r\n'),
(229, 'e4ef368d-fbb6-ea11-a812-000d3ac05981', '2023-04-17 14:13:00', 'Acrobat Pro DC for teams New - Nivel 1 (Mensual)', 'Adobe', '65324056BA01A12-M', '26,51 US$', 'Comercial', 'Adobe\r\n'),
(230, '767863e7-fbb6-ea11-a812-000d3ac05981', '2022-11-23 19:26:00', 'Acrobat Pro DC for teams New - Nivel 2 (Anual)', 'Adobe', '65297938BA02A12', '302,21 US$', 'Comercial', 'Adobe\r\n'),
(231, '9f728405-fcb6-ea11-a812-000d3ac05981', '2022-11-23 19:27:00', 'Acrobat Pro DC for teams New - Nivel 2 (Mensual)', 'Adobe', '65297938BA02A12-M', '25,18 US$', 'Comercial', 'Adobe\r\n'),
(232, '9805bb93-fdb6-ea11-a812-000d3ac05981', '2021-03-29 15:56:00', 'Acrobat Pro DC for teams Renewal - Nivel 1', 'Adobe', '65297925BA01A12', '232,66 US$', 'Comercial', 'Adobe\r\n'),
(233, '8d5a6363-ffb6-ea11-a812-000d3ac05981', '2021-03-29 16:01:00', 'Acrobat Pro DC for teams Renewal - Nivel 2', 'Adobe', '65297925BA02A12', '221,09 US$', 'Comercial', 'Adobe\r\n'),
(234, 'cc7ae633-01b7-ea11-a812-000d3ac05981', '2021-03-29 16:04:00', 'Acrobat Standard DC for teams New - Nivel 1 (Anual)', 'Adobe', '65297914BA01A12', '222,18 US$', 'Comercial', 'Adobe\r\n'),
(235, '18d68f77-03b7-ea11-a812-000d3ac05981', '2021-03-29 16:06:00', 'Acrobat Standard DC for teams New - Nivel 1 (Mensual)', 'Adobe', '65297914BA01A12-M', '18,53 US$', 'Comercial', 'Adobe\r\n'),
(236, '7cc52b76-06b7-ea11-a812-000d3ac05981', '2021-03-29 16:27:00', 'Acrobat Standard DC for teams New - Nivel 2 (Anual)', 'Adobe', '65297914BA02A12', '201,58 US$', 'Comercial', 'Adobe\r\n'),
(237, '40131a9a-06b7-ea11-a812-000d3ac05981', '2021-03-29 16:28:00', 'Acrobat Standard DC for teams New - Nivel 2 (Mensual)', 'Adobe', '65297914BA02A12-M', '16,80 US$', 'Comercial', 'Adobe\r\n'),
(238, '126dd903-08b7-ea11-a812-000d3ac05981', '2021-03-29 16:29:00', 'Acrobat Standard DC for teams Renewal - Nivel 1', 'Adobe', '65297911BA01A12', '205,28 US$', 'Comercial', 'Adobe\r\n'),
(239, '2bd7634c-0ab7-ea11-a812-000d3ac05981', '2021-03-29 16:30:00', 'Acrobat Standard DC for teams Renewal - Nivel 2', 'Adobe', '65297911BA02A12', '195,00 US$', 'Comercial', 'Adobe\r\n'),
(240, 'c5f1645b-0bb7-ea11-a812-000d3ac05981', '2021-03-29 16:31:00', 'Creative Cloud for teams All Apps New - Nivel 1 (Anual)', 'Adobe', '65297750BA01A12', '1269,91 US$', 'Comercial', 'Adobe\r\n'),
(241, 'a9f95625-0fb7-ea11-a812-000d3ac05981', '2020-06-25 18:11:00', 'Creative Cloud for teams All Apps New - Nivel 1 (Mensual)', 'Adobe', '65297750BA01A12-M', '105,73 US$', 'Comercial', 'Adobe\r\n'),
(242, '2a71724f-0fb7-ea11-a812-000d3ac05981', '2020-06-25 18:13:00', 'Creative Cloud for teams All Apps New - Nivel 2 (Anual)', 'Adobe', '65297750BA02A12', '1224,00 US$', 'Comercial', 'Adobe\r\n'),
(243, '437b9c8b-0fb7-ea11-a812-000d3ac05981', '2020-06-25 18:14:00', 'Creative Cloud for teams All Apps New - Nivel 2 (Mensual)', 'Adobe', '65297750BA02A12-M', '102,04 US$', 'Comercial', 'Adobe\r\n'),
(244, '5b0f36ce-0fb7-ea11-a812-000d3ac05981', '2020-06-25 18:16:00', 'Creative Cloud for teams All Apps Renewal- Nivel 1', 'Adobe', '65297755BA01A12', '1227,00 US$', 'Comercial', 'Adobe\r\n'),
(245, '15d83ffe-0fb7-ea11-a812-000d3ac05981', '2020-06-25 18:17:00', 'Creative Cloud for teams All Apps Renewal- Nivel 2', 'Adobe', '65297755BA02A12', '1184,00 US$', 'Comercial', 'Adobe\r\n'),
(246, 'f3163f74-6eb7-ea11-a812-000d3ac05981', '2023-02-02 14:28:00', 'AutoCAD LT 2023 Commercial New Single-user (Anual)', 'Autodesk', '057O1-WW6525-L347', '576,25 US$', 'Comercial', 'Autodesk\r\n'),
(247, 'd9f5a386-6eb7-ea11-a812-000d3ac05981', '2023-02-02 15:04:00', 'AutoCAD LT 2023 Commercial New Single-user (3-Anual)', 'Autodesk', '057O1-WW9153-L317', '1642,50 US$', 'Comercial', 'Autodesk\r\n'),
(248, '9b1318c3-6eb7-ea11-a812-000d3ac05981', '2023-02-02 15:05:00', 'Autocad LT 2023 Commercial Renewal Single-user (Anual)', 'Autodesk', '057I1-006845-L846', '521,25 US$', 'Comercial', 'Autodesk\r\n'),
(249, 'd7495f17-6fb7-ea11-a812-000d3ac05981', '2023-02-02 15:06:00', 'Autocad LT 2021 Commercial Renewal Single-user (2-Anual)', 'Autodesk', '057I1-009575-L548', '787,25 US$', 'Comercial', 'Autodesk\r\n'),
(250, 'b021bb41-6fb7-ea11-a812-000d3ac05981', '2023-02-02 15:07:00', 'Autocad LT 2023 Commercial Renewal Single-user (3-Anual)', 'Autodesk', '057I1-007738-L882', '1360,00 US$', 'Comercial', 'Autodesk\r\n'),
(251, '1fde86c6-6fb7-ea11-a812-000d3ac05981', '2023-02-02 15:09:00', 'Autocad Full 2023 Commercial New Single-user (Anual)', 'Autodesk', 'C1RK1-WW1762-L158', '2161,25 US$', 'Comercial', 'Autodesk\r\n'),
(252, 'fce179f7-6fb7-ea11-a812-000d3ac05981', '2023-02-02 15:10:00', 'Autocad Full 2023 Commercial New Single-user (3-Anual)', 'Autodesk', 'C1RK1-WW3611-L802', '6128,75 US$', 'Comercial', 'Autodesk\r\n'),
(253, '860a113a-70b7-ea11-a812-000d3ac05981', '2023-02-02 15:11:00', 'Autocad Full 2023 Commercial Renewal Single-user (Anual)', 'Autodesk', 'C1RK1-002900-L983', '1957,50 US$', 'Comercial', 'Autodesk\r\n'),
(254, '4aa7bbb2-70b7-ea11-a812-000d3ac05981', '2021-03-29 16:49:00', 'Civil 3D 2021 Commercial New Single-user (Anual)', 'Autodesk', '237N1-WW3740-L562', '2978,75 US$', 'Comercial', 'Autodesk\r\n'),
(255, '9679e9e2-70b7-ea11-a812-000d3ac05981', '2021-03-29 16:51:00', 'Civil 3D 2021 Commercial New Single-user (3-Anual)', 'Autodesk', '237N1-WW7407-L592', '8015,00 US$', 'Comercial', 'Autodesk\r\n'),
(256, '88401981-71b7-ea11-a812-000d3ac05981', '2021-03-29 16:53:00', 'Revit 2021 Commercial Renewal Single-user (Anual)', 'Autodesk', '829I1-001355-L890', '2833,75 US$', 'Comercial', 'Autodesk\r\n');
INSERT INTO `allproduct` (`idAllproduct`, `Producto`, `Fecha de modificación`, `Nombre`, `Fabricante`, `Id. de producto`, `Precio listado`, `Segmento`, `Lista de precios predeterminada`) VALUES
(257, '1cec34a5-71b7-ea11-a812-000d3ac05981', '2021-07-05 14:09:00', 'Revit 2022 Commercial New Single-user (Anual)', 'Autodesk', '829N1-WW3740-L562', '3120,00 US$', 'Comercial', 'Autodesk\r\n'),
(258, '8bff55db-71b7-ea11-a812-000d3ac05981', '2021-03-29 16:56:00', 'Architecture Engineering Construction Collection Commercial Renewal Single-user (Anual)', 'Autodesk', '02HI1-WW8500-L937', '3800,00 US$', 'Comercial', 'Autodesk\r\n'),
(259, '4ee53fac-35ba-ea11-a812-000d3ac05981', '2020-06-29 18:24:00', 'Dropbox for Business - Standard (Mensual)', 'Dropbox', 'TEAM-ST3L3T1M', '15,00 US$', 'Comercial', 'Dropbox\r\n'),
(260, '456632d6-35ba-ea11-a812-000d3ac05981', '2022-12-12 18:08:00', 'Dropbox for Business - Standard (Anual)', 'Dropbox', 'TEAM-ST3L3T1Y', '180,00 US$', 'Comercial', 'Dropbox\r\n'),
(261, 'b04f5512-36ba-ea11-a812-000d3ac05981', '2020-06-29 18:28:00', 'Dropbox for Business - Advanced (Mensual)', 'Dropbox', 'TEAM-AD3L1', '25,00 US$', 'Comercial', 'Dropbox\r\n'),
(262, 'b07f8b54-36ba-ea11-a812-000d3ac05981', '2022-12-12 18:11:00', 'Dropbox for Business - Advanced (Anual)', 'Dropbox', 'TEAM-AD3L1Y', '288,00 US$', 'Comercial', 'Dropbox\r\n'),
(263, 'e7d73bc7-36ba-ea11-a812-000d3ac05981', '2022-12-12 18:17:00', 'Dropbox for Business - Enterprise (Mensual)', 'Dropbox', 'DPBXE-0-299-U1', '32,50 US$', 'Comercial', 'Dropbox\r\n'),
(264, '0dd40103-37ba-ea11-a812-000d3ac05981', '2022-12-12 18:17:00', 'Dropbox for Business - Enterprise (Anual)', 'Dropbox', 'DPBXE-5-299-N', '360,00 US$', 'Comercial', 'Dropbox\r\n'),
(265, '5e7c5e3b-3cba-ea11-a812-000d3ac05981', '2023-02-02 15:12:00', 'Autocad Full 2021 Commercial Renewal Single-user (2-Anual)', 'Autodesk', 'C1RK1-008835-T146', '3372,50 US$', 'Comercial', 'Autodesk\r\n'),
(266, 'c153be77-3cba-ea11-a812-000d3ac05981', '2023-02-02 15:13:00', 'Autocad Full 2023 Commercial Renewal Single-user (3-Anual)', 'Autodesk', 'C1RK1-008819-L706', '5552,50 US$', 'Comercial', 'Autodesk\r\n'),
(267, 'a5adf148-c2b0-ea11-a813-000d3ac05a0e', '2022-08-12 21:50:00', 'Windows GGWA - Windows 11 Professional - Legalization GetGenuine', 'Microsoft', 'DG7GMGF0L4TL', '229,50 US$', 'Comercial', 'Microsoft\r\n'),
(268, '9a74dd0a-ceb0-ea11-a813-000d3ac05a0e', '2021-03-25 18:42:00', 'WinPro 10 Upgrade', 'Microsoft', 'FQC-09525', '227,91 US$', 'Comercial', 'Microsoft\r\n'),
(269, '49eddc6c-d2b0-ea11-a813-000d3ac05a0e', '2022-03-24 21:09:00', 'WinPro 11 Upgrade (Educaci?n)', 'Microsoft', 'DG7GMGF0D8H4', '79,69 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(270, 'ef82f994-d3b0-ea11-a813-000d3ac05a0e', '2022-03-17 00:12:00', 'Windows Server 2022 - 1 Device CAL', 'Microsoft', 'DG7GMGF0D5VX -D', '43,56 US$', 'Comercial', 'Microsoft\r\n'),
(271, 'b0d2ee86-d4b0-ea11-a813-000d3ac05a0e', '2022-03-17 00:39:00', 'Windows Server 2022 - 1 User CAL', 'Microsoft', 'DG7GMGF0D5VX - U', '55,25 US$', 'Comercial', 'Microsoft\r\n'),
(272, '01f55833-86b1-ea11-a813-000d3ac05a0e', '2022-03-17 00:36:00', 'Windows Server 2022 Datacenter - 16 Core', 'Microsoft', 'DG7GMGF0D65N', '7521,44 US$', 'Comercial', 'Microsoft\r\n'),
(273, 'd944c0d0-86b1-ea11-a813-000d3ac05a0e', '2022-03-17 00:40:00', 'Windows Server 2022 Datacenter - 2 Core', 'Microsoft', 'DG7GMGF0D65N - 2', '940,31 US$', 'Comercial', 'Microsoft\r\n'),
(274, '1dd9ea1a-87b1-ea11-a813-000d3ac05a0e', '2021-09-01 14:30:00', 'Windows Server Essentials 2019', 'Microsoft', 'G3S-01259', '640,76 US$', 'Comercial', 'Microsoft\r\n'),
(275, '808a1d5f-87b1-ea11-a813-000d3ac05a0e', '2022-03-17 00:42:00', 'Windows Server 2022 Standard - 16 Core License Pack', 'Microsoft', 'DG7GMGF0D5RK - 16', '1305,81 US$', 'Comercial', 'Microsoft\r\n'),
(276, 'cc9568a5-25eb-eb11-bacb-000d3ac13318', '2021-07-22 19:51:00', 'VMware vSphere 7 Standard for 1 processor', 'Otro', 'VS7-STD-C', '1119,38 US$', 'Comercial', 'Vmware\r\n'),
(277, '96bc2695-26eb-eb11-bacb-000d3ac13318', '2021-07-22 19:55:00', 'Basic Support/Subscription for VMware vSphere 7 Standard for 1 processor for 3 years', 'Otro', 'VS7-STD-3G-SSS-C', '900,90 US$', 'Comercial', 'Vmware\r\n'),
(278, 'd3c8b7ca-ace8-eb11-bacb-000d3ac13acc', '2022-08-08 14:21:00', 'Office 365 Extra File Storage - (Anual)', 'Microsoft', 'CFQ7TTC0LHS9 - A', '2,40 US$', 'Comercial', 'Microsoft\r\n'),
(279, '94bfa2a6-a6d3-eb11-bacc-000d3ac192f0', '2022-05-20 17:32:00', 'Windows Server 2022 CAL - 1 User CAL - 1 year', 'Microsoft', 'DG7GMGF0D5VX', '17,48 US$', 'Comercial', 'Microsoft\r\n'),
(280, '17be9fad-2ad5-eb11-bacc-000d3ac192f0', '2021-06-24 20:29:00', 'Office 365 A3 For Student (Anual)', 'Microsoft', '1b6263c0-b8fd-4706-98db-89d2ace5c1bf', '30,00 US$', 'Comercial', 'Microsoft - Educaci?n\r\n'),
(281, 'db0bf3a1-39d5-eb11-bacc-000d3ac192f0', '2021-06-24 22:16:00', 'Office 365 A5 For Faculty (Anual)', 'Microsoft', '8c484fd0-1f3f-44fb-b6d2-26ca107273f6', '96,00 US$', 'Comercial', 'Microsoft - Educaci?n\r\n'),
(282, '602ff101-3ad5-eb11-bacc-000d3ac192f0', '2021-06-24 22:28:00', 'Power BI Pro For Faculty (Anual)', 'Microsoft', '98fa9c4d-ef56-4480-86cb-b10d49effa73', '27,00 US$', 'Comercial', 'Microsoft - Educaci?n\r\n'),
(283, 'dac5310a-49f9-eb11-94ef-000d3ac193dd', '2021-08-09 19:48:00', 'Windows 10 Enterprise A3 for faculty (Anual)', 'Microsoft', 'bec91cbf-3677-41e3-afb8-bf98db7b9bd4 - A', '26,40 US$', 'Comercial', 'Microsoft - Educaci?n\r\n'),
(284, '7d629438-4bf9-eb11-94ef-000d3ac193dd', '2021-08-09 19:53:00', 'Kaspersky Endpoint Security for Business Advanced (100-149 Nodos)-Renewal', 'Kaspersky', 'KL4867DA*FR-N8', '31,18 US$', 'Comercial', 'Kaspersky\r\n'),
(285, '131aa28b-4df9-eb11-94ef-000d3ac193dd', '2022-06-22 15:26:00', 'Kaspersky Endpoint Security for Business Select (150+249 Nodos)- Bianual Renewal', 'Kaspersky', 'KL4863DA*DR-N8 BI', '31,18 US$', 'Comercial', 'Kaspersky\r\n'),
(286, '0cd7b798-56f9-eb11-94ef-000d3ac193dd', '2021-08-10 03:05:00', 'Microsoft 365 A3 for faculty (Anual)', 'Microsoft', '9c584cf1-8326-4ff4-8a23-0a833ddbcab0', '69,00 US$', 'Comercial', 'Microsoft - Educaci?n\r\n'),
(287, '42ece013-b2fa-eb11-94ef-000d3ac193dd', '2021-08-11 14:40:00', 'Office Professional 2019-202108111440320812', 'Microsoft', '79P-05729-202108111440320812', '680,75 US$', 'Comercial', '\r\n'),
(288, '6455149c-4abe-eb11-bacc-0022483600bc', '2021-05-26 17:50:00', 'Inventor Professional 2022 Commercial New Single-user (Anual)', 'Autodesk', '797N1-WW3740-L562', '2618,75 US$', 'Comercial', 'Autodesk\r\n'),
(289, 'b72c83fd-4abe-eb11-bacc-0022483600bc', '2021-05-26 17:53:00', 'Inventor Professional 2022 Commercial New Single-user (3 Anual)', 'Autodesk', '797N1-WW7407-L592', '7062,50 US$', 'Comercial', 'Autodesk\r\n'),
(290, 'e4e83a8f-4a00-ec11-94f0-0022483623e9', '2021-08-18 17:37:00', 'Minecraft: Education Edition (per user) (Anual)', 'Microsoft', 'ee10cbd2-7a12-45de-be11-0c2c7c6eeeb1', '5,00 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(291, '13b960e5-2ca8-eb11-9442-002248362b2a', '2021-04-28 14:22:00', 'Kaspersky Endpoint Security Cloud Plus (10-14 Nodos)-Educacional', 'Kaspersky', 'KL4743DA*FS-N1EDU', '45,00 US$', 'Comercial', 'Kaspersky\r\n'),
(292, '4d59616b-68a8-eb11-9442-002248362b2a', '2021-04-28 21:28:00', 'Office 365 A3 For Faculty (Anual)', 'Microsoft', '7eb5101b-b893-4d63-92ca-72df3c71fafc', '39,00 US$', 'Comercial', 'Microsoft - Educaci?n\r\n'),
(293, 'd965ee4d-d9bc-eb11-bacc-0022483653e2', '2023-01-30 17:55:00', 'Habilitaci?n M365 - Migraci?n h?brida con Exchange On-Premise (21 a 80 usuarios)', 'Last Call', 'L026', '35,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(294, '3c1b96c7-d9bc-eb11-bacc-0022483653e2', '2023-01-30 17:56:00', 'Habilitaci?n M365 - Migraci?n h?brida con Exchange On-Premise (81 a 150 usuarios)', 'Last Call', 'L027', '26,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(295, 'b889a528-dabc-eb11-bacc-0022483653e2', '2023-01-30 17:55:00', 'Habilitaci?n M365 - Migraci?n h?brida con Exchange On-Premise (151 a 250 usuarios)', 'Last Call', 'L028', '18,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(296, 'e2a924d9-dabc-eb11-bacc-0022483653e2', '2023-01-30 17:50:00', 'Habilitaci?n M365 - Migraci?n desde Google (Incluye Drive) (21 a 80 usuarios)', 'Last Call', 'L029', '43,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(297, '507465f1-dabc-eb11-bacc-0022483653e2', '2023-01-30 17:50:00', 'Habilitaci?n M365 - Migraci?n desde Google (Incluye Drive) (81 a 150 usuarios)', 'Last Call', 'L030', '35,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(298, '3238b003-dbbc-eb11-bacc-0022483653e2', '2023-01-30 17:49:00', 'Habilitaci?n M365 - Migraci?n desde Google (Incluye Drive) (151 a 250 usuarios)', 'Last Call', 'L031', '26,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(299, 'cea5c0c4-debc-eb11-bacc-0022483653e2', '2023-01-30 17:52:00', 'Habilitaci?n M365 - Migraci?n desde Google (No incluye Drive) (21 a 80 usuarios)', 'Last Call', 'L032', '38,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(300, '0c3b18ea-debc-eb11-bacc-0022483653e2', '2023-01-30 17:53:00', 'Habilitaci?n M365 - Migraci?n desde Google (No incluye Drive) (81 a 150 usuarios)', 'Last Call', 'L033', '30,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(301, 'fe6e65fc-debc-eb11-bacc-0022483653e2', '2023-01-30 17:51:00', 'Habilitaci?n M365 - Migraci?n desde Google (No incluye Drive) (151 a 250 usuarios)', 'Last Call', 'L034', '22,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(302, '993ae4b9-e0bc-eb11-bacc-0022483653e2', '2023-02-28 13:28:00', 'Habilitaci?n M365 - Migraci?n v?a IMAP (21 a 80 usuarios)', 'Last Call', 'L035', '35,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(303, '9336c9d8-e0bc-eb11-bacc-0022483653e2', '2023-02-28 13:28:00', 'Habilitaci?n M365 - Migraci?n v?a IMAP (81 a 150 usuarios)', 'Last Call', 'L036', '30,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(304, '458d0ff1-e0bc-eb11-bacc-0022483653e2', '2023-02-28 13:29:00', 'Habilitaci?n M365 - Migraci?n v?a IMAP (151 a 250 usuarios)', 'Last Call', 'L037', '28,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(305, '28e73584-e1bc-eb11-bacc-0022483653e2', '2023-01-30 18:03:00', 'Habilitaci?n M365 - Migraci?n v?a IMAP + PST (POP3) (21 a 80 usuarios)', 'Last Call', 'L038', '77,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(306, 'ec12c6a3-e1bc-eb11-bacc-0022483653e2', '2023-01-30 18:03:00', 'Habilitaci?n M365 - Migraci?n v?a IMAP + PST (POP3) (81 a 150 usuarios)', 'Last Call', 'L039', '68,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(307, 'e1e8eebb-e1bc-eb11-bacc-0022483653e2', '2023-01-30 18:03:00', 'Habilitaci?n M365 - Migraci?n v?a IMAP + PST (POP3) (151 a 250 usuarios)', 'Last Call', 'L040', '60,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(308, '48253b10-e2bc-eb11-bacc-0022483653e2', '2023-02-28 13:28:00', 'Habilitaci?n M365 - Migraci?n de PST (POP3) (21 a 80 usuarios)', 'Last Call', 'L041', '42,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(309, '95af5b4d-e2bc-eb11-bacc-0022483653e2', '2023-02-28 13:28:00', 'Habilitaci?n M365 - Migraci?n de PST (POP3) (81 a 150 usuarios)', 'Last Call', 'L042', '38,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(310, '74f5df65-e2bc-eb11-bacc-0022483653e2', '2023-02-28 13:28:00', 'Habilitaci?n M365 - Migraci?n de PST (POP3) (151 a 250 usuarios)', 'Last Call', 'L043', '32,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(311, '0a0113eb-84bd-eb11-bacc-0022483653e2', '2021-05-25 18:15:00', 'Microsoft 365 Apps for Faculty (Anual)', 'Microsoft', '35eb491f-5484-496e-978b-f349eed3c699 - A', '27,00 US$', 'Comercial', 'Microsoft - Educaci?n\r\n'),
(312, '4e0d98b2-90bd-eb11-bacc-0022483653e2', '2021-05-25 19:38:00', 'Aspose.Total for .NET - Subscription Renewal - Pre Expiry - Developer OEM - 1 Developer and Unlimited Deployment Locations', 'Otro', 'APDNTODO-R-PRE', '9206,63 US$', 'Comercial', 'Component Source\r\n'),
(313, 'd468d7b9-8fb2-eb11-8236-002248365815', '2021-05-11 19:38:00', '500 AddOn Managed Devices', 'TeamViewer', 'S93003', '1300,00 US$', 'Comercial', 'TeamViewer\r\n'),
(314, '88e1e682-47b3-eb11-8236-002248365815', '2021-05-12 17:37:00', 'FortiGate-200E 3 Year UTP', 'Otro', 'FC-10-00207-950-02-36', '6416,13 US$', 'Comercial', 'Fortinet\r\n'),
(315, 'ddf497c1-5db3-eb11-8236-002248365815', '2021-05-12 20:08:00', 'FortiGate-200E 1 Year UTP', 'Otro', 'FC-10-00207-950-02-12', '2138,71 US$', 'Comercial', 'Fortinet\r\n'),
(316, '7e2f9b87-33b4-eb11-8236-002248365815', '2022-03-17 02:01:00', 'Power Automate per user plan (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LH3L - A/M', '14,06 US$', 'Comercial', 'Microsoft\r\n'),
(317, '9f035a0e-34b4-eb11-8236-002248365815', '2022-03-17 02:00:00', 'Power Automate per user plan (Anual)', 'Microsoft', 'CFQ7TTC0LH3L - A', '168,75 US$', 'Comercial', 'Microsoft\r\n'),
(318, 'dd9b600a-85b2-eb11-8236-002248365e79', '2021-05-11 18:30:00', 'Creative Cloud for teams All Apps Education Named New - Nivel 1 (Anual)', 'Adobe', '65272476BB01A12', '524,83 US$', 'Comercial', 'Adobe\r\n'),
(319, '132fa8ff-87b2-eb11-8236-002248365e79', '2021-05-11 18:39:00', 'Creative Cloud for teams All Apps Education Named New - Nivel 1 (Mensual)', 'Adobe', '65272476BB01A12-M', '43,74 US$', 'Comercial', 'Adobe\r\n'),
(320, '54461b70-8cb2-eb11-8236-002248365e79', '2021-05-11 19:26:00', 'Creative Cloud for teams All Apps Education Named Renewel - Nivel 1 (Anual)', 'Adobe', '65272483BB01A12', '507,33 US$', 'Comercial', 'Adobe\r\n'),
(321, '6d4cb75a-76d0-ec11-a7b5-002248367f68', '2022-05-10 15:33:00', 'FortiGate-100F Hardware plus 1 Year FortiCare Premium and FortiGuard Unified Threat Protection (UTP)', 'Otro', 'FG-100F-BDL-950-12', '3921,33 US$', 'Comercial', 'Fortinet\r\n'),
(322, '873cb0db-76d0-ec11-a7b5-002248367f68', '2022-05-10 15:37:00', 'FortiGate-200F Hardware plus 1 Year FortiCare Premium and FortiGuard Unified Threat Protection (UTP)', 'Otro', 'FG-200F-BDL-950-12', '5816,21 US$', 'Comercial', 'Fortinet\r\n'),
(323, 'bd297e3b-77d0-ec11-a7b5-002248367f68', '2022-05-10 15:39:00', 'Fortigate? Rapid Deploy for FG100F o FG200F en HA', 'Otro', 'APS-FTN-FGRDBASIC', '2375,00 US$', 'Comercial', 'Fortinet\r\n'),
(324, '5d59efa3-a048-ec11-8c62-002248368554', '2021-11-18 18:54:00', 'ComponentOne Studio Enterprise 2021 v2 - 1 Developer License (1Year)', 'Otro', 'CS-513075-1269842', '3758,86 US$', 'Comercial', 'Component Source\r\n'),
(325, 'd7ba88ae-b6e5-ec11-bb3c-00224836a1e0', '2022-06-06 16:36:00', 'Project Plan 3 for faculty (Anual)', 'Microsoft', 'a3a8a723-99a2-4129-bc40-046e6768f7a3', '72,00 US$', 'Educaci?n', 'Microsoft - Educaci?n\r\n'),
(326, 'b5447013-cee5-ec11-bb3c-00224836a1e0', '2022-06-06 19:24:00', 'Power Automate per user with attended RPA plan (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LSGZ - A/M', '37,50 US$', 'Comercial', 'Microsoft\r\n'),
(327, '930d6892-cee5-ec11-bb3c-00224836a1e0', '2022-06-06 19:28:00', 'Power Automate unattended RPA add-on (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LSH0 - A/M', '140,63 US$', 'Comercial', 'Microsoft\r\n'),
(328, 'dd5605f9-e9f6-eb11-94ef-00224836b62b', '2023-02-21 21:40:00', 'Microsoft Teams Phone Standard (Anual)', 'Microsoft', 'CFQ7TTC0LH0T - A', '95,00 US$', 'Comercial', 'Microsoft\r\n'),
(329, 'ef7efd55-eaf6-eb11-94ef-00224836b62b', '2023-02-21 21:40:00', 'Microsoft Teams Phone Standard (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LH0T - A/M', '7,90 US$', 'Comercial', 'Microsoft\r\n'),
(330, 'da3de50a-4a9b-eb11-b1ac-00224836ba75', '2023-02-28 13:27:00', 'Habilitaci?n M365 - Migraci?n v?a IMAP (0 a 20 usuarios)', 'Last Call', 'L014', '39,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(331, '7d1c6b33-4a9b-eb11-b1ac-00224836ba75', '2023-01-30 18:03:00', 'Habilitaci?n M365 - Migraci?n v?a IMAP + PST (POP3) (0 a 20 usuarios)', 'Last Call', 'L015', '85,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(332, '5fe1775b-4a9b-eb11-b1ac-00224836ba75', '2023-01-30 17:55:00', 'Habilitaci?n M365 - Migraci?n h?brida con Exchange On-Premise (0 a 20 usuarios)', 'Last Call', 'L016', '43,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(333, '79984fb8-999b-eb11-b1ac-00224836ba75', '2022-03-17 00:45:00', 'Windows Server 2022 External Connector', 'Microsoft', 'DG7GMGF0D515', '2713,63 US$', 'Comercial', 'Microsoft\r\n'),
(334, '529de77d-cf9b-eb11-b1ac-00224836ba75', '2021-04-12 20:51:00', 'Photoshop for Team Renewal - Nivel 2 (Anual)', 'Adobe', '65297619BA02A12', '503,00 US$', 'Comercial', 'Adobe\r\n'),
(335, '96d9bf4b-d09b-eb11-b1ac-00224836ba75', '2021-04-12 20:52:00', 'Illustrator for Teams Renewal - Nivel 2 (Anual)', 'Adobe', '65297602BA02A12', '503,00 US$', 'Comercial', 'Adobe\r\n'),
(336, '1b9bb22c-2d9d-eb11-b1ac-00224836ba75', '2021-04-14 14:26:00', 'MFE Complete EP Protect Bus 1Yr BZ [P+] - Anual', 'Mcafee', 'CEBYFM-AA-AA', '56,01 US$', 'Comercial', 'Mcafee\r\n'),
(337, '19031c3a-0f9e-eb11-b1ac-00224836ba75', '2022-03-16 13:33:00', 'Power BI Premium P1 (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LHQ2 - A/M', '4933,33 US$', 'Comercial', 'Microsoft\r\n'),
(338, '3ecceb94-0f9e-eb11-b1ac-00224836ba75', '2022-03-16 13:36:00', 'Power BI Premium P1 (Anual)', 'Microsoft', 'CFQ7TTC0LHQ2 - A', '59.200,00 US$', 'Comercial', 'Microsoft\r\n'),
(339, '113f5a34-abf3-eb11-94ef-00224836bbc9', '2021-08-02 16:05:00', 'Kaspersky Endpoint Security Cloud Plus (50-99 Nodos) - Base Plus', 'Kaspersky', 'KL4743DA*F8-N5', '33,80 US$', 'Comercial', 'Kaspersky\r\n'),
(340, 'e15bcf6e-659c-eb11-b1ac-00224836bd66', '2021-04-13 14:39:00', 'Kaspersky Small Office Security (5-9 Nodos)-Renewal', 'Kaspersky', 'KL4542DA*FR-N1', '30,51 US$', 'Comercial', 'Kaspersky\r\n'),
(341, '12ef6f9e-669c-eb11-b1ac-00224836bd66', '2021-04-15 13:55:00', 'MVISION Standard 1:1BZ - Anual', 'Mcafee', 'MV1ECE-AA-AA - N1', '21,03 US$', 'Comercial', 'Mcafee\r\n'),
(342, '2fde75a6-f19d-eb11-b1ac-00224836bd66', '2021-04-15 13:55:00', 'MVISION Standard 1:1BZ - Bianual', 'Mcafee', 'MV1ECE-AA-AA-N2', '51,65 US$', 'Comercial', 'Mcafee\r\n'),
(343, 'f1e7edeb-f19d-eb11-b1ac-00224836bd66', '2021-04-15 13:54:00', 'MVISION Standard 1:1BZ - Trianual', 'Mcafee', 'MV1ECE-AA-AA-N3', '77,47 US$', 'Comercial', 'Mcafee\r\n'),
(344, '71de6e4e-f29d-eb11-b1ac-00224836bd66', '2021-04-15 13:57:00', 'Mc Afee ProtectPLUS Business Software Support - Bianual', 'Mcafee', 'CEBYFM-AA-AA - N2', '75,50 US$', 'Comercial', 'Mcafee\r\n'),
(345, '36c5c897-f29d-eb11-b1ac-00224836bd66', '2021-04-15 14:00:00', 'Mc Afee ProtectPLUS Business Software Support - Trianual', 'Mcafee', 'CEBYFM-AA-AA - N3', '113,27 US$', 'Comercial', 'Mcafee\r\n'),
(346, '822634a0-f79d-eb11-b1ac-00224836bd66', '2021-04-15 19:43:00', 'Kaspersky Endpoint Security Cloud Plus (150- 249 Nodos )-Renewal', 'Kaspersky', 'KL4742DA*FR-N7', '21,00 US$', 'Comercial', 'Kaspersky\r\n'),
(347, '25869f40-fa9d-eb11-b1ac-00224836bd66', '2021-04-15 14:56:00', 'Kaspersky Endpoint Security for Business Select (300 + Nodos)-Renewal', 'Kaspersky', 'KL4863DA*FR-N8', '35,00 US$', 'Comercial', 'Kaspersky\r\n'),
(348, 'f792a043-229e-eb11-b1ac-00224836bd66', '2021-05-03 14:39:00', 'VMware vSphere 6 Essentials Kit for 3 hosts(Max 2Procesadores por Hosts) - Soporte Anual', 'Otro', 'VS6-ESSL-SUB-C1', '78,78 US$', 'Comercial', 'Vmware\r\n'),
(349, '6987d826-259e-eb11-b1ac-00224836bd66', '2021-04-15 20:02:00', 'Kaspersky Hybrid Cloud Security, Server', 'Kaspersky', 'KL4255DA*FS', '171,50 US$', 'Comercial', 'Kaspersky\r\n'),
(350, '53ad132e-3bcd-eb11-bacc-00224836e3bf', '2021-06-14 18:09:00', 'Endpoint Protection, Subscription License with Support, 1-99 Devices 1 Year', 'Otro', 'SEP-SUB-1-99', '22,72 US$', 'Comercial', 'Symantec\r\n'),
(351, 'fdbb816d-4ccd-eb11-bacc-00224836e3bf', '2022-03-17 01:54:00', 'Power Apps per user plan (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LH2H - A/M', '18,75 US$', 'Comercial', 'Microsoft\r\n'),
(352, '13daf046-4ecd-eb11-bacc-00224836e3bf', '2022-03-17 01:53:00', 'Power Apps per user plan (Anual)', 'Microsoft', 'CFQ7TTC0LH2H - A', '225,00 US$', 'Comercial', 'Microsoft\r\n'),
(353, 'e9fab3ce-e5cd-eb11-bacc-00224836e3bf', '2021-06-16 03:47:00', 'Veeam Backup Essentials Universal Subscription License. Includes Enterprise PlusEdition features. 1 Year Subscription Upfr', 'Otro', 'V-ESSVUL-0I-SU1YP-00', '426,97 US$', 'Comercial', 'Veeam\r\n'),
(354, 'ceff4567-f8cd-eb11-bacc-00224836e3bf', '2021-06-15 16:42:00', 'VMware vSphere 7 Essentials Kit for 3 hosts(Max 2Procesadores por Hosts) - Soporte Anual', 'Otro', 'VS7-ESSL-KIT-C', '515,73 US$', 'Comercial', 'Vmware\r\n'),
(355, 'b439e8d0-f8cd-eb11-bacc-00224836e3bf', '2021-06-15 16:45:00', 'Subscription only for VMware vSphere 7 Essentials Kit for 1 year', 'Otro', 'VS7-ESSL-SUB-C', '75,28 US$', 'Comercial', 'Vmware\r\n'),
(356, 'bed9cc64-56ce-eb11-bacc-00224836e3bf', '2021-06-16 03:55:00', 'Kaspersky Endpoint Security Cloud Plus (50-99 Nodos)- 2 Year', 'Kaspersky', 'KL4743DA*QDS-N5', '36,31 US$', 'Comercial', 'Kaspersky\r\n'),
(357, '887c1023-19ac-eb11-8236-00224836f7e8', '2021-05-03 14:12:00', 'VMware vSphere 6 Essentials Kit for 3 hosts(Max 2Procesadores por Hosts) - Soporte Trianual', 'Otro', 'VS6-ESSL-SUB-C3', '207,97 US$', 'Comercial', 'Vmware\r\n'),
(358, '9fce997b-3aac-eb11-8236-00224836f7e8', '2021-05-03 18:26:00', 'TeamViewer Corporate Subscription', 'TeamViewer', 'S312', '1700,00 US$', 'Comercial', 'TeamViewer\r\n'),
(359, '115c4f5e-3dac-eb11-8236-00224836f7e8', '2021-05-03 18:30:00', 'AddOn Channel', 'TeamViewer', 'S911', '600,00 US$', 'Comercial', 'TeamViewer\r\n'),
(360, '6bfee2b7-3dac-eb11-8236-00224836f7e8', '2021-05-03 18:35:00', 'TeamViewer Corporate Plus', 'TeamViewer', 'S912', '650,00 US$', 'Comercial', 'TeamViewer\r\n'),
(361, 'acf55ba6-50ad-eb11-8236-00224836f7e8', '2022-01-12 15:24:00', 'Outlook LTSC 2021', 'Microsoft', 'DG7GMGF0D7FS', '213,75 US$', 'Comercial', 'Microsoft\r\n'),
(362, 'd39f85ee-acad-eb11-8236-00224836f7e8', '2021-05-05 14:29:00', 'Power Bi Pro for Faculty - Anual', 'Microsoft', '98fa9c4d-ef56-4480-86cb-b10d49effa73 - A', '27,00 US$', 'Comercial', 'Microsoft - Educaci?n\r\n'),
(363, '91dab999-f4ad-eb11-8236-00224836f7e8', '2021-05-05 22:54:00', 'TeamViewer Premium Subscription', 'TeamViewer', 'S310', '850,00 US$', 'Comercial', 'TeamViewer\r\n'),
(364, '99e39aed-f4ad-eb11-8236-00224836f7e8', '2021-05-05 22:55:00', 'Support for mobile devices', 'TeamViewer', 'S93001', '300,00 US$', 'Comercial', 'TeamViewer\r\n'),
(365, '356a3ecb-beec-ec11-bb3c-00224836ff0c', '2022-06-15 15:22:00', 'SQL Server Standard - 2 Core License Pack - 1 year', 'Microsoft', 'DG7GMGF0FLR2 - A', '1950,00 US$', 'Comercial', 'Microsoft\r\n'),
(366, '189ccb7c-7895-eb11-b1ac-0022483702bb', '2023-01-30 18:22:00', 'Adopci?n - Plan S', 'Last Call', 'L001', '1063,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(367, '688249c6-7f95-eb11-b1ac-0022483702bb', '2023-01-30 17:31:00', 'Habilitaci?n M365 - Iniciar en Microsoft 365', 'Last Call', 'L005', '638,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(368, 'bc352de2-7f95-eb11-b1ac-0022483702bb', '2023-01-30 18:22:00', 'Adopci?n - Plan L', 'Last Call', 'L003', '3190,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(369, '56b431f8-7f95-eb11-b1ac-0022483702bb', '2023-01-30 18:22:00', 'Adopci?n - Capacitaci?n adicional', 'Last Call', 'L004', '256,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(370, '6eea0d60-8195-eb11-b1ac-0022483702bb', '2023-01-30 17:46:00', 'Habilitaci?n M365 - Migraci?n desde Google (Incluye Drive) (0 a 20 usuarios)', 'Last Call', 'L006', '52,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(371, 'b5c7207f-8195-eb11-b1ac-0022483702bb', '2023-01-30 17:51:00', 'Habilitaci?n M365 - Migraci?n desde Google (No incluye Drive) (0 a 20 usuarios)', 'Last Call', 'L007', '47,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(372, 'd3c29b8e-8195-eb11-b1ac-0022483702bb', '2023-02-28 13:27:00', 'Habilitaci?n M365 - Migraci?n de PST (POP3) (0 a 20 usuarios)', 'Last Call', 'L008', '46,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(373, 'fabd1ac2-8195-eb11-b1ac-0022483702bb', '2023-01-30 18:23:00', 'Azure - Implementaci?n de soluci?n', 'Last Call', 'L010', '43,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(374, '70bfd2f2-8195-eb11-b1ac-0022483702bb', '2023-01-30 18:22:00', 'Adopci?n - Plan M', 'Last Call', 'L002', '2080,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(375, '8358c955-1796-eb11-b1ac-0022483702bb', '2021-04-12 20:52:00', 'Photoshop for Teams New - Nivel 1 (Anual)', 'Adobe', '65297614BA01A12', '539,14 US$', 'Comercial', 'Adobe\r\n'),
(376, 'ca12639b-1796-eb11-b1ac-0022483702bb', '2021-04-12 20:53:00', 'Illustrator for Teams New - Nivel 1 (Anual)', 'Adobe', '65297607BA01A12', '539,14 US$', 'Comercial', 'Adobe\r\n'),
(377, '7a83060d-6396-eb11-b1ac-0022483702bb', '2021-04-19 15:25:00', 'Microsoft Azure (eliminandose)', 'Microsoft', '7UD-00001-E', '1,00 US$', 'Comercial', 'Microsoft\r\n'),
(378, '095b2a0c-6496-eb11-b1ac-0022483702bb', '2023-01-30 14:25:00', 'Habilitaci?n M365 - Configuraci?n de estaciones de trabajo', 'Last Call', 'L011', '13,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(379, '5fc7dd82-7c96-eb11-b1ac-0022483702bb', '2021-04-06 02:07:00', 'Acrobat Pro2020Multiple PlatformsLatin American SpanishAOO License1 User - Perpetua', 'Adobe', '65310729AD01A00', '635,42 US$', 'Comercial', 'Adobe\r\n'),
(380, '3ca055e6-7c96-eb11-b1ac-0022483702bb', '2021-04-06 02:09:00', 'Acrobat Standard2020WindowsLatin American SpanishAOO License1 User - Perpetua', 'Adobe', '65310950AD01A00', '424,11 US$', 'Comercial', 'Adobe\r\n'),
(381, '26fb476f-8696-eb11-b1ac-0022483702bb', '2021-04-06 03:18:00', 'Kaspersky Endpoint Security Cloud (10-14 Nodos)-Renewal', 'Kaspersky', 'KL4742DA*FR-N1', '33,83 US$', 'Comercial', 'Kaspersky\r\n'),
(382, '62c377da-8696-eb11-b1ac-0022483702bb', '2021-04-06 03:20:00', 'Kaspersky Endpoint Security Cloud (15-19 Nodos)-Renewal', 'Kaspersky', 'KL4742DA*FR-N2', '29,75 US$', 'Comercial', 'Kaspersky\r\n'),
(383, '8b9eac30-8796-eb11-b1ac-0022483702bb', '2021-04-06 03:22:00', 'Kaspersky Endpoint Security Cloud (20-24 Nodos)-Renewal', 'Kaspersky', 'KL4742DA*FR-N3', '26,83 US$', 'Comercial', 'Kaspersky\r\n'),
(384, '7d0e107c-8796-eb11-b1ac-0022483702bb', '2021-04-15 14:34:00', 'Kaspersky Endpoint Security Cloud (25- 49 Nodos )-Renewal', 'Kaspersky', 'KL4742DA*FR-N4', '23,92 US$', 'Comercial', 'Kaspersky\r\n'),
(385, 'c4806101-8896-eb11-b1ac-0022483702bb', '2021-04-06 03:28:00', 'Kaspersky Endpoint Security Cloud Plus (10-14 Nodos)-Renewal', 'Kaspersky', 'KL4743DA*FR-N1', '39,67 US$', 'Comercial', 'Kaspersky\r\n'),
(386, '5da0512a-8896-eb11-b1ac-0022483702bb', '2021-04-06 03:29:00', 'Kaspersky Endpoint Security Cloud Plus (15-19 Nodos)-Renewal', 'Kaspersky', 'KL4743DA*FR-N2', '35,58 US$', 'Comercial', 'Kaspersky\r\n'),
(387, 'd5bd836f-8896-eb11-b1ac-0022483702bb', '2021-04-06 03:32:00', 'Kaspersky Endpoint Security Cloud Plus (20-24 Nodos)-Renewal', 'Kaspersky', 'KL4743DA*FR-N3', '31,50 US$', 'Comercial', 'Kaspersky\r\n'),
(388, '389fd5ae-8896-eb11-b1ac-0022483702bb', '2021-04-06 03:34:00', 'Kaspersky Endpoint Security Cloud Plus (25-49 Nodos)-Renewal', 'Kaspersky', 'KL4743DA*FR-N4', '28,58 US$', 'Comercial', 'Kaspersky\r\n'),
(389, 'ed5de918-8996-eb11-b1ac-0022483702bb', '2021-04-06 03:37:00', 'Kaspersky Endpoint Security for Business Select (10-19 Nodos)-Renewal', 'Kaspersky', 'KL4863DA*FR-N1', '32,67 US$', 'Comercial', 'Kaspersky\r\n'),
(390, 'a38c0173-8996-eb11-b1ac-0022483702bb', '2021-04-06 03:40:00', 'Kaspersky Endpoint Security for Business Select (20-49 Nodos)-Renewal', 'Kaspersky', 'KL4863DA*FR-N2', '28,00 US$', 'Comercial', 'Kaspersky\r\n'),
(391, '1d73b620-8a96-eb11-b1ac-0022483702bb', '2021-04-06 03:43:00', 'Kaspersky Total Security for Business (10-19 Nodos)-Renewal', 'Kaspersky', 'KL4869DA*FR-N1', '56,58 US$', 'Comercial', 'Kaspersky\r\n'),
(392, '16bae858-8a96-eb11-b1ac-0022483702bb', '2021-04-06 03:45:00', 'Kaspersky Total Security for Business (20-49 Nodos)-Renewal', 'Kaspersky', 'KL4869DA*FR-N2', '49,00 US$', 'Comercial', 'Kaspersky\r\n'),
(393, 'dc911cab-8a96-eb11-b1ac-0022483702bb', '2021-04-06 03:48:00', 'Kaspersky Endpoint Security for Business Advanced (10-19 Nodos)-Renewal', 'Kaspersky', 'KL4867DA*FR-N1', '45,50 US$', 'Comercial', 'Kaspersky\r\n'),
(394, 'fcdcf6f0-8a96-eb11-b1ac-0022483702bb', '2021-04-06 03:50:00', 'Kaspersky Endpoint Security for Business Advanced (20-49 Nodos)-Renewal', 'Kaspersky', 'KL4867DA*FR-N2', '39,08 US$', 'Comercial', 'Kaspersky\r\n'),
(395, 'f35a4578-fb96-eb11-b1ac-0022483702bb', '2022-01-12 14:53:00', 'Excel LTSC 2021', 'Microsoft', 'DG7GMGF0D7FT - C', '213,75 US$', 'Comercial', 'Microsoft\r\n'),
(396, '08ae90f8-b197-eb11-b1ac-0022483702bb', '2021-04-07 15:06:00', 'Red Hat Enterprise Linux Server, Premium (Physical or Virtual Nodes) - Trianual', 'Red Hat', 'RH00003F3-T', '3702,15 US$', 'Comercial', 'Red Hat\r\n'),
(397, '206cfdaf-b497-eb11-b1ac-0022483702bb', '2021-04-08 13:37:00', 'Desktop Educaci?n - Open Value Subscription', 'Microsoft', '2UJ-00011', '68,98 US$', 'Comercial', 'Microsoft - Educaci?n\r\n'),
(398, '127e032e-b597-eb11-b1ac-0022483702bb', '2021-09-01 15:17:00', 'SQL Server Standard Core - Open Value (Incluye Software Assurance)', 'Microsoft', '7NQ-00069', '2592,38 US$', 'Comercial', 'Microsoft\r\n'),
(399, 'add71737-b797-eb11-b1ac-0022483702bb', '2021-09-01 14:36:00', 'Windows Server Datacenter 2019 - 16 Core - Open Value (Incluye Software Assurance)', 'Microsoft', '9EA-00319', '3870,59 US$', 'Comercial', 'Microsoft\r\n'),
(400, '35e7c778-b797-eb11-b1ac-0022483702bb', '2021-09-01 14:55:00', 'Windows Server Cal 2019 -User - Open Value (Incluye Software Assurance)', 'Microsoft', 'R18-01855', '30,28 US$', 'Comercial', 'Microsoft\r\n'),
(401, '2e3796a8-b797-eb11-b1ac-0022483702bb', '2021-09-01 14:15:00', 'Windows Server RDS CAL 2019 - User - Open Value (Incluye Software Assurance)', 'Microsoft', '6VC-00701', '95,47 US$', 'Comercial', 'Microsoft\r\n'),
(402, '84bfc876-e897-eb11-b1ac-0022483702bb', '2021-04-15 19:27:00', 'Office Hogar y Empresas 2019 ESD', 'Microsoft', 'SE010MSE47', '268,75 US$', 'Comercial', 'Microsoft\r\n'),
(403, '82ad0fc4-e897-eb11-b1ac-0022483702bb', '2021-09-02 17:15:00', 'SQL Server Standard Core 2019 (Incluye Software Assurance)', 'Microsoft', '7NQ-00215', '6885,39 US$', 'Comercial', 'Microsoft\r\n'),
(404, '54713b2c-e997-eb11-b1ac-0022483702bb', '2021-09-01 14:35:00', 'Windows Server Datacenter 2019 - 16 Core (Incluye Software Assurance)', 'Microsoft', '9EA-00118', '11.822,35 US$', 'Comercial', 'Microsoft\r\n'),
(405, 'e9d81674-e997-eb11-b1ac-0022483702bb', '2021-09-01 14:32:00', 'Windows Server Datacenter 2019 - 2 Core (Incluye Software Assurance)', 'Microsoft', '9EA-00124', '1478,56 US$', 'Comercial', 'Microsoft\r\n'),
(406, '2bcdc71b-1c98-eb11-b1ac-0022483702bb', '2021-04-08 03:42:00', 'Veeam Backup & Replication Universal Subscription - Renewal', 'Otro', 'V-VBRVUL-0I-SU1AR-00', '1231,89 US$', 'Comercial', 'Veeam\r\n'),
(407, 'e9de4c86-1c98-eb11-b1ac-0022483702bb', '2021-04-08 03:48:00', 'Veeam Backup & Replication Enterprise Perpetuo Renewal Expirada', 'Otro', 'V-VBRENT-VS-P0ARE-00', '559,16 US$', 'Comercial', 'Veeam\r\n'),
(408, '553ddee0-1c98-eb11-b1ac-0022483702bb', '2021-04-08 03:49:00', 'Veeam Backup & Replication Enterprise Perpetuo Renewal', 'Otro', 'V-VBRENT-VS-P01AR-00', '447,34 US$', 'Comercial', 'Veeam\r\n'),
(409, '2bd4245f-b198-eb11-b1ac-0022483702bb', '2021-04-08 21:30:00', 'MVISION Standard - Anual', 'Mcafee', '14183364-NAI', '26,40 US$', 'Comercial', 'Mcafee\r\n'),
(410, '15ee9856-3d97-eb11-b1ac-002248370bfa', '2023-01-30 18:24:00', 'Otro servicio no categorizado', 'Last Call', 'L013', '43,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(411, '1f982a42-7e98-eb11-b1ac-002248370bfa', '2023-01-30 18:24:00', 'Power Platform - Desarrollo', 'Last Call', 'L012', '43,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(412, 'e7fe6687-9198-eb11-b1ac-002248370bfa', '2021-04-08 17:40:00', 'Componentes de Hardware', 'Otro', 'HRDWR01', '1,00 US$', 'Comercial', 'Hardware\r\n'),
(413, 'b0d0509f-c290-eb11-b1ac-0022483713bf', '2021-03-29 19:17:00', 'Kaspersky Automated Security Awareness Platform (10-14 Nodos)', 'Kaspersky', 'KL8558DA*FS-N1', '111,88 US$', 'Comercial', 'Kaspersky\r\n'),
(414, 'a95a4205-c390-eb11-b1ac-0022483713bf', '2021-03-29 19:16:00', 'Kaspersky Automated Security Awareness Platform (15-19 Nodos)', 'Kaspersky', 'KL8558DA*FS-N2', '100,63 US$', 'Comercial', 'Kaspersky\r\n'),
(415, 'e973ea7a-c390-eb11-b1ac-0022483713bf', '2021-03-29 19:19:00', 'Kaspersky Automated Security Awareness Platform (20-24 Nodos)', 'Kaspersky', 'KL8558DA*FS-N3', '90,00 US$', 'Comercial', 'Kaspersky\r\n'),
(416, '74d570d2-c390-eb11-b1ac-0022483713bf', '2021-03-29 19:21:00', 'Kaspersky Automated Security Awareness Platform (25-49 Nodos)', 'Kaspersky', 'KL8558DA*FS-N4', '81,25 US$', 'Comercial', 'Kaspersky\r\n'),
(417, '9bd54e68-c490-eb11-b1ac-0022483713bf', '2021-03-29 19:25:00', 'Kaspersky Automated Security Awareness Platform (50-99 Nodos)', 'Kaspersky', 'KL8558DA*FS-N5', '72,50 US$', 'Comercial', 'Kaspersky\r\n'),
(418, '22511ea0-c490-eb11-b1ac-0022483713bf', '2021-03-29 19:27:00', 'Kaspersky Automated Security Awareness Platform (100-149 Nodos)', 'Kaspersky', 'KL8558DA*FS-N6', '65,63 US$', 'Comercial', 'Kaspersky\r\n'),
(419, 'ae8f85d1-c490-eb11-b1ac-0022483713bf', '2021-03-29 19:28:00', 'Kaspersky Automated Security Awareness Platform (150-249 Nodos)', 'Kaspersky', 'KL8558DA*FS-N7', '46,25 US$', 'Comercial', 'Kaspersky\r\n'),
(420, 'fd824844-c590-eb11-b1ac-0022483713bf', '2021-03-29 19:32:00', 'Kaspersky Endpoint Security Cloud (10-14 Nodos)', 'Kaspersky', 'KL4742DA*FS-N1', '60,00 US$', 'Comercial', 'Kaspersky\r\n'),
(421, '1cf87482-c590-eb11-b1ac-0022483713bf', '2021-03-29 19:33:00', 'Kaspersky Endpoint Security Cloud (15-19 Nodos)', 'Kaspersky', 'KL4742DA*FS-N2', '53,33 US$', 'Comercial', 'Kaspersky\r\n'),
(422, '4b6b87d3-c590-eb11-b1ac-0022483713bf', '2021-03-29 19:36:00', 'Kaspersky Endpoint Security Cloud (20-24 Nodos)', 'Kaspersky', 'KL4742DA*FS-N3', '47,50 US$', 'Comercial', 'Kaspersky\r\n'),
(423, '99103318-c690-eb11-b1ac-0022483713bf', '2021-03-29 19:37:00', 'Kaspersky Endpoint Security Cloud (25-49 Nodos)', 'Kaspersky', 'KL4742DA*FS-N4', '42,50 US$', 'Comercial', 'Kaspersky\r\n'),
(424, '632da450-c690-eb11-b1ac-0022483713bf', '2021-04-04 21:35:00', 'Kaspersky Endpoint Security Cloud (50-99 Nodos)', 'Kaspersky', 'KL4742DA*FS-N5', '37,50 US$', 'Comercial', 'Kaspersky\r\n'),
(425, '28064887-c690-eb11-b1ac-0022483713bf', '2021-03-29 19:41:00', 'Kaspersky Endpoint Security Cloud (100-149 Nodos)', 'Kaspersky', 'KL4742DA*FS-N6', '33,33 US$', 'Comercial', 'Kaspersky\r\n'),
(426, 'f37e8ec5-c690-eb11-b1ac-0022483713bf', '2021-03-29 19:42:00', 'Kaspersky Endpoint Security Cloud (150-249 Nodos)', 'Kaspersky', 'KL4742DA*FS-N7', '30,00 US$', 'Comercial', 'Kaspersky\r\n'),
(427, '27af0c18-c790-eb11-b1ac-0022483713bf', '2021-03-29 19:45:00', 'Kaspersky Endpoint Security Cloud (10-14 Nodos) Trianual', 'Kaspersky', 'KL4742DA*TS-N1', '153,33 US$', 'Comercial', 'Kaspersky\r\n'),
(428, 'e1669d61-c790-eb11-b1ac-0022483713bf', '2021-03-29 19:47:00', 'Kaspersky Endpoint Security Cloud (15-19 Nodos) Trianual', 'Kaspersky', 'KL4742DA*TS-N2', '135,83 US$', 'Comercial', 'Kaspersky\r\n'),
(429, 'ab53ca9f-c790-eb11-b1ac-0022483713bf', '2021-03-29 19:48:00', 'Kaspersky Endpoint Security Cloud (20-24 Nodos) Trianual', 'Kaspersky', 'KL4742DA*TS-N3', '120,83 US$', 'Comercial', 'Kaspersky\r\n'),
(430, '2ccba9dd-c790-eb11-b1ac-0022483713bf', '2021-03-29 19:50:00', 'Kaspersky Endpoint Security Cloud (25-49 Nodos) Trianual', 'Kaspersky', 'KL4742DA*TS-N4', '108,33 US$', 'Comercial', 'Kaspersky\r\n'),
(431, '3928001b-c890-eb11-b1ac-0022483713bf', '2021-03-29 19:52:00', 'Kaspersky Endpoint Security Cloud (50-99 Nodos) Trianual', 'Kaspersky', 'KL4742DA*TS-N5', '95,83 US$', 'Comercial', 'Kaspersky\r\n'),
(432, '0a2fc558-c890-eb11-b1ac-0022483713bf', '2021-03-29 19:56:00', 'Kaspersky Endpoint Security Cloud (100-149 Nodos) Trianual', 'Kaspersky', 'KL4742DA*TS-N6', '85,00 US$', 'Comercial', 'Kaspersky\r\n'),
(433, 'fcbb71dd-c890-eb11-b1ac-0022483713bf', '2021-03-29 19:57:00', 'Kaspersky Endpoint Security Cloud (150-249 Nodos) Trianual', 'Kaspersky', 'KL4742DA*TS-N7', '76,67 US$', 'Comercial', 'Kaspersky\r\n'),
(434, '31422bf2-6391-eb11-b1ac-0022483713bf', '2021-03-30 14:29:00', 'Kaspersky Endpoint Security Cloud Plus (10-14 Nodos)', 'Kaspersky', 'KL4743DA*FS-N1', '70,83 US$', 'Comercial', 'Kaspersky\r\n'),
(435, '4711d42a-6491-eb11-b1ac-0022483713bf', '2021-03-30 14:29:00', 'Kaspersky Endpoint Security Cloud Plus (15-19 Nodos)', 'Kaspersky', 'KL4743DA*FS-N2', '63,33 US$', 'Comercial', 'Kaspersky\r\n'),
(436, '0d784a6d-6491-eb11-b1ac-0022483713bf', '2021-03-30 14:31:00', 'Kaspersky Endpoint Security Cloud Plus (20-24 Nodos)', 'Kaspersky', 'KL4743DA*FS-N3', '56,67 US$', 'Comercial', 'Kaspersky\r\n'),
(437, '60c3ddb0-6491-eb11-b1ac-0022483713bf', '2021-03-30 14:33:00', 'Kaspersky Endpoint Security Cloud Plus (25-49 Nodos)', 'Kaspersky', 'KL4743DA*FS-N4', '51,67 US$', 'Comercial', 'Kaspersky\r\n'),
(438, 'fc8424ee-6491-eb11-b1ac-0022483713bf', '2021-03-30 14:34:00', 'Kaspersky Endpoint Security Cloud Plus (50-99 Nodos)', 'Kaspersky', 'KL4743DA*FS-N5', '45,83 US$', 'Comercial', 'Kaspersky\r\n'),
(439, '16a31f64-6591-eb11-b1ac-0022483713bf', '2021-03-30 14:44:00', 'Kaspersky Endpoint Security Cloud Plus (100-149 Nodos)', 'Kaspersky', 'KL4743DA*FS-N6', '41,67 US$', 'Comercial', 'Kaspersky\r\n'),
(440, '27f19b17-6691-eb11-b1ac-0022483713bf', '2021-03-30 14:43:00', 'Kaspersky Endpoint Security Cloud Plus (150-249 Nodos)', 'Kaspersky', 'KL4743DA*FS-N7', '37,50 US$', 'Comercial', 'Kaspersky\r\n'),
(441, '0c6fbee9-6791-eb11-b1ac-0022483713bf', '2021-03-30 14:56:00', 'Kaspersky Endpoint Security Cloud Plus (10-14 Nodos) Trianual', 'Kaspersky', 'KL4743DA*TS-N1', '180,83 US$', 'Comercial', 'Kaspersky\r\n'),
(442, '6c587d2e-6891-eb11-b1ac-0022483713bf', '2021-03-30 14:58:00', 'Kaspersky Endpoint Security Cloud Plus (15-19 Nodos) Trianual', 'Kaspersky', 'KL4743DA*TS-N2', '161,67 US$', 'Comercial', 'Kaspersky\r\n'),
(443, 'c0c1b56b-6891-eb11-b1ac-0022483713bf', '2021-03-30 14:59:00', 'Kaspersky Endpoint Security Cloud Plus (20-24 Nodos) Trianual', 'Kaspersky', 'KL4743DA*TS-N3', '144,17 US$', 'Comercial', 'Kaspersky\r\n'),
(444, '26dd4aa0-6891-eb11-b1ac-0022483713bf', '2021-03-30 15:01:00', 'Kaspersky Endpoint Security Cloud Plus (25-49 Nodos) Trianual', 'Kaspersky', 'KL4743DA*TS-N4', '130,83 US$', 'Comercial', 'Kaspersky\r\n'),
(445, '339dd4dd-6891-eb11-b1ac-0022483713bf', '2021-03-30 15:03:00', 'Kaspersky Endpoint Security Cloud Plus (50-99 Nodos) Trianual', 'Kaspersky', 'KL4743DA*TS-N5', '117,50 US$', 'Comercial', 'Kaspersky\r\n'),
(446, '943a5218-6991-eb11-b1ac-0022483713bf', '2021-03-30 15:06:00', 'Kaspersky Endpoint Security Cloud Plus (100-149 Nodos) Trianual', 'Kaspersky', 'KL4743DA*TS-N6', '105,00 US$', 'Comercial', 'Kaspersky\r\n'),
(447, '9122b89f-6991-eb11-b1ac-0022483713bf', '2021-03-30 15:08:00', 'Kaspersky Endpoint Security Cloud Plus (150-249 Nodos) Trianual', 'Kaspersky', 'KL4743DA*TS-N7', '95,00 US$', 'Comercial', 'Kaspersky\r\n'),
(448, '6c8db89b-6c91-eb11-b1ac-0022483713bf', '2021-03-30 15:30:00', 'Kaspersky Total Security for Business (10-19 Nodos)', 'Kaspersky', 'KL4869DA*FS-N1', '115,83 US$', 'Comercial', 'Kaspersky\r\n'),
(449, 'bdcf5dd8-6c91-eb11-b1ac-0022483713bf', '2021-03-30 15:31:00', 'Kaspersky Total Security for Business (20-49 Nodos)', 'Kaspersky', 'KL4869DA*FS-N2', '100,00 US$', 'Comercial', 'Kaspersky\r\n'),
(450, '13a8031d-6d91-eb11-b1ac-0022483713bf', '2021-03-30 15:33:00', 'Kaspersky Total Security for Business (50-99 Nodos)', 'Kaspersky', 'KL4869DA*FS-N3', '81,67 US$', 'Comercial', 'Kaspersky\r\n'),
(451, '89b38f5a-6d91-eb11-b1ac-0022483713bf', '2021-03-30 15:35:00', 'Kaspersky Total Security for Business (100-149 Nodos)', 'Kaspersky', 'KL4869DA*FS-N4', '72,50 US$', 'Comercial', 'Kaspersky\r\n'),
(452, 'f81b439a-6d91-eb11-b1ac-0022483713bf', '2021-03-30 15:36:00', 'Kaspersky Total Security for Business (150-249 Nodos)', 'Kaspersky', 'KL4869DA*FS-N5', '67,50 US$', 'Comercial', 'Kaspersky\r\n'),
(453, '0033ca1d-6e91-eb11-b1ac-0022483713bf', '2021-03-30 15:47:00', 'Kaspersky Total Security for Business (10-19 Nodos) Trianual', 'Kaspersky', 'KL4869DA*TS-N1', '230,83 US$', 'Comercial', 'Kaspersky\r\n'),
(454, 'faa8ae4b-6f91-eb11-b1ac-0022483713bf', '2021-03-30 15:48:00', 'Kaspersky Total Security for Business (20-49 Nodos) Trianual', 'Kaspersky', 'KL4869DA*TS-N2', '200,00 US$', 'Comercial', 'Kaspersky\r\n'),
(455, '9082af83-6f91-eb11-b1ac-0022483713bf', '2021-03-30 15:50:00', 'Kaspersky Total Security for Business (50-99 Nodos) Trianual', 'Kaspersky', 'KL4869DA*TS-N3', '162,50 US$', 'Comercial', 'Kaspersky\r\n'),
(456, 'c07280cc-6f91-eb11-b1ac-0022483713bf', '2021-03-30 15:53:00', 'Kaspersky Total Security for Business (100-149 Nodos) Trianual', 'Kaspersky', 'KL4869DA*TS-N4', '145,00 US$', 'Comercial', 'Kaspersky\r\n'),
(457, '727db922-7091-eb11-b1ac-0022483713bf', '2021-03-30 15:55:00', 'Kaspersky Total Security for Business (150-249 Nodos) Trianual', 'Kaspersky', 'KL4869DA*TS-N5', '135,00 US$', 'Comercial', 'Kaspersky\r\n'),
(458, '383f7a66-7091-eb11-b1ac-0022483713bf', '2021-03-30 16:00:00', 'Kaspersky Endpoint Security for Business Advanced (10-19 Nodos)', 'Kaspersky', 'KL4867DA*FS-N1', '92,50 US$', 'Comercial', 'Kaspersky\r\n'),
(459, '32c5e217-7191-eb11-b1ac-0022483713bf', '2021-03-30 16:04:00', 'Kaspersky Endpoint Security for Business Advanced (20-49 Nodos)', 'Kaspersky', 'KL4867DA*FS-N2', '80,00 US$', 'Comercial', 'Kaspersky\r\n'),
(460, '803fa8e7-7191-eb11-b1ac-0022483713bf', '2021-03-30 16:07:00', 'Kaspersky Endpoint Security for Business Advanced (50-99 Nodos)', 'Kaspersky', 'KL4867DA*FS-N3', '65,00 US$', 'Comercial', 'Kaspersky\r\n'),
(461, '3fb4c518-7291-eb11-b1ac-0022483713bf', '2021-03-30 16:11:00', 'Kaspersky Endpoint Security for Business Advanced (100-149 Nodos)', 'Kaspersky', 'KL4867DA*FS-N4', '58,33 US$', 'Comercial', 'Kaspersky\r\n'),
(462, '4dbf75c4-7291-eb11-b1ac-0022483713bf', '2021-03-30 16:14:00', 'Kaspersky Endpoint Security for Business Advanced (150-249 Nodos)', 'Kaspersky', 'KL4867DA*FS-N5', '54,17 US$', 'Comercial', 'Kaspersky\r\n'),
(463, '959d1e21-7391-eb11-b1ac-0022483713bf', '2021-03-30 16:17:00', 'Kaspersky Endpoint Security for Business Advanced (10-19 Nodos) Trianual', 'Kaspersky', 'KL4867DA*TS-N1', '185,83 US$', 'Comercial', 'Kaspersky\r\n'),
(464, '68e6aa7c-7391-eb11-b1ac-0022483713bf', '2021-03-30 16:19:00', 'Kaspersky Endpoint Security for Business Advanced (20-49 Nodos) Trianual', 'Kaspersky', 'KL4867DA*TS-N2', '160,00 US$', 'Comercial', 'Kaspersky\r\n'),
(465, '63f04a10-7491-eb11-b1ac-0022483713bf', '2021-03-30 16:23:00', 'Kaspersky Endpoint Security for Business Advanced (50-99 Nodos) Trianual', 'Kaspersky', 'KL4867DA*TS-N3', '130,83 US$', 'Comercial', 'Kaspersky\r\n'),
(466, '23224ca6-7491-eb11-b1ac-0022483713bf', '2021-03-30 16:27:00', 'Kaspersky Endpoint Security for Business Advanced (100-149 Nodos) Trianual', 'Kaspersky', 'KL4867DA*TS-N4', '116,67 US$', 'Comercial', 'Kaspersky\r\n'),
(467, '4e9ae7e4-7491-eb11-b1ac-0022483713bf', '2021-03-30 16:28:00', 'Kaspersky Endpoint Security for Business Advanced (150-249 Nodos) Trianual', 'Kaspersky', 'KL4867DA*TS-N5', '108,33 US$', 'Comercial', 'Kaspersky\r\n'),
(468, '652eb221-7591-eb11-b1ac-0022483713bf', '2021-03-30 16:30:00', 'Kaspersky Endpoint Security for Business Select (10-19 Nodos)', 'Kaspersky', 'KL4863DA*FS-N1', '66,67 US$', 'Comercial', 'Kaspersky\r\n'),
(469, 'e9fe5858-7591-eb11-b1ac-0022483713bf', '2021-03-30 16:32:00', 'Kaspersky Endpoint Security for Business Select (20-49 Nodos)', 'Kaspersky', 'KL4863DA*FS-N2', '57,50 US$', 'Comercial', 'Kaspersky\r\n'),
(470, '8b9c1389-7591-eb11-b1ac-0022483713bf', '2021-03-30 16:33:00', 'Kaspersky Endpoint Security for Business Select (50-99 Nodos)', 'Kaspersky', 'KL4863DA*FS-N3', '46,67 US$', 'Comercial', 'Kaspersky\r\n'),
(471, 'a4ce64c0-7591-eb11-b1ac-0022483713bf', '2021-03-30 16:35:00', 'Kaspersky Endpoint Security for Business Select (100-149 Nodos)-', 'Kaspersky', 'KL4863DA*FS-N4', '41,67 US$', 'Comercial', 'Kaspersky\r\n'),
(472, 'c2ebaaf7-7591-eb11-b1ac-0022483713bf', '2021-03-30 16:37:00', 'Kaspersky Endpoint Security for Business Select (150-249 Nodos)', 'Kaspersky', 'KL4863DA*FS-N5', '39,17 US$', 'Comercial', 'Kaspersky\r\n'),
(473, '05bb866e-7691-eb11-b1ac-0022483713bf', '2022-06-22 14:25:00', 'Kaspersky Endpoint Security for Business Select (10-14 Nodos) Trianual - Renewal', 'Kaspersky', 'KL4863DA*TS-N1', '93,33 US$', 'Comercial', 'Kaspersky\r\n'),
(474, 'e051c3bf-7691-eb11-b1ac-0022483713bf', '2021-03-30 16:42:00', 'Kaspersky Endpoint Security for Business Select (20-49 Nodos) Trianual', 'Kaspersky', 'KL4863DA*TS-N2', '115,00 US$', 'Comercial', 'Kaspersky\r\n'),
(475, 'b4c76426-7791-eb11-b1ac-0022483713bf', '2021-03-30 16:45:00', 'Kaspersky Endpoint Security for Business Select (50-99 Nodos) Trianual', 'Kaspersky', 'KL4863DA*TS-N3', '94,17 US$', 'Comercial', 'Kaspersky\r\n'),
(476, 'f59f805d-7791-eb11-b1ac-0022483713bf', '2021-03-30 16:46:00', 'Kaspersky Endpoint Security for Business Select (100-149 Nodos) Trianual', 'Kaspersky', 'KL4863DA*TS-N4', '83,33 US$', 'Comercial', 'Kaspersky\r\n'),
(477, '911d8594-7791-eb11-b1ac-0022483713bf', '2021-03-30 16:49:00', 'Kaspersky Endpoint Security for Business Select (150-249 Nodos) Trianual', 'Kaspersky', 'KL4863DA*TS-N5', '77,50 US$', 'Comercial', 'Kaspersky\r\n'),
(478, '1786f5f1-7d91-eb11-b1ac-0022483713bf', '2021-03-30 17:33:00', 'Red Hat Ansible Automation, Standard (100 Managed Nodes)', 'Red Hat', 'MCT3691-A', '13.000,00 US$', 'Comercial', 'Red Hat\r\n'),
(479, '570eea09-7e91-eb11-b1ac-0022483713bf', '2021-03-30 17:35:00', 'Red Hat Ansible Automation, Standard (100 Managed Nodes) Trianual', 'Red Hat', 'MCT3691-T', '37.050,00 US$', 'Comercial', 'Red Hat\r\n'),
(480, 'cd7d8057-7e91-eb11-b1ac-0022483713bf', '2021-03-30 17:37:00', 'Red Hat Ansible Automation, Premium (100 Managed Nodes)', 'Red Hat', 'MCT3694-A', '17.500,00 US$', 'Comercial', 'Red Hat\r\n'),
(481, '6cf1179b-7e91-eb11-b1ac-0022483713bf', '2021-03-30 17:38:00', 'Red Hat Ansible Automation, Premium (100 Managed Nodes) Trianual', 'Red Hat', 'MCT3694-T', '49.875,00 US$', 'Comercial', 'Red Hat\r\n'),
(482, '1960f70e-7f91-eb11-b1ac-0022483713bf', '2021-03-30 17:41:00', 'Red Hat Fuse, 4-Core Standard', 'Red Hat', 'MW00139-A', '7920,00 US$', 'Comercial', 'Red Hat\r\n'),
(483, '33d33147-7f91-eb11-b1ac-0022483713bf', '2021-03-30 17:43:00', 'Red Hat Fuse, 4-Core Standard Trianual', 'Red Hat', 'MW00139-T', '22.572,00 US$', 'Comercial', 'Red Hat\r\n'),
(484, '6cfedeaf-7f91-eb11-b1ac-0022483713bf', '2021-03-30 17:46:00', 'Red Hat Fuse, 4-Core Premium', 'Red Hat', 'MW00138-A', '11.880,00 US$', 'Comercial', 'Red Hat\r\n'),
(485, 'f15fa3ef-7f91-eb11-b1ac-0022483713bf', '2021-03-30 17:48:00', 'Red Hat Fuse, 4-Core Premium Trianual', 'Red Hat', 'MW00138-T', '33.858,00 US$', 'Comercial', 'Red Hat\r\n'),
(486, 'b9014540-8091-eb11-b1ac-0022483713bf', '2021-03-30 17:50:00', 'Red Hat Fuse, Standard (16 Cores)', 'Red Hat', 'MW2254895-A', '28.800,00 US$', 'Comercial', 'Red Hat\r\n'),
(487, 'b235fe73-8091-eb11-b1ac-0022483713bf', '2021-03-30 17:51:00', 'Red Hat Fuse, Standard (16 Cores) Trianual', 'Red Hat', 'MW2254895-T', '82.080,00 US$', 'Comercial', 'Red Hat\r\n'),
(488, '308683a5-8091-eb11-b1ac-0022483713bf', '2021-03-30 17:53:00', 'Red Hat Fuse, Premium (16 Cores)', 'Red Hat', 'MW2257476-A', '43.200,00 US$', 'Comercial', 'Red Hat\r\n'),
(489, '4cce6fdf-8091-eb11-b1ac-0022483713bf', '2021-03-30 17:54:00', 'Red Hat Fuse, Premium (16 Cores) Trianual', 'Red Hat', 'MW2257476-T', '123.120,00 US$', 'Comercial', 'Red Hat\r\n'),
(490, 'edb61a25-8191-eb11-b1ac-0022483713bf', '2021-03-30 17:57:00', 'Red Hat JBoss Enterprise Application Platform, 4-Core Premium', 'Red Hat', 'MW00114-A', '3300,00 US$', 'Comercial', 'Red Hat\r\n'),
(491, '6c35ad63-8191-eb11-b1ac-0022483713bf', '2021-03-30 17:58:00', 'Red Hat JBoss Enterprise Application Platform, 4-Core Premium Trianual', 'Red Hat', 'MW00114-T', '9405,00 US$', 'Comercial', 'Red Hat\r\n'),
(492, '01148ac0-8191-eb11-b1ac-0022483713bf', '2021-03-30 18:01:00', 'Red Hat JBoss Enterprise Application Platform, 4-Core Standard', 'Red Hat', 'MW00115-A', '2200,00 US$', 'Comercial', 'Red Hat\r\n'),
(493, '514a9a7f-8291-eb11-b1ac-0022483713bf', '2021-03-30 18:06:00', 'Red Hat JBoss Enterprise Application Platform, 4-Core Standard Trianual', 'Red Hat', 'MW00115-T', '6270,00 US$', 'Comercial', 'Red Hat\r\n'),
(494, 'fbb09109-abf0-eb11-94ef-002248371867', '2021-07-29 20:27:00', 'Adobe Premier (Nivel 1) (Anual)', 'Adobe', '65297625BA01A12 - A', '539,00 US$', 'Comercial', 'Adobe\r\n'),
(495, 'b788445d-abf0-eb11-94ef-002248371867', '2021-07-29 20:28:00', 'After Effects (Nivel 1) (Anual)', 'Adobe', '65297724BA01A12- A', '539,00 US$', 'Comercial', 'Adobe\r\n'),
(496, 'dd898706-cdd9-eb11-bacb-002248371b3c', '2022-06-22 15:05:00', 'Kaspersky Endpoint Security for Business Select (20-24 Nodos) Bianual Renewal', 'Kaspersky', 'KL4863DA*DS-N2', '60,08 US$', 'Comercial', 'Kaspersky\r\n'),
(497, '09d27fd1-d8d9-eb11-bacb-002248371b3c', '2021-06-30 19:27:00', 'ESET Protect Essential On-Prem(ESET Endpoint Protection Standard) 1 A?o', 'Otro', 'NN', '34,03 US$', 'Comercial', 'Eset\r\n'),
(498, '9f74452e-3a92-eb11-b1ac-002248371e24', '2021-03-31 16:03:00', 'Red Hat OpenShift Container Platform Premium (2 Cores or 4 vCPUs)', 'Red Hat', 'MCT2735-A', '4000,00 US$', 'Comercial', 'Red Hat\r\n'),
(499, '9572f860-3a92-eb11-b1ac-002248371e24', '2021-03-31 16:03:00', 'Red Hat OpenShift Container Platform Premium (2 Cores or 4 vCPUs) Trianual', 'Red Hat', 'MCT2735-T', '11.400,00 US$', 'Comercial', 'Red Hat\r\n'),
(500, '2443eec0-3a92-eb11-b1ac-002248371e24', '2021-03-31 16:05:00', 'Red Hat OpenShift Container Platform Standard (2 Cores or 4 vCPUs)', 'Red Hat', 'MCT2736-A', '2700,00 US$', 'Comercial', 'Red Hat\r\n'),
(501, '60cc6dfb-3a92-eb11-b1ac-002248371e24', '2021-03-31 16:06:00', 'Red Hat OpenShift Container Platform Standard (2 Cores or 4 vCPUs) Trianual', 'Red Hat', 'MCT2736-T', '7695,00 US$', 'Comercial', 'Red Hat\r\n'),
(502, '63809b21-3b92-eb11-b1ac-002248371e24', '2021-03-31 16:08:00', 'Red Hat OpenShift Container Platform with Integration, Premium, (2 Cores or 4 vCPUs)', 'Red Hat', 'MW00448-A', '9940,00 US$', 'Comercial', 'Red Hat\r\n');
INSERT INTO `allproduct` (`idAllproduct`, `Producto`, `Fecha de modificación`, `Nombre`, `Fabricante`, `Id. de producto`, `Precio listado`, `Segmento`, `Lista de precios predeterminada`) VALUES
(503, '557a6576-3b92-eb11-b1ac-002248371e24', '2021-03-31 16:10:00', 'Red Hat OpenShift Container Platform with Integration, Premium, (2 Cores or 4 vCPUs) Trianual', 'Red Hat', 'MW00448-T', '28.329,00 US$', 'Comercial', 'Red Hat\r\n'),
(504, 'b7e4fc57-ea25-ec11-b6e6-002248372507', '2021-10-05 14:43:00', 'Kaspersky Endpoint Security Cloud Plus (10-14 Nodos)-Base Plus', 'Kaspersky', 'KL4743DA*F8', '55,09 US$', 'Comercial', 'Kaspersky\r\n'),
(505, '8ff3428f-e425-ec11-b6e6-002248372721', '2021-10-05 14:00:00', 'Office Standard Mac 2019-202110051400209039', 'Microsoft', '3YF-00652-202110051400209039', '609,94 US$', 'Comercial', '\r\n'),
(506, '245f4bc2-3add-ec11-bb3c-002248372e8d', '2022-05-26 21:29:00', 'InDesign for teams (Nivel 1)', 'Adobe', '65297580BA01A12', '509,84 US$', 'Comercial', 'Adobe\r\n'),
(507, '0b2537dd-3fdd-ec11-bb3c-002248372e8d', '2022-05-26 22:06:00', 'Dreamweaver for teams (Nivel 1)', 'Adobe', '65297792BA01A12', '509,84 US$', 'Comercial', 'Adobe\r\n'),
(508, '63744860-dddd-ec11-bb3c-002248372e8d', '2022-05-27 16:53:00', 'Acrobat Pro DC for enterprise (Nivel 2)', 'Adobe', '65271502BA02A12', '257,26 US$', 'Comercial', 'Adobe\r\n'),
(509, 'f219fe17-dedd-ec11-bb3c-002248372e8d', '2022-05-27 16:58:00', 'Acrobat Pro DC for enterprise (Nivel 1)', 'Adobe', '65271502BA01A12', '270,81 US$', 'Comercial', 'Adobe\r\n'),
(510, '7c16504d-94dd-eb11-bacb-002248373013', '2021-07-05 13:25:00', 'Eset Endpoint Antivirus - 1 Year', 'Otro', 'NN- 1', '25,93 US$', 'Comercial', 'Eset\r\n'),
(511, 'dd13a3b1-9add-eb11-bacb-002248373013', '2021-07-05 14:12:00', 'Revit 2022 Commercial New Single-user (Trianual)', 'Autodesk', '829N1-WW7407-L592', '7323,33 US$', 'Comercial', 'Autodesk\r\n'),
(512, '5666fd3c-76de-eb11-bacb-002248373013', '2021-07-06 16:23:00', 'ESET Protect Essential On-Prem(ESET Endpoint Protection Standard) 2 A?os', 'Otro', 'NN-2', '51,10 US$', 'Comercial', 'Eset\r\n'),
(513, '4a913136-79de-eb11-bacb-002248373013', '2021-07-08 19:16:00', 'Adobe Premier (Nivel 1) (Trianual)', 'Adobe', '65297625BA01A12 - T', '1586,25 US$', 'Comercial', 'Adobe\r\n'),
(514, 'd09e1dcf-83de-eb11-bacb-002248373013', '2021-07-06 18:01:00', 'Secure Site Wildcard - Digicert', 'Otro', 'NN3', '997,50 US$', 'Comercial', 'Certificados SSL\r\n'),
(515, '863234f6-8bde-eb11-bacb-002248373013', '2021-07-06 18:59:00', 'Rapid SSLWildcard', 'Otro', 'NN4', '433,61 US$', 'Comercial', 'Certificados SSL\r\n'),
(516, '1f70765d-a7de-eb11-bacb-002248373013', '2021-07-06 22:13:00', 'Kaspersky Endpoint Security Cloud Plus (150-249 Nodos)-202107062213282475', 'Kaspersky', 'KL4743DA*FS-N7-202107062213282475', '37,50 US$', 'Comercial', '\r\n'),
(517, '23879f7a-a8de-eb11-bacb-002248373013', '2021-07-06 22:22:00', 'Kaspersky Endpoint Security Cloud Plus (500 Nodos)', 'Kaspersky', 'KL4743DA*FS-N9', '21,00 US$', 'Comercial', 'Kaspersky\r\n'),
(518, 'c9e10b18-1fe0-eb11-bacb-002248373ccb', '2021-07-08 19:04:00', 'Acrobat Standard DC for teams New - Nivel 1 (Trianuall)', 'Adobe', '65297914BA01A12 - T', '619,18 US$', 'Comercial', 'Adobe\r\n'),
(519, 'd0c9c38e-20e0-eb11-bacb-002248373ccb', '2021-07-08 19:14:00', 'Illustrator for Teams New - Nivel 1 (Trianual)', 'Adobe', '65297607BA01A12 - T', '1586,25 US$', 'Comercial', 'Adobe\r\n'),
(520, '185b473f-21e0-eb11-bacb-002248373ccb', '2021-07-08 19:19:00', 'After Effects (Nivel 1) (Trianual)', 'Adobe', '65297724BA01A12', '1586,25 US$', 'Comercial', 'Adobe\r\n'),
(521, '33b17765-19a1-eb11-b1ac-002248374405', '2021-04-19 14:15:00', 'System Center Endpoint Protection - User - Open Value (Incluye Software Assurance)', 'Microsoft', 'M3J-00081', '16,50 US$', 'Comercial', 'Microsoft\r\n'),
(522, 'b22c6eb8-19a1-eb11-b1ac-002248374405', '2021-04-19 14:16:00', 'System Center Standard Core - Open Value (Incluye Software Assurance)', 'Microsoft', '9EN-00227', '591,03 US$', 'Comercial', 'Microsoft\r\n'),
(523, '8c5c4ae4-1ba1-eb11-b1ac-002248374405', '2021-04-19 14:33:00', 'Windows Upgrade Academico - Open Value Subscription', 'Microsoft', 'KW5-00359', '23,16 US$', 'Comercial', 'Microsoft - Educaci?n\r\n'),
(524, '57068235-1ca1-eb11-b1ac-002248374405', '2021-04-19 14:35:00', 'Office ProPlus Academico - Open Value Subscription', 'Microsoft', '2FJ-00005', '35,09 US$', 'Comercial', 'Microsoft - Educaci?n\r\n'),
(525, '81253343-23a1-eb11-b1ac-002248374405', '2021-04-19 15:25:00', 'Microsoft Azure', 'Microsoft', '7UD-00001', '1,00 US$', 'Comercial', 'Microsoft - Azure\r\n'),
(526, '86e00df2-42a1-eb11-b1ac-002248374405', '2021-04-19 19:12:00', 'Red Hat Enterprise Linux Server, Premium (Physical or Virtual Nodes)', 'Red Hat', 'RH00003F3-A', '1299,00 US$', 'Comercial', 'Red Hat\r\n'),
(527, 'aeda3825-48a1-eb11-b1ac-002248374405', '2023-01-30 18:29:00', 'Seguridad - Multi factor de autenticaci?n (MFA)', 'Last Call', 'L017', '26,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(528, 'd74607c4-48a1-eb11-b1ac-002248374405', '2023-01-30 18:27:00', 'Seguridad - Capacitaciones de concientizaci?n', 'Last Call', 'L018', '256,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(529, 'fcf47c0d-4aa1-eb11-b1ac-002248374405', '2023-01-30 18:28:00', 'Seguridad - Correo electr?nico', 'Last Call', 'L020', '1702,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(530, 'a5bd00e3-ffa1-eb11-b1ac-002248374405', '2022-03-17 02:06:00', 'Power BI Premium - Por usuario (Anual)', 'Microsoft', 'CFQ7TTC0HL8W - A', '240,00 US$', 'Comercial', 'Microsoft\r\n'),
(531, 'e8109e17-00a2-eb11-b1ac-002248374405', '2022-03-17 02:07:00', 'Power BI Premium - Por usuario (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0HL8W - A/M', '20,00 US$', 'Comercial', 'Microsoft\r\n'),
(532, 'be2461c8-2ea2-eb11-b1ac-002248374405', '2023-01-30 18:29:00', 'Seguridad - Plan Director de Ciberseguridad (PDS)', 'Last Call', 'L019', '6379,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(533, 'a471a310-32a2-eb11-b1ac-002248374405', '2023-01-30 18:27:00', 'Seguridad - Auditoria M365', 'Last Call', 'L021', '426,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(534, '3456bd0a-33a2-eb11-b1ac-002248374405', '2023-01-30 18:28:00', 'Seguridad - Implementaci?n Kaspersky Endpoint Security Cloud (No incluye migraci?n)', 'Last Call', 'L022', '18,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(535, '4a2fa67c-34a2-eb11-b1ac-002248374405', '2023-01-30 18:28:00', 'Seguridad - Implementaci?n Kaspersky Endpoint Security Cloud (Incluye migraci?n)', 'Last Call', 'L023', '26,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(536, 'd7c7e390-34a2-eb11-b1ac-002248374405', '2023-01-30 18:28:00', 'Seguridad - Implementaci?n Kaspersky Endpoint Security Cloud Plus (Incluye migraci?n)', 'Last Call', 'L025', '26,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(537, '18076e40-35a2-eb11-b1ac-002248374405', '2023-01-30 18:28:00', 'Seguridad - Implementaci?n Kaspersky Endpoint Security Cloud Plus (No incluye migraci?n)', 'Last Call', 'L024', '22,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(538, '418cf49b-d8a2-eb11-b1ac-002248374ca4', '2021-04-21 19:55:00', 'Office 365 Data Loss Prevention - (Anual)', 'Microsoft', '4833683a-1e4a-4816-80cf-25238184b8c4 - A', '35,56 US$', 'Comercial', 'Microsoft\r\n'),
(539, 'ef77922e-dba2-eb11-b1ac-002248374ca4', '2022-03-10 16:28:00', 'Office 365 Data Loss Prevention - (Anualidad con Pago Mensual)', 'Microsoft', '4833683a-1e4a-4816-80cf-25238184b8c4 - M', '2,96 US$', 'Comercial', 'Microsoft\r\n'),
(540, '27284bf2-eca2-eb11-b1ac-002248374ca4', '2022-03-16 13:00:00', 'Microsoft 365 Business Standard (11 Meses)', 'Microsoft', 'CFQ7TTC0LDPB - M11', '137,50 US$', 'Comercial', 'Microsoft\r\n'),
(541, '25cfce94-eda2-eb11-b1ac-002248374ca4', '2022-03-16 13:00:00', 'Microsoft 365 Business Standard (10 Meses)', 'Microsoft', 'CFQ7TTC0LDPB - M10', '125,00 US$', 'Comercial', 'Microsoft\r\n'),
(542, '89bae8c0-eda2-eb11-b1ac-002248374ca4', '2022-03-16 13:00:00', 'Microsoft 365 Business Standard (9 Meses)', 'Microsoft', 'CFQ7TTC0LDPB - M9', '112,50 US$', 'Comercial', 'Microsoft\r\n'),
(543, '19def70b-eea2-eb11-b1ac-002248374ca4', '2022-03-16 20:53:00', 'Exchange Online Plan 1 (2 Meses)', 'Microsoft', 'CFQ7TTC0LH16 - M2', '8,00 US$', 'Comercial', 'Microsoft\r\n'),
(544, 'b20fd537-eea2-eb11-b1ac-002248374ca4', '2022-03-16 20:54:00', 'Exchange Online Plan 1 (3 Meses)', 'Microsoft', 'CFQ7TTC0LH16 - M3', '12,00 US$', 'Comercial', 'Microsoft\r\n'),
(545, '181d1d45-eea2-eb11-b1ac-002248374ca4', '2022-03-16 20:54:00', 'Exchange Online Plan 1 (4 Meses)', 'Microsoft', 'CFQ7TTC0LH16 - M4', '16,00 US$', 'Comercial', 'Microsoft\r\n'),
(546, '8e484759-eea2-eb11-b1ac-002248374ca4', '2022-03-16 20:54:00', 'Exchange Online Plan 1 (5 Meses)', 'Microsoft', 'CFQ7TTC0LH16 - M5', '20,00 US$', 'Comercial', 'Microsoft\r\n'),
(547, 'd326de66-eea2-eb11-b1ac-002248374ca4', '2022-03-16 20:54:00', 'Exchange Online Plan 1 (6 Meses)', 'Microsoft', 'CFQ7TTC0LH16 - M6', '24,00 US$', 'Comercial', 'Microsoft\r\n'),
(548, 'b7e6057b-eea2-eb11-b1ac-002248374ca4', '2022-03-16 20:54:00', 'Exchange Online Plan 1 (7 Meses)', 'Microsoft', 'CFQ7TTC0LH16 - M7', '28,00 US$', 'Comercial', 'Microsoft\r\n'),
(549, '10408887-eea2-eb11-b1ac-002248374ca4', '2022-03-16 13:01:00', 'Microsoft 365 Business Standard (8 Meses)', 'Microsoft', 'CFQ7TTC0LDPB - M8', '100,00 US$', 'Comercial', 'Microsoft\r\n'),
(550, 'c077008f-eea2-eb11-b1ac-002248374ca4', '2022-03-16 20:55:00', 'Exchange Online Plan 1 (8 Meses)', 'Microsoft', 'CFQ7TTC0LH16 - M8', '32,00 US$', 'Comercial', 'Microsoft\r\n'),
(551, '20ffe8a1-eea2-eb11-b1ac-002248374ca4', '2022-03-16 20:55:00', 'Exchange Online Plan 1 (9 Meses)', 'Microsoft', 'CFQ7TTC0LH16 - M9', '36,00 US$', 'Comercial', 'Microsoft\r\n'),
(552, '66ffe8a1-eea2-eb11-b1ac-002248374ca4', '2022-03-16 13:04:00', 'Microsoft 365 Business Standard (7 Meses)', 'Microsoft', 'CFQ7TTC0LDPB - M7', '87,50 US$', 'Comercial', 'Microsoft\r\n'),
(553, 'd88515b0-eea2-eb11-b1ac-002248374ca4', '2022-03-16 20:55:00', 'Exchange Online Plan 1 (10 Meses)', 'Microsoft', 'CFQ7TTC0LH16 - M10', '40,00 US$', 'Comercial', 'Microsoft\r\n'),
(554, '005f18c3-eea2-eb11-b1ac-002248374ca4', '2022-03-16 13:04:00', 'Microsoft 365 Business Standard (6 Meses)', 'Microsoft', 'CFQ7TTC0LDPB - M6', '75,00 US$', 'Comercial', 'Microsoft\r\n'),
(555, '555773c9-eea2-eb11-b1ac-002248374ca4', '2022-03-16 20:56:00', 'Exchange Online Plan 1 (11 Meses)', 'Microsoft', 'CFQ7TTC0LH16 - M11', '44,00 US$', 'Comercial', 'Microsoft\r\n'),
(556, '40eeb2f2-eea2-eb11-b1ac-002248374ca4', '2022-03-16 13:04:00', 'Microsoft 365 Business Standard (5 Meses)', 'Microsoft', 'CFQ7TTC0LDPB - M5', '62,50 US$', 'Comercial', 'Microsoft\r\n'),
(557, 'ab202a12-efa2-eb11-b1ac-002248374ca4', '2022-03-16 13:04:00', 'Microsoft 365 Business Standard (4 Meses)', 'Microsoft', 'CFQ7TTC0LDPB - M4', '50,00 US$', 'Comercial', 'Microsoft\r\n'),
(558, '1ac3a549-efa2-eb11-b1ac-002248374ca4', '2022-03-16 13:05:00', 'Microsoft 365 Business Standard (3 Meses)', 'Microsoft', 'CFQ7TTC0LDPB - M3', '37,50 US$', 'Comercial', 'Microsoft\r\n'),
(559, 'e25b6d6f-efa2-eb11-b1ac-002248374ca4', '2022-03-16 13:05:00', 'Microsoft 365 Business Standard (2 Meses)', 'Microsoft', 'CFQ7TTC0LDPB - M2', '25,00 US$', 'Comercial', 'Microsoft\r\n'),
(560, '8a7c7693-f0a2-eb11-b1ac-002248374ca4', '2022-03-16 13:24:00', 'Power BI Pro (11 Meses)', 'Microsoft', 'CFQ7TTC0LHSF - M11', '110,00 US$', 'Comercial', 'Microsoft\r\n'),
(561, 'e7b163bb-f0a2-eb11-b1ac-002248374ca4', '2022-03-16 21:03:00', 'Exchange Online Kiosk (2 Meses)', 'Microsoft', 'CFQ7TTC0LH0L - M2', '4,00 US$', 'Comercial', 'Microsoft\r\n'),
(562, 'dc2a9ac1-f0a2-eb11-b1ac-002248374ca4', '2022-03-16 13:25:00', 'Power BI Pro (10 Meses)', 'Microsoft', 'CFQ7TTC0LHSF - M10', '100,00 US$', 'Comercial', 'Microsoft\r\n'),
(563, '11390ad5-f0a2-eb11-b1ac-002248374ca4', '2022-03-16 21:04:00', 'Exchange Online Kiosk (3 Meses)', 'Microsoft', 'CFQ7TTC0LH0L - M3', '6,00 US$', 'Comercial', 'Microsoft\r\n'),
(564, 'fda736e1-f0a2-eb11-b1ac-002248374ca4', '2022-03-16 13:25:00', 'Power BI Pro (9 Meses)', 'Microsoft', 'CFQ7TTC0LHSF - M9', '90,00 US$', 'Comercial', 'Microsoft\r\n'),
(565, 'ea6131e7-f0a2-eb11-b1ac-002248374ca4', '2022-03-16 21:04:00', 'Exchange Online Kiosk (4 Meses)', 'Microsoft', 'CFQ7TTC0LH0L - M4', '8,00 US$', 'Comercial', 'Microsoft\r\n'),
(566, 'd01cb601-f1a2-eb11-b1ac-002248374ca4', '2022-03-16 13:25:00', 'Power BI Pro (8 Meses)', 'Microsoft', 'CFQ7TTC0LHSF - M8', '80,00 US$', 'Comercial', 'Microsoft\r\n'),
(567, '49ff771d-f1a2-eb11-b1ac-002248374ca4', '2022-03-16 13:26:00', 'Power BI Pro (7 Meses)', 'Microsoft', 'CFQ7TTC0LHSF - M7', '70,00 US$', 'Comercial', 'Microsoft\r\n'),
(568, '1b728646-f1a2-eb11-b1ac-002248374ca4', '2022-03-16 13:26:00', 'Power BI Pro (6 Meses)', 'Microsoft', 'CFQ7TTC0LHSF - M6', '60,00 US$', 'Comercial', 'Microsoft\r\n'),
(569, 'db2ef1a5-f1a2-eb11-b1ac-002248374ca4', '2022-03-16 21:04:00', 'Exchange Online Kiosk (5 Meses)', 'Microsoft', 'CFQ7TTC0LH0L - M5', '10,00 US$', 'Comercial', 'Microsoft\r\n'),
(570, '15d076c4-f1a2-eb11-b1ac-002248374ca4', '2022-03-16 13:26:00', 'Power BI Pro (5 Meses)', 'Microsoft', 'CFQ7TTC0LHSF - M5', '50,00 US$', 'Comercial', 'Microsoft\r\n'),
(571, '2eebb0d7-f1a2-eb11-b1ac-002248374ca4', '2022-03-16 21:04:00', 'Exchange Online Kiosk (6 Meses)', 'Microsoft', 'CFQ7TTC0LH0L - M6', '12,00 US$', 'Comercial', 'Microsoft\r\n'),
(572, '00a5abdd-f1a2-eb11-b1ac-002248374ca4', '2022-03-16 13:26:00', 'Power BI Pro (4 Meses)', 'Microsoft', 'CFQ7TTC0LHSF - M4', '40,00 US$', 'Comercial', 'Microsoft\r\n'),
(573, 'e0be05e4-f1a2-eb11-b1ac-002248374ca4', '2022-03-16 21:04:00', 'Exchange Online Kiosk (7 Meses)', 'Microsoft', 'CFQ7TTC0LH0L - M7', '14,00 US$', 'Comercial', 'Microsoft\r\n'),
(574, '62fd1ef0-f1a2-eb11-b1ac-002248374ca4', '2022-03-16 21:05:00', 'Exchange Online Kiosk (8 Meses)', 'Microsoft', 'CFQ7TTC0LH0L - M8', '16,00 US$', 'Comercial', 'Microsoft\r\n'),
(575, '26c30a02-f2a2-eb11-b1ac-002248374ca4', '2022-03-16 13:27:00', 'Power BI Pro (3 Meses)', 'Microsoft', 'CFQ7TTC0LHSF - M3', '30,00 US$', 'Comercial', 'Microsoft\r\n'),
(576, '4bc30a02-f2a2-eb11-b1ac-002248374ca4', '2022-03-16 21:05:00', 'Exchange Online Kiosk (9 Meses)', 'Microsoft', 'CFQ7TTC0LH0L - M9', '18,00 US$', 'Comercial', 'Microsoft\r\n'),
(577, '5f654014-f2a2-eb11-b1ac-002248374ca4', '2022-03-16 21:05:00', 'Exchange Online Kiosk (10 Meses)', 'Microsoft', 'CFQ7TTC0LH0L - M10', '20,00 US$', 'Comercial', 'Microsoft\r\n'),
(578, '6ab7bc1a-f2a2-eb11-b1ac-002248374ca4', '2022-03-16 13:27:00', 'Power BI Pro (2 Meses)', 'Microsoft', 'CFQ7TTC0LHSF - M2', '20,00 US$', 'Comercial', 'Microsoft\r\n'),
(579, '0d98be20-f2a2-eb11-b1ac-002248374ca4', '2022-03-16 21:05:00', 'Exchange Online Kiosk (11 Meses)', 'Microsoft', 'CFQ7TTC0LH0L - M11', '22,00 US$', 'Comercial', 'Microsoft\r\n'),
(580, '76ed60b0-f2a2-eb11-b1ac-002248374ca4', '2022-03-16 13:17:00', 'Microsoft 365 Apps for business (2 Meses)', 'Microsoft', 'CFQ7TTC0LH1G - M2', '16,50 US$', 'Comercial', 'Microsoft\r\n'),
(581, '658816d6-f2a2-eb11-b1ac-002248374ca4', '2022-03-16 13:17:00', 'Microsoft 365 Apps for business (3 Meses)', 'Microsoft', 'CFQ7TTC0LH1G - M3', '24,75 US$', 'Comercial', 'Microsoft\r\n'),
(582, 'ba3764e2-f2a2-eb11-b1ac-002248374ca4', '2022-03-16 13:18:00', 'Microsoft 365 Apps for business (4 Meses)', 'Microsoft', 'CFQ7TTC0LH1G - M4', '33,00 US$', 'Comercial', 'Microsoft\r\n'),
(583, 'ff88abf4-f2a2-eb11-b1ac-002248374ca4', '2022-03-16 13:18:00', 'Microsoft 365 Apps for business (5 Meses)', 'Microsoft', 'CFQ7TTC0LH1G - M5', '41,25 US$', 'Comercial', 'Microsoft\r\n'),
(584, '08703501-f3a2-eb11-b1ac-002248374ca4', '2022-03-16 13:18:00', 'Microsoft 365 Apps for business (6 Meses)', 'Microsoft', 'CFQ7TTC0LH1G - M6', '49,50 US$', 'Comercial', 'Microsoft\r\n'),
(585, '5a638c1a-f3a2-eb11-b1ac-002248374ca4', '2022-03-16 13:18:00', 'Microsoft 365 Apps for business (7 Meses)', 'Microsoft', 'CFQ7TTC0LH1G - M7', '57,75 US$', 'Comercial', 'Microsoft\r\n'),
(586, '849ac426-f3a2-eb11-b1ac-002248374ca4', '2022-03-16 13:18:00', 'Microsoft 365 Apps for business (8 Meses)', 'Microsoft', 'CFQ7TTC0LH1G - M8', '66,00 US$', 'Comercial', 'Microsoft\r\n'),
(587, 'e8b11d39-f3a2-eb11-b1ac-002248374ca4', '2022-03-16 13:20:00', 'Microsoft 365 Apps for business (9 Meses)', 'Microsoft', 'CFQ7TTC0LH1G - M9', '74,25 US$', 'Comercial', 'Microsoft\r\n'),
(588, 'd69ecc4b-f3a2-eb11-b1ac-002248374ca4', '2022-03-16 13:20:00', 'Microsoft 365 Apps for business (10 Meses)', 'Microsoft', 'CFQ7TTC0LH1G - M10', '82,50 US$', 'Comercial', 'Microsoft\r\n'),
(589, '58b0de57-f3a2-eb11-b1ac-002248374ca4', '2022-03-16 13:20:00', 'Microsoft 365 Apps for business (11 Meses)', 'Microsoft', 'CFQ7TTC0LH1G - M11', '90,75 US$', 'Comercial', 'Microsoft\r\n'),
(590, '4959c9bd-f3a2-eb11-b1ac-002248374ca4', '2022-11-23 19:33:00', 'Acrobat Pro DC for teams New - Nivel 1 (11 Meses)', 'Adobe', '65297938BA01A12-2M', '233,64 US$', 'Comercial', '\r\n'),
(591, '0a4e45dc-f3a2-eb11-b1ac-002248374ca4', '2022-11-23 19:34:00', 'Acrobat Pro DC for teams New - Nivel 1 (10 Meses)', 'Adobe', '65297938BA01A12-3M', '212,40 US$', 'Comercial', '\r\n'),
(592, 'd96f2dfb-f3a2-eb11-b1ac-002248374ca4', '2022-11-23 19:34:00', 'Acrobat Pro DC for teams New - Nivel 1 (9 Meses)', 'Adobe', '65297938BA01A12-4M', '191,16 US$', 'Comercial', '\r\n'),
(593, 'f045a113-f4a2-eb11-b1ac-002248374ca4', '2022-11-23 19:34:00', 'Acrobat Pro DC for teams New - Nivel 1 (8 Meses)', 'Adobe', '65297938BA01A12-5M', '169,92 US$', 'Comercial', '\r\n'),
(594, '2e4eaa19-f4a2-eb11-b1ac-002248374ca4', '2022-03-16 13:07:00', 'Microsoft 365 Business Basic (2 Meses)', 'Microsoft', 'CFQ7TTC0LH18 - M2', '12,00 US$', 'Comercial', 'Microsoft\r\n'),
(595, 'c48d0f2c-f4a2-eb11-b1ac-002248374ca4', '2022-03-16 13:07:00', 'Microsoft 365 Business Basic (3 Meses)', 'Microsoft', 'CFQ7TTC0LH18 - M3', '18,00 US$', 'Comercial', 'Microsoft\r\n'),
(596, 'ef8d0f2c-f4a2-eb11-b1ac-002248374ca4', '2022-11-23 19:34:00', 'Acrobat Pro DC for teams New - Nivel 1 (7 Meses)', 'Adobe', '65297938BA01A12-6M', '148,68 US$', 'Comercial', '\r\n'),
(597, '4bc70938-f4a2-eb11-b1ac-002248374ca4', '2022-03-16 13:07:00', 'Microsoft 365 Business Basic (4 Meses)', 'Microsoft', 'CFQ7TTC0LH18 - M4', '24,00 US$', 'Comercial', 'Microsoft\r\n'),
(598, '925f6344-f4a2-eb11-b1ac-002248374ca4', '2022-03-16 13:07:00', 'Microsoft 365 Business Basic (5 Meses)', 'Microsoft', 'CFQ7TTC0LH18 - M5', '30,00 US$', 'Comercial', 'Microsoft\r\n'),
(599, 'e1599750-f4a2-eb11-b1ac-002248374ca4', '2022-03-16 13:07:00', 'Microsoft 365 Business Basic (6 Meses)', 'Microsoft', 'CFQ7TTC0LH18 - M6', '36,00 US$', 'Comercial', 'Microsoft\r\n'),
(600, 'e7599750-f4a2-eb11-b1ac-002248374ca4', '2022-11-23 19:34:00', 'Acrobat Pro DC for teams New - Nivel 1 (6 Meses)', 'Adobe', '65297938BA01A12-7M', '127,44 US$', 'Comercial', '\r\n'),
(601, '78c4f55c-f4a2-eb11-b1ac-002248374ca4', '2022-03-16 13:08:00', 'Microsoft 365 Business Basic (7 Meses)', 'Microsoft', 'CFQ7TTC0LH18 - M7', '42,00 US$', 'Comercial', 'Microsoft\r\n'),
(602, 'e6067869-f4a2-eb11-b1ac-002248374ca4', '2022-03-16 13:08:00', 'Microsoft 365 Business Basic (8 Meses)', 'Microsoft', 'CFQ7TTC0LH18 - M8', '48,00 US$', 'Comercial', 'Microsoft\r\n'),
(603, '1a1d2f70-f4a2-eb11-b1ac-002248374ca4', '2022-11-23 19:35:00', 'Acrobat Pro DC for teams New - Nivel 1 (5 Meses)', 'Adobe', '65297938BA01A12-8M', '106,20 US$', 'Comercial', '\r\n'),
(604, '83f25b76-f4a2-eb11-b1ac-002248374ca4', '2022-03-16 13:08:00', 'Microsoft 365 Business Basic (9 Meses)', 'Microsoft', 'CFQ7TTC0LH18 - M9', '54,00 US$', 'Comercial', 'Microsoft\r\n'),
(605, '56ebf582-f4a2-eb11-b1ac-002248374ca4', '2022-03-16 13:08:00', 'Microsoft 365 Business Basic (10 Meses)', 'Microsoft', 'CFQ7TTC0LH18 - M10', '60,00 US$', 'Comercial', 'Microsoft\r\n'),
(606, '3a34608f-f4a2-eb11-b1ac-002248374ca4', '2022-03-16 13:09:00', 'Microsoft 365 Business Basic (11 Meses)', 'Microsoft', 'CFQ7TTC0LH18 - M11', '66,00 US$', 'Comercial', 'Microsoft\r\n'),
(607, '3c34608f-f4a2-eb11-b1ac-002248374ca4', '2022-11-23 19:35:00', 'Acrobat Pro DC for teams New - Nivel 1 (4 Meses)', 'Adobe', '65297938BA01A12-9M', '84,96 US$', 'Comercial', '\r\n'),
(608, 'cb81d6a2-f4a2-eb11-b1ac-002248374ca4', '2022-11-23 19:35:00', 'Acrobat Pro DC for teams New - Nivel 1 (3 Meses)', 'Adobe', '65297938BA01A12-10M', '63,72 US$', 'Comercial', '\r\n'),
(609, '1744bbc1-f4a2-eb11-b1ac-002248374ca4', '2022-11-23 19:36:00', 'Acrobat Pro DC for teams New - Nivel 1 (2 Meses)', 'Adobe', '65297938BA01A12-11M', '42,48 US$', 'Comercial', '\r\n'),
(610, '2825bed9-f4a2-eb11-b1ac-002248374ca4', '2022-03-16 13:12:00', 'Microsoft 365 Business Premium (2 Meses)', 'Microsoft', 'CFQ7TTC0LCHC - M2', '44,00 US$', 'Comercial', 'Microsoft\r\n'),
(611, '6161a685-f5a2-eb11-b1ac-002248374ca4', '2022-11-23 19:32:00', 'Acrobat Standard DC for teams New - Nivel 1 (11 Meses)', 'Adobe', '65297914BA01A12-2M', '203,83 US$', 'Comercial', '\r\n'),
(612, '862054a0-f5a2-eb11-b1ac-002248374ca4', '2022-11-23 19:32:00', 'Acrobat Standard DC for teams New - Nivel 1 (10 Meses)', 'Adobe', '65297914BA01A12-3M', '185,30 US$', 'Comercial', '\r\n'),
(613, 'e2fd0ec5-f5a2-eb11-b1ac-002248374ca4', '2022-11-23 19:32:00', 'Acrobat Standard DC for teams New - Nivel 1 (9 Meses)', 'Adobe', '65297914BA01A12-4M', '166,77 US$', 'Comercial', '\r\n'),
(614, '9bdfd1d8-f5a2-eb11-b1ac-002248374ca4', '2022-11-23 19:32:00', 'Acrobat Standard DC for teams New - Nivel 1 (8 Meses)', 'Adobe', '65297914BA01A12-5M', '148,24 US$', 'Comercial', '\r\n'),
(615, 'b6174df8-f5a2-eb11-b1ac-002248374ca4', '2022-03-16 13:12:00', 'Microsoft 365 Business Premium (3 Meses)', 'Microsoft', 'CFQ7TTC0LCHC - M3', '66,00 US$', 'Comercial', 'Microsoft\r\n'),
(616, '0e4977ff-f5a2-eb11-b1ac-002248374ca4', '2022-11-23 19:32:00', 'Acrobat Standard DC for teams New - Nivel 1 (7 Meses)', 'Adobe', '65297914BA01A12-6M', '129,71 US$', 'Comercial', '\r\n'),
(617, 'c45e912b-f6a2-eb11-b1ac-002248374ca4', '2022-11-23 19:32:00', 'Acrobat Standard DC for teams New - Nivel 1 (6 Meses)', 'Adobe', '65297914BA01A12-7M', '111,18 US$', 'Comercial', '\r\n'),
(618, '07484e53-f6a2-eb11-b1ac-002248374ca4', '2022-03-16 13:12:00', 'Microsoft 365 Business Premium (4 Meses)', 'Microsoft', 'CFQ7TTC0LCHC - M4', '88,00 US$', 'Comercial', 'Microsoft\r\n'),
(619, '2f484e53-f6a2-eb11-b1ac-002248374ca4', '2022-11-23 19:32:00', 'Acrobat Standard DC for teams New - Nivel 1 (5 Meses)', 'Adobe', '65297914BA01A12-8M', '92,65 US$', 'Comercial', '\r\n'),
(620, '271b0760-f6a2-eb11-b1ac-002248374ca4', '2022-03-16 13:12:00', 'Microsoft 365 Business Premium (5 Meses)', 'Microsoft', 'CFQ7TTC0LCHC - M5', '110,00 US$', 'Comercial', 'Microsoft\r\n'),
(621, 'af2a156e-f6a2-eb11-b1ac-002248374ca4', '2022-03-16 13:12:00', 'Microsoft 365 Business Premium (6 Meses)', 'Microsoft', 'CFQ7TTC0LCHC - M6', '132,00 US$', 'Comercial', 'Microsoft\r\n'),
(622, '8bca357a-f6a2-eb11-b1ac-002248374ca4', '2022-03-16 13:12:00', 'Microsoft 365 Business Premium (7 Meses)', 'Microsoft', 'CFQ7TTC0LCHC - M7', '154,00 US$', 'Comercial', 'Microsoft\r\n'),
(623, 'fad64a80-f6a2-eb11-b1ac-002248374ca4', '2022-11-23 19:32:00', 'Acrobat Standard DC for teams New - Nivel 1 (4 Meses)', 'Adobe', '65297914BA01A12-9M', '74,12 US$', 'Comercial', '\r\n'),
(624, '1c39708d-f6a2-eb11-b1ac-002248374ca4', '2022-03-16 13:13:00', 'Microsoft 365 Business Premium (8 Meses)', 'Microsoft', 'CFQ7TTC0LCHC - M8', '176,00 US$', 'Comercial', 'Microsoft\r\n'),
(625, '6bad6599-f6a2-eb11-b1ac-002248374ca4', '2022-03-16 13:13:00', 'Microsoft 365 Business Premium (9 Meses)', 'Microsoft', 'CFQ7TTC0LCHC - M9', '198,00 US$', 'Comercial', 'Microsoft\r\n'),
(626, '7551aa9f-f6a2-eb11-b1ac-002248374ca4', '2022-11-23 19:32:00', 'Acrobat Standard DC for teams New - Nivel 1 (3 Meses)', 'Adobe', '65297914BA01A12-10M', '55,59 US$', 'Comercial', '\r\n'),
(627, 'b252bfa5-f6a2-eb11-b1ac-002248374ca4', '2022-03-16 13:13:00', 'Microsoft 365 Business Premium (10 Meses)', 'Microsoft', 'CFQ7TTC0LCHC - M10', '220,00 US$', 'Comercial', 'Microsoft\r\n'),
(628, '5fe2efb7-f6a2-eb11-b1ac-002248374ca4', '2022-03-16 13:13:00', 'Microsoft 365 Business Premium (11 Meses)', 'Microsoft', 'CFQ7TTC0LCHC - M11', '242,00 US$', 'Comercial', 'Microsoft\r\n'),
(629, 'e10eb8be-f6a2-eb11-b1ac-002248374ca4', '2022-11-23 19:32:00', 'Acrobat Standard DC for teams New - Nivel 1 (2 Meses)', 'Adobe', '65297914BA01A12-11M', '37,06 US$', 'Comercial', '\r\n'),
(630, '414a4111-f8a2-eb11-b1ac-002248374ca4', '2021-04-21 23:21:00', 'Creative Cloud for teams All Apps New - Nivel 1 (11 Meses)', 'Adobe', '65297750BA01A12-2M', '1163,03 US$', 'Comercial', 'Adobe\r\n'),
(631, 'aaf1393d-f8a2-eb11-b1ac-002248374ca4', '2021-04-21 23:21:00', 'Creative Cloud for teams All Apps New - Nivel 1 (10 Meses)', 'Adobe', '65297750BA01A12-3M', '1057,30 US$', 'Comercial', 'Adobe\r\n'),
(632, 'bd65b551-f8a2-eb11-b1ac-002248374ca4', '2021-04-21 23:22:00', 'Creative Cloud for teams All Apps New - Nivel 1 (9 Meses)', 'Adobe', '65297750BA01A12-4M', '951,57 US$', 'Comercial', 'Adobe\r\n'),
(633, 'd8f7e46b-f8a2-eb11-b1ac-002248374ca4', '2021-04-21 23:22:00', 'Creative Cloud for teams All Apps New - Nivel 1 (8 Meses)', 'Adobe', '65297750BA01A12-5M', '845,84 US$', 'Comercial', 'Adobe\r\n'),
(634, '1d3c537f-f8a2-eb11-b1ac-002248374ca4', '2021-04-21 23:23:00', 'Creative Cloud for teams All Apps New - Nivel 1 (7 Meses)', 'Adobe', '65297750BA01A12-6M', '740,11 US$', 'Comercial', 'Adobe\r\n'),
(635, '24a2e5a1-f8a2-eb11-b1ac-002248374ca4', '2021-04-21 23:24:00', 'Creative Cloud for teams All Apps New - Nivel 1 (6 Meses)', 'Adobe', '65297750BA01A12-7M', '634,38 US$', 'Comercial', 'Adobe\r\n'),
(636, '023460ba-f8a2-eb11-b1ac-002248374ca4', '2021-04-21 23:25:00', 'Creative Cloud for teams All Apps New - Nivel 1 (5 Meses)', 'Adobe', '65297750BA01A12-8M', '528,65 US$', 'Comercial', 'Adobe\r\n'),
(637, '7c7bedd9-f8a2-eb11-b1ac-002248374ca4', '2021-04-21 23:26:00', 'Creative Cloud for teams All Apps New - Nivel 1 (4 Meses)', 'Adobe', '65297750BA01A12-9M', '422,92 US$', 'Comercial', 'Adobe\r\n'),
(638, '2b97e4f8-f8a2-eb11-b1ac-002248374ca4', '2021-04-21 23:27:00', 'Creative Cloud for teams All Apps New - Nivel 1 (3 Meses)', 'Adobe', '65297750BA01A12-10M', '317,19 US$', 'Comercial', 'Adobe\r\n'),
(639, '13a91e1f-f9a2-eb11-b1ac-002248374ca4', '2021-04-21 23:27:00', 'Creative Cloud for teams All Apps New - Nivel 1 (2 Meses)', 'Adobe', '65297750BA01A12-11M', '211,46 US$', 'Comercial', 'Adobe\r\n'),
(640, '155b6867-77a3-eb11-b1ac-002248374ca4', '2021-04-22 14:34:00', 'Acrobat Standard DC for Enterprise Renewal - Nivel 1', 'Adobe', '65271327BA01A12', '251,82 US$', 'Comercial', 'Adobe\r\n'),
(641, 'f549c0d2-7aa3-eb11-b1ac-002248374ca4', '2021-04-22 14:58:00', 'Kaspersky Endpoint Security for Business Select (20-49 Nodos)-Renewal- Trianual', 'Kaspersky', 'KL4863DA*TR-N2', '47,53 US$', 'Comercial', 'Kaspersky\r\n'),
(642, 'bfcd1e45-a9a3-eb11-b1ac-002248374ca4', '2021-09-01 14:13:00', 'Windows Server Standard 2019 - 2 Core (Incluye Software Assurance)', 'Microsoft', '9EM-00114', '1866,64 US$', 'Comercial', 'Microsoft\r\n'),
(643, 'dc514895-a9a3-eb11-b1ac-002248374ca4', '2021-09-01 14:54:00', 'Windows Server CAL Software Assurance', 'Microsoft', 'R18-00145', '26,74 US$', 'Comercial', 'Microsoft\r\n'),
(644, 'edf142c3-a9a3-eb11-b1ac-002248374ca4', '2021-09-01 15:18:00', 'SQL Server Enterprise Software Assurance', 'Microsoft', '7JQ-00255', '8800,47 US$', 'Comercial', 'Microsoft\r\n'),
(645, '96278fb7-b222-ec11-b6e6-0022483753e3', '2022-03-10 19:14:00', 'Windows 365 Business 1 vCPU, 2 GB, 64 GB (Anualidad con Pago Mensual)', 'Microsoft', 'a335767a-5c59-4064-a139-34105c2e6440 - M', '24,00 US$', 'Comercial', 'Microsoft\r\n'),
(646, 'fd00abf3-b222-ec11-b6e6-0022483753e3', '2021-10-01 12:28:00', 'Windows 365 Business 1 vCPU, 2 GB, 64 GB (Anual)', 'Microsoft', 'a335767a-5c59-4064-a139-34105c2e6440', '288,00 US$', 'Comercial', 'Microsoft\r\n'),
(647, '96817423-b322-ec11-b6e6-0022483753e3', '2022-03-10 19:14:00', 'Windows 365 Business 2 vCPU, 4 GB, 128 GB (Anualidad con Pago Mensual)', 'Microsoft', '7200e05a-fae4-46be-89c4-1cdd6433d4da - M', '35,00 US$', 'Comercial', 'Microsoft\r\n'),
(648, '1b5a6f41-b322-ec11-b6e6-0022483753e3', '2021-10-01 12:30:00', 'Windows 365 Business 2 vCPU, 4 GB, 128 GB (Anual)', 'Microsoft', '7200e05a-fae4-46be-89c4-1cdd6433d4da', '420,00 US$', 'Comercial', 'Microsoft\r\n'),
(649, '8ef9b06b-b322-ec11-b6e6-0022483753e3', '2021-10-01 12:34:00', 'Windows 365 Business 2 vCPU, 4 GB, 256 GB (Anual)', 'Microsoft', '7c6f44af-d284-4e49-9e09-20cf80bac1b4', '528,00 US$', 'Comercial', 'Microsoft\r\n'),
(650, '41c044f0-b322-ec11-b6e6-0022483753e3', '2022-03-10 19:14:00', 'Windows 365 Business 2 vCPU, 4 GB, 256 GB (Anualidad con Pago Mensual)', 'Microsoft', '7c6f44af-d284-4e49-9e09-20cf80bac1b4 - M', '44,00 US$', 'Comercial', 'Microsoft\r\n'),
(651, 'd7981f1a-b422-ec11-b6e6-0022483753e3', '2022-03-10 19:15:00', 'Windows 365 Business 2 vCPU, 4 GB, 64 GB (Anualidad con Pago Mensual)', 'Microsoft', '47f761d8-7484-4914-b070-4dda542fb484 - M', '32,00 US$', 'Comercial', 'Microsoft\r\n'),
(652, '5de2d1c7-b422-ec11-b6e6-0022483753e3', '2021-10-01 12:41:00', 'Windows 365 Business 2 vCPU, 4 GB, 64 GB (Anual)', 'Microsoft', '47f761d8-7484-4914-b070-4dda542fb484', '384,00 US$', 'Comercial', 'Microsoft\r\n'),
(653, 'c2cd7f0f-b522-ec11-b6e6-0022483753e3', '2022-03-10 19:15:00', 'Windows 365 Business 2 vCPU, 8 GB, 128 GB (Anualidad con Pago Mensual)', 'Microsoft', '224504a6-510a-4a73-9da2-4a8a19af8dcf - M', '45,00 US$', 'Comercial', 'Microsoft\r\n'),
(654, 'a57feca4-b522-ec11-b6e6-0022483753e3', '2021-10-01 12:48:00', 'Windows 365 Business 2 vCPU, 8 GB, 128 GB (Anual)', 'Microsoft', '224504a6-510a-4a73-9da2-4a8a19af8dcf', '540,00 US$', 'Comercial', 'Microsoft\r\n'),
(655, 'b7d1c6da-b522-ec11-b6e6-0022483753e3', '2022-03-10 19:15:00', 'Windows 365 Business 2 vCPU, 8 GB, 256 GB (Anualidad con Pago Mensual)', 'Microsoft', 'c3b683e7-db11-418f-b3c9-d184e14fd8ad - M', '54,00 US$', 'Comercial', 'Microsoft\r\n'),
(656, '3f36b8f8-b522-ec11-b6e6-0022483753e3', '2021-10-01 12:50:00', 'Windows 365 Business 2 vCPU, 8 GB, 256 GB (Anual)', 'Microsoft', 'c3b683e7-db11-418f-b3c9-d184e14fd8ad', '648,00 US$', 'Comercial', 'Microsoft\r\n'),
(657, '727f763a-b622-ec11-b6e6-0022483753e3', '2022-03-10 19:15:00', 'Windows 365 Business 4 vCPU, 16 GB, 128 GB (Anualidad con Pago Mensual)', 'Microsoft', '1ca54fff-7cf8-4658-9b10-19421113ce8f - M', '70,00 US$', 'Comercial', 'Microsoft\r\n'),
(658, '270c5a6b-b722-ec11-b6e6-0022483753e3', '2021-10-01 13:00:00', 'Windows 365 Business 4 vCPU, 16 GB, 128 GB (Anual)', 'Microsoft', '1ca54fff-7cf8-4658-9b10-19421113ce8f', '840,00 US$', 'Comercial', 'Microsoft\r\n'),
(659, '78c7429b-b722-ec11-b6e6-0022483753e3', '2022-03-10 19:15:00', 'Windows 365 Business 4 vCPU, 16 GB, 256 GB (Anualidad con Pago Mensual)', 'Microsoft', '0fa97e63-5e70-489d-bead-9c4a91d8698f - M', '79,00 US$', 'Comercial', 'Microsoft\r\n'),
(660, 'd3a5ffee-b722-ec11-b6e6-0022483753e3', '2021-10-01 13:03:00', 'Windows 365 Business 4 vCPU, 16 GB, 256 GB (Anual)', 'Microsoft', '0fa97e63-5e70-489d-bead-9c4a91d8698f', '948,00 US$', 'Comercial', 'Microsoft\r\n'),
(661, '3d61d01e-b822-ec11-b6e6-0022483753e3', '2022-03-10 19:15:00', 'Windows 365 Business 4 vCPU, 16 GB, 512 GB (Anualidad con Pago Mensual)', 'Microsoft', '9c8e50fe-2745-47d9-be7b-040213d0f9eb - M', '105,00 US$', 'Comercial', 'Microsoft\r\n'),
(662, 'bbbf8466-b822-ec11-b6e6-0022483753e3', '2021-10-01 13:07:00', 'Windows 365 Business 4 vCPU, 16 GB, 512 GB (Anual)', 'Microsoft', '9c8e50fe-2745-47d9-be7b-040213d0f9eb', '1260,00 US$', 'Comercial', 'Microsoft\r\n'),
(663, '04034ba2-b822-ec11-b6e6-0022483753e3', '2022-03-10 19:15:00', 'Windows 365 Business 8 vCPU, 32 GB, 128 GB (Anualidad con Pago Mensual)', 'Microsoft', 'ea5adb10-37b1-49af-b757-9ce5d996e79e - M', '127,00 US$', 'Comercial', 'Microsoft\r\n'),
(664, '19602fcc-b822-ec11-b6e6-0022483753e3', '2021-10-01 13:10:00', 'Windows 365 Business 8 vCPU, 32 GB, 128 GB (Anual)', 'Microsoft', 'ea5adb10-37b1-49af-b757-9ce5d996e79e', '1524,00 US$', 'Comercial', 'Microsoft\r\n'),
(665, '24f53d4a-3fb7-eb11-8236-00224837556e', '2021-05-17 18:42:00', 'FortiAnalyzer-1000E 1 Year 24x7 FortiCare Contract', 'Otro', 'FC-10-L1005-247-02-12', '4250,00 US$', 'Comercial', 'Fortinet\r\n'),
(666, 'b8a27cb7-3fb7-eb11-8236-00224837556e', '2021-05-17 18:46:00', 'FortiGate-2000E 1 Year (UTP) (IPS, AMP, Application Control, Web & Video Filtering, Antispam Service, and 24x7 FortiCare)', 'Otro', 'FC-10-002KE-950-02-12', '27.625,00 US$', 'Comercial', 'Fortinet\r\n'),
(667, '178c7255-40b7-eb11-8236-00224837556e', '2021-05-17 18:49:00', 'FortiGate-2000E 3 Year (UTP) (IPS, AMP, Application Control, Web & Video Filtering, Antispam Service, and 24x7 FortiCare)', 'Otro', 'FC-10-002KE-950-02-36', '82.875,00 US$', 'Comercial', 'Fortinet\r\n'),
(668, '71310c47-5fb7-eb11-8236-00224837556e', '2021-05-17 22:33:00', 'Kaspersky Endpoint Security Cloud Plus Ampliacion (150-249 Nodos) Bianual', 'Kaspersky', 'KL4743DASDS*DS-N7', '38,86 US$', 'Comercial', 'Kaspersky\r\n'),
(669, '9ef83ced-b8b8-eb11-8236-00224837556e', '2021-05-19 15:43:00', 'WinPro 10 Legalization GetGenuine-202105191543257847', 'Microsoft', 'FQC-09478-202105191543257847', '208,26 US$', 'Comercial', '\r\n'),
(670, '4abe1a3f-c1b8-eb11-8236-00224837556e', '2021-05-19 16:42:00', 'Windows Server Standard 2019 - 2 Core-202105191642523510', 'Microsoft', '9EM-00653-202105191642523510', '149,77 US$', 'Comercial', '\r\n'),
(671, 'f7253a71-c1b8-eb11-8236-00224837556e', '2021-05-19 16:47:00', 'Windows 10 Profesional OEM', 'Microsoft', 'FQC-08981', '171,25 US$', 'Comercial', 'Microsoft\r\n'),
(672, 'c97f9b34-c2b8-eb11-8236-00224837556e', '2021-05-19 16:51:00', 'Microsoft 365 Apps for Students (Anual)', 'Microsoft', '5699c6f3-cc7a-4212-9042-8f85ce30f4e0', '21,00 US$', 'Comercial', 'Microsoft - Educaci?n\r\n'),
(673, '2daf2ee0-c2b8-eb11-8236-00224837556e', '2021-05-19 16:55:00', 'Microsoft 365 Apps for Students (7 Meses)', 'Microsoft', '5699c6f3-cc7a-4212-9042-8f85ce30f4e0-5', '12,25 US$', 'Comercial', 'Microsoft - Educaci?n\r\n'),
(674, 'a0cf232a-9709-ec11-b6e6-002248376075', '2022-03-17 02:04:00', 'Power Automate per user plan (Mensual)', 'Microsoft', 'CFQ7TTC0LH3L - M', '16,88 US$', 'Comercial', 'Microsoft\r\n'),
(675, 'dc5f4805-950a-ec11-b6e6-002248376075', '2021-08-31 19:53:00', 'WINENTLTSC 2019 SNGL Upgrd OLP NL', 'Microsoft', 'KW4-00190', '363,22 US$', 'Comercial', 'Microsoft\r\n'),
(676, '33ee996a-f20c-ec11-b6e6-002248376075', '2021-09-03 20:08:00', 'Illustrator for Teams Renewal - Nivel 1 (Anual)', 'Adobe', '65297602BA01A12', '521,00 US$', 'Comercial', 'Adobe\r\n'),
(677, '54d069d0-f20c-ec11-b6e6-002248376075', '2021-09-03 20:10:00', 'Photoshop for Teams New - Nivel 2 (Anual)-Edu', 'Adobe', '65272496BB02A12', '198,00 US$', 'Educaci?n', 'Adobe\r\n'),
(678, '72b65e1e-16c2-eb11-bacc-002248377abf', '2021-05-31 13:45:00', 'Endpoint Security Enterprise, Hybrid Subscription License with Support, 1-99', 'Otro', 'SES-SUB-1-99', '20,00 US$', 'Comercial', 'Symantec\r\n'),
(679, '495b68bb-1fc2-eb11-bacc-002248377abf', '2021-05-31 15:32:00', 'Red Hat Enterprise Linux Server, Standard (Physical or Virtual Nodes)', 'Red Hat', 'RH00004F3-A', '798,89 US$', 'Comercial', 'Red Hat\r\n'),
(680, '28674681-62c5-eb11-bacc-002248377abf', '2021-06-04 18:32:00', 'Kaspersky Endpoint Security Cloud Plus (250 Nodos)', 'Kaspersky', 'KL4743DA*FS-N8', '19,00 US$', 'Comercial', 'Kaspersky\r\n'),
(681, '082520dd-5d37-ec11-8c64-0022483785ad', '2023-04-12 19:08:00', 'Microsoft Teams Rooms Pro (Anual)', 'Microsoft', 'CFQ7TTC0QW7C - A', '480,00 US$', 'Comercial', 'Microsoft\r\n'),
(682, '8be3ccbf-eaca-eb11-bacc-002248379702', '2021-06-11 19:27:00', 'Endpoint Security Enterprise, Hybrid Subscription License with Support, 500+ Device 1 Year', 'Otro', 'SES-SUB-500-PLUS', '18,25 US$', 'Comercial', 'Symantec\r\n'),
(683, '3d738132-ebca-eb11-bacc-002248379702', '2021-06-11 19:29:00', 'Endpoint Protection, Subscription License with Support, 500+ Devices 1 Year', 'Otro', 'SEP-SUB-500-PLUS', '16,80 US$', 'Comercial', 'Symantec\r\n'),
(684, '20d0c7d2-34ca-eb11-bacc-002248379d96', '2022-03-10 19:14:00', 'Microsoft 365 Business Voice (Anualidad con Pago Mensual)', 'Microsoft', 'cc69a07c-8c51-457f-bb2a-f21a62d6bede-M', '12,00 US$', 'Comercial', 'Microsoft\r\n'),
(685, '44e9efde-34ca-eb11-bacc-002248379d96', '2021-06-10 21:44:00', 'Microsoft 365 Business Voice (Anual)', 'Microsoft', 'cc69a07c-8c51-457f-bb2a-f21a62d6bede', '144,00 US$', 'Comercial', 'Microsoft\r\n'),
(686, 'e239d0b9-012b-ec11-b6e6-00224837ab03', '2021-10-12 02:12:00', 'Mensualidades', 'Otro', 'M-LASTCALL', '1,00 US$', 'Comercial', 'Otros\r\n'),
(687, '543ea74e-e23c-ec11-8c62-00224837c61d', '2021-11-03 20:14:00', 'SQL Server Enterprise + Software Assurance', 'Microsoft', '7JQ-00253', '26.565,57 US$', 'Comercial', 'Microsoft\r\n'),
(688, '3b543825-29d6-ec11-a7b5-00224837d2c6', '2022-05-17 21:35:00', 'Visio Plan 2 (Mensual)', 'Microsoft', 'CFQ7TTC0HD32 - M', '18,00 US$', 'Comercial', 'Microsoft\r\n'),
(689, '9f156ea7-4442-ec11-8c62-002248382375', '2021-11-10 16:38:00', 'Kaspersky Endpoint Security Cloud Plus (50-99 Nodos) - Base Plus-202111101638469456', 'Kaspersky', 'KL4743DA*F8-N5-202111101638469456', '33,80 US$', 'Comercial', '\r\n'),
(690, 'd3d76fbd-6aa5-ec11-9840-002248384087', '2022-03-16 20:51:00', 'Power BI Pro (Mensual)', 'Microsoft', 'CFQ7TTC0LHSF - M', '12,00 US$', 'Comercial', 'Microsoft\r\n'),
(691, '44248fdc-6ba5-ec11-9840-002248384087', '2022-03-16 21:01:00', 'Exchange Online Plan 2 (Mensual)', 'Microsoft', 'CFQ7TTC0LH1P - M', '9,60 US$', 'Comercial', 'Microsoft\r\n'),
(692, 'd85c62db-6ca5-ec11-9840-002248384087', '2022-03-16 21:07:00', 'Exchange Online Kiosk (Mensual)', 'Microsoft', 'CFQ7TTC0LH0L - M', '2,40 US$', 'Comercial', 'Microsoft\r\n'),
(693, '3eff8c5a-6da5-ec11-9840-002248384087', '2022-03-16 21:10:00', 'Project Plan 1 (Mensual)', 'Microsoft', 'CFQ7TTC0HDB1 - M', '12,00 US$', 'Comercial', 'Microsoft\r\n'),
(694, '18ee659b-6da5-ec11-9840-002248384087', '2022-03-16 21:12:00', 'Project Plan 3 (Mensual)', 'Microsoft', 'CFQ7TTC0HDB0 - M', '36,00 US$', 'Comercial', 'Microsoft\r\n'),
(695, 'fd2e423a-6ea5-ec11-9840-002248384087', '2022-03-16 21:16:00', 'Project Plan 5 (Mensual)', 'Microsoft', 'CFQ7TTC0HD9Z - M', '66,00 US$', 'Comercial', 'Microsoft\r\n'),
(696, '9e8fb60d-8ca5-ec11-9840-002248384087', '2022-03-17 00:50:00', 'Windows 10/11 Enterprise E3 (Mensual)', 'Microsoft', 'CFQ7TTC0LGTX - M', '8,40 US$', 'Comercial', 'Microsoft\r\n'),
(697, 'e6ad9b6a-8da5-ec11-9840-002248384087', '2022-03-17 01:00:00', 'Windows 10/11 Enterprise E3 VDA (Mensual)', 'Microsoft', 'CFQ7TTC0LGTX - M - VDA', '15,84 US$', 'Comercial', 'Microsoft\r\n'),
(698, 'd754f87a-8ea5-ec11-9840-002248384087', '2022-03-17 01:07:00', 'Windows 10/11 Enterprise E5 (Mensual)', 'Microsoft', 'CFQ7TTC0LFNW - M', '13,53 US$', 'Comercial', 'Microsoft\r\n'),
(699, '6da490ca-92a5-ec11-9840-002248384087', '2022-03-17 01:38:00', 'SharePoint Online Plan 1 (Mensual)', 'Microsoft', 'CFQ7TTC0LH0N - M', '6,00 US$', 'Comercial', 'Microsoft\r\n'),
(700, '06a14a6a-93a5-ec11-9840-002248384087', '2022-03-17 01:42:00', 'SharePoint Online Plan 2 (Mensual)', 'Microsoft', 'CFQ7TTC0LH14 - M', '12,00 US$', 'Comercial', 'Microsoft\r\n'),
(701, '2352f5fb-93a5-ec11-9840-002248384087', '2022-03-17 01:47:00', 'OneDrive for Business Plan 1 (Mensual)', 'Microsoft', 'CFQ7TTC0LHSV - M', '6,00 US$', 'Comercial', 'Microsoft\r\n'),
(702, 'b1fb945e-94a5-ec11-9840-002248384087', '2022-03-17 01:49:00', 'OneDrive for Business Plan 2 (Mensual)', 'Microsoft', 'CFQ7TTC0LH1M - M', '12,00 US$', 'Comercial', 'Microsoft\r\n'),
(703, '936d7053-95a5-ec11-9840-002248384087', '2022-03-17 01:56:00', 'Power Apps per user plan (Mensual)', 'Microsoft', 'CFQ7TTC0LH2H - M', '22,50 US$', 'Comercial', 'Microsoft\r\n'),
(704, '3c47cd2a-97a5-ec11-9840-002248384087', '2022-03-17 02:10:00', 'Power BI Premium - Por usuario (Mensual)', 'Microsoft', 'CFQ7TTC0HL8W - M', '24,00 US$', 'Comercial', 'Microsoft\r\n'),
(705, 'f7d83735-99a5-ec11-9840-002248384087', '2022-03-17 02:24:00', 'Microsoft Intune (Mensual)', 'Microsoft', 'CFQ7TTC0LCH4 - M', '9,60 US$', 'Comercial', 'Microsoft\r\n'),
(706, '806a3e03-9aa5-ec11-9840-002248384087', '2022-03-17 02:30:00', 'Enterprise Mobility + Security E3 (Mensual)', 'Microsoft', 'CFQ7TTC0LHT4 - M', '12,73 US$', 'Comercial', 'Microsoft\r\n'),
(707, '87f51d8a-9aa5-ec11-9840-002248384087', '2022-03-17 02:33:00', 'Enterprise Mobility + Security E5 (Mensual)', 'Microsoft', 'CFQ7TTC0LFJ1 - M', '19,68 US$', 'Comercial', 'Microsoft\r\n'),
(708, '7c9321e0-87ab-ec11-9840-002248d2e80c', '2022-03-24 15:36:00', 'Dynamics 365 Sales Professional (Mensual)', 'Microsoft', 'CFQ7TTC0LFN5-M', '58,50 US$', 'Comercial', 'Microsoft\r\n'),
(709, '6736637e-88ab-ec11-9840-002248d2e80c', '2022-03-24 15:40:00', 'Dynamics 365 Team Member (Anualidad con Pago Mensual)', 'Microsoft', 'CFQ7TTC0LFNJ-A/M', '8,00 US$', 'Comercial', 'Microsoft\r\n'),
(710, '9272a9a9-88ab-ec11-9840-002248d2e80c', '2022-03-24 15:40:00', 'Dynamics 365 Team Member (Pago Mensual)', 'Microsoft', 'CFQ7TTC0LFNJ-M', '9,60 US$', 'Comercial', 'Microsoft\r\n'),
(711, 'be817682-57ac-ec11-9840-002248d2e80c', '2022-03-25 16:22:00', 'Central Intercept X Advanced - 200-499 USERS - 24 MOS', 'Otro', 'CIXI2CSAA', '49,87 US$', 'Comercial', 'Sophos\r\n'),
(712, '1e5dc5d8-57ac-ec11-9840-002248d2e80c', '2022-03-25 16:23:00', 'Central Intercept X Advanced with XDR - 200-499 USERS - 24 MOS', 'Otro', 'CAEI2CSAA', '85,87 US$', 'Comercial', 'Sophos\r\n'),
(713, 'a2c73e2e-58ac-ec11-9840-002248d2e80c', '2022-03-25 16:25:00', 'Central Intercept X Advanced for Server with XDR - 25-49 SERVERS - 24 MOS', 'Otro', 'CSIF2CSAA', '150,72 US$', 'Comercial', 'Sophos\r\n'),
(714, 'dd759433-cfc4-ec11-a7b5-002248d30e83', '2022-12-07 18:06:00', 'Common Data Service File Capacity (Mensual)', 'Microsoft', 'CFQ7TTC0LHQ3 - M', '2,40 US$', 'Comercial', 'Microsoft\r\n'),
(715, '2c99a83b-f6b0-ec11-9840-002248d31eec', '2023-01-30 17:53:00', 'Habilitaci?n M365 - Migraci?n desde Google (Unidades Compartidas) (1 Carpeta)', 'Last Call', 'L050', '22,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(716, '2d726fed-f7b0-ec11-9840-002248d31eec', '2022-11-07 13:49:00', 'Soporte Advanced (1-50 usuarios)', 'Last Call', 'L044', '130,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(717, '24a39b18-f9b0-ec11-9840-002248d31eec', '2022-11-07 13:50:00', 'Soporte Advanced (51-150 usuarios)', 'Last Call', 'L045', '300,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(718, 'aeb9b7b2-fab0-ec11-9840-002248d31eec', '2022-11-07 13:49:00', 'Soporte Advanced (151-300 usuarios)', 'Last Call', 'L046', '550,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(719, 'd88417dc-fab0-ec11-9840-002248d31eec', '2022-11-07 13:50:00', 'Soporte Advanced (301-500 usuarios)', 'Last Call', 'L047', '900,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(720, '50a78063-feb0-ec11-9840-002248d31eec', '2022-09-27 15:48:00', 'Soporte BBDD SQL', 'Last Call', 'L048', '886,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(721, '352b2bd2-feb0-ec11-9840-002248d31eec', '2022-09-27 15:48:00', 'Soporte Aplicaci?n (Chile y Argentina)', 'Last Call', 'L049', '709,00 US$', 'Comercial', 'Servicios Last Call\r\n'),
(722, '2de2edc1-a7a0-ec11-b400-002248de7abe', '2022-03-16 13:06:00', 'Microsoft 365 Business Standard (Mensual)', 'Microsoft', 'CFQ7TTC0LDPB - M', '15,00 US$', 'Comercial', 'Microsoft\r\n'),
(723, 'ab91792b-a8a0-ec11-b400-002248de7abe', '2022-03-16 13:10:00', 'Microsoft 365 Business Basic (Mensual)', 'Microsoft', 'CFQ7TTC0LH18 - M', '7,20 US$', 'Comercial', 'Microsoft\r\n'),
(724, '9306b9c2-aaa0-ec11-b400-002248de7abe', '2022-03-16 13:14:00', 'Microsoft 365 Business Premium (Mensual)', 'Microsoft', 'CFQ7TTC0LCHC - M', '26,40 US$', 'Comercial', 'Microsoft\r\n'),
(725, '0e4c48c4-b3a0-ec11-b400-002248de7abe', '2022-03-16 13:22:00', 'Office 365 E1 (Mensual)', 'Microsoft', 'CFQ7TTC0LF8Q - M', '12,00 US$', 'Comercial', 'Microsoft\r\n'),
(726, '04c8d088-b4a0-ec11-b400-002248de7abe', '2022-03-16 13:23:00', 'Office 365 E3 (Mensual)', 'Microsoft', 'CFQ7TTC0LF8R - M', '27,60 US$', 'Comercial', 'Microsoft\r\n'),
(727, '249032a6-b5a0-ec11-b400-002248de7abe', '2022-03-16 20:56:00', 'Exchange Online Plan 1 (Mensual)', 'Microsoft', 'CFQ7TTC0LH16 - M', '4,80 US$', 'Comercial', 'Microsoft\r\n'),
(728, 'add15dcc-78a1-ec11-b400-002248de7abe', '2022-03-16 13:21:00', 'Microsoft 365 Apps for business (Mensual)', 'Microsoft', 'CFQ7TTC0LH1G - M', '9,96 US$', 'Comercial', 'Microsoft\r\n'),
(729, 'f789b5b8-79a1-ec11-b400-002248de7abe', '2022-03-16 13:21:00', 'Microsoft 365 Apps for enterprise (Mensual)', 'Microsoft', 'CFQ7TTC0LGZT - M', '14,40 US$', 'Comercial', 'Microsoft\r\n'),
(733, 'asasas', '2023-07-06 12:19:10', 'asasasasas', 'Microsoft', 'sasasasa', '12121 US$', 'Empresa', 'sass12'),
(734, 'CHAMAS', '2023-07-06 18:21:35', 'HOLA', 'Microsoft', 'ESPERA QUE', '150 US$', 'Empresa', '175');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `api`
--

CREATE TABLE `api` (
  `idapi` int(11) NOT NULL,
  `api` varchar(255) DEFAULT NULL,
  `fecha_actualizada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `api`
--

INSERT INTO `api` (`idapi`, `api`, `fecha_actualizada`) VALUES
(1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImFsdC54ay0zb3FjdW9hbUB5b3BtYWlsLmNvbSJ9.KKpvjSbWiLBE-xTNpcocsPYAccjpOyHECsp1NkVfPqc', '2023-06-08 21:56:55');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `idcliente` int(11) NOT NULL,
  `dni` int(8) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `telefono` int(15) NOT NULL,
  `direccion` varchar(200) NOT NULL,
  `usuario_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`idcliente`, `dni`, `nombre`, `telefono`, `direccion`, `usuario_id`) VALUES
(1, 123545, 'Pubico en general', 925491523, 'Lima', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `collections`
--

CREATE TABLE `collections` (
  `idCollections` int(11) NOT NULL,
  `NumeroFactura` varchar(50) DEFAULT NULL,
  `fechaEmision` date DEFAULT NULL,
  `fechaVencimiento` date DEFAULT NULL,
  `monto` decimal(10,2) DEFAULT NULL,
  `moneda` varchar(10) DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  `documento` varchar(100) DEFAULT NULL,
  `observaciones` varchar(200) DEFAULT NULL,
  `recurrente` varchar(200) DEFAULT NULL,
  `CODidcustomer` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `collections`
--

INSERT INTO `collections` (`idCollections`, `NumeroFactura`, `fechaEmision`, `fechaVencimiento`, `monto`, `moneda`, `estado`, `documento`, `observaciones`, `recurrente`, `CODidcustomer`) VALUES
(84, 'XXX1-DXX-CCXZ-CXZ', '2023-09-15', '2024-09-15', 15000.00, 'Soles', 'NC', 'cobit.pdf', 'Ninguna', 'Aveces', 81);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracion`
--

CREATE TABLE `configuracion` (
  `id` int(11) NOT NULL,
  `dni` bigint(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `razon_social` varchar(100) NOT NULL,
  `telefono` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `direccion` text NOT NULL,
  `igv` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `configuracion`
--

INSERT INTO `configuracion` (`id`, `dni`, `nombre`, `razon_social`, `telefono`, `email`, `direccion`, `igv`) VALUES
(1, 20601622921, 'Christian', 'Virtual Business S.A.C', 925491523, 'bpineda@virtualbusiness.pe', 'Lima - Perú', 1.18);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contacts`
--

CREATE TABLE `contacts` (
  `idContacts` int(11) NOT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `segundo_nombre` varchar(255) DEFAULT NULL,
  `apellido_paterno` varchar(255) DEFAULT NULL,
  `apellido_materno` varchar(255) DEFAULT NULL,
  `Nivel de interés` varchar(255) DEFAULT NULL,
  `observaciones` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `telefono_fijo` varchar(20) DEFAULT NULL,
  `celular` varchar(20) DEFAULT NULL,
  `COD_idusuario` int(11) NOT NULL,
  `AddedContacts` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `contacts`
--

INSERT INTO `contacts` (`idContacts`, `nombre`, `segundo_nombre`, `apellido_paterno`, `apellido_materno`, `Nivel de interés`, `observaciones`, `email`, `telefono_fijo`, `celular`, `COD_idusuario`, `AddedContacts`) VALUES
(23, 'Paco', 'Alonso', 'Royer', 'Romin', 'Medio', 'Buen cliente', 'luisaslonso@gmail.com', '012871674', '985421620', 23, '2023-07-27 16:13:35'),
(24, 'María', 'Isabel', 'González', 'López', 'Alto', 'Cliente potencial', 'mariagonzalez@gmail.com', '021348769', '998765432', 23, '2023-07-27 16:13:35'),
(25, 'Pedro', 'José', 'Sánchez', 'Pérez', 'Bajo', 'No interesado', 'pedrosanchez@gmail.com', '032587410', '987654321', 23, '2023-07-27 16:13:35'),
(26, 'Ana', 'María', 'Ramírez', 'Gómez', 'Alto', 'Potencial cliente', 'anaramirez@gmail.com', '035478962', '955667788', 23, '2023-07-27 16:13:35'),
(27, 'Javier', 'Andrés', 'Martínez', 'López', 'Medio', 'Interesado', 'javiermartinez@gmail.com', '038971245', '912345678', 23, '2023-07-27 16:13:35'),
(28, 'Carla', 'Fernanda', 'Hernández', 'García', 'Bajo', 'Sin interés', 'carlahernandez@gmail.com', '040589632', '978542136', 23, '2023-07-27 16:13:35'),
(29, 'Daniel', 'Alejandro', 'Gutiérrez', 'Flores', 'Medio', 'Cliente frecuente', 'danielgutierrez@gmail.com', '041287509', '925874136', 23, '2023-07-27 16:13:35'),
(30, 'Sofía', 'Camila', 'Díaz', 'Pérez', 'Alto', 'Buena relación', 'sofiadiaz@gmail.com', '045874962', '990198879', 23, '2023-07-27 16:13:35'),
(31, 'Diego', 'Andrés', 'Rodríguez', 'Soto', 'Bajo', 'No cliente potencial', 'diegorodriguez@gmail.com', '050123987', '999333222', 23, '2023-07-27 16:13:35'),
(32, 'Laura', 'Fernanda', 'Acosta', 'Torres', 'Medio', 'Posible cliente', 'lauraacosta@gmail.com', '057896321', '933648726', 23, '2023-07-27 16:13:35'),
(33, 'CHRISTIAN', 'RAUL', 'OCHOA', 'GUILLEN', 'Medio', 'REFERIDO de alguien', 'christian.ochoa@virtualbusiness.pe', '', '983854485', 23, '2023-07-27 16:13:35'),
(35, 'Bruno', 'Alonso', 'Pineda', 'Flores', 'Bajo', 'el creador', 'bruno123@gmail.com', '01454545454', '987787510', 23, '2023-07-27 16:13:35'),
(36, 'Mia', 'Marccela', 'Arecco', 'Quispe', 'Bajo', 'ejem', 'fsdfdsfsdf@gmail.com', '989160763', '989160763', 23, '2023-07-27 16:13:35'),
(37, 'Julio ', '', 'Figueroa', 'Camacho', 'Medio', '', 'julio.figueroa@mollehuaca.com', '', '995726006', 1, '2023-07-31 17:06:47'),
(38, 'Omar', '', 'Hernandez', '', 'Alto', '', 'omar.hernandez@boostersolutions.com', '', '989719028', 24, '2023-07-31 17:40:36'),
(39, 'Joel', '', 'Alvaro', '', 'Medio', '', 'Joel.Alvaro@incaone.com', '', '932555818', 24, '2023-07-31 17:42:53'),
(40, 'Clarivel ', '', 'Vasquez', 'Rodriguez', 'Medio', '', 'arquitectura@GRUPOCOMPOSTELA.PE', '', '994228970', 24, '2023-07-31 17:52:42'),
(41, 'Aniano', '', 'Miranda', '', 'Medio', '', 'aniano.miranda@ingenieriadigital.com.pe', '', '999915565', 24, '2023-07-31 17:54:56'),
(42, 'Bruno', '', 'Pineda', '', 'Bajo', 'xxx', '', '', '', 1, '2023-07-31 19:08:36'),
(43, 'Santiago', '', 'Plaza', 'Battisitini', 'Medio', '', 'splaza@nextplacement.net', '', '993653781', 24, '2023-08-07 23:51:29'),
(44, 'Michelle', 'Alexandra', 'Llontop', 'Cardoza ', 'Bajo', '', 'mllontop@virtualbusiness.pe', '923071755', '923071755', 24, '2023-08-14 21:01:14'),
(45, 'Erika ', '', 'Zevallos', '', 'Alto', '', 'ezevallos@renzocosta.com', '', '945125171', 24, '2023-09-01 15:07:49'),
(46, 'Rebeca', 'Maria', 'Waltron', 'Ramirez', 'Bajo', 'Ninguna', 'obras@batalladejunin.com', '', '985007968', 26, '2023-09-15 16:56:29'),
(48, 'Marco ', '', 'Maylle', '', 'Medio', 'Azure', 'marco.maylle@incaone.com', '', '986056669', 24, '2023-09-18 14:17:05'),
(49, 'Victor', '', 'Villavicencio', '', 'Alto', '', 'vvillavicencioz@uladech.edu.pe', '', '943612388', 24, '2023-09-18 15:34:30'),
(50, 'Juan Carlos ', '', 'Won', '', 'Alto', '', 'juancarlos.won@genrent.pe', '', '933811161', 24, '2023-09-18 15:48:32'),
(51, 'Paul', '', 'Perez', '', 'Alto', '', 'sistemas@ladrillosfortes.com', '', '999328529', 24, '2023-09-18 15:55:45'),
(52, 'Alfredo', 'Michel', 'Quispe', 'Díaz', 'Alto', '', 'roger.portal@losfresnos.pe', '', '976364975', 24, '2023-09-18 16:00:50'),
(53, 'Alex', '', 'Durand', 'Durand', 'Alto', 'TI', 'adurand@data.com.pe', '993585956', '993585956', 24, '2023-09-26 16:23:49'),
(54, 'Javier ', '', 'Diaz', '.', 'Alto', '.', 'javier.diaz@arti.com.pe', '997911616', '997911616', 24, '2023-09-26 16:46:30'),
(55, 'Maria ', 'Antonieta ', 'Abad', 'Centurion', 'Bajo', 'LICENCIA POWER BI PRO ', 'marienta@gmail.com', '. ', '954535620', 32, '2023-09-29 15:50:29'),
(56, 'EDUARDO ', '', 'RIOS ', 'OSORIO ', 'Alto', 'LICENCIAS BUSINESS BASIC ', 'edu@gmail.com', '42514512', '987535680', 32, '2023-09-29 16:16:25'),
(57, 'Robert', 'Luis', 'Campos', 'Altamirano', 'Bajo', 'Sa', 'bruassseda@urp.edu.pe', '972282311', '972282310', 33, '2023-10-02 14:55:03'),
(58, 'Omar', '', 'Hernandez', '.', 'Alto', 'LICENCIA BUSINESS BASIC ', 'omar2801@gmail.com', '.', '989719027', 32, '2023-10-04 20:22:11'),
(59, 'JOSE ', '.', 'JUAREZ', '.', 'Medio', 'LICENCIAS ', 'jjuarezv@azaleia.com.pe', '(01) 6193636', '997944290', 32, '2023-10-05 21:13:44'),
(60, 'Bryan ', '.', 'Chavez', '.', 'Bajo', '.', 'bchavez@diamante.com.pe', '01 5132000', '015132000', 32, '2023-10-05 22:07:27'),
(61, 'Juan', '', 'Quispe', 'Milcher', 'Bajo', 'ninguna', 'jauncito@gmail.com', '987787520', '987787520', 33, '2023-10-16 16:41:12'),
(62, 'Janet', 'Maria', 'Acussive', 'Quispe', 'Bajo', 'Información', 'Janetdelods@gmail.com', '97225230', '975585620', 33, '2023-10-17 20:55:31'),
(63, 'Emily', 'Paola', 'Quispe', 'Quispe', 'Bajo', 'QuispeQuispe', 'Quispe@Quispe.com', '98565230', '985654310', 36, '2023-10-18 20:12:32'),
(64, 'Angel ', '', 'Ulises', 'Cruz', 'Alto', 'Administrador de redes', 'a.vilchez@munilapunta.gob.pe', '918190081', '918190081', 24, '2023-10-18 21:41:14'),
(65, 'Paquito', 'Veterraga', 'Alcachofa', 'Alcachofa', 'Bajo', 'PaquitoAlcachofa', 'PaquitoAlcachofa@gmail.com', '98775420', '98554230', 37, '2023-10-19 14:17:50'),
(66, 'Juan', 'Carlos ', 'Del ', 'Castillo ', 'Alto', 'Licencias Project y Licencia Visio', 'juan.delcastillo@abzingenieros.com', '01 500 6850', '993592022', 32, '2023-10-20 17:53:18'),
(67, 'Patrisia1', '', 'Patrisia', 'patrisia', 'Medio', 'TI Omar Hernandez', 'patrisia3730@gmail.com', '947123970', '947123970', 24, '2023-10-27 16:42:01'),
(68, 'Juan', 'Alonso', 'Quiroz', 'Quispe', 'Bajo', 'demo', 'juanqs@gmail.com', '987765450', '987676546', 35, '2023-11-30 23:20:37'),
(69, 'Pedro ', 'Juan', 'Perez', 'Lopez', 'Medio', 'xxxx', 'pejnddkj@gmail.com', '452344566', '982746488499', 24, '2023-12-19 22:32:13'),
(70, 'Joel', 'Mitsuo', 'Hernandez', 'Lumbe', 'Bajo', 'Es el nuevo ingeniero', 'joel@gmail.com', '930 921 531', '930921531', 35, '2024-01-30 00:37:56'),
(71, 'Mia', 'Melissa', 'Paco', 'Yunque', 'Medio', 'Nuevo', 'miapacoyunque@urp.edu.pe', '972282123', '972282123', 35, '2024-01-30 16:48:10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `customers`
--

CREATE TABLE `customers` (
  `idCliente` int(11) NOT NULL,
  `Company` varchar(255) NOT NULL,
  `RUC` bigint(20) DEFAULT NULL,
  `URL` varchar(255) DEFAULT NULL,
  `Direccion` varchar(255) DEFAULT NULL,
  `Distrito` varchar(50) DEFAULT NULL,
  `Provincia` varchar(50) DEFAULT NULL,
  `Departamento` varchar(50) DEFAULT NULL,
  `Pais` varchar(50) DEFAULT NULL,
  `Cargo` varchar(100) DEFAULT NULL,
  `Cantidad_Empleados` int(11) DEFAULT NULL,
  `OrigenCliente` varchar(255) DEFAULT NULL,
  `COD_idusuario` int(11) NOT NULL,
  `COD_idcontacto` int(11) NOT NULL,
  `AddedCustomers` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `customers`
--

INSERT INTO `customers` (`idCliente`, `Company`, `RUC`, `URL`, `Direccion`, `Distrito`, `Provincia`, `Departamento`, `Pais`, `Cargo`, `Cantidad_Empleados`, `OrigenCliente`, `COD_idusuario`, `COD_idcontacto`, `AddedCustomers`) VALUES
(70, 'VIRTUAL BUSINESS S.A.C', 20601622921, 'www.virtualbusiness.pe', 'MLC. 28 DE JULIO NRO 211 DEP. 407 URB. PETIT JEAN OCHARAN ', 'MIRAFLORES', 'LIMA', 'LIMA', 'Perú', 'Gerente de Ventas', 3, 'Generación Propia', 23, 33, '2023-07-27 16:15:30'),
(72, 'AEROPUERTOS DEL PERU S.A.', 20514513172, '', 'JR. DOMENICO MORELLI NRO 110 INT. 501 ', 'SAN BORJA', 'LIMA', 'LIMA', 'Perú', 'Sistemas', 1, 'Generación Propia', 23, 35, '2023-07-27 16:15:30'),
(74, 'COMPAÑIA PROCESADORA MOLLEHUACA S.A.C.', 20535879762, '', 'AV. MANUEL OLGUIN NRO 373 INT. 501 URB. LOS GRANADOS ', 'SANTIAGO DE SURCO', 'LIMA', 'LIMA', 'Perú', 'TI', 20, 'Generación Propia', 24, 37, '2023-07-31 17:31:59'),
(75, 'AMERICA MOVIL PERU S.A.C.', 20467534026, 'www.claro.com.pe', 'AV. NICOLAS ARRIOLA NRO 480 URB. SANTA CATALINA ', 'LA VICTORIA', 'LIMA', 'LIMA', 'Perú', 'Gerente de Ventas', 3000, 'Campaña', 1, 42, '2023-07-31 19:09:55'),
(76, 'DS PROYECTOS S.A.C.', 20392474618, '', 'AV. MANUEL OLGUIN NRO 335 INT. 1301 ', 'SANTIAGO DE SURCO', 'LIMA', 'LIMA', 'Perú', 'TI', 20, 'Generación Propia', 24, 38, '2023-08-07 16:16:31'),
(77, 'BOOSTER GROUP PERU SAC', 20519118221, '', 'CAL. SANTO TOMAS MZA. M1 LOTE 18 URB. VILLA MARINA ', 'CHORRILLOS', 'LIMA', 'LIMA', 'Perú', 'TI', 20, 'Generación Propia', 24, 38, '2023-08-07 22:44:40'),
(78, 'NEXTPLACEMENT EIRL', 20601193192, '', 'CAL. PONTEVEDRA NRO 185 DEP. 301 ', 'SANTIAGO DE SURCO', 'LIMA', 'LIMA', 'Perú', 'Gerente', 10, 'Generación Propia', 24, 43, '2023-08-07 23:54:03'),
(79, 'CCE CONSULTING S.A.C.', 20550870593, '', 'CAL. MARTIN DE MURUA NRO 150 INT. 403 URB. MARANGA ET. SIETE ', 'SAN MIGUEL', 'LIMA', 'LIMA', 'Perú', 'TI', 20, 'Generación Propia', 24, 37, '2023-08-14 20:27:34'),
(81, 'QUADRAT S.A.C.', 20508941341, '', 'AV. JAVIER PRADO ESTE NRO 5268 INT. 45 URB. CAMACHO ', 'LA MOLINA', 'LIMA', 'LIMA', 'Perú', 'TI', 10, 'Generación Propia', 24, 38, '2023-08-21 22:43:54'),
(82, 'RENZO COSTA S.A.C.', 20138998780, '', 'AV. DOS DE MAYO NRO 674 URB. ORRANTIA ', 'SAN ISIDRO', 'LIMA', 'LIMA', 'Perú', 'TI', 500, 'Generación Propia', 24, 45, '2023-09-01 14:55:16'),
(83, 'BATALLA DE JUNÍN S.A.C.', 20603173156, 'https://compuempresa.com/info/bi-grand-confecciones-sac-20553856451', 'AV. SERGIO BERNALES NRO 249 BAR. BARRIO MEDICO ', 'SURQUILLO', 'LIMA', 'LIMA', 'Perú', 'LOGISTICA', 50, 'Campaña', 26, 46, '2023-09-15 17:14:25'),
(84, 'SAMANCO MINING S.A.C.', 20611424541, '', 'AV. LA REPUBLICA NRO 818 URB. SANTA CRUZ ', 'SAN ISIDRO', 'LIMA', 'LIMA', 'Perú', 'Gerente', 5, 'Generación Propia', 24, 38, '2023-09-18 14:08:31'),
(85, 'INCA ONE METALS PERU S.A.', 20544188926, '', 'CAL. AMADOR MERINO REYNA NRO 465 INT. 402 ', 'SAN ISIDRO', 'LIMA', 'LIMA', 'Perú', 'TI', 50, 'Generación Propia', 24, 48, '2023-09-18 14:20:44'),
(86, 'UNIVERSIDAD CATOLICA LOS ANGELES DE CHIMBOTE', 20319956043, '', 'JR. TUMBES NRO 247 CENTRO COMERCIAL Y FINANC ', 'CHIMBOTE', 'SANTA', 'ANCASH', 'Perú', 'TI', 50, 'Generación Propia', 24, 49, '2023-09-18 15:39:08'),
(87, 'GENRENT DEL PERU S.A.C.', 20567129331, '', 'CAL. MOORE NRO 682 INT. A ', 'IQUITOS', 'MAYNAS', 'LORETO', 'Perú', 'TI', 50, 'Referido de marca', 24, 50, '2023-09-18 15:49:37'),
(88, 'LATERCER S.A.C.', 20514134155, '', 'AV. LAS TORRES MZA. S-N LOTE 27 ', 'LURIGANCHO', 'LIMA', 'LIMA', 'Perú', 'TI', 50, 'Generación Propia', 24, 51, '2023-09-18 15:57:13'),
(89, 'SERVICIOS DE SALUD LOS FRESNOS S.A.C.', 20453503047, '', 'CAL. LOS NOGALES NRO 179 URB. EL INGENIO ', 'CAJAMARCA', 'CAJAMARCA', 'CAJAMARCA', 'Perú', 'TI', 50, 'Referido de marca', 24, 52, '2023-09-18 16:02:16'),
(90, 'COFAMGA S.A.C.', 20606635606, 'www.claro.com.pe', 'CAL. LAUTARO NRO 234 DEP. 201 URB. GERMAN ASTETE ', 'SAN MIGUEL', 'LIMA', 'LIMA', 'Perú', 'Gerente de Ventas', 5, 'Generación Propia', 1, 52, '2023-09-21 15:32:23'),
(91, 'DATA SYSTEM SOLUTION PERU S.A.C.', 20553812837, '', 'AV. VILLARAN NRO 1117 URB. LOS SAUCES ', 'SURQUILLO', 'LIMA', 'LIMA', 'Perú', 'TI', 200, 'Generación Propia', 24, 53, '2023-09-26 16:37:22'),
(92, 'PRODUCTOS INDUSTRIALES ARTI S A', 20100310288, '', 'CAL. LOS TALLADORES NRO 353 INT. A URB. EL ARTESANO ', 'ATE', 'LIMA', 'LIMA', 'Perú', 'Gerente General', 200, 'Generación Propia', 24, 54, '2023-09-26 16:48:28'),
(93, 'DATA SYSTEM & GLOBAL SERVICES S.A.C.', 20600633601, '', 'CAL. MONTE ROSA NRO 256 INT. 1001 URB. CHACARILLA DEL ESTANQUE ', 'SANTIAGO DE SURCO', 'LIMA', 'LIMA', 'Perú', 'TI', 200, 'Generación Propia', 24, 53, '2023-09-26 17:08:26'),
(94, 'PACHA EL MIRADOR S.A.C.', 20608439103, '', 'CAL. MARTIN DE MURUA NRO 150 INT. 403 URB. MARANGA ET. SIETE ', 'SAN MIGUEL', 'LIMA', 'LIMA', 'Perú', 'TI', 15, 'Generación Propia', 24, 37, '2023-09-26 21:19:19'),
(95, 'ENTEL PERU S.A.', 20106897914, '', 'AV. REPUBLICA DE COLOMBIA NRO 791 ', 'SAN ISIDRO', 'LIMA', 'LIMA', 'Perú', 'ESTO ES UNA PRUEBA', 1, 'Campaña', 33, 27, '2023-09-27 21:58:07'),
(96, 'CORPORACION ACEROS AREQUIPA S.A.', 20370146994, '', 'CAR. PANAMERICANA SUR NRO 241 PANAMERICANA SUR ', 'PARACAS', 'PISCO', 'ICA', 'Perú', 'Gerente General ', 500, 'Generación Propia', 32, 55, '2023-09-29 15:53:04'),
(97, 'COMPAñIA DE MINAS BUENAVENTURA S.A.A.', 20100079501, 'https://www.buenaventura.com/es/', 'CAL. LAS BEGONIAS NRO 415 INT. P-19 ', 'SAN ISIDRO', 'LIMA', 'LIMA', 'Perú', 'Ingeniero de TI', 1000, 'Campaña', 32, 56, '2023-09-29 16:20:26'),
(98, 'BI GRAND CONFECCIONES S.A.C.', 20553856451, 'ES UNA PRUEBA', 'JR. SAN GABRIEL NRO 284 URB. SAN CARLOS COMAS ', 'COMAS', 'LIMA', 'LIMA', 'Perú', 'ESTO ES UNA PRUEBA', 1, 'Campaña', 33, 35, '2023-09-29 21:18:51'),
(99, 'E.J.M. CONTADORES & ASESORES E.I.R.L.', 20601558026, 'https://compuempresa.com/info/bi-grand-confecciones-sac-20553856451', 'MZA. G LOTE 20 URB. VILLA HERMOSA ', 'SAN VICENTE DE CAÑETE', 'CAÑETE', 'LIMA', 'Perú', '1', 12, 'Referido de marca', 33, 35, '2023-09-29 21:23:40'),
(100, 'EJM CARDENAS S.A.C.', 20523860632, 'https://compuempresa.com/info/bi-grand-confecciones-sac-20553856451', 'AV. NICOLAS AYLLON MZA. A LOTE 23 URB. PARQ. IND. DE LA MADERA KM. 15.5 ', 'ATE', 'LIMA', 'LIMA', 'Perú', 'ESTO ES UNA PRUEBA', 32, 'Campaña', 33, 35, '2023-09-29 21:25:35'),
(101, 'ESCUELA DE DETECTIVES PRIVADOS DEL PERU E.I.R.L. - ESDEPRIP', 20603498799, 'https://compuempresa.com/info/bi-grand-confecciones-sac-20553856451', 'AV. SAN MARTIN NRO 335 URB. STA ISABEL ', 'CARABAYLLO', 'LIMA', 'LIMA', 'Perú', 'ESTO ES UNA PRUEBA', 2, 'Campaña', 33, 57, '2023-10-02 14:55:26'),
(102, 'FINE ART SOLUTIONS SOCIEDAD ANONIMA CERRADA', 20606106883, '', 'AV. GEMINIS NRO 395 ', 'SAN BORJA', 'LIMA', 'LIMA', 'Perú', 'Sistemas', 32, 'Referido de marca', 33, 35, '2023-10-02 15:00:33'),
(103, 'INFORMES TECH', 20606106883, 'https://compuempresa.com/info/bi-grand-confecciones-sac-20553856451', '', '', '', '', 'Perú', 'ESTO ES UNA PRUEBA', 1, 'Referido de marca', 33, 35, '2023-10-02 17:20:09'),
(104, 'CALZADOS AZALEIA PERU S.A', 20374412524, 'https://www.azaleia.pe/', 'AV. PROLONGACION ARICA NRO 2248 ', 'LIMA', 'LIMA', 'LIMA', 'Perú', 'Ingeniero de TI', 50, 'Generación Propia', 32, 59, '2023-10-05 21:15:35'),
(105, 'PESQUERA DIAMANTE S.A.', 20159473148, 'https://www.diamante.com.pe/', 'CAL. AMADOR MERINO REYNA NRO 307 ', 'SAN ISIDRO', 'LIMA', 'LIMA', 'Perú', 'Ingeniero de TI', 100, 'Generación Propia', 32, 60, '2023-10-05 22:10:05'),
(106, 'SAMILLAN ALACHE MARIA MELANIA', 10164090588, '', '-', '', '', '', 'Perú', 'Ing', 1, 'Campaña', 33, 57, '2023-10-16 16:46:31'),
(107, 'DISTRIBUIDORA AMERICANA S.R.LTDA', 20352534677, 'https://compuempresa.com/info/bi-grand-confecciones-sac-20553856451', 'CAL. LAS ACACIAS NRO 210 URB. SANTA VICTORIA ', 'CHICLAYO', 'CHICLAYO', 'LAMBAYEQUE', 'Perú', 'TI', 1, 'Campaña', 33, 61, '2023-10-16 21:19:11'),
(108, 'PINEDA FLORES BRUNO ALONSO', 10764556009, 'https://compuempresa.com/info/bi-grand-confecciones-sac-20553856451', '-', '', '', '', 'Perú', 'Sistemas', 50, 'Referido de marca', 36, 63, '2023-10-18 20:16:39'),
(109, 'MUNICIPALIDAD DISTRITAL DE LA PUNTA', 20131379600, '', 'AV. GRAU Y SAENZ PENA NRO 298 ', 'LA PUNTA', 'PROV. CONST. DEL CALLAO', 'CALLAO', 'Perú', 'Administrador de Red', 30, 'Generación Propia', 24, 64, '2023-10-18 21:42:29'),
(110, 'QUIROZ CRUZ ZOILA AUREA', 10165036854, '', '-', '', '', '', 'Perú', '1', 1, 'Campaña', 37, 65, '2023-10-19 14:18:21'),
(111, 'SOLUCIONES INTEGRALES DE ALTA TECNOLOGIA S.A.C.', 20508195584, 'http://www.abzingenieros.com', 'AV. REPUBLICA DE PANAMA NRO 3418 URB. LIMATAMBO ', 'SAN ISIDRO', 'LIMA', 'LIMA', 'Perú', 'Jefe de Logistica', 50, 'Generación Propia', 32, 66, '2023-10-20 17:59:12'),
(112, 'ASTAH S.A.C.', 20603214499, '', 'MZA. H16 LOTE 5F URB. LAS DELICIAS DE VILLA ', 'CHORRILLOS', 'LIMA', 'LIMA', 'Perú', 'Gerente', 6, 'Generación Propia', 24, 67, '2023-10-27 16:44:49'),
(113, 'EDM TEXTIL SOCIEDAD ANONIMA CERRADA EN LIQUIDACION - EDM TEXTIL S.A.C. EN LIQUIDACION', 20520564200, 'https://sfibras-frontend.azurewebsites.net/login', 'JR. RIO DE JANEIRO NRO 124 ', 'JESUS MARIA', 'LIMA', 'LIMA', 'Perú', 'Jefe', 20, 'Campaña', 35, 68, '2023-11-30 23:21:32'),
(114, 'INMOBILIARIA LOS ALERCES S.A.C.', 20600517571, '', 'CAL. GERMAN SCHEREIBER NRO 276 URB. SANTA ANA ', 'SAN ISIDRO', 'LIMA', 'LIMA', 'Perú', 'TI', 20, 'Generación Propia', 24, 69, '2023-12-19 22:33:40'),
(115, 'NETWORKING & CLOUD PERU S.A.C.', 20602552501, 'https://intermetalindustrias.com/', 'CAL. JOSE TORIBIO POLO NRO 327 URB. SANTA CRUZ ', 'MIRAFLORES', 'LIMA', 'LIMA', 'Perú', 'SEO SOFTWARE', 25, 'Generación Propia', 35, 70, '2024-01-30 00:41:27'),
(116, 'ALFARO & CONTADORES SOCIEDAD ANONIMA CERRADA', 20570892291, '', 'CAL. MARISCAL SUCRE NRO 1513 SEC. PUEBLO NUEVO ', 'JAEN', 'JAEN', 'CAJAMARCA', 'Perú', 'TI', 500, 'Campaña', 35, 71, '2024-01-30 16:51:54');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detallefactura`
--

CREATE TABLE `detallefactura` (
  `correlativo` bigint(20) NOT NULL,
  `nofactura` bigint(20) NOT NULL,
  `codproducto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_temp`
--

CREATE TABLE `detalle_temp` (
  `correlativo` int(11) NOT NULL,
  `token_user` varchar(50) NOT NULL,
  `codproducto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entradas`
--

CREATE TABLE `entradas` (
  `correlativo` int(11) NOT NULL,
  `codproducto` int(11) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `cantidad` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `usuario_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `eventos`
--

CREATE TABLE `eventos` (
  `id` int(11) NOT NULL,
  `asignado` varchar(255) DEFAULT NULL,
  `asunto` varchar(255) DEFAULT NULL,
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `ubicacion` varchar(255) DEFAULT NULL,
  `mostrar_hora` varchar(250) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `COD_idrol` int(11) DEFAULT NULL,
  `color_evento` varchar(255) DEFAULT NULL,
  `COD_idusuario` int(11) NOT NULL,
  `COD_idsales` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `eventos`
--

INSERT INTO `eventos` (`id`, `asignado`, `asunto`, `fecha_inicio`, `fecha_fin`, `ubicacion`, `mostrar_hora`, `descripcion`, `COD_idrol`, `color_evento`, `COD_idusuario`, `COD_idsales`) VALUES
(11, 'Admin - vida@gmail.com', 'De prueba', '2023-07-27 10:36:00', '2023-07-27 10:36:00', 'San isidro', 'Ocupada', 'a', 1, '#FF0000', 1, 1),
(14, 'Delia Flores - deli489@gmail.com', 'De prueba', '2023-07-27 10:45:00', '2023-07-27 10:45:00', 'San isidro', 'Fuera de la oficina', 'a', 20, '#FFFF00', 23, 4),
(15, 'Delia Flores - deli489@gmail.com', 'De prueba', '2023-07-27 10:45:00', '2023-07-28 10:45:00', 'San isidro', 'Fuera de la oficina', 'a', 20, '#FFFF00', 23, 5),
(16, 'test12 - asasasa@gmail.com', 'Conferencia de google', '2023-09-15 12:16:00', '2023-09-15 17:16:00', 'San isidro', 'Ocupada', 'Google cloud', 1, '#FF0000', 26, 21),
(17, 'Mia Arecco - marecco@virtualbusiness.pe', 'Reunión ', '2023-09-21 10:13:00', '2023-09-21 10:15:00', 'san isidro', '--Ninguno--', 'xxxx', 1, '#00FF00', 24, 1),
(18, 'Mia Arecco - marecco@virtualbusiness.pe', '', '2023-09-21 10:13:00', '2023-09-21 10:14:00', '', '--Ninguno--', '', 1, '#00FF00', 24, 1),
(19, 'Mia Arecco - marecco@virtualbusiness.pe', '', '2023-09-26 12:15:00', '2023-09-26 12:15:00', '', '--Ninguno--', 'GYGY', 1, '#00FF00', 24, 1),
(20, 'Angela Israel - angela.israel@virtualbusiness.pe', 'CAPACITACION INGRAM 4 -5PM   ', '2023-09-28 17:10:00', '2023-09-28 17:10:00', '', 'Ocupada', 'CAPACITACION - CON EL ACCESO DE MIA ', 20, '#FF0000', 32, 0),
(21, 'Bruno - fafafg@gmail.com', 'De prueba', '2023-10-02 10:04:00', '2023-10-02 10:04:00', 'San isidro', 'Ocupada', 'si', 20, '#FF0000', 33, 64);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `eventos1`
--

CREATE TABLE `eventos1` (
  `id` int(11) NOT NULL,
  `asignado` varchar(255) DEFAULT NULL,
  `asunto` varchar(255) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `h_inicio` time DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `h_fin` time DEFAULT NULL,
  `ubicacion` varchar(255) DEFAULT NULL,
  `mostrar_hora` varchar(250) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `COD_idrol` int(11) DEFAULT NULL,
  `color_evento` varchar(255) DEFAULT NULL,
  `COD_idusuario` int(11) NOT NULL,
  `COD_idsales` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `eventos1`
--

INSERT INTO `eventos1` (`id`, `asignado`, `asunto`, `fecha_inicio`, `h_inicio`, `fecha_fin`, `h_fin`, `ubicacion`, `mostrar_hora`, `descripcion`, `COD_idrol`, `color_evento`, `COD_idusuario`, `COD_idsales`) VALUES
(39, 'Bruno - Brunoreto27@gmail.com', 'sasasa', '2023-10-04', '15:40:00', '2023-10-05', '16:40:00', 'San isidro', 'Disponible', '', 1, '#0000FF', 29, 1),
(41, 'Bruno - Brunoreto27@gmail.com', 'fs', '2023-10-06', '15:40:00', '2023-10-07', '16:40:00', 'sa', 'Disponible', '', 1, '#0000FF', 29, 1),
(42, 'Bruno - Brunoreto27@gmail.com', 'De prueba', '2023-10-18', '15:53:00', '2023-10-20', '16:53:00', 'San isidro', 'Ocupada', 'as', 1, '#FF0000', 29, 1),
(43, 'Bruno - Brunoreto27@gmail.com', 'Pollos21', '2023-10-05', '16:40:00', '2023-10-06', '17:40:00', 'San isidro', 'Fuera de la oficina', 'ADADA', 1, '#FFFF00', 29, 1),
(44, 'Bruno - fafafg@gmail.com', 'De prueba', '2023-10-16', '16:18:00', '2023-10-17', '17:18:00', 'San isidro', 'Fuera de la oficina', 'A', 20, '#f6c23e', 33, 64),
(45, 'Admin4 - Admin4@gmail.com', 'as', '2023-10-18', '12:20:00', '2023-10-19', '13:20:00', '', '--Ninguno--', '', 20, '#1cc88a', 34, 0),
(46, 'Admin4 - Admin4@gmail.com', 'asddsa', '2023-10-18', '12:21:00', '2023-10-19', '13:21:00', '', '--Ninguno--', '', 20, '#1cc88a', 34, 0),
(47, 'Admin4 - Admin4@gmail.com', 'sadsad', '2023-10-18', '12:22:00', '2023-10-19', '13:22:00', '', '--Ninguno--', '', 20, '#1cc88a', 34, 0),
(48, 'Emiliano Test - emiliate@virtualbusiness.com', 'Almuerzo con ejecutivos', '2023-10-18', '15:19:00', '2023-10-19', '03:19:00', '', '--Ninguno--', 'hola', 20, '#1cc88a', 36, 68),
(49, 'PaquitoAlcachofa - PaquitoAlcachofa@PaquitoAlcachofa.com', 'De prueba', '2023-10-19', '09:18:00', '2023-10-20', '10:18:00', '', 'Ocupada', '', 20, '#e74a3b', 37, 70),
(50, 'PaquitoAlcachofa - PaquitoAlcachofa@PaquitoAlcachofa.com', 'De prueba', '2023-10-20', '10:58:00', '2023-10-21', '11:58:00', '', '--Ninguno--', 'asas', 20, '#1cc88a', 37, 70),
(51, 'Bruno - Bruno@gmail.com', 'Entrevista', '2023-12-19', '12:31:00', '2023-12-20', '13:31:00', '', 'Ocupada', 'Microsoft', 1, '#e74a3b', 35, 57),
(52, 'Bruno - Bruno@gmail.com', 'La pollada de Ramirez', '2024-01-29', '19:49:00', '2024-01-30', '20:49:00', '', 'Ocupada', 'La mejor polleria', 1, '#e74a3b', 35, 70),
(53, 'Bruno - Bruno@gmail.com', 'Capacitación Joel', '2024-01-30', '12:06:00', '2024-01-31', '14:06:00', '', 'Ocupada', 'Es una prueba', 1, '#e74a3b', 35, 69);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura`
--

CREATE TABLE `factura` (
  `nofactura` int(11) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `usuario` int(11) NOT NULL,
  `codcliente` int(11) NOT NULL,
  `totalfactura` decimal(10,2) NOT NULL,
  `estado` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `family&products`
--

CREATE TABLE `family&products` (
  `id` int(11) NOT NULL,
  `Familia` varchar(255) DEFAULT NULL,
  `Marca` varchar(255) DEFAULT NULL,
  `Producto/Servicio` varchar(255) DEFAULT NULL,
  `Descripción` varchar(255) DEFAULT NULL,
  `Proveedor` varchar(255) DEFAULT NULL,
  `Contacto` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `family&products`
--

INSERT INTO `family&products` (`id`, `Familia`, `Marca`, `Producto/Servicio`, `Descripción`, `Proveedor`, `Contacto`) VALUES
(1, 'Seguridad', 'A10', 'A10 Thunder SSLi', 'Decodificación SSL/TLS, protección de datos y comunicaciones seguras', 'Deltron', ''),
(2, 'Seguridad', 'AlienVault', 'AlienVault USM', 'Gestión de seguridad unificada, detección de amenazas y cumplimiento', '', ''),
(3, 'Seguridad', 'Allied Telesis', 'Allied Telesis xSeries', 'Switches de red seguros, protección y control de accesos a la red', '', ''),
(4, 'Seguridad', 'Barracuda', 'Barracuda Web Filter', 'Filtro de contenido web, seguridad web y protección contra amenazas', '', ''),
(5, 'Seguridad', 'BeyondTrust', 'BeyondTrust PAM', 'Gestión de accesos privilegiados, control y monitoreo de accesos privilegiados', '', ''),
(6, 'Seguridad', 'CheckPoint', 'CheckPoint Next Generation Firewall', 'Firewall de próxima generación, protección de redes y detección de amenazas', '', ''),
(7, 'Seguridad', 'CyberArk', 'CyberArk PAM', 'Gestión de accesos privilegiados, protección y control de accesos privilegiados', '', ''),
(8, 'Seguridad', 'Cisco', 'Cisco Firepower', 'Firewalls de próxima generación, seguridad de red y protección contra amenazas', '', ''),
(9, 'Seguridad', 'F5', 'F5 Advanced WAF', 'Firewall de aplicaciones web, protección de aplicaciones web y datos', '', ''),
(10, 'Seguridad', 'FireMon', 'FireMon Security Manager', 'Gestión de políticas de seguridad, monitoreo y optimización de políticas de seguridad', '', ''),
(11, 'Seguridad', 'ForeScout', 'ForeScout CounterACT', 'Control de acceso a la red, detección y respuesta a amenazas en tiempo real', '', ''),
(12, 'Seguridad', 'Fortinet', 'Fortinet FortiGate', 'Firewalls de próxima generación, protección de redes y detección de amenazas', '', ''),
(13, 'Seguridad', 'Gigamon', 'Gigamon GigaVUE', 'Visibilidad de tráfico de red, monitoreo y análisis del tráfico de red', '', ''),
(14, 'Seguridad', 'Imperva', 'Imperva Web Application Firewall', 'Firewall de aplicaciones web, protección de aplicaciones web y datos', '', ''),
(15, 'Seguridad', 'Infoblox', 'Infoblox BloxOne Threat Defense', 'Protección contra amenazas en DNS, seguridad y prevención de amenazas en DNS', '', ''),
(16, 'Seguridad', 'Ivanti', 'Ivanti Security Controls', 'Gestión de parches y seguridad de endpoints, protección y cumplimiento de endpoints', '', ''),
(17, 'Seguridad', 'Juniper', 'Juniper SRX', 'Firewalls de próxima generación, seguridad de red y protección contra amenazas', '', ''),
(18, 'Seguridad', 'LogRhythm', 'LogRhythm SIEM', 'Gestión de eventos e información de seguridad, monitoreo y análisis de eventos de seguridad', '', ''),
(19, 'Seguridad', 'Microsoft', 'Microsoft Defender ATP', 'Protección avanzada de endpoints, prevención de amenazas y protección de endpoints', '', ''),
(20, 'Seguridad', 'Netscout', 'Netscout Arbor', 'Protección DDoS, mitigación y prevención de ataques DDoS', '', ''),
(21, 'Seguridad', 'Nozomi Networks', 'Nozomi Networks Guardian', 'Seguridad en infraestructura crítica, protección y monitoreo de infraestructuras críticas', '', ''),
(22, 'Seguridad', 'Palo Alto', 'Palo Alto Networks Next-Generation Firewall', 'Firewall de próxima generación, protección de redes y detección de amenazas', '', ''),
(23, 'Seguridad', 'Proofpoint', 'Proofpoint Email Protection', 'Protección del correo electrónico, prevención de amenazas y filtrado de spam', '', ''),
(24, 'Seguridad', 'Radwin', 'Radwin Wireless Broadband', 'Conectividad inalámbrica segura, comunicaciones encriptadas', '', ''),
(25, 'Seguridad', 'SonicWall', 'SonicWall TZ Series', 'Firewalls de próxima generación, seguridad de red y protección contra amenazas', '', ''),
(26, 'Seguridad', 'Splunk', 'Splunk Enterprise Security', 'SIEM, análisis y correlación de eventos de seguridad', '', ''),
(27, 'Seguridad', 'SkyBox', 'SkyBox Security Suite', 'Gestión de vulnerabilidades y políticas de seguridad, análisis y priorización', '', ''),
(28, 'Seguridad', 'Symantec', 'Symantec Endpoint Security', 'Protección de endpoints, detección y respuesta a amenazas', '', ''),
(29, 'Seguridad', 'Thales', 'Thales SafeNet Data Protection', 'Protección de datos y cifrado, seguridad de la información', '', ''),
(30, 'Seguridad', 'Oracle', 'Oracle Advanced Security', 'Seguridad de bases de datos, cifrado y prevención de intrusiones', '', ''),
(31, 'Seguridad', 'RSA', 'RSA NetWitness Platform', 'Detección y respuesta a amenazas, análisis de seguridad', '', ''),
(32, 'Seguridad', 'Tenable', 'Tenable.io', 'Gestión de vulnerabilidades, monitoreo y priorización de riesgos', '', ''),
(33, 'Seguridad', 'Trend Micro', 'Trend Micro Apex One', 'Protección de endpoints, seguridad y cumplimiento', '', ''),
(34, 'Seguridad', 'Tripwire', 'Tripwire Enterprise', 'Monitoreo de integridad y cumplimiento, seguridad de la información', '', ''),
(35, 'Seguridad', 'Sophos', 'Sophos XG Firewall', 'Firewalls de próxima generación, seguridad de red y protección contra amenazas', '', ''),
(36, 'Seguridad', 'Pulse Secure', 'Pulse Secure Access Suite', 'Acceso remoto seguro, VPN', '', ''),
(37, 'Cloud', 'AWS', 'Amazon Web Services (AWS)', 'Plataforma de servicios en la nube, IaaS, PaaS, y SaaS, almacenamiento, bases de datos, análisis y más', '', ''),
(38, 'Cloud', 'Microsoft', 'Microsoft Azure', 'Plataforma de servicios en la nube, IaaS, PaaS, y SaaS, computación, bases de datos, inteligencia artificial y más', '', ''),
(39, 'Cloud', 'Google', 'Google Cloud Platform (GCP)', 'Plataforma de servicios en la nube, IaaS, PaaS, y SaaS, almacenamiento, análisis, machine learning y más', '', ''),
(40, 'Cloud', 'Oracle', 'Oracle Cloud Infrastructure (OCI)', 'Plataforma de servicios en la nube, IaaS, PaaS, y SaaS, bases de datos, aplicaciones empresariales, analítica y más', '', ''),
(41, 'Infraestructura', 'Allied Telesis', 'Allied Telesis Switches', 'Switches de red, enrutamiento y gestión de tráfico', '', ''),
(42, 'Infraestructura', 'Juniper', 'Juniper Networks Routers', 'Routers empresariales, enrutamiento y optimización de red', '', ''),
(43, 'Infraestructura', 'NetApp', 'NetApp Storage Systems', 'Sistemas de almacenamiento, NAS y SAN, gestión de datos', '', ''),
(44, 'Infraestructura', 'Netscout', 'Netscout nGeniusONE', 'Monitoreo y análisis del rendimiento de la red, optimización y solución de problemas', '', ''),
(45, 'Infraestructura', 'CommScope Ruckus', 'Ruckus Wireless Access Points', 'Puntos de acceso inalámbricos, redes Wi-Fi empresariales y administración de red', '', ''),
(46, 'Infraestructura', 'Ciena', 'Ciena Optical Networking', 'Redes ópticas, transporte y conmutación de alta capacidad', '', ''),
(47, 'Infraestructura', 'Nokia', 'Nokia IP/MPLS Networking', 'Redes IP/MPLS, enrutamiento y conmutación de paquetes', '', ''),
(48, 'Infraestructura', 'Cisco', 'Cisco Networking Solutions', 'Soluciones de redes, switches, routers y puntos de acceso', '', ''),
(49, 'Infraestructura', 'Nutanix', 'Nutanix HCI', 'Infraestructura hiperconvergente, virtualización y gestión de centros de datos', '', ''),
(50, 'Infraestructura', 'Ekahau', 'Ekahau Wi-Fi Design', 'Diseño y planificación de redes Wi-Fi, análisis y optimización', '', ''),
(51, 'Infraestructura', 'Opengear', 'Opengear Out-of-Band Management', 'Gestión fuera de banda, acceso remoto seguro a dispositivos de red', '', ''),
(52, 'Infraestructura', 'Extreme', 'Extreme Networks', 'Soluciones de redes, switches, routers, y puntos de acceso', '', ''),
(53, 'Infraestructura', 'Oracle', 'Oracle Servers and Storage', 'Servidores y almacenamiento, optimización de centros de datos y rendimiento', '', ''),
(54, 'Infraestructura', 'Exagrid', 'Exagrid Disk-based Backup', 'Almacenamiento de respaldo basado en disco, deduplicación y recuperación', '', ''),
(55, 'Infraestructura', 'Fortinet', 'Fortinet Secure SD-WAN', 'Redes de área amplia definidas por software, optimización y seguridad', '', ''),
(56, 'Infraestructura', 'Pure Storage', 'Pure Storage FlashArray', 'Almacenamiento flash, rendimiento y escalabilidad', '', ''),
(57, 'Infraestructura', 'Gigamon', 'Gigamon Visibility and Analytics Fabric', 'Visibilidad de la red y análisis, optimización del tráfico y monitoreo', '', ''),
(58, 'Infraestructura', 'Rubrik', 'Rubrik Cloud Data Management', 'Gestión de datos en la nube, protección y recuperación de datos', '', ''),
(59, 'Infraestructura', 'Hitachi', 'Hitachi Vantara Storage Solutions', 'Soluciones de almacenamiento, virtualización y gestión de datos', '', ''),
(60, 'Infraestructura', 'Silver Peak', 'Silver Peak SD-WAN', 'Redes de área amplia definidas por software, optimización y rendimiento de red', '', ''),
(61, 'Business Intelligence y Process', 'AWS', 'AWS QuickSight', 'Servicio de análisis empresarial y visualización de datos', '', ''),
(62, 'Business Intelligence y Process', 'AppViewX', 'AppViewX Platform', 'Automatización y orquestación de infraestructura de red', '', ''),
(63, 'Business Intelligence y Process', 'Exabeam', 'Exabeam Security Management Platform', 'Plataforma de gestión de seguridad y análisis de datos', '', ''),
(64, 'Business Intelligence y Process', 'Extreme', 'ExtremeAnalytics', 'Análisis de red y visibilidad del tráfico', '', ''),
(65, 'Business Intelligence y Process', 'Erwin', 'Erwin Data Modeler', 'Modelado de datos, diseño de bases de datos y gestión', '', ''),
(66, 'Business Intelligence y Process', 'LogRhythm', 'LogRhythm NextGen SIEM', 'SIEM de próxima generación, análisis de seguridad y respuesta a incidentes', '', ''),
(67, 'Business Intelligence y Process', 'Fortinet', 'Fortinet FortiAnalyzer', 'Análisis de seguridad y eventos, correlación y alertas', '', ''),
(68, 'Business Intelligence y Process', 'Ivanti', 'Ivanti IT Asset Management', 'Gestión de activos de TI y optimización de procesos', '', ''),
(69, 'Business Intelligence y Process', 'Splunk', 'Splunk Enterprise', 'Análisis de datos y plataforma de inteligencia operativa', '', ''),
(70, 'Business Intelligence y Process', 'RSA', 'RSA Archer GRC', 'Gestión de riesgos, cumplimiento y gobernanza de seguridad', '', ''),
(71, 'Business Intelligence y Process', 'Oracle', 'Oracle Business Intelligence', 'Análisis de datos empresariales y visualización', '', ''),
(72, 'Business Intelligence y Process', 'Microsoft', 'Microsoft Power BI', 'Servicio de análisis empresarial y visualización de datos', '', ''),
(73, 'Business Intelligence y Process', 'Microsoft', 'Microsoft', '', 'Deltron', 'Amparo/ 977869484'),
(74, 'Business Intelligence y Process', 'Microsoft', 'Microsoft', '', 'Multimport', 'Miguel Angel Huaman/ 981028909'),
(75, 'Business Continuity', 'Arcserve', 'Arcserve Unified Data Protection', 'Protección de datos unificada, respaldo y recuperación', '', ''),
(76, 'Business Continuity', 'Cisco', 'Cisco Disaster Recovery', 'Soluciones de recuperación ante desastres y continuidad del negocio', '', ''),
(77, 'Business Continuity', 'Commvault', 'Commvault Data Protection', 'Protección de datos, respaldo y recuperación, gestión de la información', '', ''),
(78, 'Business Continuity', 'Extreme', 'Extreme Fabric Connect', 'Conectividad de red resiliente y recuperación rápida', '', ''),
(79, 'Business Continuity', 'F5', 'F5 BIG-IP Local Traffic Manager', 'Gestión de tráfico local y balanceo de carga para alta disponibilidad', '', ''),
(80, 'Business Continuity', 'NetApp', 'NetApp SnapMirror', 'Replicación de datos y recuperación ante desastres', '', ''),
(81, 'Business Continuity', 'Oracle', 'Oracle Data Guard', 'Protección de datos y recuperación ante desastres para bases de datos Oracle', '', ''),
(82, 'Business Continuity', 'Pure Storage', 'Pure Storage ActiveCluster', 'Almacenamiento activo-activo y recuperación ante desastres', '', ''),
(83, 'Business Continuity', 'Radware', 'Radware Alteon', 'Balanceo de carga y continuidad del negocio', '', ''),
(84, 'Business Continuity', 'Rubrik', 'Rubrik Cloud Data Management', 'Gestión de datos en la nube, protección y recuperación de datos', '', ''),
(85, 'Modern App', 'AWS', 'AWS Lambda', 'Servicio de cómputo sin servidor para aplicaciones modernas', '', ''),
(86, 'Modern App', 'AppViewX', 'AppViewX Platform', 'Automatización y orquestación de infraestructura de red', '', ''),
(87, 'Modern App', 'Cisco', 'Cisco AppDynamics', 'Monitoreo de rendimiento de aplicaciones y análisis', '', ''),
(88, 'Modern App', 'F5', 'F5 BIG-IP Application Security Manager', 'Seguridad y protección de aplicaciones web', '', ''),
(89, 'Modern App', 'Ivanti', 'Ivanti Application Control', 'Control y seguridad de aplicaciones empresariales', '', ''),
(90, 'Modern App', 'Juniper', 'Juniper AppFormix', 'Monitoreo y optimización de aplicaciones en la nube', '', ''),
(91, 'Modern App', 'Microsoft', 'Microsoft Azure Functions', 'Servicio de cómputo sin servidor para aplicaciones modernas', '', ''),
(92, 'Modern App', 'Fox IT', 'Fox IT Managed Services', 'Servicios administrados de seguridad y soporte para aplicaciones modernas', '', ''),
(93, 'Modern App', 'Netscout', 'Netscout nGeniusPULSE', 'Monitoreo del rendimiento y disponibilidad de aplicaciones', '', ''),
(94, 'Modern App', 'Splunk', 'Splunk App for Infrastructure', 'Monitoreo y análisis de la infraestructura de aplicaciones', '', ''),
(95, 'Modern App', 'Radware', 'Radware AppWall', 'Protección y seguridad de aplicaciones web', '', ''),
(96, 'Modern App', 'RSA', 'RSA Archer GRC', 'Gestión de riesgos, cumplimiento y gobernanza de seguridad', '', ''),
(97, 'Colaboración', 'AudioCodes', 'AudioCodes One Voice', 'Soluciones de voz y colaboración para empresas', '', ''),
(98, 'Colaboración', 'Microsoft', 'Microsoft Teams', 'Plataforma de colaboración y comunicación empresarial', '', ''),
(99, 'Colaboración', 'Avaya', 'Avaya Spaces', 'Plataforma de colaboración y comunicación en equipo', '', ''),
(100, 'Colaboración', 'Cisco', 'Cisco Webex', 'Plataforma de videoconferencia y colaboración en línea', '', ''),
(101, 'Colaboración', 'Ribbon', 'Ribbon Unified Communications', 'Soluciones de comunicación unificada y colaboración', '', ''),
(102, 'Colaboración', 'Zoom', 'Zoom Video Communications', 'Plataforma de videoconferencia y colaboración en línea', '', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `files`
--

CREATE TABLE `files` (
  `id` int(11) NOT NULL,
  `url` varchar(500) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `COD_idCollections` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `files`
--

INSERT INTO `files` (`id`, `url`, `type`, `COD_idCollections`) VALUES
(12, 'files/20230615211458-recibo (2).pdf', 'pdf', 72),
(13, 'files/20230615192104-recibo (1).pdf', 'pdf', 73),
(15, 'files/20230618230122-REPORTE PDF.pdf', 'pdf', 75),
(16, 'files/20230621114541-CertificadoDigital.pdf', 'pdf', 76),
(17, 'files/20230703121838-Ejemplo.pdf', 'pdf', 77),
(20, 'files/20230703212015-recibo (2).pdf', 'pdf', 80),
(21, 'none', 'none', 81),
(22, 'files/20230709225347-Ejemplo.pdf', 'pdf', 82),
(23, 'files/20230915120753-cobit.pdf', 'pdf', 84);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `files_sales`
--

CREATE TABLE `files_sales` (
  `id` int(11) NOT NULL,
  `url` varchar(500) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `COD_idSales` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `file_sales`
--

CREATE TABLE `file_sales` (
  `id` int(11) NOT NULL,
  `url` varchar(500) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `COD_idSales` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `file_sales`
--

INSERT INTO `file_sales` (`id`, `url`, `type`, `COD_idSales`) VALUES
(12, 'none', 'none', 0),
(13, 'none', 'none', 4),
(14, 'none', 'none', 5),
(15, 'none', 'none', 0),
(16, 'none', 'none', 6),
(17, 'none', 'none', 7),
(18, 'none', 'none', 8),
(19, 'none', 'none', 9),
(20, 'none', 'none', 10),
(21, 'none', 'none', 11),
(22, 'none', 'none', 12),
(23, 'none', 'none', 13),
(24, 'none', 'none', 14),
(25, 'none', 'none', 15),
(26, 'none', 'none', 0),
(27, 'none', 'none', 16),
(28, 'files_sales/20230807112459-Propuesta Técnico EconómicaV2.pdf', 'pdf', 17),
(29, 'files_sales/20230807174150-Propuesta Técnico EconómicaV2.pdf', 'pdf', 18),
(30, 'none', 'none', 0),
(31, 'files_sales/20230811121955-Mollehuaca.pdf', 'pdf', 19),
(32, 'none', 'none', 20),
(33, 'files_sales/20230814122931-mollehuaca.pdf', 'pdf', 21),
(34, 'files_sales/20230814122933-mollehuaca.pdf', 'pdf', 22),
(35, 'files_sales/20230814123146-mollehuaca plan 3.pdf', 'pdf', 23),
(36, 'files_sales/20230814154112-Consult.pdf', 'pdf', 24),
(37, 'none', 'none', 25),
(38, 'files_sales/20230815120407-Samanco coming.pdf', 'pdf', 26),
(39, 'files_sales/20230821175929-licencia business estandar.pdf', 'pdf', 0),
(40, 'files_sales/20230901095414-01082023.pdf', 'pdf', 0),
(41, 'none', 'none', 0),
(42, 'files_sales/20230901101554-Propuesta Técnico Económica.pdf', 'pdf', 27),
(43, 'files_sales/20230904144921-Mollehuaca 04092023.pdf', 'pdf', 0),
(44, 'files_sales/20230904145722-04092023.pdf', 'pdf', 28),
(45, 'none', 'none', 29),
(46, 'none', 'none', 0),
(47, 'none', 'none', 0),
(48, 'files_sales/20230913131117-12092023.pdf', 'pdf', 0),
(49, 'none', 'none', 30),
(50, 'files_sales/20230915104637-TARIFARIO LIMA 23.pdf', 'pdf', 31),
(51, 'files_sales/20230915122143-cobit.pdf', 'pdf', 32),
(52, 'none', 'none', 0),
(53, 'files_sales/20230921102527-1865987-1 (1).pdf', 'pdf', 33),
(54, 'files_sales/20230918102659-Propuesta Servicios Azure para INCA ONE v2.pdf', 'pdf', 0),
(55, 'files_sales/20230918103101-Propuesta Servicios Azure para INCA ONE v2.pdf', 'pdf', 0),
(56, 'files_sales/20230918104106-Propuesta Técnico Económica 2806231032v1.pdf', 'pdf', 34),
(57, 'none', 'none', 35),
(58, 'none', 'none', 0),
(59, 'none', 'none', 0),
(60, 'none', 'none', 0),
(61, 'none', 'none', 0),
(62, 'none', 'none', 0),
(63, 'none', 'none', 36),
(64, 'none', 'none', 37),
(65, 'none', 'none', 0),
(66, 'none', 'none', 0),
(67, 'none', 'none', 0),
(68, 'none', 'none', 38),
(69, 'files_sales/20230920142948-cobit.pdf', 'pdf', 39),
(70, 'none', 'none', 40),
(71, 'none', 'none', 0),
(72, 'none', 'none', 41),
(73, 'none', 'none', 42),
(74, 'none', 'none', 43),
(75, 'none', 'none', 0),
(76, 'files_sales/20230921152009-21092023.pdf', 'pdf', 0),
(77, 'files_sales/20230921152229-Propuesta de Proyecto de Migración de Google Workspace a Microsoft Office 365 v2.pdf', 'pdf', 0),
(78, 'files_sales/20230921161313-21092023.pdf', 'pdf', 0),
(79, 'files_sales/20230922090433-Propuesta Servicios Azure para INCA ONE v2.pdf', 'pdf', 0),
(80, 'none', 'none', 0),
(81, 'files_sales/20230922091157-Propuesta Servicios Azure para INCA ONE v2.pdf', 'pdf', 0),
(82, 'files_sales/20230922103745-cobit.pdf', 'pdf', 44),
(83, 'files_sales/20230922104231-cobit.pdf', 'pdf', 45),
(84, 'files_sales/20230922114234-Propuesta Servicios Azure para INCA ONE v2.pdf', 'pdf', 0),
(85, 'none', 'none', 0),
(86, 'files_sales/20230922115518-Propuesta Servicios Azure para INCA ONE v2.pdf', 'pdf', 46),
(87, 'files_sales/20230922115813-Propuesta Servicios Azure para INCA ONE v2.pdf', 'pdf', 47),
(88, 'none', 'none', 48),
(89, 'none', 'none', 49),
(90, 'none', 'none', 0),
(91, 'none', 'none', 0),
(92, 'none', 'none', 50),
(93, 'none', 'none', 0),
(94, 'none', 'none', 0),
(95, 'none', 'none', 0),
(96, 'none', 'none', 51),
(97, 'none', 'none', 0),
(98, 'none', 'none', 0),
(99, 'none', 'none', 0),
(100, 'none', 'none', 0),
(101, 'none', 'none', 0),
(102, 'none', 'none', 0),
(103, 'none', 'none', 52),
(104, 'none', 'none', 53),
(105, 'none', 'none', 54),
(106, 'files_sales/20230925092547-01082023.pdf', 'pdf', 55),
(107, 'none', 'none', 56),
(108, 'files_sales/20230926115408-Propuesta Técnico Económica v2.pdf', 'pdf', 57),
(109, 'files_sales/20230926115926-Propuesta Técnico Económica v2.pdf', 'pdf', 58),
(110, 'none', 'none', 59),
(111, 'files_sales/20230926162114-26092023.pdf', 'pdf', 60),
(112, 'none', 'none', 61),
(113, 'none', 'none', 62),
(114, 'none', 'none', 63),
(115, 'none', 'none', 0),
(116, 'none', 'none', 64),
(117, 'none', 'none', 65),
(118, 'files_sales/20231005160045-041023.pdf', 'pdf', 66),
(119, 'files_sales/20231013154056-Propuesta Técnico Económica VM UCLACHv2.pdf', 'pdf', 67),
(120, 'files_sales/20231018151856-ROL_PARCIAL_2023-2 Ercilia_21-09-2023_ (2).pdf', 'pdf', 68),
(121, 'files_sales/20231018164438-muni la punta.pdf', 'pdf', 69),
(122, 'none', 'none', 70),
(123, 'files_sales/20231020130732-Propuesta Técnico Económica- 1222201023.pdf', 'pdf', 0),
(124, 'files_sales/20231020131302-Propuesta Técnico Económica- 1222201023.pdf', 'pdf', 71),
(125, 'files_sales/20231027113753-sankaku.pdf', 'pdf', 72),
(126, 'files_sales/20231027114020-mollehuaca.pdf', 'pdf', 73),
(127, 'files_sales/20231027114755-Oferta Técnico Económica - 20603214499 - ASTAH S.A.C v3.pdf', 'pdf', 0),
(128, 'none', 'none', 74),
(129, 'none', 'none', 75);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `maker`
--

CREATE TABLE `maker` (
  `idFabricante` int(11) NOT NULL,
  `marca` varchar(255) DEFAULT NULL,
  `fecha_De_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `maker`
--

INSERT INTO `maker` (`idFabricante`, `marca`, `fecha_De_registro`) VALUES
(1, 'Microsoft', '2023-06-07 16:51:42'),
(2, 'Adobe', '2023-06-07 16:51:42'),
(3, 'Autodesk', '2023-06-07 16:51:42'),
(4, 'Oracle', '2023-06-07 16:51:42'),
(5, 'SAP', '2023-06-07 16:51:42'),
(6, 'IBM', '2023-06-07 16:51:42'),
(7, 'Salesforce', '2023-06-07 16:51:42'),
(8, 'VMware', '2023-06-07 16:51:42'),
(9, 'Symantec', '2023-06-07 16:51:42'),
(10, 'Red Hat', '2023-06-07 16:51:42'),
(11, 'Otro', '2023-07-08 23:12:53'),
(12, 'Ivanti', '2024-01-30 11:54:02');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `newcustomers`
--

CREATE TABLE `newcustomers` (
  `idnewCliente` int(11) NOT NULL,
  `Company` varchar(255) NOT NULL,
  `RUC` int(11) DEFAULT NULL,
  `URL` varchar(255) DEFAULT NULL,
  `Tipo_Contacto` varchar(50) DEFAULT NULL,
  `Contact_Name` varchar(255) DEFAULT NULL,
  `Apellido_Paterno` varchar(255) DEFAULT NULL,
  `Apellido_Materno` varchar(255) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Phone` int(11) DEFAULT NULL,
  `Direccion` varchar(255) DEFAULT NULL,
  `Distrito` varchar(50) DEFAULT NULL,
  `Provincia` varchar(50) DEFAULT NULL,
  `Departamento` varchar(50) DEFAULT NULL,
  `Pais` varchar(50) DEFAULT NULL,
  `Cargo` varchar(100) DEFAULT NULL,
  `Cantidad_Empleados` int(11) DEFAULT NULL,
  `OrigenCliente` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `id` int(11) NOT NULL,
  `permiso` varchar(100) DEFAULT NULL,
  `fecha_creacion` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`id`, `permiso`, `fecha_creacion`) VALUES
(1, 'Account', '2023-07-08'),
(2, 'Collections', '2023-07-08'),
(3, 'Contacts', '2023-07-08'),
(4, 'ALL Products', '2023-07-08'),
(5, 'ALL Account', '2023-07-08'),
(6, 'Activities', '2023-07-08'),
(7, 'Sales', '2023-07-08'),
(8, 'Family and Products', '2023-07-08'),
(9, 'Usuarios', '2023-07-08');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `product`
--

CREATE TABLE `product` (
  `idProduct` int(11) NOT NULL,
  `Producto` char(36) NOT NULL,
  `FechaModificacion` datetime DEFAULT NULL,
  `Nombre` varchar(255) DEFAULT NULL,
  `Fabricante` varchar(255) DEFAULT NULL,
  `IdProducto` varchar(255) DEFAULT NULL,
  `PrecioListado` decimal(10,2) DEFAULT NULL,
  `Segmento` varchar(255) DEFAULT NULL,
  `ListaPreciosPredeterminada` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `product`
--

INSERT INTO `product` (`idProduct`, `Producto`, `FechaModificacion`, `Nombre`, `Fabricante`, `IdProducto`, `PrecioListado`, `Segmento`, `ListaPreciosPredeterminada`) VALUES
(1, '9a52656f-f216-ec11-b6e7-000d3a88538e', '2022-01-12 15:27:00', 'Project Server 2019', 'Microsoft', 'DG7GMGF0F4MH', 7613.88, 'Comercial', 'Microsoft'),
(2, 'd5f6bad5-3bbc-ec11-983f-000d3a8888a9', '2022-04-14 21:43:00', 'Cisco Umbrella Insights (1000-2499)', 'Otro', 'CISCOSINID', 42960.00, 'Comercial', 'Otros');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `codproducto` int(11) NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  `proveedor` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `existencia` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`codproducto`, `descripcion`, `proveedor`, `precio`, `existencia`, `usuario_id`) VALUES
(1, 'Laptop lenovo', 1, 1560.00, 49, 2),
(2, 'Televisor', 1, 2500.00, 79, 1),
(6, 'Impresora', 1, 800.00, 0, 1),
(7, 'Gaseosa', 3, 1500.00, 5, 1),
(0, 'ASDASDSA', 0, 0.00, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `ProductoId` char(36) NOT NULL,
  `FechaModificacion` datetime DEFAULT NULL,
  `Nombre` varchar(255) DEFAULT NULL,
  `Fabricante` varchar(255) DEFAULT NULL,
  `IdProducto` varchar(255) DEFAULT NULL,
  `PrecioListado` decimal(10,2) DEFAULT NULL,
  `Segmento` varchar(255) DEFAULT NULL,
  `ListaPreciosPredeterminada` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`ProductoId`, `FechaModificacion`, `Nombre`, `Fabricante`, `IdProducto`, `PrecioListado`, `Segmento`, `ListaPreciosPredeterminada`) VALUES
('9a52656f-f216-ec11-b6e7-000d3a88538e', '2022-01-12 15:27:00', 'Project Server 2019', 'Microsoft', 'DG7GMGF0F4MH', 7613.88, 'Comercial', 'Microsoft'),
('d5f6bad5-3bbc-ec11-983f-000d3a8888a9', '2022-04-14 21:43:00', 'Cisco Umbrella Insights (1000-2499)', 'Otro', 'CISCOSINID', 42960.00, 'Comercial', 'Otros');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

CREATE TABLE `proveedor` (
  `codproveedor` int(11) NOT NULL,
  `proveedor` varchar(100) NOT NULL,
  `contacto` varchar(100) NOT NULL,
  `telefono` int(11) NOT NULL,
  `direccion` varchar(100) NOT NULL,
  `usuario_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `proveedor`
--

INSERT INTO `proveedor` (`codproveedor`, `proveedor`, `contacto`, `telefono`, `direccion`, `usuario_id`) VALUES
(1, 'Open Services', '965432143', 9645132, 'Lima', 2),
(3, 'Lineo', '25804', 9865412, 'Lima', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `idrol` int(11) NOT NULL,
  `rol` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`idrol`, `rol`) VALUES
(1, 'Administrador'),
(20, 'Vendedor'),
(21, 'soporte'),
(23, 'Desarrollador');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rolxpermisos`
--

CREATE TABLE `rolxpermisos` (
  `id` int(11) NOT NULL,
  `idRol` int(11) DEFAULT NULL,
  `idPermisoArreglo` varchar(250) DEFAULT NULL,
  `crud` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rolxpermisos`
--

INSERT INTO `rolxpermisos` (`id`, `idRol`, `idPermisoArreglo`, `crud`) VALUES
(1, 1, '[1,2,3,4,5,6,7,8,9]', '[[1,2,3,4],[1,2,3,4],[1,2,3,4],[1,2,3,4],[1,2,3,4],[1,2,3,4],[1,2,3,4],[1,2,3,4],[1,2,3,4]]'),
(17, 20, '[1,3,6,7]', '[[1,2,3],[],[1,2,3],[],[],[1,2,3,4],[1,2,3],[],[]]'),
(18, 21, '[1,2,3]', '[[1,2,3,4],[1,2,3,4],[1,2,3,4],[],[],[],[],[],[]]'),
(20, 23, '[1,2,3,4,5,6,7]', '[[1,2,3,4],[2],[1,3,4],[2],[2],[1,2,3,4],[2],[],[]]');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sale`
--

CREATE TABLE `sale` (
  `id` int(11) NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Company` varchar(255) DEFAULT NULL,
  `Status` varchar(255) DEFAULT NULL,
  `Priority` varchar(255) DEFAULT NULL,
  `MRC` decimal(10,2) DEFAULT NULL,
  `Account Owner` varchar(255) DEFAULT NULL,
  `Detalle` text DEFAULT NULL,
  `Phone` varchar(255) DEFAULT NULL,
  `Expected Close` date DEFAULT NULL,
  `Added` datetime DEFAULT NULL,
  `Contacto Cliente` varchar(255) DEFAULT NULL,
  `FCV` date DEFAULT NULL,
  `One Shot` varchar(255) DEFAULT NULL,
  `Producto` varchar(255) DEFAULT NULL,
  `Propuesta` varchar(255) DEFAULT NULL,
  `Typesale` int(11) NOT NULL,
  `idUsuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sale`
--

INSERT INTO `sale` (`id`, `Name`, `Company`, `Status`, `Priority`, `MRC`, `Account Owner`, `Detalle`, `Phone`, `Expected Close`, `Added`, `Contacto Cliente`, `FCV`, `One Shot`, `Producto`, `Propuesta`, `Typesale`, `idUsuario`) VALUES
(28, 'Chamo', 'DSDS', 'Qualified', 'High', 121.00, 'User', 'sdsd', '1212121', '0000-00-00', '2023-07-11 17:41:50', 'asass', '0000-00-00', '10250 PEN', 'ddd', 'none', 0, 0),
(29, 'dsffdf', 'asdsd', 'Lead', 'High', 23131.00, 'sadfg', 'AS', '121', '2023-07-12', '2023-07-11 17:42:16', 'XS', '0000-00-00', '123 USD', 'ASA', 'reading-quiz-1-virtual-202211-avanzado-12-16-00-17-30_compress.pdf', 0, 0),
(31, 'DATA', 'ASASASA', 'Lead', 'High', 212121.00, 'ASASASA', 'SASASASA', '121212121', '2023-07-18', '2023-07-14 11:12:11', 'ASASASASASA', '2012-12-01', '12121 PEN', 'ASASASA', 'none', 0, 18);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sales`
--

CREATE TABLE `sales` (
  `id` int(11) NOT NULL,
  `Oportunidad` varchar(255) NOT NULL,
  `Status` varchar(50) DEFAULT NULL,
  `Priorit` varchar(50) DEFAULT NULL,
  `MRC` decimal(10,2) DEFAULT NULL,
  `Detalle` text DEFAULT NULL,
  `Added` datetime NOT NULL DEFAULT current_timestamp(),
  `Expected Close` date DEFAULT NULL,
  `FCV` float DEFAULT 0,
  `One Shot` decimal(10,2) DEFAULT NULL,
  `tipo` varchar(30) NOT NULL,
  `Producto` varchar(255) DEFAULT NULL,
  `Propuesta` varchar(255) DEFAULT NULL,
  `Typesale` varchar(50) DEFAULT NULL,
  `current_step` int(11) NOT NULL,
  `progress_width` int(11) NOT NULL,
  `idUsuario` int(11) DEFAULT NULL,
  `idCustomer` int(11) DEFAULT NULL,
  `idContact` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sales`
--

INSERT INTO `sales` (`id`, `Oportunidad`, `Status`, `Priorit`, `MRC`, `Detalle`, `Added`, `Expected Close`, `FCV`, `One Shot`, `tipo`, `Producto`, `Propuesta`, `Typesale`, `current_step`, `progress_width`, `idUsuario`, `idCustomer`, `idContact`) VALUES
(1, 'Office', 'Ganada', 'High', 12.00, 'Que tal', '2023-07-27 15:59:14', '2023-07-19', 12, 2500.00, 'PEN', 'Gama alta', 'arw3-midterm-exam-virtual-202109-avanzado-12-16-00-17-30_compress.pdf', '0', 4, 100, 1, 56, 20),
(2, 'ddddd', 'Negotiation', 'High', 122121.00, 'sss', '2023-07-27 15:59:14', '2023-08-04', 3213220, 12321.00, 'PEN', 'dasd', 'none', '0', 3, 75, 1, 58, 11),
(3, 'BORRAR', 'Lost', 'Medium', 120.00, 'esto es una prueba', '2023-07-27 15:59:14', '2023-07-19', 123, 205.00, 'PEN', 'nose', 'none', '0', 5, 125, 1, 56, 20),
(4, 'Licencias', 'Lead', 'High', 123.00, 'Gama alta', '2023-07-27 15:59:14', '2023-07-19', 1500, 2500.00, 'PEN', 'Licencias', 'none', '0', 0, 0, 23, 61, 23),
(5, 'PC', 'Qualified', 'Medium', 123.00, 'detalle', '2023-07-27 15:59:14', '2023-07-28', 5800, 5950.00, 'PEN', 'pc gamer', 'none', '0', 1, 25, 23, 62, 24),
(6, 'Tinta', 'Proposal', 'High', 1500.00, 'Canon', '2023-07-27 15:59:14', '2023-07-28', 50, 50.00, 'PEN', 'Tinta canon', 'none', '0', 2, 50, 23, 64, 26),
(7, 'Usb Kingston', 'Negotiation', 'Low', 15.00, 'USB de 128gb', '2023-07-27 15:59:14', '2023-07-28', 50, 80.00, 'PEN', 'Usb kingston', 'none', '0', 3, 75, 23, 65, 27),
(8, 'Impresoras', 'Ganada', 'High', 1500.00, '5 laptops edson', '2023-07-27 15:59:14', '2023-07-27', 150, 2500.00, 'PEN', 'Laptop EDSON X5', 'none', '0', 4, 100, 23, 66, 28),
(9, '500 celulares Samsung', 'Lost', 'Medium', 0.00, 'Gama alta S24', '2023-07-27 15:59:14', '2023-08-05', 5800, 5654.00, 'PEN', 'Samsung', 'none', '0', 5, 125, 23, 67, 29),
(10, 'Azure', 'Negotiation', 'Low', 1000.00, '2 VM para app de control de horario', '2023-07-27 15:59:14', '2023-07-03', 36000, 500.00, 'PEN', 'Azure a medida', 'none', '0', 3, 75, 23, 70, 33),
(11, 'CRM', 'Lost', 'High', 1025.00, 'ES UNA PRUEBA', '2023-07-27 15:59:14', '2023-08-05', 125, 125.00, 'PEN', 'CRM', 'none', '0', 5, 125, 23, 71, 35),
(12, 'PRUEBA', 'Lead', 'Medium', 123.00, 'aa', '2023-07-27 15:59:57', '2023-07-28', 12, 1.00, 'PEN', 'a', 'none', '0', 0, 0, 1, 63, 25),
(13, 'Licencia Business Standar', 'Lead', 'Medium', 0.00, '1 Licencia Business Standar', '2023-07-31 17:10:37', '2023-08-01', 150, 150.00, 'PEN', 'Licencia Business Standar', 'none', '0', 0, 0, 1, 73, 37),
(17, 'Licencias Office 365', 'ganada', 'High', 545.00, 'M365 Business Standard (36)\r\nM365 Business Basic (34)\r\nMicrosoft Cloud App Security', '2023-08-07 16:24:59', '2023-08-07', 7832.8, 1300.00, 'PEN', 'M365 Business Standard, M365 Business Basic y Microsoft Cloud App Security', 'Propuesta Técnico EconómicaV2.pdf', '0', 4, 100, 24, 76, 38),
(18, 'Licencia', 'Ganada', 'High', 200.00, '', '2023-08-07 22:41:50', '2023-08-07', 200, 200.00, 'PEN', 'lll', 'Propuesta Técnico EconómicaV2.pdf', '0', 4, 100, 24, 76, 38),
(19, 'Licencia Business Standard', 'Ganada', 'High', 0.00, 'Licencia Business Standard (1)', '2023-08-11 17:19:55', '2023-08-11', 150, 150.00, 'PEN', 'Licencia Business Standard', 'Mollehuaca.pdf', '0', 4, 100, 24, 74, 37),
(21, 'Licencia M365', 'Ganada', 'High', 0.00, '2 Lincencias Business Standard', '2023-08-14 17:29:31', '2023-08-14', 300, 300.00, 'USD', 'Lincencia Business Standard', 'mollehuaca.pdf', '0', 4, 100, 24, 74, 37),
(22, 'Licencia M365', 'Ganada', 'High', 0.00, '2 Lincencias Business Standard', '2023-08-14 17:29:33', '2023-08-14', 300, 300.00, 'USD', 'Lincencia Business Standard', 'mollehuaca.pdf', '0', 4, 100, 24, 74, 37),
(23, 'Licencia Project Plan 3', 'Ganada', 'High', 0.00, 'Licencia Project plan 3', '2023-08-14 17:31:46', '2023-08-14', 360, 360.00, 'USD', 'Licencia project plan 3 ', 'mollehuaca plan 3.pdf', '0', 4, 100, 24, 74, 37),
(24, 'Licencia Business estándar', 'Ganada', 'High', 0.00, 'Licencia business estandar (2)', '2023-08-14 20:41:12', '2023-08-14', 300, 300.00, 'USD', 'Licencia Business estándar ', 'Consult.pdf', '0', 4, 100, 24, 79, 37),
(25, 'Licencia Business Standard', 'Lost', 'High', 0.00, 'Licencia Business Standard (2)', '2023-08-14 20:52:04', '2023-08-14', 300, 300.00, 'USD', 'Licencia Business Standard', 'none', '0', 5, 125, 24, 79, 37),
(27, 'Office 365', 'Lost', 'High', 4510.00, 'M365 Business Basic (132)\r\nMicrosoft 365 E3 (4)\r\nVisio Plan 2 (1)\r\nExchange Online (Plan 1) (3)\r\nExchange Online (Plan 2) (4)\r\nPower Automate per user with attended RPA plan NCE MCY (1)\r\nProject Plan 3 (1)\r\nM365 Business Standard (20)\r\nPower BI Pro (39)', '2023-09-01 15:15:54', '2023-09-08', 54120, 0.00, 'PEN', 'Office 365', 'Propuesta Técnico Económica.pdf', '0', 5, 125, 24, 82, 45),
(28, 'Licencia Office 365', 'Ganada', 'High', 195.00, 'Licencia Business Basic (3)\r\nLicencia Business Standard (3)', '2023-09-04 19:57:22', '2023-09-04', 2333.52, 0.00, 'PEN', 'Licencia Business Standard, Licencia Business Basic', '04092023.pdf', '0', 4, 100, 24, 81, 38),
(29, 'Licencia Business Standard', 'Ganada', 'High', 0.00, 'Licencia Business Standard (4)', '2023-09-07 21:00:26', '2023-09-07', 600, 600.00, 'USD', 'Licencia Business Standard (4)', 'none', '0', 4, 100, 24, 74, 37),
(33, 'Licencias Business Basic', 'Ganada', 'Medium', 60.00, 'Licencia Business Basic', '2023-09-18 14:12:59', '2023-09-18', 720, 0.00, 'USD', '', '1865987-1 (1).pdf', '0', 4, 100, 24, 84, 38),
(34, 'Implementación AD', 'Proposal', 'High', 0.00, 'Implementación AD', '2023-09-18 15:41:06', '2023-09-18', 1300, 0.00, 'USD', '', 'Propuesta Técnico Económica 2806231032v1.pdf', '0', 2, 50, 24, 86, 49),
(35, 'Licencia Business Standard', 'qualified', 'High', 115.00, 'Microsoft 365 Empresa Estándar (10)- WOW / INGRAM MICRO', '2023-09-18 15:53:37', '2024-03-16', 1380, 0.00, 'USD', 'Business Standard', 'none', '0', 1, 25, 24, 87, 50),
(42, 'Plan Azure', 'Qualified', 'High', 370.00, 'Plan azure - WOW - Ingram', '2023-09-20 19:40:46', '2023-11-18', 4440, 0.00, 'USD', 'Plan Azure', 'none', '0', 1, 25, 24, 88, 51),
(43, 'Exchange online (Plan 1)', 'Lost', 'High', 200.00, 'Exchange online (Plan 1) 40 licencia - WOW - Ingram', '2023-09-20 19:45:37', '2023-10-01', 2400, 0.00, 'USD', 'Exchange online Plan 1', 'none', '0', 5, 125, 24, 89, 52),
(45, 'azure', 'ganada', 'High', 0.00, 'asas', '2023-09-22 15:42:31', '2023-09-27', 12, 21.00, 'PEN', '21', 'cobit.pdf', '0', 4, 100, 24, 85, 48),
(46, 'Despliegue VM', 'proposal', 'High', 0.00, 'Despliegue VM', '2023-09-22 16:55:18', '2023-10-02', 0, 100.00, 'USD', 'Azure', 'Propuesta Servicios Azure para INCA ONE v2.pdf', '0', 2, 50, 24, 85, 48),
(47, 'VM plataforma Azure', 'proposal', 'High', 367.00, 'VM plataforma Azure', '2023-09-22 16:58:13', '2023-10-02', 0, 367.00, 'USD', 'Azure', 'Propuesta Servicios Azure para INCA ONE v2.pdf', '0', 2, 50, 24, 85, 48),
(57, 'Licencia Business Standard ', 'Negotiation', 'High', 1816.00, 'Licencia Business Standard (44) ', '2023-09-26 16:54:08', '2023-09-28', 21791, 0.00, 'PEN', 'Licencia Business Standard ', 'Propuesta Técnico Económica v2.pdf', '0', 3, 75, 24, 92, 54),
(58, 'Licencia Business Basic', 'Negotiation', 'High', 872.00, 'Licencia Business Basic (44)', '2023-09-26 16:59:26', '2023-09-28', 10464, 0.00, 'PEN', 'Licencia Business Basic', 'Propuesta Técnico Económica v2.pdf', '0', 3, 75, 24, 92, 54),
(59, 'CERTIFICACION DE PUNTOS DE RED CATEGORIA A6', 'Lost', 'High', 0.00, 'CERTIFICACION DE PUNTOS DE RED CATEGORIA A6 ( 853)', '2023-09-26 17:14:20', '2023-09-29', 0, 8530.00, 'PEN', 'CERTIFICACION DE PUNTOS DE RED CATEGORIA A6', 'none', '0', 5, 125, 24, 91, 53),
(60, 'Licencia Business Standard', 'Negotiation', 'High', 0.00, 'Licencia Business Standard (1)', '2023-09-26 21:21:14', '2023-09-29', 0, 150.00, 'PEN', 'Licencia Business Standard', '26092023.pdf', '0', 3, 75, 24, 94, 37),
(61, 'LICENCIA POWER BI PRO ', 'Lead', 'High', 500.00, 'LICENCIA POWER BI PRO ( 100) ', '2023-09-29 16:01:06', '2023-10-15', 6000, 0.00, 'USD', 'LICENCIA POWER BI PRO (100) ', 'none', '0', 0, 0, 32, 96, 55),
(62, 'LICENCIA BUSINESS BASIC ', 'Lead', 'High', 0.00, 'LICENCIAS BUSINESS BASIC (100) ', '2023-09-29 16:34:27', '2023-09-30', 545, 1.00, 'USD', 'LICENCIA BUSINESS BASIC (100) ', 'none', '0', 0, 0, 32, 97, 56),
(64, 'OFFICE', 'Lead', 'High', 0.00, 'asas', '2023-10-02 15:04:17', '2023-10-02', 0, 0.00, 'PEN', 'office', 'none', '0', 0, 0, 33, 101, 57),
(65, 'LICENCIA BUSINESS BASIC ', 'Lead', 'High', 18.00, '', '2023-10-05 20:53:20', '2023-10-05', 216, 0.00, 'PEN', 'LICENCIA BUSINESS BASIC', 'none', '0', 0, 0, 32, 84, 38),
(66, 'LICENCIA BUSINESS BASIC Y LICENCIA BUSINESS STANDARD', 'Ganada', 'High', 31.00, 'LICENCIA BUSINESS BASIC (3) Y LICENCIA BUSINESS STANDARD(1)', '2023-10-05 21:00:45', '2023-10-05', 366, 0.00, 'USD', 'LICENCIA BUSINESS BASIC (3) Y LICENCIA BUSINESS STANDARD(1)', '041023.pdf', '0', 4, 100, 32, 84, 38),
(67, 'Windows Server', 'Negotiation', 'High', 0.00, 'Licencias Windows Server 2022 Standard -16 Core Licence Pack\r\nWindows Server 2022 Standard - 2 Core License Pack\r\nImplementación, Roles, SetUp, GPO, y Batch\r\nCapacitación\r\n', '2023-10-13 20:40:56', '2023-10-17', 6000, 0.00, 'USD', 'Windows Server', 'Propuesta Técnico Económica VM UCLACHv2.pdf', '0', 3, 75, 24, 86, 49),
(68, 'Licencias Office 365', 'qualified', 'High', 25.00, '', '2023-10-18 20:18:56', '0000-00-00', 25, 50.00, 'USD', 'Licencias Office 365 x5', 'ROL_PARCIAL_2023-2 Ercilia_21-09-2023_ (2).pdf', '0', 1, 25, 36, 108, 63),
(69, 'Discos solidos', 'Lead', 'High', 0.00, 'Discos solidos (10-15 unidades)', '2023-10-18 21:44:38', '2023-10-30', 0, 1000.00, 'PEN', 'Discos solidos', 'muni la punta.pdf', '0', 0, 0, 24, 109, 64),
(70, 'Demo', 'Lost', 'High', 500.00, 'a', '2023-10-19 14:18:55', '2023-10-19', 3, 3.00, 'PEN', 'prueba', 'none', '0', 5, 125, 37, 110, 65),
(71, 'Licencias Microsoft 365 ', 'Ganada', 'High', 0.00, 'Licencia Project plan 5 y Licencia Visio plan 2 ', '2023-10-20 18:13:02', '2023-10-23', 0, 6804.00, 'USD', 'Licencia Project plan 5 y Licencia Visio plan 2 ', 'Propuesta Técnico Económica- 1222201023.pdf', '0', 4, 100, 32, 111, 66),
(72, 'Licencias Business Standard', 'Ganada', 'High', 0.00, 'Licencia Business Standard (2)', '2023-10-27 16:37:53', '2023-10-27', 0, 250.00, 'USD', 'Microsoft 365', 'sankaku.pdf', '0', 4, 100, 24, 74, 37),
(73, 'Licencia Business Standard', 'Ganada', 'High', 0.00, 'Licencia Business  Standard (1)', '2023-10-27 16:40:20', '2023-10-27', 0, 88.00, 'USD', 'Licencia Business Standard', 'mollehuaca.pdf', '0', 4, 100, 24, 74, 37),
(74, 'VOIP', 'lost', 'High', 2000.00, 'demo', '2023-11-30 23:23:09', '2023-12-09', 50000, 1999.00, 'PEN', 'Telefonia VOIP', 'none', '0', 5, 125, 35, 113, 68),
(75, 'Licencia 365', 'Lost', 'Medium', 100.00, 'Este contacto es un conocido', '2024-01-30 17:00:45', '2024-02-01', 4000, 4000.00, 'PEN', 'Licencias de office', 'none', '0', 5, 125, 35, 116, 71);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `segment`
--

CREATE TABLE `segment` (
  `idSegment` int(11) NOT NULL,
  `marca` varchar(255) DEFAULT NULL,
  `fecha_De_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `segment`
--

INSERT INTO `segment` (`idSegment`, `marca`, `fecha_De_registro`) VALUES
(2, 'Empresa', '2023-06-07 16:55:48'),
(3, 'Gobierno', '2023-06-07 16:55:48'),
(4, 'Regional', '2024-01-30 11:53:33');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `typecustomer`
--

CREATE TABLE `typecustomer` (
  `idtypecustomer` int(11) NOT NULL,
  `type` int(11) DEFAULT NULL,
  `COD_idCliente` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `typecustomer`
--

INSERT INTO `typecustomer` (`idtypecustomer`, `type`, `COD_idCliente`) VALUES
(16, 1, 70),
(18, 2, 72),
(20, 1, 74),
(21, 1, 75),
(22, 1, 76),
(23, 1, 77),
(24, 1, 78),
(25, 1, 79),
(27, 1, 81),
(28, 1, 82),
(29, 1, 83),
(30, 1, 84),
(31, 1, 85),
(32, 1, 86),
(33, 1, 87),
(34, 1, 88),
(35, 1, 89),
(36, 1, 90),
(37, 1, 91),
(38, 1, 92),
(39, 1, 93),
(40, 1, 94),
(41, 2, 95),
(42, 1, 96),
(43, 1, 97),
(44, 1, 98),
(45, 1, 99),
(46, 1, 100),
(47, 1, 101),
(48, 1, 102),
(49, 1, 103),
(50, 1, 104),
(51, 1, 105),
(52, 2, 106),
(53, 1, 107),
(54, 2, 108),
(55, 1, 109),
(56, 1, 110),
(57, 1, 111),
(58, 1, 112),
(59, 1, 113),
(60, 1, 114),
(61, 1, 115),
(62, 1, 116);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `idusuario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `usuario` varchar(20) NOT NULL,
  `clave` varchar(50) NOT NULL,
  `rol` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`idusuario`, `nombre`, `correo`, `usuario`, `clave`, `rol`) VALUES
(1, 'Admin', 'christian.ochoa@outlook.com', 'admin', '34825fe02878998a888e785ccc18d6be', 1),
(9, 'bruno', 'bpineda@virtualbusiness.pe', 'Administrador', '21232f297a57a5a743894a0e4a801fc3', 1),
(10, 'veneco', 'veneco@gmail.com', 'veneco', '8c6e2d3b12029c208f561db58ee14a6a', 4),
(11, 'leonel', 'leonel@gmail.com', 'leonel', 'd94d81a75c0e8c0aef4e46a08206426b', 7),
(12, 'Cliente1', 'cliente1@gmail.com', 'Cliente1', '4ed7af2716d54b59a95f34a6e34bdd74', 2),
(13, 'Cliente2', 'Cliente2@gmail.com', 'Cliente2', 'e939e2f874864613df50ac43fba2c83c', 8),
(15, 'Cliente4', 'Cliente4@gmail.com', 'Cliente4', '39f60dd4e0112539596e14fe2f053ff6', 14),
(16, 'ClienteFinal', 'ClienteFinal@gmail.com', 'ClienteFinal', 'db47bbb203a6c1b9e4b609084ed15f22', 15),
(17, 'ClienteFinal1', 'ClienteFinal1@gmail.com', 'ClienteFinal1', '49a548346f5fd5488cb953d1de286a5b', 16),
(18, 'usuario', 'usuario@gmail.com', 'usuario', 'f8032d5cae3de20fcec887f395ec9a6a', 17),
(19, 'Cliente51', 'Cliente5@gmail.com', 'Cliente51', '0754bd031cb743f0d11a5ed24f3c45d2', 18),
(21, 'mereceserborrado', 'mereceserborrado@gmail.com', 'mereceserborrado', 'e5447ba89071e0f34514a9607e66fbdc', 18),
(22, 'ClienteVendedor', 'ClienteVendedor@gmail.com', 'ClienteVendedor', '11efd2078030ddd9e3a1728de934b2c3', 19),
(24, 'Mia Arecco', 'marecco@virtualbusiness.pe', 'marecco', 'e527f221e69aa841901b60b0d910074b', 1),
(25, 'Francisco', 'Francisco.joyo@gmail.com', 'FJoyo', '71b040fff3d6c22442efb05c6402b689', 20),
(26, 'test12', 'asasasa@gmail.com', 'Admin1', '263bce650e68ab4e23f28263760b9fa5', 2),
(28, 'test1', 'test@gmail.com', 'asasa', '263bce650e68ab4e23f28263760b9fa5', 3),
(30, 'dsadsad', 'dsadas@gmail.com', 'Admin1', 'e00cf25ad42683b3df678c61f42c6bda', 2),
(32, 'Angela Israel', 'angela.israel@virtualbusiness.pe', 'aisrael', '54f9f56e93aa0054ab58b6c62d4814b3', 1),
(33, 'Bruno', 'fafafg@gmail.com', 'Admin3', '263bce650e68ab4e23f28263760b9fa5', 20),
(34, 'Admin4', 'Admin4@gmail.com', 'Admin4', '263bce650e68ab4e23f28263760b9fa5', 20),
(35, 'Bruno', 'Bruno@gmail.com', 'Admin5', '263bce650e68ab4e23f28263760b9fa5', 1),
(37, 'PaquitoAlcachofa', 'PaquitoAlcachofa@PaquitoAlcachofa.com', 'PaquitoAlcachofa', '99afe00a250fe12c7fa2c9bee4231847', 20),
(38, 'DANIEL', 'daniel@claro.com', 'DANIEL132', 'b58a4a5ce417d2315814e8baa7b1cbc0', 1),
(39, 'Jose Crispin', 'jose1@gmail.com', 'JoseCrispin', 'bd71ce76f63539d257e74b50b8caf9ef', 20),
(40, 'Joel', 'Joel@gmail.com', 'joel', 'c000ccf225950aac2a082a59ac5e57ff', 23);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`idAccount`);

--
-- Indices de la tabla `activities`
--
ALTER TABLE `activities`
  ADD PRIMARY KEY (`idActivities`),
  ADD KEY `COD_idContact` (`COD_idContact`),
  ADD KEY `COD_idAccount` (`COD_idAccount`);

--
-- Indices de la tabla `allproduct`
--
ALTER TABLE `allproduct`
  ADD PRIMARY KEY (`idAllproduct`);

--
-- Indices de la tabla `api`
--
ALTER TABLE `api`
  ADD PRIMARY KEY (`idapi`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`idcliente`);

--
-- Indices de la tabla `collections`
--
ALTER TABLE `collections`
  ADD PRIMARY KEY (`idCollections`),
  ADD KEY `CODidcustomer` (`CODidcustomer`);

--
-- Indices de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`idContacts`);

--
-- Indices de la tabla `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`idCliente`);

--
-- Indices de la tabla `eventos`
--
ALTER TABLE `eventos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `COD_idrol` (`COD_idrol`);

--
-- Indices de la tabla `eventos1`
--
ALTER TABLE `eventos1`
  ADD PRIMARY KEY (`id`),
  ADD KEY `COD_idrol` (`COD_idrol`);

--
-- Indices de la tabla `family&products`
--
ALTER TABLE `family&products`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `files`
--
ALTER TABLE `files`
  ADD PRIMARY KEY (`id`),
  ADD KEY `COD_idCollections` (`COD_idCollections`);

--
-- Indices de la tabla `files_sales`
--
ALTER TABLE `files_sales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `COD_idSales` (`COD_idSales`);

--
-- Indices de la tabla `file_sales`
--
ALTER TABLE `file_sales`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `maker`
--
ALTER TABLE `maker`
  ADD PRIMARY KEY (`idFabricante`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`idProduct`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`idrol`);

--
-- Indices de la tabla `rolxpermisos`
--
ALTER TABLE `rolxpermisos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idRol` (`idRol`);

--
-- Indices de la tabla `sale`
--
ALTER TABLE `sale`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `segment`
--
ALTER TABLE `segment`
  ADD PRIMARY KEY (`idSegment`);

--
-- Indices de la tabla `typecustomer`
--
ALTER TABLE `typecustomer`
  ADD PRIMARY KEY (`idtypecustomer`),
  ADD KEY `COD_idCliente` (`COD_idCliente`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idusuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `account`
--
ALTER TABLE `account`
  MODIFY `idAccount` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=226;

--
-- AUTO_INCREMENT de la tabla `activities`
--
ALTER TABLE `activities`
  MODIFY `idActivities` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `allproduct`
--
ALTER TABLE `allproduct`
  MODIFY `idAllproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=735;

--
-- AUTO_INCREMENT de la tabla `collections`
--
ALTER TABLE `collections`
  MODIFY `idCollections` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT de la tabla `contacts`
--
ALTER TABLE `contacts`
  MODIFY `idContacts` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT de la tabla `customers`
--
ALTER TABLE `customers`
  MODIFY `idCliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=117;

--
-- AUTO_INCREMENT de la tabla `eventos`
--
ALTER TABLE `eventos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `eventos1`
--
ALTER TABLE `eventos1`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT de la tabla `family&products`
--
ALTER TABLE `family&products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT de la tabla `files`
--
ALTER TABLE `files`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `files_sales`
--
ALTER TABLE `files_sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `file_sales`
--
ALTER TABLE `file_sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=130;

--
-- AUTO_INCREMENT de la tabla `maker`
--
ALTER TABLE `maker`
  MODIFY `idFabricante` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `product`
--
ALTER TABLE `product`
  MODIFY `idProduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `idrol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `rolxpermisos`
--
ALTER TABLE `rolxpermisos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `sale`
--
ALTER TABLE `sale`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT de la tabla `sales`
--
ALTER TABLE `sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT de la tabla `segment`
--
ALTER TABLE `segment`
  MODIFY `idSegment` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `typecustomer`
--
ALTER TABLE `typecustomer`
  MODIFY `idtypecustomer` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `activities`
--
ALTER TABLE `activities`
  ADD CONSTRAINT `activities_ibfk_1` FOREIGN KEY (`COD_idContact`) REFERENCES `contacts` (`idContacts`),
  ADD CONSTRAINT `activities_ibfk_2` FOREIGN KEY (`COD_idAccount`) REFERENCES `account` (`idAccount`);

--
-- Filtros para la tabla `eventos`
--
ALTER TABLE `eventos`
  ADD CONSTRAINT `eventos_ibfk_1` FOREIGN KEY (`COD_idrol`) REFERENCES `rol` (`idrol`);

--
-- Filtros para la tabla `eventos1`
--
ALTER TABLE `eventos1`
  ADD CONSTRAINT `eventos1_ibfk_1` FOREIGN KEY (`COD_idrol`) REFERENCES `rol` (`idrol`);

--
-- Filtros para la tabla `files_sales`
--
ALTER TABLE `files_sales`
  ADD CONSTRAINT `files_sales_ibfk_1` FOREIGN KEY (`COD_idSales`) REFERENCES `sale` (`id`);

--
-- Filtros para la tabla `rolxpermisos`
--
ALTER TABLE `rolxpermisos`
  ADD CONSTRAINT `rolxpermisos_ibfk_1` FOREIGN KEY (`idRol`) REFERENCES `rol` (`idrol`);

--
-- Filtros para la tabla `typecustomer`
--
ALTER TABLE `typecustomer`
  ADD CONSTRAINT `typecustomer_ibfk_1` FOREIGN KEY (`COD_idCliente`) REFERENCES `customers` (`idCliente`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
