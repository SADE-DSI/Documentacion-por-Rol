CREATE TABLE IF NOT EXISTS `persona` (
  `peRut` varchar(13) NOT NULL,
  `peNombresApellidos` varchar(80) DEFAULT NULL,
  `peActivo` int(1) DEFAULT '1',
  `peEmail` varchar(30) DEFAULT NULL,
  `peTelefono` varchar(14) DEFAULT NULL,
  `peTipo` varchar(12) DEFAULT NULL,
  `peDescripcion` VARCHAR(767),
  `peDireccion` VARCHAR(767),
  CONSTRAINT pkPersona PRIMARY kEY(peRut),
  UNIQUE KEY `persona_index1304` (`peRut`,`peTipo`),
  CONSTRAINT check1Persona CHECK(peActivo = 0 OR peActivo = 1) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `arrendatariodueno` (
  `adRut` varchar(13) NOT NULL,
  `adClave` varchar(30) NOT NULL,
  `adEstado` int(1) DEFAULT '1',
  `adFechaLiberacion` date DEFAULT NULL,
    CONSTRAINT pkAD PRIMARY kEY(adRut),
	CONSTRAINT fk1AD FOREIGN KEY (adRut) REFERENCES persona(peRut) ON UPDATE CASCADE, 
	CONSTRAINT check1AD CHECK(adEstado = 0 OR adEstado = 1) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `conserjeadministrador` (
  `caRut` varchar(13) NOT NULL,
  `caClave` varchar(20) NOT NULL,
	CONSTRAINT pkConserje PRIMARY kEY(caRut),
	CONSTRAINT fk1Conserje FOREIGN KEY (caRut) REFERENCES persona(peRut) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `contratopersonal` (
  `cpCodigo` int(11) NOT NULL AUTO_INCREMENT,
  `peRut` varchar(13) NOT NULL,
  `cpAFPNombre` varchar(20) NOT NULL,
  `cpAFPMonto` integer DEFAULT NULL,
  `cpPrevisionNombre` varchar(20) DEFAULT NULL,
  `cpPrevisionMonto` integer unsigned DEFAULT NULL,
  `cpSueldoBruto` int(10) unsigned DEFAULT NULL,
  `cpValorHoraExtra` INTEGER,
  `cpFechaInicio` date NOT NULL,
  `cpFechaFin` date DEFAULT NULL,
	CONSTRAINT pkCP PRIMARY kEY(cpCodigo),
	UNIQUE KEY `contratopersonal_index1305` (`peRut`,`cpFechaInicio`),
	CONSTRAINT fk1CP FOREIGN KEY (peRut) REFERENCES persona(peRut) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `sueldopersonal` (
  `spCodigo` int(11) NOT NULL AUTO_INCREMENT,	
  `spFechaPago` date NOT NULL,
  `cpCodigo` integer NOT NULL,
  `spFechaVencimiento` DATE,
  `spOtrosDescuentos` INTEGER NOT NULL,
  `spHorasExtras` decimal,
	CONSTRAINT pkSueldoPersonal PRIMARY kEY(spCodigo),
	UNIQUE KEY `contratopersonal_index1305` (`spCodigo`,`spFechaVencimiento`),
	CONSTRAINT fk1SueldoPersonal FOREIGN KEY (cpCodigo) REFERENCES contratopersonal(cpCodigo) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `visita` (
  `viRut` varchar(13) NOT NULL,
  `viNombresApellidos` varchar(80) DEFAULT NULL,
  `viObs` varchar(767) DEFAULT NULL,
	CONSTRAINT pkVisita PRIMARY KEY (viRut)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `dptolocal` (
  `dlDireccion` varchar(767) NOT NULL,
  `dlMts2Construidos` float DEFAULT NULL,
  `dlValorArriendo` integer DEFAULT NULL,
  `dlActivo` varchar(2) DEFAULT NULL,
	CONSTRAINT pkDptoLocal PRIMARY KEY (dlDireccion)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `espaciocomun` (
  `ecCodigo` varchar(30) NOT NULL,
  `ecDescripcion` varchar(767) DEFAULT NULL,
  	ecFrecuencia INTEGER,
	ecActivo INTEGER,
	CONSTRAINT pkEC PRIMARY KEY (ecCodigo),
	CONSTRAINT check1EspComun CHECK(ecActivo=0 OR ecActivo=1) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS reservaespaciocomun  (
  `reId` int(20) unsigned NOT NULL AUTO_INCREMENT,
  `reFecha` date NOT NULL,
  `adRut` varchar(13) NOT NULL,
  ecCodigo VARCHAR (30) NOT NULL,
  `reHoraInicio` time NOT NULL,
  `reHoraFin` time NOT NULL,
	CONSTRAINT pkREC PRIMARY KEY(reId),
	UNIQUE KEY `reservaespaciocomun_index1306` (`ecCodigo`,`reFecha`,`reHoraInicio`),
	CONSTRAINT fkREC1 FOREIGN KEY  (ecCodigo) REFERENCES espaciocomun(ecCodigo)ON UPDATE CASCADE,
	CONSTRAINT fkREC2 FOREIGN KEY  (adRut) REFERENCES arrendatariodueno(adRut) ON UPDATE CASCADE
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `pagomensual` (
  `dlDireccion` varchar(767) NOT NULL,
  `pmFechaPago` date NOT NULL,
  `pmMonto` integer unsigned NOT NULL,
  `pmObs` varchar(767) DEFAULT NULL,
  `pmFechaRealPago` date NOT NULL,
  `pmId` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`pmId`),
  UNIQUE KEY `pagoMensual_index1304` (`dlDireccion`,`pmFechaPago`),
  CONSTRAINT kfPagoMensual FOREIGN KEY (dlDireccion) REFERENCES dptolocal (dlDireccion) ON UPDATE CASCADE
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `residedpto` (
  `rdId` INTEGER NOT NULL AUTO_INCREMENT,
  `rdFechaInicio` date NOT NULL,
  `adRut` varchar(13) NOT NULL,
  `dlDireccion` varchar(767) NOT NULL,
  `rdFechaFin` date DEFAULT NULL,
   `rdActivo` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`rdId`),
    UNIQUE KEY `residedpto_index1304` (`rdFechaInicio`,`dlDireccion`,`adRut`),
	CONSTRAINT fkResideDpto1 FOREIGN KEY (dlDireccion) REFERENCES dptolocal (dlDireccion) ON UPDATE CASCADE,
	CONSTRAINT fkResideDpto2 FOREIGN KEY (adRut) REFERENCES arrendatariodueno (adRut) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `visitadpto` (
  `vdCodigo` INTEGER NOT NULL AUTO_INCREMENT,
  `vdFechaIngreso` datetime NOT NULL,
  `caRut` varchar(13) NOT NULL,
  `viRut` varchar(13) NOT NULL,
  `dlDireccion` varchar(767) NOT NULL,
  `vdFechaSalida` datetime DEFAULT NULL,
  PRIMARY KEY (`vdCodigo`),
    UNIQUE KEY `visitadpto_index1304` (`vdFechaIngreso`,`viRut`),
	CONSTRAINT fkVisitaDpto1 FOREIGN KEY (viRut) REFERENCES visita (viRut) ON UPDATE CASCADE,
	CONSTRAINT fkVisitaDpto2 FOREIGN KEY (dlDireccion) REFERENCES dptolocal(dlDireccion) ON UPDATE CASCADE,
	CONSTRAINT fkVisitaDpto3 FOREIGN KEY (caRut) REFERENCES conserjeadministrador (caRut) ON UPDATE CASCADE,
	CONSTRAINT checkVD1 CHECK (vdFechaingreso < vdFechaSalida)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `compromisopago` (
  `cpId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cpTipo` varchar(255) NOT NULL,
  `cpFechaVencimiento` date NOT NULL,
  `cpMonto` int(10) unsigned NOT NULL,
  `cpDescripcion` varchar(767) DEFAULT NULL,
  `cpFechaIngreso` datetime NOT NULL,
  `cpObs` varchar(767) DEFAULT NULL,
  `cpNumeroBoleta` int(10) unsigned DEFAULT NULL,
  `cpFechaRealPago` date DEFAULT NULL,
  PRIMARY KEY (`cpId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `material` (
  `maCodigo` integer NOT NULL AUTO_INCREMENT,
  `maNombre` varchar(20) NOT NULL,
  `maDescripcion` varchar(767) DEFAULT NULL,
  `maEstado` integer NOT NULL DEFAULT '1',
	CONSTRAINT pkMaterial PRIMARY KEY(maCodigo),
	CONSTRAINT checkMaterial CHECK (maEstado = 1 OR maEstado = 0)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `aviso` (
  `avCodigo` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `avTitulo` varchar(40) DEFAULT NULL,
  `avFecha` datetime DEFAULT NULL,
  `avAviso` varchar(767) DEFAULT NULL,
	CONSTRAINT pkAviso PRIMARY KEY(avCodigo)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `sugerencias` (
  `sgId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sfComentario` varchar(767) NOT NULL,
  `sfRespuesta` varchar(767) DEFAULT NULL,
  `sfLeido` varchar(10) NOT NULL DEFAULT 'Enviado',
  `sfFecha` date DEFAULT NULL,
  `sfUsuario` varchar(13) DEFAULT NULL,
  PRIMARY KEY (`sgId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;








