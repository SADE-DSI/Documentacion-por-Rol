CREATE TABLE IF NOT EXISTS `persona` (
  `peRut` varchar(13) NOT NULL,
  `peNombresApellidos` varchar(80) DEFAULT NULL,
  `peActivo` int(11) DEFAULT '1',
  `peEmail` varchar(30) DEFAULT NULL,
  `peTelefono` varchar(14) DEFAULT NULL,
  `peTipo` varchar(12) DEFAULT NULL,
  `peDescripcion` text,
  `peDireccion` text,
  CONSTRAINT pkPersona PRIMARY kEY(peRut),
  CONSTRAINT check1Persona CHECK(peActivo = 0 OR peActivo = 1) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `arrendatariodueno` (
  `adRut` varchar(13) NOT NULL,
  `adClave` varchar(30) NOT NULL,
  `adEstado` int(1) DEFAULT '1',
  `adFechaLiberacion` date DEFAULT NULL,
    CONSTRAINT pkAD PRIMARY kEY(adRut),
	CONSTRAINT fk1AD FOREIGN KEY (adRut) REFERENCES persona(peRut), 
	CONSTRAINT check1AD CHECK(adEstado = 0 OR adEstado = 1) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `conserjeadministrador` (
  `caRut` varchar(13) NOT NULL,
  `caClave` varchar(20) NOT NULL,
  PRIMARY KEY (`caRut`),
	CONSTRAINT fk1Conserje FOREIGN KEY (caRut) REFERENCES persona(peRut)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `contratopersonal` (
  `peRut` varchar(13) NOT NULL,
  `cpAFPNombre` varchar(20) NOT NULL,
  `cpAFPMonto` int(10) unsigned DEFAULT NULL,
  `cpPrevisionNombre` varchar(20) DEFAULT NULL,
  `cpPrevisionMonto` int(10) unsigned DEFAULT NULL,
  `cpFechaInicio` date NOT NULL,
  `cpFechaFin` date DEFAULT NULL,
	CONSTRAINT pkCP PRIMARY kEY(peRut),
	CONSTRAINT fk1CP FOREIGN KEY (peRut) REFERENCES persona(peRut)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `sueldopersonal` (
  `spFechaPago` date NOT NULL,
  `peRut` varchar(13) NOT NULL,
  `spOtrosDescuento` int(10) unsigned DEFAULT NULL,
  `spHorasExtra` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`spFechaPago`),
  KEY `sueldoPersonal_FKIndex1` (`peRut`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `visita` (
  `viRut` varchar(13) NOT NULL,
  `viNombresApellidos` varchar(40) NOT NULL,
  `viObs` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`viRut`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `dptolocal` (
  `dlDireccion` varchar(767) NOT NULL,
  `dlMts2Construidos` float DEFAULT NULL,
  `dlValorArriendo` int(10) unsigned DEFAULT NULL,
  `dlActivo` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`dlDireccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `espaciocomun` (
  `ecCodigo` varchar(30) NOT NULL,
  `ecDescripcion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ecCodigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `reservaespcomun` (
  `reFechaInicio` datetime NOT NULL,
  `adRut` varchar(13) NOT NULL,
  `ecCodigo` varchar(30) NOT NULL,
  `reFechaFin` datetime NOT NULL,
	CONSTRAINT pkREC PRIMARY KEY(reFechaInicio),
	CONSTRAINT fkREC1 FOREIGN KEY  (ecCodigo) REFERENCES espaciocomun(ecCodigo),
	CONSTRAINT fkREC2 FOREIGN KEY  (adRut) REFERENCES arrendatariodueno(adRut),
	CONSTRAINT checkREC1 CHECK (reFechaInicio < reFechaFin)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `pagomensual` (
  `pmCodigo` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dlDireccion` varchar(767) NOT NULL,
  `pmFechaPago` date NOT NULL,
  `pmMonto` int(10) unsigned NOT NULL,
  `pmObs` varchar(255) DEFAULT NULL,
  `pmFechaRealPago` date NOT NULL,
  `pmId` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`pmCodigo`),
  UNIQUE KEY `pagoMensual_index1304` (`dlDireccion`,`pmFechaPago`),
  CONSTRAINT kfPagoMensual FOREIGN KEY (dlDireccion) REFERENCES dptolocal (dlDireccion)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

CREATE TABLE IF NOT EXISTS `residedpto` (
  `rdFechaInicio` date NOT NULL,
  `adRut` varchar(13) NOT NULL,
  `dlDireccion` varchar(767) NOT NULL,
  `rdFechaFin` date DEFAULT NULL,
  PRIMARY KEY (`rdFechaInicio`),
	CONSTRAINT fkResideDpto1 FOREIGN KEY (dlDireccion) REFERENCES dptolocal (dlDireccion),
	CONSTRAINT fkResideDpto2 FOREIGN KEY (adRut) REFERENCES arrendatariodueno (adRut)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `visitadpto` (
  `vdFechaIngreso` datetime NOT NULL,
  `caRut` varchar(13) NOT NULL,
  `viRut` varchar(13) NOT NULL,
  `dlDireccion` varchar(767) NOT NULL,
  `vdFechaSalida` datetime DEFAULT NULL,
  PRIMARY KEY (`vdFechaIngreso`),
	CONSTRAINT fkVisitaDpto1 FOREIGN KEY (viRut) REFERENCES visita (viRut),
	CONSTRAINT fkVisitaDpto2 FOREIGN KEY (dlDireccion) REFERENCES dptolocal(dlDireccion),
	CONSTRAINT fkVisitaDpto3 FOREIGN KEY (caRut) REFERENCES conserjeadministrador (caRut)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `compromisopago` (
  `cpId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cpCodigo` int(10) unsigned NOT NULL,
  `cpFechaVencimiento` date NOT NULL,
  `cpMonto` int(10) unsigned NOT NULL,
  `cpDescripcion` varchar(255) DEFAULT NULL,
  `cpFechaIngreso` datetime NOT NULL,
  `cpObs` varchar(255) DEFAULT NULL,
  `cpNumeroBoleta` int(10) unsigned DEFAULT NULL,
  `cpFechaRealPago` date DEFAULT NULL,
  PRIMARY KEY (`cpId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=32 ;

CREATE TABLE IF NOT EXISTS `material` (
  `maCodigo` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `maNombre` varchar(20) NOT NULL,
  `maDescripcion` varchar(100) DEFAULT NULL,
  `maEstado` int(10) unsigned NOT NULL DEFAULT '1',
	CONSTRAINT pkMaterial PRIMARY KEY(maCodigo),
	CONSTRAINT checkMaterial CHECK (maEstado = 1 OR maEstado = 0)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

CREATE TABLE IF NOT EXISTS `aviso` (
  `avCodigo` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `avTitulo` varchar(40) DEFAULT NULL,
  `avFecha` datetime DEFAULT NULL,
  `avAviso` varchar(767) DEFAULT NULL,
	CONSTRAINT pkAviso PRIMARY KEY(avCodigo),
  UNIQUE KEY `avCodigo` (`avCodigo`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

CREATE TABLE IF NOT EXISTS `sugerencias` (
  `sgId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sfComentario` varchar(767) NOT NULL,
  `sfRespuesta` varchar(767) DEFAULT NULL,
  `sfLeido` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`sgId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;








