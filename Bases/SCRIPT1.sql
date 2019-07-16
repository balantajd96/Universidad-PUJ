CREATE OR REPLACE FUNCTION VALIDAR_PLAN(v_IDPlan IN INTEGER) RETURN BOOLEAN
IS
  existencia SMALLINT;
BEGIN
    SELECT COUNT(*) INTO existencia FROM Plan WHERE Plan.IDPlan = v_IDPlan;
    IF existencia > 0 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
END;


CREATE OR REPLACE PROCEDURE REGISTRAR_PLAN(v_IDPlan IN INTEGER,
											v_Nombre IN VARCHAR2,
											v_Minutos IN SMALLINT,
											v_GB IN SMALLINT,
											v_Mensajes IN SMALLINT,
											v_PrecioMinAdicional IN SMALLINT,
											v_PreOrPos IN BOOLEAN, -- TRUE: POSTPAGO // FALSE: PREPAGO
											v_PrecioMinuto IN SMALLINT DEFAULT -1,
											v_PrecioPlan IN INTEGER DEFAULT -1,
											v_Control IN  BOOLEAN DEFAULT TRUE, 
											v_DescripcionGeneral IN VARCHAR2 DEFAULT 'Sin descripcion')
IS
controlValue NUMBER(1,0);
BEGIN
	IF VALIDAR_PLAN(v_IDPlan) = FALSE THEN
		IF v_PreOrPos = TRUE THEN
			IF v_PrecioPlan != -1 THEN
				controlValue := 0;
				IF v_Control = TRUE THEN
					controlValue := 1;
				END IF;
				INSERT INTO Plan (IDPlan, Nombre, Minutos, GB, Mensajes, PrecioMinAdicional, DescripcionGeneral)
				VALUES (v_IDPlan, v_Nombre, v_Minutos, v_GB, v_Mensajes, v_PrecioMinAdicional, v_DescripcionGeneral);
				INSERT INTO Postpago (IDPlan, PrecioPlan, Control)
				VALUES (v_IDPlan, v_PrecioPlan, controlValue);
				DBMS_OUTPUT.PUT_LINE('Insertado Plan Postpago: '|| v_IDPlan || ' ' || v_Nombre);
			ELSE
				DBMS_OUTPUT.PUT_LINE('Digite el precio del plan.');
			END IF;
		ELSE
			IF v_PrecioMinuto != -1 THEN
				INSERT INTO Plan (IDPlan, Nombre, Minutos, GB, Mensajes, PrecioMinAdicional, DescripcionGeneral)
				VALUES (v_IDPlan, v_Nombre, v_Minutos, v_GB, v_Mensajes, v_PrecioMinAdicional, v_DescripcionGeneral);
				INSERT INTO Prepago (IDPlan, PrecioMinuto)
				VALUES (v_IDPlan, v_PrecioMinuto);
				DBMS_OUTPUT.PUT_LINE('Insertado Plan Prepago: '|| v_IDPlan || ' ' || v_Nombre);
			ELSE
				DBMS_OUTPUT.PUT_LINE('Digite el precio del minuto.');
			END IF;
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('El plan ya existe en la base de datos.');
	END IF;
	EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(' Se presento un error insertando el plan.');
END REGISTRAR_PLAN;