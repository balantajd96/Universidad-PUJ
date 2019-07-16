-- tables : tablespace SERVICIOSJIA
-- Table: ConsumoPost
CREATE TABLE ConsumoPost (
    IDContrato integer  NOT NULL,
    DesfaceMin smallint  NOT NULL CHECK (DesfaceMin >= 0),
    MinDisp smallint  NOT NULL CHECK (MinDisp >= 0),
    CONSTRAINT ConsumoPost_pk PRIMARY KEY (IDContrato)
)  TABLESPACE TBS_SERVICIOSJIA;

-- Table: ConsumosPre
CREATE TABLE ConsumosPre (
    IDContrato integer  NOT NULL,
    SaldoDisponible integer  NOT NULL CHECK (SaldoDisponible >= 0),
    GigasDisponibles smallint  NOT NULL CHECK (GigasDisponibles >= 0),
    CONSTRAINT ConsumosPre_pk PRIMARY KEY (IDContrato)
)TABLESPACE TBS_SERVICIOSJIA;

-- Table: Contrato
CREATE TABLE Contrato (
    IDContrato integer  NOT NULL,
    IDPlan integer  NOT NULL,
    IDEmpresa smallint  NOT NULL,
    DNI integer  NOT NULL,
    Telefono number(10,0)  NOT NULL,
    FechaInicio date  NOT NULL ,
    FechaFin date  NOT NULL,
    FechaFacturacion date  NOT NULL,
    ValorPagar  number(7,2)  NOT NULL CHECK (ValorPagar > 0),
    CONSTRAINT Telefono UNIQUE (Telefono),
    CONSTRAINT Contrato_pk PRIMARY KEY (IDContrato)
)  TABLESPACE TBS_SERVICIOSJIA;



CREATE INDEX IDPlan_idx1 
on Contrato 
(IDPlan ASC)
;

CREATE INDEX IDEmpresa_idx 
on Contrato 
(IDEmpresa ASC)
;

CREATE INDEX DNI_idx 
on Contrato 
(DNI ASC)
;

-- Table: Llamadas
CREATE TABLE Llamadas (
    IDLlamada number(18,0)  NOT NULL,
    IDContrato integer  NOT NULL,
    TelefonoDestino number(10,0)  NOT NULL,
    MinConsumidos smallint  NOT NULL CHECK (MinConsumidos >= 0),
    Fecha timestamp  NOT NULL,
    CONSTRAINT Llamadas_pk PRIMARY KEY (IDLlamada)
)  TABLESPACE TBS_SERVICIOSJIA;

CREATE INDEX IDContrato_idx1 
on Llamadas 
(IDContrato ASC)
;

-- Table: Recarga
CREATE TABLE Recarga (
    IDRecarga number(18,0)  NOT NULL,
    IDContrato integer  NOT NULL,
    Valor number(7,2)  NOT NULL CHECK (Valor > 0),
    Fecha date  NOT NULL,
    CONSTRAINT Recarga_pk PRIMARY KEY (IDRecarga)
)  TABLESPACE TBS_SERVICIOSJIA;

CREATE INDEX IDContrato_idx 
on Recarga 
(IDContrato ASC)
;

-- End of file.