-- tables : tablespace CLIENTESJIA
-- Table: Cliente
CREATE TABLE Cliente (
    DNI integer  NOT NULL,
    IDTipoDoc smallint  NOT NULL,
    IDSexo smallint  NOT NULL,
    IDOcupacion smallint  NOT NULL,
    Nombre varchar2(20)  NOT NULL,
    Apellido varchar2(20)  NOT NULL,
    FechaNacimiento date  NOT NULL,
    Telefono number(10,0)  NOT NULL,
    RangoSalarial smallint  NOT NULL CHECK (RangoSalarial > 0),
    Direccion varchar2(20)  NOT NULL,
    CONSTRAINT Cliente_pk PRIMARY KEY (DNI)
) TABLESPACE TBS_CLIENTESJIA;

CREATE INDEX IDTipoDoc_idx 
on Cliente 
(IDTipoDoc ASC)
;

CREATE INDEX IDSexo_idx 
on Cliente 
(IDSexo ASC)
;

CREATE INDEX IDOcupacion_idx 
on Cliente 
(IDOcupacion ASC)
;

-- Table: Ocupaciones
CREATE TABLE Ocupaciones (
    IDOcupacion smallint  NOT NULL,
    Nombre varchar2(15)  NOT NULL,
    CONSTRAINT Ocupaciones_pk PRIMARY KEY (IDOcupacion)
) TABLESPACE TBS_CLIENTESJIA;



-- Table: Sexo
CREATE TABLE Sexo (
    IDSexo smallint  NOT NULL,
    Nombre varchar2(10)  NOT NULL,
    CONSTRAINT Sexo_pk PRIMARY KEY (IDSexo)
) TABLESPACE TBS_CLIENTESJIA;

-- Table: TipoDocumento
CREATE TABLE TipoDocumento (
    IDTipoDoc smallint  NOT NULL,
    Nombre varchar2(15)  NOT NULL,
    CONSTRAINT TipoDocumento_pk PRIMARY KEY (IDTipoDoc)
) TABLESPACE TBS_CLIENTESJIA;

-- End of file.