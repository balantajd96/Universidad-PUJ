
-- tables : tablespace PLANESJIA
-- Table: Plan
CREATE TABLE Plan (
    IDPlan integer  NOT NULL,
    Nombre varchar2(10)  NOT NULL,
    Minutos smallint  NOT NULL CHECK (Minutos >= 0),
    GB smallint  NOT NULL CHECK (GB >= 0),
    Mensajes smallint  NOT NULL CHECK (Mensajes >= 0),
    PrecioMinAdicional smallint  NOT NULL CHECK (PrecioMinAdicional >= 0),
    DescripcionGeneral varchar2(20)  NULL,
    CONSTRAINT IDPlan PRIMARY KEY (IDPlan)
) TABLESPACE TBS_PLANESJIA;


-- Table: Catalogo
CREATE TABLE Catalogo (
    IDCatalogo integer  NOT NULL,
    FechaInicio date  NOT NULL,
    FechaFin date  NOT NULL,
    CONSTRAINT Catalogo_pk PRIMARY KEY (IDCatalogo)
) TABLESPACE TBS_PLANESJIA;

-- Table: CatalogoXPlan
CREATE TABLE CatalogoXPlan (
    IDCatalogoXPlan integer  NOT NULL,
    IDCatalogo integer  NOT NULL,
    IDPlan integer  NOT NULL,
    CONSTRAINT CatalogoXPlan_pk PRIMARY KEY (IDCatalogoXPlan)
) TABLESPACE TBS_PLANESJIA;

CREATE INDEX IDCatalago_idx 
on CatalogoXPlan 
(IDCatalogo ASC)
;

CREATE INDEX IDPlan_idx 
on CatalogoXPlan 
(IDPlan ASC)
;

-- Table: Postpago
CREATE TABLE Postpago (
    IDPlan integer  NOT NULL,
    PrecioPlan integer  NOT NULL,
    Control number(1,0)  NOT NULL CHECK (Control = 1 OR Control = 0),
    CONSTRAINT Rango CHECK (PrecioPlan >= 0),
    CONSTRAINT Postpago_pk PRIMARY KEY (IDPlan)
) TABLESPACE TBS_PLANESJIA;

-- Table: Prepago
CREATE TABLE Prepago (
    IDPlan integer  NOT NULL,
    PrecioMinuto smallint  NOT NULL CHECK (PrecioMinuto > 0),
    CONSTRAINT Prepago_pk PRIMARY KEY (IDPlan)
) TABLESPACE TBS_PLANESJIA;

-- End of file.

