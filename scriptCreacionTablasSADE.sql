CREATE TABLE persona (
	peRut VARCHAR (13) ,
	peNombresApellidos VARCHAR(80),
	peActivo INT,
	peEmail VARCHAR(30),
	peTelefono VARCHAR(14),
	peTipo VARCHAR(12),
	peDescripcion TEXT,
	peDireccion TEXT,
	CONSTRAINT pkPersona PRIMARY kEY(peRut),
	CONSTRAINT check1Persona CHECK(peActivo = 0 OR peActivo = 1) 
);

CREATE TABLE arrendatarioDueno (
	adRut VARCHAR(13),
	adClave VARCHAR(30),
	adEstado INT,
	adFechaLiberacion DATE,
	CONSTRAINT pkAD PRIMARY kEY(adRut),
	CONSTRAINT fk1AD FOREIGN KEY (adRut) REFERENCES persona(peRut), 
	CONSTRAINT check1AD CHECK(adEstado = 0 OR adEstado = 1) 
);

CREATE TABLE conserjeAdministrador (
	caRut VARCHAR(13),
	caClave VARCHAR(30),
	CONSTRAINT pkConserje PRIMARY kEY(caRut),
	CONSTRAINT fk1Conserje FOREIGN KEY (caRut) REFERENCES persona(peRut)
);

CREATE TABLE contratoPersonal (
	peRut VARCHAR(13),
	cpAFPNombre VARCHAR(20),
	cpAFPMonto INTEGER,
	cpPrevisionNombre VARCHAR(20),
	cpPrevisionMonto INTEGER,
	cpSueldoBruto INTEGER,
	cpFechaInicio DATE,
	cpFechaFin DATE,
	CONSTRAINT pkCP PRIMARY kEY(peRut),
	CONSTRAINT fk1CP FOREIGN KEY (peRut) REFERENCES persona(peRut)
);

CREATE TABLE sueldoPersonal (
	peRut VARCHAR(13),
	spFechaPago DATE,
	spOtrosDescuentos INTEGER,
	spHorasExtras DECIMAL,
	CONSTRAINT pkSueldoPersonal PRIMARY kEY(peRut, spFechaPago),
	CONSTRAINT fk1SueldoPersonal FOREIGN KEY (peRut) REFERENCES persona(peRut)
);


CREATE TABLE visita(
	viRut VARCHAR (13),
	viNombresApellidos VARCHAR (80),
	viObs TEXT,
	CONSTRAINT pkVisita PRIMARY KEY (viRut)
);



CREATE TABLE dptoLocal (
	dlDireccion VARCHAR (767),
	dlMts2Construidos FLOAT,
	dlValorArriendo INTEGER,
	CONSTRAINT pkDptoLocal PRIMARY KEY (dlDireccion)
);

CREATE TABLE espacioComun(
	ecCodigo VARCHAR (30),
	ecDescripcion VARCHAR (767),
	ecFrecuencia DECIMAL,
	CONSTRAINT pkEC PRIMARY KEY (ecCodigo)
);

CREATE TABLE reservaEspacioComun (
	ecCodigo VARCHAR (30),
	reFechaInicio DATETIME,
	reFechaFin DATETIME,
	adRut VARCHAR (13),
	CONSTRAINT pkREC PRIMARY KEY(ecCodigo, reFechaInicio),
	CONSTRAINT fkREC1 FOREIGN KEY  (ecCodigo) REFERENCES espacioComun(ecCodigo),
	CONSTRAINT fkREC2 FOREIGN KEY  (adRut) REFERENCES arrendatarioDueno(adRut),
	CONSTRAINT checkREC1 CHECK (reFechaInicio < reFechaFin)
);

CREATE TABLE pagoMensual (
	pmCodigo SERIAL UNIQUE,
	dlDireccion VARCHAR (767),
	pmFechaPago DATE,
	pmMonto INTEGER,
	pmObs VARCHAR (767),
	pmFechaRealPago DATE,
	CONSTRAINT pkPagoMensual PRIMARY KEY (dlDireccion, pmFechaPago),
	CONSTRAINT kfPagoMensual FOREIGN KEY (dlDireccion) REFERENCES dptoLocal (dlDireccion)
);

CREATE TABLE resideDpto (
	adRut VARCHAR (13),
	dlDireccion VARCHAR (767),
	fechaInicio DATE NOT NULL,
	fechaFin DATE,
	CONSTRAINT pkResideDpto PRIMARY kEY (adRut, dlDireccion, fechaInicio),
	CONSTRAINT fkResideDpto1 FOREIGN KEY (dlDireccion) REFERENCES DptoLocal (dlDireccion),
	CONSTRAINT fkResideDpto2 FOREIGN KEY (adRut) REFERENCES arrendatarioDueno (adRut)
);

CREATE TABLE visitaDpto (
	viRut VARCHAR (13),
	dlDireccion VARCHAR (767),
	vdFechaIngreso DATETIME,
	caRut VARCHAR (13),
	vdFechaSalida DATETIME,
	CONSTRAINT pkVisitaDpto PRIMARY KEY(viRut, vdFechaIngreso),
	CONSTRAINT fkVisitaDpto1 FOREIGN KEY (viRut) REFERENCES visita (viRut),
	CONSTRAINT fkVisitaDpto2 FOREIGN KEY (dlDireccion) REFERENCES dptoLocal(dlDireccion),
	CONSTRAINT fkVisitaDpto3 FOREIGN KEY (caRut) REFERENCES conserjeAdministrador (caRut),
	CONSTRAINT checkVD1 CHECK (vdFechaingreso < vdFechaSalida)
);

CREATE TABLE codigo (
	coCodigo INTEGER,
	coNombre VARCHAR(20),
	CONSTRAINT pkCodigo PRIMARY KEY (coCodigo)
);

CREATE TABLE compromisoPago	 (
	coCodigo INTEGER,
	cpFechaVencimiento DATE,
	cpMonto INTEGER,
	cpDescripcion VARCHAR (767),
	cpFechaIngreso DATETIME,
	cpObs VARCHAR (767),
	gpNumeroBoleta INTEGER,
	gpFechaRealPago DATE,
	CONSTRAINT pkCP PRIMARY KEY(coCodigo, cpFechaVencimiento),
	CONSTRAINT fkCP FOREIGN KEY (coCodigo) REFERENCES codigo (coCodigo)
);

CREATE TABLE material(	
	maCodigo INTEGER,
	maNombre VARCHAR (20),
	maDescripcion VARCHAR(767),
	maEstado INTEGER,
	CONSTRAINT pkMaterial PRIMARY KEY(maCodigo),
	CONSTRAINT checkMaterial CHECK (maEstado = 1 OR maEstado = 0)
);

CREATE TABLE aviso(
	avCodigo SERIAL,	
	avTitulo VARCHAR (40) NOT NULL,
	avFecha DATETIME NOT NULL,
	avAviso VARCHAR (767) NOT NULL,
	CONSTRAINT pkAviso PRIMARY KEY(avCodigo)
);








	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('dlValorArriendo', 'numerical', 'integerOnly'=>true, 'min'=>1, 'max'=>1000000000),	
			array('dlDireccion', 'length', 'max'=>767),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('dlDireccion, dlMts2Construidos, dlValorArriendo', 'safe', 'on'=>'search'),
			array('dlDireccion', 'required'),		
			array('dlMts2Construidos', 'numerical', 'integerOnly'=>false,'message'=>
					'{attribute}  debe ser un entero o un decimal con punto.'),	
		);
	}