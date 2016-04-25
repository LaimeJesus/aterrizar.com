CREATE DATABASE  IF NOT EXISTS `aterrizar`;
USE `aterrizar`;

DROP TABLE IF EXISTS `Usuario`;

CREATE TABLE `Usuario` (
  `idUsuario` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `apellido` varchar(45) NOT NULL,
  `nickname` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `fechaDeNacimiento` date NOT NULL,
  `codigo` varchar(45) NOT NULL,
  PRIMARY KEY (`idUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE Usuario AUTO_INCREMENT = 1;