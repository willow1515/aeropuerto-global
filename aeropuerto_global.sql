-- Base de datos: aeropuerto_global_db  (20 tablas, 10 atributos cada una, PK incluida)
-- Importar en phpMyAdmin > pestaña SQL > pegar > Continuar
CREATE DATABASE IF NOT EXISTS aeropuerto_global_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE aeropuerto_global_db;

CREATE TABLE paises (
  id_pais INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL UNIQUE,
  codigo_iso CHAR(2) NOT NULL UNIQUE,
  continente VARCHAR(30) NOT NULL,
  capital VARCHAR(80) NOT NULL,
  idioma_oficial VARCHAR(50) NOT NULL,
  moneda VARCHAR(40) NOT NULL,
  poblacion BIGINT NOT NULL,
  prefijo_telefonico VARCHAR(8) NOT NULL,
  zona_horaria VARCHAR(40) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE ciudades (
  id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
  id_pais INT NOT NULL,
  nombre VARCHAR(80) NOT NULL,
  region VARCHAR(80) NOT NULL,
  latitud DECIMAL(9,6) NOT NULL,
  longitud DECIMAL(9,6) NOT NULL,
  poblacion INT NOT NULL,
  altitud_m INT NOT NULL,
  zona_horaria VARCHAR(40) NOT NULL,
  codigo_postal VARCHAR(12) NULL,
  FOREIGN KEY (id_pais) REFERENCES paises(id_pais)
) ENGINE=InnoDB;

CREATE TABLE aeropuertos (
  id_aeropuerto INT AUTO_INCREMENT PRIMARY KEY,
  id_ciudad INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  codigo_iata CHAR(3) NOT NULL UNIQUE,
  codigo_icao CHAR(4) NOT NULL UNIQUE,
  categoria VARCHAR(30) NOT NULL,
  num_pistas SMALLINT NOT NULL,
  num_terminales SMALLINT NOT NULL,
  fecha_inauguracion DATE NOT NULL,
  telefono VARCHAR(25) NOT NULL,
  FOREIGN KEY (id_ciudad) REFERENCES ciudades(id_ciudad)
) ENGINE=InnoDB;

CREATE TABLE terminales (
  id_terminal INT AUTO_INCREMENT PRIMARY KEY,
  id_aeropuerto INT NOT NULL,
  nombre VARCHAR(60) NOT NULL,
  tipo VARCHAR(30) NOT NULL,
  num_puertas SMALLINT NOT NULL,
  capacidad_pasajeros INT NOT NULL,
  area_m2 INT NOT NULL,
  estado VARCHAR(20) NOT NULL,
  fecha_apertura DATE NOT NULL,
  observaciones TEXT NULL,
  FOREIGN KEY (id_aeropuerto) REFERENCES aeropuertos(id_aeropuerto)
) ENGINE=InnoDB;

CREATE TABLE puertas_embarque (
  id_puerta INT AUTO_INCREMENT PRIMARY KEY,
  id_terminal INT NOT NULL,
  codigo VARCHAR(10) NOT NULL,
  tipo VARCHAR(30) NOT NULL,
  tiene_pasarela TINYINT NOT NULL,
  capacidad_maxima SMALLINT NOT NULL,
  estado VARCHAR(20) NOT NULL,
  piso SMALLINT NOT NULL,
  fecha_mantenimiento DATE NOT NULL,
  observaciones TEXT NULL,
  FOREIGN KEY (id_terminal) REFERENCES terminales(id_terminal)
) ENGINE=InnoDB;

CREATE TABLE aerolineas (
  id_aerolinea INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL UNIQUE,
  codigo_iata CHAR(2) NOT NULL UNIQUE,
  codigo_icao CHAR(3) NOT NULL UNIQUE,
  id_pais INT NOT NULL,
  fecha_fundacion DATE NOT NULL,
  sitio_web VARCHAR(120) NOT NULL,
  telefono VARCHAR(25) NOT NULL,
  email_contacto VARCHAR(120) NOT NULL,
  estado VARCHAR(20) NOT NULL,
  FOREIGN KEY (id_pais) REFERENCES paises(id_pais)
) ENGINE=InnoDB;

CREATE TABLE modelos_avion (
  id_modelo INT AUTO_INCREMENT PRIMARY KEY,
  fabricante VARCHAR(50) NOT NULL,
  nombre_modelo VARCHAR(50) NOT NULL,
  capacidad_pasajeros SMALLINT NOT NULL,
  alcance_km INT NOT NULL,
  velocidad_crucero_kmh SMALLINT NOT NULL,
  longitud_m DECIMAL(5,2) NOT NULL,
  envergadura_m DECIMAL(5,2) NOT NULL,
  num_motores SMALLINT NOT NULL,
  anio_lanzamiento SMALLINT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE aviones (
  id_avion INT AUTO_INCREMENT PRIMARY KEY,
  id_modelo INT NOT NULL,
  id_aerolinea INT NOT NULL,
  matricula VARCHAR(15) NOT NULL UNIQUE,
  fecha_fabricacion DATE NOT NULL,
  fecha_ultimo_mantenimiento DATE NOT NULL,
  horas_vuelo INT NOT NULL,
  estado VARCHAR(20) NOT NULL,
  num_asientos SMALLINT NOT NULL,
  capacidad_carga_kg INT NOT NULL,
  FOREIGN KEY (id_modelo) REFERENCES modelos_avion(id_modelo),
  FOREIGN KEY (id_aerolinea) REFERENCES aerolineas(id_aerolinea)
) ENGINE=InnoDB;

CREATE TABLE rutas (
  id_ruta INT AUTO_INCREMENT PRIMARY KEY,
  id_origen INT NOT NULL,
  id_destino INT NOT NULL,
  id_aerolinea INT NOT NULL,
  distancia_km INT NOT NULL,
  duracion_min INT NOT NULL,
  frecuencia_semanal SMALLINT NOT NULL,
  estado VARCHAR(20) NOT NULL,
  fecha_creacion DATE NOT NULL,
  observaciones TEXT NULL,
  FOREIGN KEY (id_origen) REFERENCES aeropuertos(id_aeropuerto),
  FOREIGN KEY (id_destino) REFERENCES aeropuertos(id_aeropuerto),
  FOREIGN KEY (id_aerolinea) REFERENCES aerolineas(id_aerolinea)
) ENGINE=InnoDB;

CREATE TABLE vuelos (
  id_vuelo INT AUTO_INCREMENT PRIMARY KEY,
  numero_vuelo VARCHAR(10) NOT NULL,
  id_ruta INT NOT NULL,
  id_avion INT NOT NULL,
  id_puerta INT NULL,
  fecha_salida DATETIME NOT NULL,
  fecha_llegada DATETIME NOT NULL,
  estado VARCHAR(20) NOT NULL,
  precio_base DECIMAL(10,2) NOT NULL,
  observaciones TEXT NULL,
  FOREIGN KEY (id_ruta) REFERENCES rutas(id_ruta),
  FOREIGN KEY (id_avion) REFERENCES aviones(id_avion),
  FOREIGN KEY (id_puerta) REFERENCES puertas_embarque(id_puerta)
) ENGINE=InnoDB;

CREATE TABLE pasajeros (
  id_pasajero INT AUTO_INCREMENT PRIMARY KEY,
  nombres VARCHAR(80) NOT NULL,
  apellidos VARCHAR(80) NOT NULL,
  tipo_documento VARCHAR(20) NOT NULL,
  documento VARCHAR(30) NOT NULL UNIQUE,
  fecha_nacimiento DATE NOT NULL,
  id_pais INT NOT NULL,
  email VARCHAR(120) NOT NULL,
  telefono VARCHAR(25) NOT NULL,
  direccion VARCHAR(150) NOT NULL,
  FOREIGN KEY (id_pais) REFERENCES paises(id_pais)
) ENGINE=InnoDB;

CREATE TABLE clases_tarifa (
  id_clase INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(40) NOT NULL UNIQUE,
  descripcion VARCHAR(150) NULL,
  equipaje_kg SMALLINT NOT NULL,
  permite_cambios TINYINT NOT NULL,
  reembolsable TINYINT NOT NULL,
  comidas_incluidas TINYINT NOT NULL,
  millas_otorgadas INT NOT NULL,
  multiplicador_precio DECIMAL(4,2) NOT NULL,
  estado VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE reservas (
  id_reserva INT AUTO_INCREMENT PRIMARY KEY,
  id_pasajero INT NOT NULL,
  id_vuelo INT NOT NULL,
  id_clase INT NOT NULL,
  codigo_reserva VARCHAR(10) NOT NULL UNIQUE,
  fecha_reserva DATETIME NOT NULL,
  asiento VARCHAR(5) NOT NULL,
  estado VARCHAR(20) NOT NULL,
  precio_total DECIMAL(10,2) NOT NULL,
  observaciones TEXT NULL,
  FOREIGN KEY (id_pasajero) REFERENCES pasajeros(id_pasajero),
  FOREIGN KEY (id_vuelo) REFERENCES vuelos(id_vuelo),
  FOREIGN KEY (id_clase) REFERENCES clases_tarifa(id_clase)
) ENGINE=InnoDB;

CREATE TABLE equipaje (
  id_equipaje INT AUTO_INCREMENT PRIMARY KEY,
  id_reserva INT NOT NULL,
  peso_kg DECIMAL(5,2) NOT NULL,
  tipo VARCHAR(30) NOT NULL,
  etiqueta VARCHAR(20) NOT NULL UNIQUE,
  descripcion VARCHAR(150) NULL,
  estado VARCHAR(20) NOT NULL,
  fecha_registro DATETIME NOT NULL,
  es_fragil TINYINT NOT NULL,
  valor_declarado DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva)
) ENGINE=InnoDB;

CREATE TABLE empleados (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  id_aeropuerto INT NOT NULL,
  nombres VARCHAR(80) NOT NULL,
  apellidos VARCHAR(80) NOT NULL,
  documento VARCHAR(30) NOT NULL UNIQUE,
  cargo VARCHAR(50) NOT NULL,
  fecha_ingreso DATE NOT NULL,
  salario DECIMAL(10,2) NOT NULL,
  telefono VARCHAR(25) NOT NULL,
  email VARCHAR(120) NOT NULL,
  FOREIGN KEY (id_aeropuerto) REFERENCES aeropuertos(id_aeropuerto)
) ENGINE=InnoDB;

CREATE TABLE tripulacion (
  id_tripulante INT AUTO_INCREMENT PRIMARY KEY,
  id_empleado INT NOT NULL,
  id_vuelo INT NOT NULL,
  rol VARCHAR(40) NOT NULL,
  num_licencia VARCHAR(30) NOT NULL,
  fecha_vencimiento_licencia DATE NOT NULL,
  horas_vuelo INT NOT NULL,
  idiomas VARCHAR(80) NOT NULL,
  estado VARCHAR(20) NOT NULL,
  observaciones TEXT NULL,
  FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
  FOREIGN KEY (id_vuelo) REFERENCES vuelos(id_vuelo)
) ENGINE=InnoDB;

CREATE TABLE mantenimientos (
  id_mantenimiento INT AUTO_INCREMENT PRIMARY KEY,
  id_avion INT NOT NULL,
  id_empleado INT NOT NULL,
  tipo VARCHAR(40) NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NULL,
  descripcion TEXT NOT NULL,
  costo DECIMAL(12,2) NOT NULL,
  estado VARCHAR(20) NOT NULL,
  observaciones TEXT NULL,
  FOREIGN KEY (id_avion) REFERENCES aviones(id_avion),
  FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
) ENGINE=InnoDB;

CREATE TABLE combustible (
  id_carga INT AUTO_INCREMENT PRIMARY KEY,
  id_avion INT NOT NULL,
  id_aeropuerto INT NOT NULL,
  id_empleado INT NOT NULL,
  fecha_carga DATETIME NOT NULL,
  litros DECIMAL(10,2) NOT NULL,
  tipo_combustible VARCHAR(30) NOT NULL,
  precio_litro DECIMAL(8,2) NOT NULL,
  proveedor VARCHAR(80) NOT NULL,
  observaciones TEXT NULL,
  FOREIGN KEY (id_avion) REFERENCES aviones(id_avion),
  FOREIGN KEY (id_aeropuerto) REFERENCES aeropuertos(id_aeropuerto),
  FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
) ENGINE=InnoDB;

CREATE TABLE incidentes (
  id_incidente INT AUTO_INCREMENT PRIMARY KEY,
  id_vuelo INT NOT NULL,
  id_empleado INT NOT NULL,
  tipo VARCHAR(40) NOT NULL,
  gravedad VARCHAR(20) NOT NULL,
  fecha_hora DATETIME NOT NULL,
  descripcion TEXT NOT NULL,
  accion_tomada TEXT NULL,
  estado VARCHAR(20) NOT NULL,
  fecha_cierre DATE NULL,
  FOREIGN KEY (id_vuelo) REFERENCES vuelos(id_vuelo),
  FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
) ENGINE=InnoDB;

CREATE TABLE pagos (
  id_pago INT AUTO_INCREMENT PRIMARY KEY,
  id_reserva INT NOT NULL,
  monto DECIMAL(10,2) NOT NULL,
  moneda CHAR(3) NOT NULL,
  metodo VARCHAR(30) NOT NULL,
  fecha_pago DATETIME NOT NULL,
  estado VARCHAR(20) NOT NULL,
  referencia VARCHAR(40) NOT NULL UNIQUE,
  banco VARCHAR(60) NULL,
  observaciones TEXT NULL,
  FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva)
) ENGINE=InnoDB;
