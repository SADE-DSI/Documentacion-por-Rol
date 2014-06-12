CREATE TABLE IF NOT EXISTS persona (
	peRut VARCHAR (13) ,
	peNombresApellidos VARCHAR(80),
	peActivo int(11) DEFAULT '1',
	peEmail VARCHAR(30),
	peTelefono VARCHAR(14),
	peTipo VARCHAR(12),
	peDescripcion VARCHAR(767),
	peDireccion VARCHAR(767),
	CONSTRAINT pkPersona PRIMARY kEY(peRut),
	CONSTRAINT check1Persona CHECK(peActivo=0 OR peActivo = 1) 
);

CREATE TABLE IF NOT EXISTS arrendatariodueno (
	adRut VARCHAR(13) NOT NULL,
	adClave VARCHAR(30) NOT NULL,
	adEstado INT DEFAULT '1',
	adFechaLiberacion DATE DEFAULT NULL,
	CONSTRAINT pkAD PRIMARY kEY(adRut),
	CONSTRAINT fk1AD FOREIGN KEY (adRut) REFERENCES persona(peRut) ON UPDATE CASCADE, 
	CONSTRAINT check1AD CHECK(adEstado = 0 OR adEstado = 1) 
);

CREATE TABLE IF NOT EXISTS conserjeadministrador (
	caRut VARCHAR(13),
	caClave VARCHAR(30),
	CONSTRAINT pkConserje PRIMARY kEY(caRut),
	CONSTRAINT fk1Conserje FOREIGN KEY (caRut) REFERENCES persona(peRut) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS contratopersonal (
 	cpCodigo int(11) NOT NULL AUTO_INCREMENT,
	peRut VARCHAR(13),
	cpAFPNombre VARCHAR(20),
	cpAFPMonto INTEGER,
	cpPrevisionNombre VARCHAR(20),
	cpPrevisionMonto INTEGER,
	cpSueldoBruto INTEGER,
	cpFechaInicio DATE,
	cpFechaFin DATE,
	cpValorHoraExtra INTEGER,
	CONSTRAINT pkCP PRIMARY kEY(cpCodigo),
	UNIQUE KEY ukCP(peRut,cpFechaInicio),
	CONSTRAINT fk1CP FOREIGN KEY (peRut) REFERENCES persona(peRut) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS sueldopersonal (
	spCodigo int(11) NOT NULL AUTO_INCREMENT,
	cpCodigo INTEGER,
	spFechaPago DATE,
	spOtrosDescuentos INTEGER,
	spHorasExtras DECIMAL,
	CONSTRAINT pkSueldoPersonal PRIMARY kEY(spCodigo),
	UNIQUE KEY ukSueldoPersonal(spCodigo,	spFechaPago),
	CONSTRAINT fk1SueldoPersonal FOREIGN KEY (cpCodigo) REFERENCES contratopersonal(cpCodigo) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS visita(
	viRut VARCHAR (13),
	viNombresApellidos VARCHAR (80),
	viObs VARCHAR(767),
	CONSTRAINT pkVisita PRIMARY KEY (viRut)
);

CREATE TABLE IF NOT EXISTS dptolocal (
	dlDireccion VARCHAR (767),
	dlMts2Construidos FLOAT NOT NULL,
	dlValorArriendo INTEGER,
	dlActivo VARCHAR (2) NOT NULL,
	CONSTRAINT pkDptoLocal PRIMARY KEY (dlDireccion),
	CONSTRAINT check1dptolocal CHECK(dlActivo=0 OR dlActivo=1) 
);

CREATE TABLE IF NOT EXISTS espaciocomun(
	ecCodigo VARCHAR (30),
	ecDescripcion VARCHAR (767),
	ecFrecuencua INTEGER,
	ecActivo INTEGER,
	CONSTRAINT pkEC PRIMARY KEY (ecCodigo),
	CONSTRAINT check1EspComun CHECK(ecActivo=0 OR ecActivo=1) 

);

CREATE TABLE IF NOT EXISTS reservaespaciocomun (
	ecCodigo VARCHAR (30),
	reFechaInicio DATETIME,
	reFechaFin DATETIME,
	adRut VARCHAR (13),
	CONSTRAINT pkREC PRIMARY KEY(ecCodigo, reFechaInicio),
	CONSTRAINT fkREC1 FOREIGN KEY  (ecCodigo) REFERENCES espaciocomun(ecCodigo) ON UPDATE CASCADE,
	CONSTRAINT fkREC2 FOREIGN KEY  (adRut) REFERENCES arrendatariodueno(adRut) ON UPDATE CASCADE,
	CONSTRAINT checkREC1 CHECK (reFechaInicio < reFechaFin)
);

CREATE TABLE IF NOT EXISTS pagomensual (
	pmCodigo bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	dlDireccion VARCHAR (767),
	pmFechaPago DATE,
	pmMonto INTEGER,
	pmObs VARCHAR (767),
	pmFechaRealPago DATE,
	pmId int(10) unsigned DEFAULT NULL,
	CONSTRAINT pkPagoMensual PRIMARY KEY (dlDireccion, pmFechaPago),
UNIQUE KEY pmCodigo (pmCodigo),
	CONSTRAINT kfPagoMensual FOREIGN KEY (dlDireccion) REFERENCES dptolocal (dlDireccion) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS residedpto (
	adRut VARCHAR (13),
	dlDireccion VARCHAR (767),
	rdFechaInicio DATE NOT NULL,
	rdFechaFin DATE,
	CONSTRAINT pkResideDpto PRIMARY kEY (adRut, dlDireccion, rdFechaInicio),
	CONSTRAINT fkResideDpto1 FOREIGN KEY (dlDireccion) REFERENCES dptolocal (dlDireccion) ON UPDATE CASCADE,
	CONSTRAINT fkResideDpto2 FOREIGN KEY (adRut) REFERENCES arrendatariodueno (adRut) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS visitadpto (
	viRut VARCHAR (13),
	dlDireccion VARCHAR (767),
	vdFechaIngreso DATETIME,
	caRut VARCHAR (13),
	vdFechaSalida DATETIME,
	CONSTRAINT pkVisitaDpto PRIMARY KEY(viRut, vdFechaIngreso),
	CONSTRAINT fkVisitaDpto1 FOREIGN KEY (viRut) REFERENCES visita (viRut),
	CONSTRAINT fkVisitaDpto2 FOREIGN KEY (dlDireccion) REFERENCES dptolocal(dlDireccion) ON UPDATE CASCADE,
	CONSTRAINT fkVisitaDpto3 FOREIGN KEY (caRut) REFERENCES conserjeadministrador (caRut) ON UPDATE CASCADE,
	CONSTRAINT checkVD1 CHECK (vdFechaingreso < vdFechaSalida)
);

CREATE TABLE IF NOT EXISTS compromisopago	 (
	cpId int(10) unsigned NOT NULL AUTO_INCREMENT,
	cpCodigo INTEGER NOT NULL,
	cpFechaVencimiento DATE NOT NULL,
	cpMonto int(10) unsigned NOT NULL,
	cpDescripcion VARCHAR (767),
	cpFechaIngreso DATETIME NOT NULL,
	cpObs VARCHAR (767),
	gpNumeroBoleta int(10) unsigned DEFAULT NULL,
	gpFechaRealPago DATE,
	CONSTRAINT pkCP PRIMARY KEY(cpId)
);

CREATE TABLE IF NOT EXISTS material(	
	maCodigo INTEGER,
	maNombre VARCHAR (20),
	maDescripcion VARCHAR(767),
	maEstado INTEGER,
	CONSTRAINT pkMaterial PRIMARY KEY(maCodigo)
);

CREATE TABLE IF NOT EXISTS aviso(
	avCodigo bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	avTitulo VARCHAR (40) NOT NULL,
	avFecha DATETIME NOT NULL,
	avAviso VARCHAR (767) NOT NULL,
	CONSTRAINT pkAviso PRIMARY KEY(avCodigo)
);

CREATE TABLE IF NOT EXISTS sugerencia(
	sgId INTEGER,
	sgComentario VARCHAR (767),
	sgRespuesta VARCHAR (767),
	sgLeido INTEGER,
	CONSTRAINT checkMaterial CHECK (sgLeido = 1 OR sgLeido = 0)
);

CREATE TABLE IF NOT EXISTS `cruge_authassignment` (
  `userid` int(11) NOT NULL,
  `bizrule` text COLLATE utf8_spanish_ci,
  `data` text COLLATE utf8_spanish_ci,
  `itemname` varchar(64) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`userid`,`itemname`),
  KEY `fk_cruge_authassignment_cruge_authitem1` (`itemname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

CREATE TABLE IF NOT EXISTS `cruge_authitem` (
  `name` varchar(64) COLLATE utf8_spanish_ci NOT NULL,
  `type` int(11) NOT NULL,
  `description` text COLLATE utf8_spanish_ci,
  `bizrule` text COLLATE utf8_spanish_ci,
  `data` text COLLATE utf8_spanish_ci,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

CREATE TABLE IF NOT EXISTS `cruge_authitemchild` (
  `parent` varchar(64) COLLATE utf8_spanish_ci NOT NULL,
  `child` varchar(64) COLLATE utf8_spanish_ci NOT NULL,
  PRIMARY KEY (`parent`,`child`),
  KEY `crugeauthitemchild_ibfk_2` (`child`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

CREATE TABLE IF NOT EXISTS `cruge_field` (
  `idfield` int(11) NOT NULL AUTO_INCREMENT,
  `fieldname` varchar(20) COLLATE utf8_spanish_ci NOT NULL,
  `longname` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `position` int(11) DEFAULT '0',
  `required` int(11) DEFAULT '0',
  `fieldtype` int(11) DEFAULT '0',
  `fieldsize` int(11) DEFAULT '20',
  `maxlength` int(11) DEFAULT '45',
  `showinreports` int(11) DEFAULT '0',
  `useregexp` varchar(512) COLLATE utf8_spanish_ci DEFAULT NULL,
  `useregexpmsg` varchar(512) COLLATE utf8_spanish_ci DEFAULT NULL,
  `predetvalue` mediumblob,
  PRIMARY KEY (`idfield`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `cruge_fieldvalue` (
  `idfieldvalue` int(11) NOT NULL AUTO_INCREMENT,
  `iduser` int(11) NOT NULL,
  `idfield` int(11) NOT NULL,
  `value` blob,
  PRIMARY KEY (`idfieldvalue`),
  KEY `fk_cruge_fieldvalue_cruge_field1` (`idfield`),
  KEY `fk_cruge_fieldvalue_cruge_user1` (`iduser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `cruge_session` (
  `idsession` int(11) NOT NULL AUTO_INCREMENT,
  `iduser` int(11) NOT NULL,
  `created` bigint(30) DEFAULT NULL,
  `expire` bigint(30) DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  `ipaddress` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `usagecount` int(11) DEFAULT '0',
  `lastusage` bigint(30) DEFAULT NULL,
  `logoutdate` bigint(30) DEFAULT NULL,
  `ipaddressout` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  PRIMARY KEY (`idsession`),
  KEY `crugesession_iduser` (`iduser`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci AUTO_INCREMENT=8 ;

INSERT INTO `cruge_session` (`idsession`, `iduser`, `created`, `expire`, `status`, `ipaddress`, `usagecount`, `lastusage`, `logoutdate`, `ipaddressout`) VALUES
(1, 1, 1395434746, 1395436546, 0, '127.0.0.1', 1, 1395434746, 1395435116, '127.0.0.1'),
(2, 1, 1395435128, 1395436928, 1, '127.0.0.1', 1, 1395435128, NULL, NULL),
(3, 1, 1400772778, 1400774578, 1, '146.83.195.38', 2, 1400772828, NULL, NULL),
(4, 1, 1401122868, 1401124668, 1, '179.57.203.61', 1, 1401122868, NULL, NULL),
(5, 1, 1401152450, 1401154250, 1, '200.120.91.112', 1, 1401152450, NULL, NULL),
(6, 1, 1401223576, 1401225376, 1, '179.57.203.61', 1, 1401223576, NULL, NULL),
(7, 1, 1401316471, 1401318271, 1, '200.120.91.112', 2, 1401318035, NULL, NULL);


CREATE TABLE IF NOT EXISTS `cruge_system` (
  `idsystem` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `largename` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `sessionmaxdurationmins` int(11) DEFAULT '30',
  `sessionmaxsameipconnections` int(11) DEFAULT '10',
  `sessionreusesessions` int(11) DEFAULT '1' COMMENT '1yes 0no',
  `sessionmaxsessionsperday` int(11) DEFAULT '-1',
  `sessionmaxsessionsperuser` int(11) DEFAULT '-1',
  `systemnonewsessions` int(11) DEFAULT '0' COMMENT '1yes 0no',
  `systemdown` int(11) DEFAULT '0',
  `registerusingcaptcha` int(11) DEFAULT '0',
  `registerusingterms` int(11) DEFAULT '0',
  `terms` blob,
  `registerusingactivation` int(11) DEFAULT '1',
  `defaultroleforregistration` varchar(64) COLLATE utf8_spanish_ci DEFAULT NULL,
  `registerusingtermslabel` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `registrationonlogin` int(11) DEFAULT '1',
  PRIMARY KEY (`idsystem`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci AUTO_INCREMENT=2 ;

INSERT INTO `cruge_system` (`idsystem`, `name`, `largename`, `sessionmaxdurationmins`, `sessionmaxsameipconnections`, `sessionreusesessions`, `sessionmaxsessionsperday`, `sessionmaxsessionsperuser`, `systemnonewsessions`, `systemdown`, `registerusingcaptcha`, `registerusingterms`, `terms`, `registerusingactivation`, `defaultroleforregistration`, `registerusingtermslabel`, `registrationonlogin`) VALUES
(1, 'default', NULL, 30, 10, 1, -1, -1, 0, 0, 0, 0, '', 0, '', '', 1);


CREATE TABLE IF NOT EXISTS `cruge_user` (
  `iduser` int(11) NOT NULL AUTO_INCREMENT,
  `regdate` bigint(30) DEFAULT NULL,
  `actdate` bigint(30) DEFAULT NULL,
  `logondate` bigint(30) DEFAULT NULL,
  `username` varchar(64) COLLATE utf8_spanish_ci DEFAULT NULL,
  `email` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `password` varchar(64) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Hashed password',
  `authkey` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'llave de autentificacion',
  `state` int(11) DEFAULT '0',
  `totalsessioncounter` int(11) DEFAULT '0',
  `currentsessioncounter` int(11) DEFAULT '0',
  PRIMARY KEY (`iduser`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci AUTO_INCREMENT=3 ;


INSERT INTO `cruge_user` (`iduser`, `regdate`, `actdate`, `logondate`, `username`, `email`, `password`, `authkey`, `state`, `totalsessioncounter`, `currentsessioncounter`) VALUES
(1, NULL, NULL, 1401318035, 'admin', 'admin@tucorreo.com', 'admin', NULL, 1, 0, 0),
(2, NULL, NULL, NULL, 'invitado', 'invitado', 'nopassword', NULL, 1, 0, 0);


ALTER TABLE `cruge_authassignment`
  ADD CONSTRAINT `fk_cruge_authassignment_cruge_authitem1` FOREIGN KEY (`itemname`) REFERENCES `cruge_authitem` (`name`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_cruge_authassignment_user` FOREIGN KEY (`userid`) REFERENCES `cruge_user` (`iduser`) ON DELETE CASCADE ON UPDATE NO ACTION;


ALTER TABLE `cruge_authitemchild`
  ADD CONSTRAINT `crugeauthitemchild_ibfk_1` FOREIGN KEY (`parent`) REFERENCES `cruge_authitem` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `crugeauthitemchild_ibfk_2` FOREIGN KEY (`child`) REFERENCES `cruge_authitem` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `cruge_fieldvalue`
  ADD CONSTRAINT `fk_cruge_fieldvalue_cruge_field1` FOREIGN KEY (`idfield`) REFERENCES `cruge_field` (`idfield`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_cruge_fieldvalue_cruge_user1` FOREIGN KEY (`iduser`) REFERENCES `cruge_user` (`iduser`) ON DELETE CASCADE ON UPDATE NO ACTION;

