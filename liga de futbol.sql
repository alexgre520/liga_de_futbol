-- Crear la base de datos
DROP DATABASE IF EXISTS liga_de_futbol;
CREATE DATABASE liga_de_futbol;
USE liga_de_futbol;

-- Tabla ligas
CREATE TABLE ligas (
  id_liga INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  pais VARCHAR(50)
);

-- Tabla equipos
CREATE TABLE equipos (
  id_equipo INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  ciudad VARCHAR(50),
  id_liga INT,
  FOREIGN KEY (id_liga) REFERENCES ligas(id_liga)
);

-- Tabla jugadores
CREATE TABLE jugadores (
  id_jugador INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  edad INT,
  posicion VARCHAR(50),
  id_equipo INT,
  FOREIGN KEY (id_equipo) REFERENCES equipos(id_equipo)
);

-- Tabla arbitros
CREATE TABLE arbitros (
  id_arbitro INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  experiencia INT
);

-- Tabla partidos
CREATE TABLE partidos (
  id_partido INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATE,
  id_local INT,
  id_visitante INT,
  id_liga INT,
  FOREIGN KEY (id_local) REFERENCES equipos(id_equipo),
  FOREIGN KEY (id_visitante) REFERENCES equipos(id_equipo),
  FOREIGN KEY (id_liga) REFERENCES ligas(id_liga)
);

-- Tabla arbitros_partidos
CREATE TABLE arbitros_partidos (
  id_arbitro INT,
  id_partido INT,
  PRIMARY KEY (id_arbitro, id_partido),
  FOREIGN KEY (id_arbitro) REFERENCES arbitros(id_arbitro),
  FOREIGN KEY (id_partido) REFERENCES partidos(id_partido)
);

-- Tabla goles
CREATE TABLE goles (
  id_gol INT AUTO_INCREMENT PRIMARY KEY,
  id_partido INT,
  id_jugador INT,
  minuto INT,
  FOREIGN KEY (id_partido) REFERENCES partidos(id_partido),
  FOREIGN KEY (id_jugador) REFERENCES jugadores(id_jugador)
);

-- Tabla tarjetas
CREATE TABLE tarjetas (
  id_tarjeta INT AUTO_INCREMENT PRIMARY KEY,
  id_partido INT,
  id_jugador INT,
  tipo VARCHAR(10),
  minuto INT,
  FOREIGN KEY (id_partido) REFERENCES partidos(id_partido),
  FOREIGN KEY (id_jugador) REFERENCES jugadores(id_jugador)
);

-- Tabla clasificacion
CREATE TABLE clasificacion (
  id_clasificacion INT AUTO_INCREMENT PRIMARY KEY,
  id_liga INT,
  id_equipo INT,
  puntos INT,
  goles_favor INT,
  goles_contra INT,
  FOREIGN KEY (id_liga) REFERENCES ligas(id_liga),
  FOREIGN KEY (id_equipo) REFERENCES equipos(id_equipo)
);

-- Insertar en ligas
INSERT INTO ligas (nombre, pais) VALUES 
('La Liga', 'España'),
('Premier League', 'Inglaterra'),
('Serie A', 'Italia');

-- Insertar en equipos
INSERT INTO equipos (nombre, ciudad, id_liga) VALUES 
('Grupo Pérez S.L.', 'Murcia', 2),
('Consultores López y Asociados', 'Parla', 2),
('Servicios Martínez', 'Ourense', 2),
('Tecnología Sánchez', 'Barcelona', 3),
('Industrias García', 'Zaragoza', 3),
('Distribuciones Rodríguez', 'Sevilla', 1);

-- Insertar en jugadores
INSERT INTO jugadores (nombre, edad, posicion, id_equipo) VALUES 
('Carlos Gómez', 23, 'Delantero', 1),
('Luis Fernández', 30, 'Centrocampista', 1),
('Pedro López', 27, 'Defensa', 2),
('Jorge Torres', 22, 'Portero', 2),
('David Martín', 25, 'Delantero', 3),
('Raúl Jiménez', 29, 'Defensa', 3),
('Miguel Díaz', 21, 'Centrocampista', 4),
('Antonio Romero', 24, 'Portero', 4),
('Javier Navarro', 28, 'Delantero', 5),
('Andrés Sánchez', 26, 'Centrocampista', 6);

-- Insertar en árbitros
INSERT INTO arbitros (nombre, experiencia) VALUES 
('Álvaro Moreno', 10),
('Fernando Ruiz', 12),
('Julián Prieto', 8),
('Samuel Delgado', 15),
('Iván Blanco', 5);

-- Insertar en partidos
INSERT INTO partidos (fecha, id_local, id_visitante, id_liga) VALUES 
('2024-08-01', 1, 2, 2),
('2024-08-03', 3, 4, 3),
('2024-08-05', 5, 6, 3),
('2024-08-07', 2, 5, 2),
('2024-08-10', 4, 1, 1);

-- Insertar en árbitros_partidos
INSERT INTO arbitros_partidos (id_arbitro, id_partido) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Insertar en goles
INSERT INTO goles (id_partido, id_jugador, minuto) VALUES 
(1, 1, 15),
(2, 3, 30),
(3, 5, 45),
(4, 7, 60),
(5, 9, 75);

-- Insertar en tarjetas
INSERT INTO tarjetas (id_partido, id_jugador, tipo, minuto) VALUES 
(1, 2, 'amarilla', 20),
(2, 4, 'roja', 35),
(3, 6, 'amarilla', 55),
(4, 8, 'amarilla', 70),
(5, 10, 'roja', 85);

-- Insertar en clasificacion
INSERT INTO clasificacion (id_liga, id_equipo, puntos, goles_favor, goles_contra) VALUES 
(2, 1, 10, 5, 3),
(2, 2, 8, 4, 2),
(2, 3, 6, 3, 3),
(3, 4, 7, 2, 4),
(3, 5, 4, 1, 3),
(1, 6, 9, 4, 1);

-- Vistas
-- Vista 1: Jugadores mayores de 25 años
CREATE VIEW jugadores_mayores_25 AS
SELECT * FROM jugadores WHERE edad > 25;

-- Vista 2: Clasificación ordenada por puntos
CREATE VIEW clasificacion_ordenada AS
SELECT * FROM clasificacion ORDER BY puntos DESC;

-- Vista 3: Goles por jugador
CREATE VIEW goles_por_jugador AS
SELECT j.nombre, COUNT(g.id_gol) AS goles
FROM jugadores j
LEFT JOIN goles g ON j.id_jugador = g.id_jugador
GROUP BY j.id_jugador, j.nombre;

-- Vista 4: Partidos con sus árbitros
CREATE VIEW partidos_con_arbitros AS
SELECT p.id_partido, a.nombre AS arbitro, p.fecha
FROM partidos p
JOIN arbitros_partidos ap ON p.id_partido = ap.id_partido
JOIN arbitros a ON ap.id_arbitro = a.id_arbitro;

-- Vista 5: Equipos con su liga
CREATE VIEW equipos_con_liga AS
SELECT e.nombre AS equipo, l.nombre AS liga, l.pais
FROM equipos e
JOIN ligas l ON e.id_liga = l.id_liga;

-- Vista 6: Goles por partido
CREATE VIEW goles_por_partido AS
SELECT p.id_partido, COUNT(g.id_gol) AS total_goles
FROM partidos p
LEFT JOIN goles g ON p.id_partido = g.id_partido
GROUP BY p.id_partido;

-- Vista 7: Tarjetas rojas por jugador
CREATE VIEW tarjetas_rojas_por_jugador AS
SELECT j.nombre, COUNT(t.id_tarjeta) AS rojas
FROM jugadores j
JOIN tarjetas t ON j.id_jugador = t.id_jugador
WHERE t.tipo = 'roja'
GROUP BY j.id_jugador, j.nombre;

-- Vista 8: Jugadores y sus equipos
CREATE VIEW jugadores_con_equipos AS
SELECT j.nombre AS jugador, e.nombre AS equipo
FROM jugadores j
JOIN equipos e ON j.id_equipo = e.id_equipo;

-- Vista 9: Árbitros con más de 10 años de experiencia
CREATE VIEW arbitros_experimentados AS
SELECT * FROM arbitros WHERE experiencia > 10;

-- Vista 10: Promedio de edad por equipo
CREATE VIEW edad_promedio_equipos AS
SELECT e.nombre AS equipo, AVG(j.edad) AS edad_promedio
FROM equipos e
JOIN jugadores j ON e.id_equipo = j.id_equipo
GROUP BY e.id_equipo, e.nombre;

-- Vista 11: Total de tarjetas por tipo
CREATE VIEW tarjetas_por_tipo AS
SELECT tipo, COUNT(*) AS cantidad FROM tarjetas GROUP BY tipo;

-- Vista 12: Partidos por liga
CREATE VIEW partidos_por_liga AS
SELECT l.nombre AS liga, COUNT(p.id_partido) AS total_partidos
FROM ligas l
LEFT JOIN partidos p ON l.id_liga = p.id_liga
GROUP BY l.id_liga, l.nombre;

-- Vista 13: Jugadores menores de 24 años
CREATE VIEW jugadores_menores_24 AS
SELECT * FROM jugadores WHERE edad < 24;

-- Vista 14: Clasificación con diferencia de goles
CREATE VIEW clasificacion_con_diferencia AS
SELECT *, (goles_favor - goles_contra) AS diferencia FROM clasificacion;

-- Vista 15: Equipos con más de 5 puntos
CREATE VIEW equipos_con_mas_de_5_puntos AS
SELECT e.nombre, c.puntos
FROM equipos e
JOIN clasificacion c ON e.id_equipo = c.id_equipo
WHERE c.puntos > 5;

-- Vista 16: Partidos con goles anotados
CREATE VIEW partidos_con_goles AS
SELECT DISTINCT p.id_partido, p.fecha
FROM partidos p
JOIN goles g ON p.id_partido = g.id_partido;

-- Vista 17: Jugadores con tarjetas
CREATE VIEW jugadores_con_tarjetas AS
SELECT DISTINCT j.nombre
FROM jugadores j
JOIN tarjetas t ON j.id_jugador = t.id_jugador;

-- Vista 18: Total de goles por liga
CREATE VIEW goles_por_liga AS
SELECT l.nombre AS liga, COUNT(g.id_gol) AS total_goles
FROM ligas l
JOIN partidos p ON l.id_liga = p.id_liga
JOIN goles g ON p.id_partido = g.id_partido
GROUP BY l.id_liga, l.nombre;

-- Vista 19: Partidos y equipos involucrados
CREATE VIEW partidos_con_equipos AS
SELECT p.id_partido, el.nombre AS local, ev.nombre AS visitante, p.fecha
FROM partidos p
JOIN equipos el ON p.id_local = el.id_equipo
JOIN equipos ev ON p.id_visitante = ev.id_equipo;

-- Vista 20: Árbitros y partidos arbitrados
CREATE VIEW arbitros_con_partidos AS
SELECT a.nombre, COUNT(ap.id_partido) AS partidos
FROM arbitros a
JOIN arbitros_partidos ap ON a.id_arbitro = ap.id_arbitro
GROUP BY a.id_arbitro, a.nombre;

-- Vista 21: Promedio de puntos por liga
CREATE VIEW promedio_puntos_por_liga AS
SELECT l.nombre, AVG(c.puntos) AS promedio_puntos
FROM ligas l
JOIN clasificacion c ON l.id_liga = c.id_liga
GROUP BY l.id_liga, l.nombre;

-- Vista 22: Jugadores que han hecho goles
CREATE VIEW jugadores_con_goles AS
SELECT DISTINCT j.nombre
FROM jugadores j
JOIN goles g ON j.id_jugador = g.id_jugador;

-- Vista 23: Jugadores sin tarjetas
CREATE VIEW jugadores_sin_tarjetas AS
SELECT j.nombre
FROM jugadores j
LEFT JOIN tarjetas t ON j.id_jugador = t.id_jugador
WHERE t.id_tarjeta IS NULL;

-- Vista 24: Equipos con más de un jugador
CREATE VIEW equipos_con_multiples_jugadores AS
SELECT e.nombre, COUNT(j.id_jugador) AS total_jugadores
FROM equipos e
JOIN jugadores j ON e.id_equipo = j.id_equipo
GROUP BY e.id_equipo, e.nombre
HAVING COUNT(j.id_jugador) > 1;

-- Vista 25: Lista de partidos con goles y tarjetas
CREATE VIEW partidos_con_goles_y_tarjetas AS
SELECT p.id_partido, 
       COUNT(DISTINCT g.id_gol) AS goles, 
       COUNT(DISTINCT t.id_tarjeta) AS tarjetas
FROM partidos p
LEFT JOIN goles g ON p.id_partido = g.id_partido
LEFT JOIN tarjetas t ON p.id_partido = t.id_partido
GROUP BY p.id_partido;

-- PROCEDIMIENTOS ALMACENADOS (20)

-- 1. Procedimiento para agregar un nuevo jugador
DELIMITER //
CREATE PROCEDURE sp_agregar_jugador(
    IN p_nombre VARCHAR(100),
    IN p_edad INT,
    IN p_posicion VARCHAR(50),
    IN p_id_equipo INT
)
BEGIN
    INSERT INTO jugadores (nombre, edad, posicion, id_equipo)
    VALUES (p_nombre, p_edad, p_posicion, p_id_equipo);
END //
DELIMITER ;

-- 2. Procedimiento para registrar un partido
DELIMITER //
CREATE PROCEDURE sp_registrar_partido(
    IN p_fecha DATE,
    IN p_id_local INT,
    IN p_id_visitante INT,
    IN p_id_liga INT
)
BEGIN
    INSERT INTO partidos (fecha, id_local, id_visitante, id_liga)
    VALUES (p_fecha, p_id_local, p_id_visitante, p_id_liga);
END //
DELIMITER ;

-- 3. Procedimiento para asignar árbitro a partido
DELIMITER //
CREATE PROCEDURE sp_asignar_arbitro_partido(
    IN p_id_arbitro INT,
    IN p_id_partido INT
)
BEGIN
    INSERT INTO arbitros_partidos (id_arbitro, id_partido)
    VALUES (p_id_arbitro, p_id_partido);
END //
DELIMITER ;

-- 4. Procedimiento para registrar gol
DELIMITER //
CREATE PROCEDURE sp_registrar_gol(
    IN p_id_partido INT,
    IN p_id_jugador INT,
    IN p_minuto INT
)
BEGIN
    INSERT INTO goles (id_partido, id_jugador, minuto)
    VALUES (p_id_partido, p_id_jugador, p_minuto);
END //
DELIMITER ;

-- 5. Procedimiento para registrar tarjeta
DELIMITER //
CREATE PROCEDURE sp_registrar_tarjeta(
    IN p_id_partido INT,
    IN p_id_jugador INT,
    IN p_tipo VARCHAR(10),
    IN p_minuto INT
)
BEGIN
    INSERT INTO tarjetas (id_partido, id_jugador, tipo, minuto)
    VALUES (p_id_partido, p_id_jugador, p_tipo, p_minuto);
END //
DELIMITER ;

-- 6. Procedimiento para actualizar clasificación
DELIMITER //
CREATE PROCEDURE sp_actualizar_clasificacion(
    IN p_id_equipo INT,
    IN p_puntos INT,
    IN p_goles_favor INT,
    IN p_goles_contra INT
)
BEGIN
    UPDATE clasificacion 
    SET puntos = p_puntos, 
        goles_favor = p_goles_favor, 
        goles_contra = p_goles_contra
    WHERE id_equipo = p_id_equipo;
END //
DELIMITER ;

-- 7. Procedimiento para obtener jugadores por equipo
DELIMITER //
CREATE PROCEDURE sp_obtener_jugadores_equipo(IN p_id_equipo INT)
BEGIN
    SELECT * FROM jugadores WHERE id_equipo = p_id_equipo ORDER BY nombre;
END //
DELIMITER ;

-- 8. Procedimiento para obtener partidos por fecha
DELIMITER //
CREATE PROCEDURE sp_partidos_por_fecha(IN p_fecha DATE)
BEGIN
    SELECT p.*, el.nombre AS equipo_local, ev.nombre AS equipo_visitante
    FROM partidos p
    JOIN equipos el ON p.id_local = el.id_equipo
    JOIN equipos ev ON p.id_visitante = ev.id_equipo
    WHERE p.fecha = p_fecha;
END //
DELIMITER ;

-- 9. Procedimiento para obtener estadísticas de equipo
DELIMITER //
CREATE PROCEDURE sp_estadisticas_equipo(IN p_id_equipo INT)
BEGIN
    SELECT 
        e.nombre AS equipo,
        COUNT(j.id_jugador) AS total_jugadores,
        AVG(j.edad) AS edad_promedio,
        SUM(CASE WHEN g.id_gol IS NOT NULL THEN 1 ELSE 0 END) AS goles_totales,
        SUM(CASE WHEN t.tipo = 'amarilla' THEN 1 ELSE 0 END) AS tarjetas_amarillas,
        SUM(CASE WHEN t.tipo = 'roja' THEN 1 ELSE 0 END) AS tarjetas_rojas
    FROM equipos e
    LEFT JOIN jugadores j ON e.id_equipo = j.id_equipo
    LEFT JOIN goles g ON j.id_jugador = g.id_jugador
    LEFT JOIN tarjetas t ON j.id_jugador = t.id_jugador
    WHERE e.id_equipo = p_id_equipo
    GROUP BY e.id_equipo, e.nombre;
END //
DELIMITER ;

-- 10. Procedimiento para eliminar jugador
DELIMITER //
CREATE PROCEDURE sp_eliminar_jugador(IN p_id_jugador INT)
BEGIN
    DELETE FROM jugadores WHERE id_jugador = p_id_jugador;
END //
DELIMITER ;

-- 11. Procedimiento para transferir jugador
DELIMITER //
CREATE PROCEDURE sp_transferir_jugador(
    IN p_id_jugador INT,
    IN p_id_nuevo_equipo INT
)
BEGIN
    UPDATE jugadores 
    SET id_equipo = p_id_nuevo_equipo 
    WHERE id_jugador = p_id_jugador;
END //
DELIMITER ;

-- 12. Procedimiento para obtener goleadores
DELIMITER //
CREATE PROCEDURE sp_obtener_goleadores(IN p_limite INT)
BEGIN
    SELECT j.nombre, COUNT(g.id_gol) AS total_goles
    FROM jugadores j
    JOIN goles g ON j.id_jugador = g.id_jugador
    GROUP BY j.id_jugador, j.nombre
    ORDER BY total_goles DESC
    LIMIT p_limite;
END //
DELIMITER ;

-- 13. Procedimiento para obtener clasificación por liga
DELIMITER //
CREATE PROCEDURE sp_clasificacion_liga(IN p_id_liga INT)
BEGIN
    SELECT e.nombre AS equipo, c.puntos, c.goles_favor, c.goles_contra,
           (c.goles_favor - c.goles_contra) AS diferencia_goles
    FROM clasificacion c
    JOIN equipos e ON c.id_equipo = e.id_equipo
    WHERE c.id_liga = p_id_liga
    ORDER BY c.puntos DESC, diferencia_goles DESC;
END //
DELIMITER ;

-- 14. Procedimiento para buscar jugadores por posición
DELIMITER //
CREATE PROCEDURE sp_buscar_jugadores_posicion(IN p_posicion VARCHAR(50))
BEGIN
    SELECT j.*, e.nombre AS equipo
    FROM jugadores j
    JOIN equipos e ON j.id_equipo = e.id_equipo
    WHERE j.posicion = p_posicion
    ORDER BY j.edad;
END //
DELIMITER ;

-- 15. Procedimiento para obtener partidos con detalles
DELIMITER //
CREATE PROCEDURE sp_partidos_detallados()
BEGIN
    SELECT p.id_partido, p.fecha,
           el.nombre AS local, ev.nombre AS visitante,
           l.nombre AS liga,
           COUNT(g.id_gol) AS total_goles
    FROM partidos p
    JOIN equipos el ON p.id_local = el.id_equipo
    JOIN equipos ev ON p.id_visitante = ev.id_equipo
    JOIN ligas l ON p.id_liga = l.id_liga
    LEFT JOIN goles g ON p.id_partido = g.id_partido
    GROUP BY p.id_partido, p.fecha, el.nombre, ev.nombre, l.nombre
    ORDER BY p.fecha DESC;
END //
DELIMITER ;

-- 16. Procedimiento para actualizar edad jugador
DELIMITER //
CREATE PROCEDURE sp_actualizar_edad_jugador(
    IN p_id_jugador INT,
    IN p_nueva_edad INT
)
BEGIN
    UPDATE jugadores SET edad = p_nueva_edad WHERE id_jugador = p_id_jugador;
END //
DELIMITER ;

-- 17. Procedimiento para obtener árbitros por experiencia
DELIMITER //
CREATE PROCEDURE sp_arbitros_por_experiencia(IN p_exp_minima INT)
BEGIN
    SELECT * FROM arbitros 
    WHERE experiencia >= p_exp_minima 
    ORDER BY experiencia DESC;
END //
DELIMITER ;

-- 18. Procedimiento para contar jugadores por equipo
DELIMITER //
CREATE PROCEDURE sp_contar_jugadores_equipo(IN p_id_equipo INT)
BEGIN
    SELECT COUNT(*) AS total_jugadores
    FROM jugadores
    WHERE id_equipo = p_id_equipo;
END //
DELIMITER ;

-- 19. Procedimiento para obtener jugadores sancionados
DELIMITER //
CREATE PROCEDURE sp_jugadores_sancionados()
BEGIN
    SELECT j.nombre AS jugador, e.nombre AS equipo,
           COUNT(CASE WHEN t.tipo = 'roja' THEN 1 END) AS tarjetas_rojas
    FROM jugadores j
    JOIN equipos e ON j.id_equipo = e.id_equipo
    JOIN tarjetas t ON j.id_jugador = t.id_jugador
    WHERE t.tipo = 'roja'
    GROUP BY j.id_jugador, j.nombre, e.nombre
    HAVING tarjetas_rojas >= 1;
END //
DELIMITER ;

-- 20. Procedimiento para resetear clasificación
DELIMITER //
CREATE PROCEDURE sp_resetear_clasificacion(IN p_id_liga INT)
BEGIN
    UPDATE clasificacion 
    SET puntos = 0, goles_favor = 0, goles_contra = 0
    WHERE id_liga = p_id_liga;
END //
DELIMITER ;

-- FUNCIONES (10)

-- 21. Función para calcular diferencia de goles
DELIMITER //
CREATE FUNCTION fn_diferencia_goles(p_id_equipo INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_diferencia INT;
    SELECT (goles_favor - goles_contra) INTO v_diferencia
    FROM clasificacion
    WHERE id_equipo = p_id_equipo;
    RETURN v_diferencia;
END //
DELIMITER ;

-- 22. Función para verificar tarjetas rojas
DELIMITER //
CREATE FUNCTION fn_tiene_tarjetas_rojas(p_id_jugador INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_tiene_rojas BOOLEAN;
    SELECT COUNT(*) > 0 INTO v_tiene_rojas
    FROM tarjetas
    WHERE id_jugador = p_id_jugador AND tipo = 'roja';
    RETURN v_tiene_rojas;
END //
DELIMITER ;

-- 23. Función para total goles partido
DELIMITER //
CREATE FUNCTION fn_total_goles_partido(p_id_partido INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_total INT;
    SELECT COUNT(*) INTO v_total
    FROM goles
    WHERE id_partido = p_id_partido;
    RETURN v_total;
END //
DELIMITER ;

-- 24. Función para edad promedio equipo
DELIMITER //
CREATE FUNCTION fn_edad_promedio_equipo(p_id_equipo INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE v_promedio DECIMAL(5,2);
    SELECT AVG(edad) INTO v_promedio
    FROM jugadores
    WHERE id_equipo = p_id_equipo;
    RETURN v_promedio;
END //
DELIMITER ;

-- 25. Función para contar partidos arbitrados
DELIMITER //
CREATE FUNCTION fn_contar_partidos_arbitrados(p_id_arbitro INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_total INT;
    SELECT COUNT(*) INTO v_total
    FROM arbitros_partidos
    WHERE id_arbitro = p_id_arbitro;
    RETURN v_total;
END //
DELIMITER ;

-- 26. Función para verificar existencia equipo
DELIMITER //
CREATE FUNCTION fn_equipo_existe(p_id_equipo INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_existe BOOLEAN;
    SELECT COUNT(*) > 0 INTO v_existe
    FROM equipos
    WHERE id_equipo = p_id_equipo;
    RETURN v_existe;
END //
DELIMITER ;

-- 27. Función para nombre completo equipo
DELIMITER //
CREATE FUNCTION fn_nombre_completo_equipo(p_id_equipo INT) 
RETURNS VARCHAR(150)
DETERMINISTIC
BEGIN
    DECLARE v_nombre VARCHAR(100);
    DECLARE v_ciudad VARCHAR(50);
    
    SELECT nombre, ciudad INTO v_nombre, v_ciudad
    FROM equipos
    WHERE id_equipo = p_id_equipo;
    
    RETURN CONCAT(v_nombre, ' (', v_ciudad, ')');
END //
DELIMITER ;

-- 28. Función para total goles jugador
DELIMITER //
CREATE FUNCTION fn_total_goles_jugador(p_id_jugador INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_total INT;
    SELECT COUNT(*) INTO v_total
    FROM goles
    WHERE id_jugador = p_id_jugador;
    RETURN v_total;
END //
DELIMITER ;

-- 29. Función para jugador más joven equipo
DELIMITER //
CREATE FUNCTION fn_jugador_mas_joven(p_id_equipo INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_edad INT;
    SELECT MIN(edad) INTO v_edad
    FROM jugadores
    WHERE id_equipo = p_id_equipo;
    RETURN v_edad;
END //
DELIMITER ;

-- 30. Función para verificar si jugador ha anotado
DELIMITER //
CREATE FUNCTION fn_ha_anotado_gol(p_id_jugador INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_ha_anotado BOOLEAN;
    SELECT COUNT(*) > 0 INTO v_ha_anotado
    FROM goles
    WHERE id_jugador = p_id_jugador;
    RETURN v_ha_anotado;
END //
DELIMITER ;