-- tables : tablespace PAGOSJIA
-- Table: Factura
CREATE TABLE Factura (
    IDFactura integer  NOT NULL,
    IDContrato integer  NOT NULL,
    ValorPagar integer  NOT NULL CHECK (ValorPagar > 0),
    Impuestos integer  NOT NULL CHECK (Impuestos > 0 ),
    CONSTRAINT Factura_pk PRIMARY KEY (IDFactura)
) TABLESPACE TBS_PAGOSJIA;

CREATE INDEX IDContrato_idx2 
on Factura 
(IDContrato ASC)
;
-- Table: FacturaDetalles
CREATE TABLE FacturaDetalles (
    IDFacturaDetalles number(18,0)  NOT NULL,
    IDFactura integer  NOT NULL,
    IDLlamada number(18,0)  NOT NULL,
    Valor integer  NOT NULL CHECK (Valor > 0),
    CONSTRAINT FacturaDetalles_pk PRIMARY KEY (IDFacturaDetalles)
) TABLESPACE TBS_PAGOSJIA; 

CREATE INDEX IDFactura_idx 
on FacturaDetalles 
(IDFactura ASC)
;

CREATE INDEX IDLlamada_idx 
on FacturaDetalles 
(IDLlamada ASC)
;

-- End of file.