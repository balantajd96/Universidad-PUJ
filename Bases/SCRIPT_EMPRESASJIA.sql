-- tables : tablespace EMPRESASJIA
-- Table: Ciudad
CREATE TABLE Ciudad (
    IDCiudad smallint  NOT NULL,
    IDDepartamento smallint  NOT NULL,
    Nombre varchar2(20)  NOT NULL,
    CONSTRAINT Ciudad_pk PRIMARY KEY (IDCiudad)
) TABLESPACE TBS_EMPRESASJIA;

CREATE INDEX IDDepartamento_idx 
on Ciudad 
(IDDepartamento ASC)
;

-- Table: Departamento
CREATE TABLE Departamento (
    IDDepartamento smallint  NOT NULL,
    IDPais smallint  NOT NULL,
    Nombre varchar2(20)  NOT NULL,
    CONSTRAINT Departamento_pk PRIMARY KEY (IDDepartamento)
) TABLESPACE TBS_EMPRESASJIA;

CREATE INDEX IDPais_idx 
on Departamento 
(IDPais ASC)
;

-- Table: Empresa
CREATE TABLE Empresa (
    IDEmpresa smallint  NOT NULL,
    IDCiudad smallint  NOT NULL,
    Nombre varchar2(20)  NOT NULL,
    CONSTRAINT Empresa_pk PRIMARY KEY (IDEmpresa)
) TABLESPACE TBS_EMPRESASJIA;

CREATE INDEX IDCiudad_idx 
on Empresa 
(IDCiudad ASC)
;

-- Table: Pais
CREATE TABLE Pais (
    IDPais smallint  NOT NULL,
    Nombre varchar2(20)  NOT NULL,
    CONSTRAINT Pais_pk PRIMARY KEY (IDPais)
) TABLESPACE TBS_EMPRESASJIA;

-- End of file.