-- foreign keys
-- Reference: CatalogoXPlan_Plan (table: CatalogoXPlan)
ALTER TABLE CatalogoXPlan ADD CONSTRAINT CatalogoXPlan_Plan
    FOREIGN KEY (IDPlan)
    REFERENCES Plan (IDPlan);

-- Reference: Catalogo_CatalogoXPlan (table: CatalogoXPlan)
ALTER TABLE CatalogoXPlan ADD CONSTRAINT Catalogo_CatalogoXPlan
    FOREIGN KEY (IDCatalogo)
    REFERENCES Catalogo (IDCatalogo);

-- Reference: Ciudad_Empresa (table: Empresa)
ALTER TABLE Empresa ADD CONSTRAINT Ciudad_Empresa
    FOREIGN KEY (IDCiudad)
    REFERENCES Ciudad (IDCiudad);

-- Reference: Cliente_Ocupaciones (table: Cliente)
ALTER TABLE Cliente ADD CONSTRAINT Cliente_Ocupaciones
    FOREIGN KEY (IDOcupacion)
    REFERENCES Ocupaciones (IDOcupacion);

-- Reference: Cliente_Sexo (table: Cliente)
ALTER TABLE Cliente ADD CONSTRAINT Cliente_Sexo
    FOREIGN KEY (IDSexo)
    REFERENCES Sexo (IDSexo);

-- Reference: Cliente_TipoDocumento (table: Cliente)
ALTER TABLE Cliente ADD CONSTRAINT Cliente_TipoDocumento
    FOREIGN KEY (IDTipoDoc)
    REFERENCES TipoDocumento (IDTipoDoc);

-- Reference: ConsumoPost_Contrato (table: ConsumoPost)
ALTER TABLE ConsumoPost ADD CONSTRAINT ConsumoPost_Contrato
    FOREIGN KEY (IDContrato)
    REFERENCES Contrato (IDContrato);

-- Reference: ConsumosPre_Contrato (table: ConsumosPre)
ALTER TABLE ConsumosPre ADD CONSTRAINT ConsumosPre_Contrato
    FOREIGN KEY (IDContrato)
    REFERENCES Contrato (IDContrato);

-- Reference: Contrato_Cliente (table: Contrato)
ALTER TABLE Contrato ADD CONSTRAINT Contrato_Cliente
    FOREIGN KEY (DNI)
    REFERENCES Cliente (DNI);

-- Reference: Contrato_Factura (table: Factura)
ALTER TABLE Factura ADD CONSTRAINT Contrato_Factura
    FOREIGN KEY (IDContrato)
    REFERENCES Contrato (IDContrato);

-- Reference: Departamento_Ciudad (table: Ciudad)
ALTER TABLE Ciudad ADD CONSTRAINT Departamento_Ciudad
    FOREIGN KEY (IDDepartamento)
    REFERENCES Departamento (IDDepartamento);

-- Reference: Departamento_Pais (table: Departamento)
ALTER TABLE Departamento ADD CONSTRAINT Departamento_Pais
    FOREIGN KEY (IDPais)
    REFERENCES Pais (IDPais);

-- Reference: Empresa_Contrato (table: Contrato)
ALTER TABLE Contrato ADD CONSTRAINT Empresa_Contrato
    FOREIGN KEY (IDEmpresa)
    REFERENCES Empresa (IDEmpresa);

-- Reference: FacturaDetalles_Llamadas (table: FacturaDetalles)
ALTER TABLE FacturaDetalles ADD CONSTRAINT FacturaDetalles_Llamadas
    FOREIGN KEY (IDLlamada)
    REFERENCES Llamadas (IDLlamada);

-- Reference: Factura_FacturaDetalles (table: FacturaDetalles)
ALTER TABLE FacturaDetalles ADD CONSTRAINT Factura_FacturaDetalles
    FOREIGN KEY (IDFactura)
    REFERENCES Factura (IDFactura);

-- Reference: Llamadas_Contrato (table: Llamadas)
ALTER TABLE Llamadas ADD CONSTRAINT Llamadas_Contrato
    FOREIGN KEY (IDContrato)
    REFERENCES Contrato (IDContrato);

-- Reference: Plan_Contrato (table: Contrato)
ALTER TABLE Contrato ADD CONSTRAINT Plan_Contrato
    FOREIGN KEY (IDPlan)
    REFERENCES Plan (IDPlan);

-- Reference: Plan_Postpago (table: Postpago)
ALTER TABLE Postpago ADD CONSTRAINT Plan_Postpago
    FOREIGN KEY (IDPlan)
    REFERENCES Plan (IDPlan);

-- Reference: Plan_Prepago (table: Prepago)
ALTER TABLE Prepago ADD CONSTRAINT Plan_Prepago
    FOREIGN KEY (IDPlan)
    REFERENCES Plan (IDPlan);

-- Reference: Recarga_Contrato (table: Recarga)
ALTER TABLE Recarga ADD CONSTRAINT Recarga_Contrato
    FOREIGN KEY (IDContrato)
    REFERENCES Contrato (IDContrato);
    
-- End of file.