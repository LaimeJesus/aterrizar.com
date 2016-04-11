SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema aterrizabd
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `aterrizabd` ;
CREATE SCHEMA IF NOT EXISTS `aterrizabd` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `aterrizabd` ;

-- -----------------------------------------------------
-- Table `aterrizabd`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aterrizabd`.`Usuario` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
  `nickname` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `fechaDeNacimiento` DATE NOT NULL,
  `codigo` VARCHAR(45) NULL,
  UNIQUE INDEX `NICKNAME_UNIQUE` (`nickname` ASC),
  UNIQUE INDEX `id_usuario_UNIQUE` (`id_usuario` ASC),
  PRIMARY KEY (`id_usuario`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aterrizabd`.`Aerolinea`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aterrizabd`.`Aerolinea` (
  `idAerolinea` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `telefono` INT NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idAerolinea`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aterrizabd`.`Vuelo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aterrizabd`.`Vuelo` (
  `idVuelo` INT NOT NULL AUTO_INCREMENT,
  `nroAvion` INT NOT NULL,
  `idAerolinea` INT NOT NULL,
  PRIMARY KEY (`idVuelo`),
  INDEX `Aerolinea_idx` (`idAerolinea` ASC),
  CONSTRAINT `Aerolinea`
    FOREIGN KEY (`idAerolinea`)
    REFERENCES `aterrizabd`.`Aerolinea` (`idAerolinea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aterrizabd`.`Tramo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aterrizabd`.`Tramo` (
  `idTramo` INT NOT NULL AUTO_INCREMENT,
  `idVuelo` INT NOT NULL,
  `horaDeSalida` DATETIME NOT NULL,
  `horaDeLlegada` DATETIME NOT NULL,
  `origen` VARCHAR(45) NOT NULL,
  `destino` VARCHAR(45) NOT NULL,
  `precioBase` DOUBLE NOT NULL,
  PRIMARY KEY (`idTramo`),
  INDEX `Vuelo_idx` (`idVuelo` ASC),
  CONSTRAINT `Vuelo`
    FOREIGN KEY (`idVuelo`)
    REFERENCES `aterrizabd`.`Vuelo` (`idVuelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aterrizabd`.`Categoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aterrizabd`.`Categoria` (
  `idCategoria` INT NOT NULL AUTO_INCREMENT,
  `tipoCategoria` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idCategoria`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aterrizabd`.`Asiento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aterrizabd`.`Asiento` (
  `idAsiento` INT NOT NULL,
  `id_usuario` INT NULL,
  `idTramo` INT NOT NULL,
  `idCategoria` INT NOT NULL,
  PRIMARY KEY (`idAsiento`),
  INDEX `Tramo_idx` (`idTramo` ASC),
  INDEX `Categoria_idx` (`idCategoria` ASC),
  CONSTRAINT `Tramo`
    FOREIGN KEY (`idTramo`)
    REFERENCES `aterrizabd`.`Tramo` (`idTramo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Categoria`
    FOREIGN KEY (`idCategoria`)
    REFERENCES `aterrizabd`.`Categoria` (`idCategoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aterrizabd`.`Reseva`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `aterrizabd`.`Reseva` (
  `idReseva` INT NOT NULL AUTO_INCREMENT,
  `idAsiento` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  `fechaDeReserva` DATE NULL,
  PRIMARY KEY (`idReseva`),
  INDEX `Usuario_idx` (`id_usuario` ASC),
  INDEX `Asiento_idx` (`idAsiento` ASC),
  CONSTRAINT `Usuario`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `aterrizabd`.`Usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Asiento`
    FOREIGN KEY (`idAsiento`)
    REFERENCES `aterrizabd`.`Asiento` (`idAsiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
