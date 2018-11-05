--01 - DENUNCIAS -------------------------------
DECLARE @INTERACCION AS INT = 1;
DECLARE @CANAL AS INT = 1;
select 
	CASE 
		WHEN ISNUMERIC(RutAcc) = 1
		THEN CAST(RutAcc as int)
		ELSE NULL
	END as RUT
	, CASE 
		WHEN ISDATE(FecAcc) = 1 
		THEN CAST(FecAcc as date) 
		ELSE NULL
	 END as Fecha
	, cast(DvAcc as char(1)) as DV
	, CAST(CONCAT(isnull(LTRIM(RTRIM(NomAcc)),''), ' ', isnull(LTRIM(RTRIM(ApePatAcc)),''), ' ', isnull(LTRIM(RTRIM(ApeMatAcc)),'')) as varchar(300)) as Nombre 
	, CAST(DescripcionYHecho as varchar(2000)) as Descripcion
	, CAST(Estado as varchar(200)) as Estado
	, CAST(comuna as varchar(50)) as Comuna
	, @INTERACCION as Interaccion
	, @CANAL as Canal
	, NULL as Sexo
	, NULL as Fecha_nacimiento
	, NULL as Folio
	, NULL as Telefono
from [dirtrab_plus].[dbo].[AccidentesLaborales] NOLOCK
where 
	ISNUMERIC(RutAcc)=1 
	and RutAcc<>1

Union all

select 
	CASE 
		WHEN ISNUMERIC(SolRut) = 1
		THEN CAST(SolRut as int)
		ELSE NULL
	END as RUT
	, CASE 
		WHEN ISDATE(FechaRegistro) = 1 
		THEN CAST(FechaRegistro as date) 
		ELSE NULL
	 END as Fecha
	, cast(SolDV as char(1)) as DV
	, CAST(CONCAT(isnull(LTRIM(RTRIM(SolNombres)),''), ' ', isnull(LTRIM(RTRIM(SolMaterno)),''), ' ', isnull(LTRIM(RTRIM(SolPaterno)),'')) as varchar(300)) as Nombre 	
	, CAST(declaracionDenunciante as varchar(2000)) as Descripcion
	, NULL as Estado
	, CAST(SolIdCoumna as varchar(50)) as Comuna
	, @INTERACCION as Interaccion
	, @CANAL as Canal
	, NULL as Sexo	
	, CASE 
		WHEN ISDATE(SolFechaNac) = 1 
		THEN CAST(SolFechaNac as date) 
		ELSE NULL
	 END as Fecha_nacimiento
	, NULL as Folio
	, NULL as Telefono
FROM [dirtrab_plus].[dbo].[df_IngresoSolicitud] (NOLOCK)  
WHERE 
	SolRut IS NOT NULL 
	and SolRut<>0 
	and SolRut<>1
------------------------------------------------
--02 - CERTIFICADOS ----------------------------
DECLARE @INTERACCION AS INT = 2;
DECLARE @CANAL AS INT = 4;
DECLARE @DIA AS VARCHAR(2) = '12';
DECLARE @DESCRIPCION_1 AS VARCHAR(30) = 'Certificado Nomina Trabajador';
DECLARE @DESCRIPCION_2 AS VARCHAR(30) = 'Dato Previsional';
DECLARE @DESCRIPCION_3 AS VARCHAR(30) = 'Detalle Despido';
DECLARE @DESCRIPCION_5 AS VARCHAR(30) = 'Certificado Nomina Trabajador';
SELECT 
	CASE 
		WHEN ISNUMERIC(TrabRut) = 1
		THEN CAST(TrabRut as int)
		ELSE NULL
	END as RUT
	, CAST(@DIA + '-' + CASE WHEN PeriodoMes BETWEEN 0 AND 10 THEN RIGHT('0' + CAST(PeriodoMes AS VARCHAR(2)), 2)ELSE CAST(PeriodoMes AS VARCHAR(10))END+'-'+cast(PeriodoAgno as varchar(10)) as date) as Fecha
	, cast(TrabDv as char(1)) as DV
	, CAST(LTRIM(RTRIM(TrabNombre)) as varchar(300)) as Nombre 
	, @INTERACCION as Interaccion
	, @CANAL as Canal
	, @DESCRIPCION_1 as Descripcion 	
	, NULL as Sexo
	, NULL as Fecha_nacimiento
	, NULL as Folio
	, NULL as Estado
	, NULL as Comuna 
	, NULL as Telefono
FROM [dirtrab_plus].[dbo].[cert_NominaTrab] NOLOCK 
where 
	TrabRut !=0 
	and TrabRut<>1 

Union all

SELECT 
	CASE 
		WHEN ISNUMERIC(RutTrabajador) = 1
		THEN CAST(RutTrabajador as int)
		ELSE NULL
	END as RUT
	, CASE
		WHEN ISDATE(periodoMesAno) = 1 
		THEN cast(CONCAT(@DIA, '-', RIGHT(periodoMesAno,2), '-', SUBSTRING(periodoMesAno,1,4)) as date)
		ELSE NULL
	END as Fecha
	, cast(DVTrabajador as char(1)) as DV
	, CAST(LTRIM(RTRIM(NombreTrabajador)) as varchar(300)) as Nombre 
	, @INTERACCION as Interaccion
	, @CANAL as Canal
	, @DESCRIPCION_2 as Descripcion 
	, NULL as Sexo
	, NULL as Fecha_nacimiento
	, NULL as Folio
	, NULL as Estado
	, NULL as Comuna 
	, NULL as Telefono
FROM [ventanilla].[dbo].[CCL_DatoPrevisional2] NOLOCK
where 
	RutTrabajador is not null 
	and ISNUMERIC(RutTrabajador)<>0 
	AND RutTrabajador<>0 
	and NombreTrabajador !='' 
	and RutTrabajador<>1

union all

SELECT 
	CASE 
		WHEN ISNUMERIC(ddes.ruttrab) = 1
		THEN CAST(ddes.ruttrab as int)
		ELSE NULL
	END as RUT
	, CASE
		WHEN ISDATE(p4.fecha_paso4) = 1 
		THEN cast(p4.fecha_paso4 as date)
		ELSE NULL
	END as Fecha
	, cast(ddes.DVTrab as char(1)) as DV	
	, cast((isnull(LTRIM(RTRIM(ddes.NombreTrab)),'')+' '+ isnull(LTRIM(RTRIM(ddes.ApPaternoTrab)),'')+' '+isnull(LTRIM(RTRIM(ddes.ApMaternoTrab)),'')) as Varchar(300)) as Nombre
	, @INTERACCION as Interaccion
	, @CANAL as Canal
	, @DESCRIPCION_3 as Descripcion 
	, NULL as Sexo
	, NULL as Fecha_nacimiento
	--, CONCAT('2000/', CASE WHEN iso.Ano IS NULL THEN '' ELSE rtrim(iso.Ano) END, '/', CASE WHEN cer.CertificadoId IS NULL THEN '' ELSE rtrim(cer.CertificadoId) END) as Folio
	--, CONCAT('2000/', rtrim(iso.Ano), '/', rtrim(cer.CertificadoId)) as Folio
	, NULL as Folio
	, NULL as Estado
	, NULL as Comuna 
	, NULL as Telefono
FROM [ventanilla].[dbo].[CCL_Solicitud] iso
INNER JOIN [ventanilla].[dbo].[CCL_Paso2] (NOLOCK) p2 ON ( iso.SolicitudId = p2.SolicitudId )
INNER JOIN [ventanilla].[dbo].[CCL_Paso4] (NOLOCK) p4 ON ( iso.SolicitudId = p4.SolicitudId )
INNER JOIN [ventanilla].[dbo].[CCL_Certificado] (NOLOCK) cer ON ( cer.Paso2Id = p2.Paso2Id )
INNER JOIN [ventanilla].[dbo].[CCL_DetalleDespido] (NOLOCK) ddes on (ddes.Paso2Id = p2.Paso2Id)
where 
	ddes.RutTrab is not null 
	and ISNUMERIC(ddes.RutTrab)<>0 
	and ddes.RutTrab<>0 and ddes.NombreTrab !='' 
	and ddes.RutTrab<>1

Union all

SELECT 
	CASE 
		WHEN ISNUMERIC(dlar.RutTrab) = 1
		THEN CAST(dlar.RutTrab as int)
		ELSE NULL
	END as RUT
	, CASE
		WHEN ISDATE(p4.fecha_paso4) = 1 
		THEN cast(p4.fecha_paso4 as date)
		ELSE NULL
	END as Fecha
	, cast(dlar.DVTrab as char(1)) as DV	
 	, cast((isnull(LTRIM(RTRIM(dlar.NombreTrab)),'')+' '+isnull(LTRIM(RTRIM(dlar.ApPaternoTrab)),'')+' '+isnull(LTRIM(RTRIM(dlar.ApMaternoTrab)),'')) as VARCHAR(300)) AS Nombre 
	, @INTERACCION as Interaccion
	, @CANAL as Canal
	, cast(dlar.DetalleMensajeCuadratura as varchar(2000)) as Descripcion 
	, NULL as Sexo
	, NULL as Fecha_nacimiento
	, null as Folio
	, NULL as Estado
	, NULL as Comuna 
	, NULL as Telefono
FROM [ventanilla].[dbo].[CCL_Solicitud] (NOLOCK) iso
INNER JOIN [ventanilla].[dbo].[CCL_Paso2] (NOLOCK) p2 ON ( iso.SolicitudId = p2.SolicitudId )
INNER JOIN [ventanilla].[dbo].[CCL_Paso3] (NOLOCK) p3 ON ( iso.SolicitudId = p3.SolicitudId )
INNER JOIN [ventanilla].[dbo].[CCL_Paso4] (NOLOCK) p4 ON ( iso.SolicitudId = p4.SolicitudId )
INNER JOIN [ventanilla].[dbo].[CCL_Certificado] cer ON ( cer.Paso2Id = p2.Paso2Id )
INNER JOIN [ventanilla].[dbo].[CCL_DetalleLAR] (NOLOCK) dlar on (dlar.Paso3Id = p3.Paso3Id)
where 
	RutTrab is not null 
	and ISNUMERIC(RutTrab)<>0 
	and RutTrab<>0 
	and NombreTrab!='' 
	and RutTrab<>1

Union all

SELECT 
	CASE 
		WHEN ISNUMERIC(Rut) = 1
		THEN CAST(Rut as int)
		ELSE NULL
	END as RUT
	, CASE
		WHEN ISDATE(FechaInicio) = 1 
		THEN cast(FechaInicio as date)
		ELSE NULL
	END as Fecha
	, cast(Dv as char(1)) as DV	
	, cast((isnull(LTRIM(RTRIM(Nombre)),'')+' '+isnull(LTRIM(RTRIM(Paterno)),'')+' '+isnull(LTRIM(RTRIM(Materno)),'')) as varchar(300)) as Nombre
	, @INTERACCION as Interaccion
	, @CANAL as Canal
	, @DESCRIPCION_5 as Descripcion 	
	--, CASE
	--	WHEN SEXO IS NULL
	--	then NULL
	--	ELSE cast(case SEXO when 1 then 'F' when 2 then 'M' end as char(1))
	--END as Sexo
	, NULL as Sexo
	, NULL as Fecha_nacimiento
	, NULL as Folio 
	, NULL as Estado
	, NULL as Comuna 
	, NULL as Telefono
FROM [notarios].[dbo].[TrabNomina] NOLOCK
WHERE 
	Rut IS NOT NULL AND ISNUMERIC(Rut)<>0 
	AND Rut<>0 
	AND Rut<>1
-------------------------------------------------
--03 - RECLAMOS ---------------------------------
DECLARE @INTERACCION AS INT = 3;
DECLARE @CANAL_1 AS INT = 1;
DECLARE @CANAL_4 AS INT = 4;
DECLARE @DESCRIPCION_1 AS VARCHAR(30) = 'Trabajo Asesor';
DECLARE @DESCRIPCION_2 AS VARCHAR(30) = 'Otro Afectado';
DECLARE @DESCRIPCION_3 AS VARCHAR(30) = 'Reclamos Reclamante';
DECLARE @DESCRIPCION_4 AS VARCHAR(30) = 'Datos Asistentes Trabajador';
SELECT top 10
	CASE 
		WHEN ISNUMERIC(ases.RUT) = 1
		THEN CAST(ases.RUT as int)
		ELSE NULL
	END as RUT
	, cast(ases.Dv as char(1)) as DV	
	, cast(CONCAT(isnull(LTRIM(RTRIM(ases.NOMBRE_COMPLETO)),''), ' ', isnull(LTRIM(RTRIM(ases.APELLIDO_PATERNO)),''), ' ', isnull(LTRIM(RTRIM(ases.APELLIDO_MATERNO)),'')) as varchar(300)) as Nombre
	, @INTERACCION as Interaccion
	, @CANAL_4 as Canal
	, @DESCRIPCION_1 as Descripcion 
	, NULL as Sexo
	, NULL as Fecha_nacimiento
	, CAST(CONCAT(rtrim(rec.CodOficina), '/', rtrim(rec.Agno), '/', rtrim(rec.NroComision)) as varchar(50)) as Folio
	,CASE
		WHEN rec.FechaReg is not null and ISDATE(rec.FechaReg) = 1
		then cast(rec.FechaReg as date)
		else null 
		end as Fecha
	, NULL as Estado
	, NULL as Comuna 
	, NULL as Telefono
    , NULL as Correo
FROM [conciliaplus].[dbo].[TRABAJADOR_ASESOR] ases 
inner join [conciliaplus].[dbo].[PROCESO_CONCILIACION] pro on (pro.PROC_ID = ases.PROC_ID)
inner join [dirtrab_plus].[dbo].[rec_ingresoreclamo] rec on (pro.idreclamo = rec.idreclamo)
WHERE 
	Rut IS NOT NULL 
	AND ISNUMERIC(Rut)<>0 
	AND Rut<>0 
	and RUT<>1

Union all

SELECT top 10
	CASE 
		WHEN ISNUMERIC(otr.Rut) = 1
		THEN CAST(otr.Rut as int)
		ELSE NULL
	END as RUT
	, cast(otr.Dv as char(1)) as DV	
	, cast(CONCAT(isnull(LTRIM(RTRIM(otr.Nombres)),''), ' ', isnull(LTRIM(RTRIM(otr.Paterno)),''), ' ' , isnull(LTRIM(RTRIM(otr.Materno)),'')) as varchar(300)) as Nombre	
	, @INTERACCION as Interaccion
	, @CANAL_1 as Canal
	, @DESCRIPCION_2 as Descripcion 
	, cast(otr.Sexo as char(1)) as Sexo 
	, CASE
		WHEN iso.SolFechaNac is not null and ISDATE(iso.SolFechaNac) = 1
		THEN CAST(iso.SolFechaNac AS DATE) 
		ELSE NULL
	  END as Fecha_nacimiento
	, CAST(CONCAT(rtrim(ing.CodOficina), '/', rtrim(ing.Agno), '/', rtrim(ing.NroComision)) as varchar(50)) as Folio
	, CASE
		WHEN iso.FechaRegistro is not null and ISDATE(iso.FechaRegistro) = 1
		THEN CAST(iso.FechaRegistro AS DATE)
		ELSE NULL
	  END as Fecha
	, NULL as Estado
	, NULL as Comuna 
	, NULL as Telefono
    , NULL as Correo
FROM [dirtrab_plus].[dbo].[df_OtroAfectado] otr 
     inner join  [dirtrab_plus].[dbo].[df_IngresoSolicitud] iso on (iso.IDDerechoFundamental = otr.IDDerechoFundamental)
	 inner join [dirtrab_plus].[dbo].[FI_INGRESO_FISCALIZACION] ing on (ing.IDFiscalizacion = iso.IDFiscalizacion)
WHERE 
	Rut IS NOT NULL 
	AND Rut !=0 
	AND Rut !=1 
	AND Rut !=123
	AND iso.CodTipoTermino = 1

Union all

select top 10
	CASE 
		WHEN ISNUMERIC(Rut) = 1
		THEN CAST(Rut as int)
		ELSE NULL
	END as RUT
	, CAST(Dv AS char(1)) AS DV
	, CAST(CONCAT(isnull(LTRIM(RTRIM(Nombre)),''), ' ', isnull(LTRIM(RTRIM(Paterno)),''), ' ', isnull(LTRIM(RTRIM(Materno)),'')) AS varchar(300)) as Nombre
	, @INTERACCION as Interaccion
	, @CANAL_1 as Canal
	, @DESCRIPCION_3 as Descripcion 
	, cast(Sexo as char(1)) as Sexo 
	, CASE
		WHEN FechaNac is not null and ISDATE(FechaNac) = 1
		THEN cast(FechaNac as date)
		ELSE NULL
	END as Fecha_nacimiento
	, NULL as Folio 
	, CASE
		WHEN FecInicioRL is not null and ISDATE(FecInicioRL) = 1
		THEN cast(FecInicioRL as date)
		ELSE NULL
	END as Fecha
	, NULL as Estado
	, NULL as Comuna 
	, NULL as Telefono
    , NULL AS Correo
FROM [dirtrab_plus].[dbo].[rec_Reclamante] NOLOCK
WHERE 
	Rut IS NOT NULL 
	AND ISNUMERIC(Rut)<>0 
	AND Rut<>0 AND Rut<>1

Union all

select top 10
	CASE 
		WHEN ISNUMERIC(tra.Rut) = 1
		THEN CAST(tra.Rut as int)
		ELSE NULL
	END as RUT
	, cast(tra.DV as char(1)) as DV
	, cast(CONCAT(isnull(LTRIM(RTRIM(tra.NOMBRES)),''), ' ', isnull(LTRIM(RTRIM(tra.APELLIDO_PATERNO)),''), ' ', isnull(LTRIM(RTRIM(tra.APELLIDO_MATERNO)),'')) as varchar(300)) as Nombre
	, @INTERACCION as Interaccion
	, @CANAL_1 as Canal
	, @DESCRIPCION_4 as Descripcion 
	, CASE
		WHEN tra.SEXO IS NULL
		then NULL
		ELSE cast(case tra.SEXO when '1' then 'M' when '2' then 'F' end as char(1))
	END as Sexo
	, CASE
		WHEN tra.FECHA_NACIMIENTO is not null and ISDATE(tra.FECHA_NACIMIENTO) = 1
		THEN cast(tra.FECHA_NACIMIENTO as date)
		ELSE NULL
	    END as Fecha_nacimiento
	, CAST(CONCAT(rtrim(rec.CodOficina), '/', rtrim(rec.Agno), '/', rtrim(rec.NroComision)) as varchar(50)) as Folio
	, CASE
		WHEN rec.FechaReg is not null and ISDATE(rec.FechaReg) = 1
		  THEN CAST(rec.FechaReg AS DATE)
		  ELSE NULL
	  END as Fecha
	, NULL as Estado
	, CAST(tra.DIR_ID_COMUNA as varchar(50)) as Comuna
	, NULL as Telefono
	, NULL as Correo
FROM [conciliaplus].[dbo].[DATOS_ASISTENTES_TRABAJADOR] tra
  inner join [conciliaplus].[dbo].[PROCESO_CONCILIACION] pro on (pro.PROC_ID = tra.PROC_ID)
  inner join [dirtrab_plus].[dbo].[rec_ingresoreclamo] rec on (pro.idreclamo = rec.idreclamo)
WHERE 
	Rut IS NOT NULL 
	AND ISNUMERIC(Rut)<>0 
	AND Rut<>0 
	AND RUT<>1
-------------------------------------------------
--04 - CARTA DE AVISO ---------------------------
DECLARE @INTERACCION AS INT = 4;
DECLARE @CANAL AS INT = 4;
select 
	CASE 
		WHEN ISNUMERIC(RutTrab) = 1
		THEN CAST(RutTrab as int)
		ELSE NULL
	END as RUT
	, cast(DVTrab as char(1)) as DV
	, cast(CONCAT(isnull(LTRIM(RTRIM(NombresTrab)),''), ' ', isnull(LTRIM(RTRIM(ApPaternoTrab)),''), ' ', isnull(LTRIM(RTRIM(ApMaternoTrab)),'')) as Varchar(300)) as Nombre
	, @INTERACCION as Interaccion
	, @CANAL as Canal
	, cast(DescripcionHecho as varchar(2000)) as Descripcion 
	, cast(Sexo as char(1)) as Sexo 
	, NULL as Fecha_nacimiento
	, NULL as Folio	
	, CASE
		WHEN ISDATE(fechaIngreso) = 1 
		THEN cast(fechaIngreso as date)
		ELSE NULL
	END as Fecha
	, cast(EstadoCotizaciones as varchar(200)) as Estado
	, CAST(IdComunaTrabajo as varchar(50)) as Comuna
	, NULL as Telefono
FROM [ventanilla].[dbo].[Ven_CartaAviso_Trabajador_Itel] NOLOCK
WHERE 
	RutTrab IS NOT NULL 
	AND ISNUMERIC(RutTrab)<>0 
	AND RutTrab<>0 
	and NombresTrab !='' 
	and RutTrab<>1

Union all

select 
	CASE 
		WHEN ISNUMERIC(TrabRut) = 1
		THEN CAST(TrabRut as int)
		ELSE NULL
	END as RUT
	, cast(TrabDv as char(1)) as DV
	, cast(CONCAT(isnull(LTRIM(RTRIM(TrabNombres)),''), ' ', isnull(LTRIM(RTRIM(TrabApPaterno)),''), ' ', isnull(LTRIM(RTRIM(TrabApMaterno)),'')) as varchar(300)) as Nombre
	, @INTERACCION as Interaccion
	, @CANAL as Canal
	, CAST(HechosCausal as varchar(2000)) as Descripcion 
	, cast(case TrabSexo  when 'A' then 'M' when 'D' then 'M' when 'F' then 'F' when 'H' then 'M' when 'L' then 'F' when 'M' then 'M' when '0' then 'M' when 'R' then 'M' when null then '' end as char(1)) as Sexo
	, NULL as Fecha_nacimiento
	, NULL as Folio	
	, CASE
		WHEN ISDATE(FechaReg) = 1 
		THEN cast(FechaReg as date)
		ELSE NULL
	END as Fecha
	, cast(EstadoCotizaciones as varchar(200)) as Estado
	, NULL as Comuna
	, NULL as Telefono
FROM [ventanilla].[dbo].[ven_CartaAvisoMasivaTrabajador] NOLOCK
where TrabRut is not null 
	and ISNUMERIC(TrabRut)<>0 
	and TrabRut<>0 
	and TrabNombres !='' 
	and TrabRut<>1
-------------------------------------------------
--05 - CONSTANCIA -------------------------------
DECLARE @INTERACCION AS INT = 5;
DECLARE @CANAL AS INT = 4;
select top 10
	CASE 
		WHEN ISNUMERIC(rut_dec) = 1
		THEN CAST(rut_dec as int)
		ELSE NULL
	END as RUT
	, CAST(dv_dec AS char(1)) as DV
	, cast(CONCAT(isnull(LTRIM(RTRIM(nombres_dec)),''), ' ', isnull(LTRIM(RTRIM(ap_paterno_dec)),''), ' ', isnull(LTRIM(RTRIM(ap_materno_dec)),'')) as varchar(300)) as Nombre 
	, CASE
		WHEN ISDATE(fecha) = 1 
		THEN cast(fecha as date)
		ELSE NULL
	END as Fecha
	, cast(declaracion as varchar(2000)) as Descripcion 
	, @INTERACCION as Interaccion
	, @CANAL as Canal
	, NULL as Sexo
	, NULL as Fecha_nacimiento
	, NULL as Folio 
	, NULL as Estado
	, NULL as Comuna
	, NULL as Telefono
FROM [ventanilla].[dbo].[Ven_Constancia] NOLOCK
where 
	rut_dec is not null 
	and ISNUMERIC(rut_dec)<>0 
	and rut_dec<>0 
	and nombres_dec !='' 
	and rut_dec<>1 
	and rut_dec >1000

Union all

Select top 10
	CASE 
		WHEN ISNUMERIC(RUT) = 1
		THEN CAST(RUT as int)
		ELSE NULL
	END as RUT
	, CAST(Dv_Dec as char(1)) as DV
	, cast(CONCAT(isnull(LTRIM(RTRIM(NombreDec)),''), ' ', isnull(LTRIM(RTRIM(ApPaterno)),''), ' ', isnull(LTRIM(RTRIM(ApMaterno)),'')) as varchar(300)) as Nombre
	, CASE
		WHEN ISDATE(fecha) = 1 
		THEN cast(fecha as date)
		ELSE NULL
	END as Fecha
	, cast(declaracion as varchar(2000)) as Descripcion  
	, @INTERACCION as Interaccion
	, NULL as Canal
	, NULL as Sexo
	, NULL as Fecha_nacimiento
	, CAST(CONCAT(right(replicate(' ',4) + CodOficina,4), '/', right(replicate(' ',4) + Agno,4), '/', CONVERT(VARCHAR, Corre)) as varchar(50)) as Folio
	, NULL as Estado
	, CAST(comuna as varchar(50)) as Comuna
	, NULL as Telefono
FROM [ventanilla].[dbo].[Ven_Constancia_Itel] NOLOCK
where 
	RutDec is not null 
	and ISNUMERIC(RutDec)<>0 
	and RutDec<>0 
	and RutDec > 1000 
	and NombreDec !='' 
	and RutDec<>1 
	and Dv_Dec is not null 
	and rut >1000
-------------------------------------------------
--06 - FISCALIZACION ----------------------------
Declare @Interaccion as int = 6;
Declare @Canal as int = 1;
SELECT top 10
	  CASE
		WHEN MenRut IS NOT NULL AND MenRut <> ''
		THEN cast(MenRut as int)
		ELSE NULL
	  END as RUT
	, CASE
		WHEN MenDv IS NOT NULL AND MenDv <> ''
		THEN cast(MenDv as char(1))
		ELSE NULL
	  END as DV	
	, CASE
		WHEN MenFechaNac IS NOT NULL AND ISDATE(MenFechaNac) = 1
		THEN CAST(MenFechaNac as date)
		ELSE NULL
	  END as Fecha_nacimiento
	, CASE
		WHEN FechaReg IS NOT NULL AND ISDATE(FechaReg) = 1
		THEN CAST(FechaReg as date)
		ELSE NULL
	  END as Fecha
	, CAST((
		ISNULL((LTRIM(RTRIM(MenNombres))),'') +' '+
		ISNULL((LTRIM(RTRIM(MenApPaterno))),'') +' '+
		ISNULL((LTRIM(RTRIM(MenApMaterno))),'')) as varchar(300)) as Nombre		
	, CAST(MenDomCodComuna as varchar(50)) as Comuna	
	, CASE 
		WHEN MenSexo IS NULL
		THEN NULL
		ELSE cast(MenSexo as char(1))
	END as Sexo 
	, NULL as Folio
	, NULL as Estado
	, NULL as Descripcion
	, NULL as Telefono
	, @Interaccion as Interaccion
	, @Canal as Canal	
FROM [dirtrab_plus].[dbo].[fi_NominaMenor] NOLOCK
WHERE 
	MenRut IS NOT NULL 
	AND ISNUMERIC(MenRut) <> 0 
	AND MenRut <> 0 
	AND MenRut <> 1

Union all

SELECT top 10
	  CASE
		WHEN SolRut IS NOT NULL AND SolRut <> ''
		THEN CAST(SolRut as int)
		ELSE NULL
	  END as RUT
	, CASE
		WHEN SolDv IS NOT NULL AND SolDv <> ''
		THEN CAST(SolDv as char(1))
		ELSE NULL
	  END as DV
	, CASE
		WHEN SolFechaNac IS NOT NULL AND ISDATE(SolFechaNac) = 1
		THEN CAST(SolFechaNac as date)
		ELSE NULL
	  END as Fecha_nacimiento
	, CASE
		WHEN FechaOrigen IS NOT NULL AND ISDATE(FechaOrigen) = 1
		THEN CAST(FechaOrigen as date)
		ELSE NULL
	  END as Fecha
	, CAST((
		ISNULL((LTRIM(RTRIM(SolNombres))),'') +' '+ 
		ISNULL(LTRIM(RTRIM(SolPaterno)),'') +' '+	
		ISNULL(LTRIM(RTRIM(SolMaterno)),'')) as varchar(300)) as Nombre
	, CAST(EmpDireccion as varchar(50)) as Comuna	
	, CASE 
		WHEN SolSexo IS NULL
		THEN NULL
		ELSE cast(SolSexo as char(1))
	END as Sexo 
	, CAST(CONCAT(right(replicate(' ',4) + CodOficina,4), '/', right(replicate(' ',4) + Agno,4), '/', CONVERT(VARCHAR, NroComision)) as varchar(50)) as Folio
	, NULL as Estado
	, NULL as Descripcion 
	, NULL as Telefono
	, @Interaccion as Interaccion
	, @Canal as Canal    
from [dirtrab_plus].[dbo].[FI_INGRESO_FISCALIZACION] NOLOCK
WHERE 
	SolRut IS NOT NULL 
	AND ISNUMERIC(SolRut) <> 0 
	AND SolRut <> 0 
	AND SolRut <> 1
-------------------------------------------------
--07 - MINISTRO DE FE (AFC) ---------------------
Declare @Interaccion as int = 7;
Declare @Canal as int = NULL;
SELECT top 10
	  CASE
		WHEN TrabRut IS NOT NULL AND TrabRut <> ''
		THEN CAST(TrabRut as int)
		ELSE NULL
	  END as RUT
	, CASE
		WHEN FechaReg IS NOT NULL AND ISDATE(FechaReg) = 1
		THEN CAST(FechaReg as date)
		ELSE NULL
	  END as Fecha
	, CAST(TrabDv as char(1)) as DV
	, CAST((
		ISNULL((LTRIM(RTRIM(TrabNombre))),'') +' '+
		ISNULL((LTRIM(RTRIM(TrabPaterno))),'') +' '+
		ISNULL((LTRIM(RTRIM(TrabMaterno))),'')) as varchar(300)) as Nombre
	, CAST(ISNULL(TrabSexo ,'') as char(1)) AS Sexo
	, CAST(EmpDireccion as varchar(50)) as Comuna	
	, NULL as Descripcion 
	, NULL as Estado
	, CAST(CONCAT(right(replicate(' ',4) + CodOficina,4), '/', right(replicate(' ',4) + Agno,4), '/', CONVERT(VARCHAR, NroActuacion)) as varchar(50)) as Folio
	, NULL as Telefono
	, @Interaccion as Interaccion
	, @Canal as Canal
FROM [dirtrab_plus].[dbo].[mf_CertificadoAFC] NOLOCK
WHERE 
	TrabRut IS NOT NULL 
	AND ISNUMERIC(TrabRut)<>0 
	AND TrabRut<>0 
	AND TrabRut<>1
-------------------------------------------------
--08 - MINISTRO DE FE(CONSTANCIA) ---------------
Declare @Interaccion as int = 8;
Declare @Canal as int = NULL;
SELECT top 10
	CASE
		WHEN TrabRut IS NOT NULL AND TrabRut <> ''
		THEN CAST(TrabRut as int)
		ELSE NULL
	END as RUT	
	,CASE
		WHEN FechaReg IS NOT NULL AND ISDATE(FechaReg) = 1
		THEN CAST(FechaReg as date)
		ELSE NULL
	END as Fecha
	, CAST(TrabDv as char(1)) as DV
	, CAST((
		ISNULL((LTRIM(RTRIM(TrabNombre))),'')+' '+
		ISNULL((LTRIM(RTRIM(TrabPaterno))),'')+' '+
		ISNULL((LTRIM(RTRIM(TrabMaterno))),'')) as varchar(300)) as Nombre
	, CAST(ISNULL(TrabSexo ,'') as char(1)) AS Sexo
	, CAST(Motivo as varchar(2000)) as Descripcion 
	, CAST(EmpCodComuna as varchar(50)) as Comuna	
	, NULL as Estado 
	, CAST(CONCAT(right(replicate(' ',4) + CodOficina,4), '/', right(replicate(' ',4) + Agno,4), '/', CONVERT(VARCHAR, NroActuacion)) as varchar(50)) as Folio
	, NULL as Fecha_nacimiento
	, NULL as Telefono
	, @Interaccion as Interaccion
	, @Canal as Canal	
FROM [dirtrab_plus].[dbo].[mf_Constancia] NOLOCK
WHERE 
	TrabRut IS NOT NULL 
	AND ISNUMERIC(TrabRut) <> 0 
	AND TrabRut <> 0 
	AND TrabRut <> 1
-------------------------------------------------
--09 - Ministro de Fe (Declaración Jurada) ------
Declare @Interaccion as int = 9;
Declare @Canal as int = NULL;
SELECT top 10
	  CASE
		WHEN TrabRut IS NOT NULL AND TrabRut <> ''
		THEN CAST(TrabRut as int)
		ELSE NULL
	  END as RUT	
	, CASE
		WHEN FechaReg IS NOT NULL AND ISDATE(FechaReg) = 1
		THEN CAST(FechaReg as date)
		ELSE NULL
	  END as Fecha
	, CAST(TrabDv as char(1)) as DV
	, CAST((
		ISNULL((LTRIM(RTRIM(TrabNombre))),'') +' '+
		ISNULL((LTRIM(RTRIM(TrabPaterno))),'') +' '+
		ISNULL((LTRIM(RTRIM(TrabMaterno))),'')) as varchar(300)) as Nombre
	, CAST(ISNULL(TrabSexo ,'')as char(1)) AS Sexo	
	, CAST(EmpCodComuna as varchar(50)) as Comuna	
	, CAST(Declaracion as varchar(2000)) as Descripcion	
	, NULL as Estado  
	, CAST(CONCAT(right(replicate(' ',4) + CodOficina,4), '/', right(replicate(' ',4) + Agno,4), '/', CONVERT(VARCHAR, NroActuacion)) as varchar(50)) as Folio
	, NULL as Fecha_nacimiento
	, NULL as Telefono
	, @Interaccion as Interaccion
	, @Canal as Canal
	
FROM [dirtrab_plus].[dbo].[mf_DecJurada] NOLOCK
WHERE 
	TrabRut IS NOT NULL 
	AND ISNUMERIC(TrabRut) <> 0 
	AND TrabRut <> 0 
	and TrabRut <> 1
-------------------------------------------------
--10 - MINISTRO DE FE (FINIQUITO) ---------------
Declare @Interaccion as int = 10;
Declare @Canal as int = NULL;
SELECT top 10
	 CASE
		WHEN TrabRut IS NOT NULL AND TrabRut <> ''
		THEN CAST(TrabRut as int)
		ELSE NULL
	  END as RUT	
	, CASE
		WHEN FechaReg IS NOT NULL AND ISDATE(FechaReg) = 1
		THEN CAST(FechaReg as date)
		ELSE NULL
	  END as Fecha
	, CAST(TrabDv as char(1)) as DV
	, CAST((
		isnull((LTRIM(RTRIM(TrabNombre))),'') +' '+
		isnull((LTRIM(RTRIM(TrabPaterno))),'') +' '+
		isnull((LTRIM(RTRIM(TrabMaterno))),'')) as varchar(300)) as Nombre
	, CAST(case TrabSexo when 'F' then 'F' when 'M' then 'M' end as char(1)) as Sexo
	, CAST(EmpCodComuna as varchar(50)) as Comuna	
	, NULL as Fecha_nacimiento
	, NULL as Descripcion 
	, NULL as Estado
	, CAST(CONCAT(right(replicate(' ',4) + CodOficina,4), '/', right(replicate(' ',4) + Agno,4), '/', CONVERT(VARCHAR, NroActuacion)) as varchar(50)) as Folio
	, NULL as Telefono
	, @Interaccion as Interaccion
	, @Canal as Canal    
FROM [dirtrab_plus].[dbo].[mf_finiquito] NOLOCK
WHERE 
	TrabRut IS NOT NULL 
	AND ISNUMERIC(TrabRut) <> 0 
	AND TrabRut <> 0 
	and TrabRut <> 1
-------------------------------------------------
--11 - MINISTRO DE FE (RENUNCIA) ----------------
Declare @Interaccion as int = 11;
Declare @Canal as int = NULL;
SELECT top 10
	CASE
		WHEN TrabRut IS NOT NULL AND TrabRut <> ''
		THEN CAST(TrabRut as int)
		ELSE NULL
	  END as RUT	
	, CASE
		WHEN FechaReg IS NOT NULL AND ISDATE(FechaReg) = 1
		THEN CAST(FechaReg as date)
		ELSE NULL
	  END as Fecha
	, CAST(TrabDv as char(1)) as DV
	, CAST((
		ISNULL(LTRIM(RTRIM(TrabNombre)),'') +' '+
		ISNULL((LTRIM(RTRIM(TrabPaterno))),'') +' '+
		ISNULL((LTRIM(RTRIM(TrabMaterno))),'')) as varchar(300)) as Nombre
	, CAST(ISNULL(TrabSexo ,'')as char(1)) AS Sexo
	, CAST(EmpCodComuna as varchar(50)) as Comuna		
	, NULL as Descripcion 
	, NULL as Estado
	, CAST(CONCAT(right(replicate(' ',4) + CodOficina,4), '/', right(replicate(' ',4) + Agno,4), '/', CONVERT(VARCHAR, NroActuacion)) as varchar(50)) as Folio
	, NULL as Fecha_nacimiento
	, NULL as Telefono
	, @Interaccion as Interaccion
	, @Canal as Canal	
FROM [dirtrab_plus].[dbo].[mf_Renuncia] NOLOCK
WHERE 
	TrabRut IS NOT NULL 
	AND ISNUMERIC(TrabRut) <> 0 
	AND TrabRut <> 0 
	and TrabRut <> 1
-------------------------------------------------
--12 - Ministro de Fe (Término de contrato TCP) -
Declare @Interaccion as int = 12;
Declare @Canal as int = NULL;
SELECT top 10
	  CASE
		WHEN TrabRut IS NOT NULL AND TrabRut <> ''
		THEN CAST(TrabRut as int)
		ELSE NULL
	  END as RUT	
	, CASE
		WHEN FechaReg IS NOT NULL AND ISDATE(FechaReg) = 1
		THEN CAST(FechaReg as date)
		ELSE NULL
	  END as Fecha
	, CAST(TrabDv AS char(1)) AS DV
	, CAST((
		isnull(LTRIM(RTRIM(TrabNombre)),'')+' '+
		isnull(LTRIM(RTRIM(TrabPaterno)),'')+' '+
		isnull(LTRIM(RTRIM(TrabMaterno)),'')) AS VARCHAR(300)) as Nombre
	, CAST(case TrabSexo when 'F' then 'F' when 'M' then 'M' end as char(1)) as Sexo
	, CAST(EmpCodComuna as varchar(50)) as Comuna
	, NULL as Descripcion 
	, NULL as Estado
	, NULL as Fecha_nacimiento
	, CAST(CONCAT(right(replicate(' ',4) + CodOficina,4), '/', right(replicate(' ',4) + Agno,4), '/', CONVERT(VARCHAR, NroActuacion)) as varchar(50)) as Folio
	, NULL as Telefono
	, @Interaccion as Interaccion
	, @Canal as Canal	
FROM [dirtrab_plus].[dbo].[mf_TerContratoCasa] NOLOCK
WHERE 
	TrabRut IS NOT NULL 
	AND ISNUMERIC(TrabRut) <> 0 
	AND TrabRut <> 0 
	and TrabRut <> 1
-------------------------------------------------
--13 - MINISTRO DE FE (TERMINO DE CONTRATO) -----
Declare @Interaccion as int = 13;
Declare @Canal as int = NULL;
SELECT top 10
	  CASE
		WHEN TrabRut IS NOT NULL AND TrabRut <> ''
		THEN CAST(TrabRut as int)
		ELSE NULL
	  END as RUT	
	, CASE
		WHEN FechaReg IS NOT NULL AND ISDATE(FechaReg) = 1
		THEN CAST(FechaReg as date)
		ELSE NULL
	  END as Fecha
	, CAST(TrabDv AS CHAR(1)) AS DV
	, CAST((
		ISNULL(LTRIM(RTRIM(TrabNombre)),'')+' '+
		ISNULL(LTRIM(RTRIM(TrabPaterno)),'')+' '+
		ISNULL(LTRIM(RTRIM(TrabMaterno)),''))AS VARCHAR(300)) as Nombre
	, CAST(ISNULL(TrabSexo ,'') AS CHAR(1)) AS Sexo 
	, CAST(EmpCodComuna as varchar(50)) as Comuna	
	, NULL as Descripcion 
	, NULL as Estado
	, NULL as Fecha_nacimiento
	, CAST(CONCAT(right(replicate(' ',4) + CodOficina,4), '/', right(replicate(' ',4) + Agno,4), '/', CONVERT(VARCHAR, NroActuacion)) as varchar(50)) as Folio
	, NULL as Telefono
	, @Interaccion as Interaccion
	, @Canal as Canal	
FROM [dirtrab_plus].[dbo].[mf_TerminoContrato] NOLOCK
WHERE 
	TrabRut IS NOT NULL 
	AND ISNUMERIC(TrabRut) <> 0 
	AND TrabRut <> 0 
	AND TrabRut <> 1
-------------------------------------------------
--14 - MINISTRO DE FE (CONTRATO DE MENORES) -----
Declare @Interaccion as int = 14;
Declare @Canal as int = NULL;
SELECT top 10
	  CASE
		WHEN TrabRut IS NOT NULL AND TrabRut <> ''
		THEN CAST(TrabRut as int)
		ELSE NULL
	  END as RUT	
	, CASE
		WHEN FechaReg IS NOT NULL AND ISDATE(FechaReg) = 1
		THEN CAST(FechaReg as date)
		ELSE NULL
	  END as Fecha
	, CAST(TrabDv AS CHAR(1)) AS DV
	, CAST((
		ISNULL(LTRIM(RTRIM(TrabNombre)),'')+' '+
		ISNULL(LTRIM(RTRIM(TrabPaterno)),'')+' '+
		ISNULL(LTRIM(RTRIM(TrabMaterno)),''))AS VARCHAR(300)) as Nombre
	, CAST(ISNULL(TrabSexo ,'')AS CHAR(1)) AS Sexo 
	, CAST(TrabCodComuna as varchar(50)) as Comuna
	, NULL as Descripcion 
	, NULL as Estado
	, NULL as Fecha_nacimiento
	, CAST(CONCAT(right(replicate(' ',4) + CodOficina,4), '/', right(replicate(' ',4) + Agno,4), '/', CONVERT(VARCHAR, NroActuacion)) as varchar(50)) as Folio 
	, NULL as Telefono
	, @Interaccion as Interaccion
	, @Canal as Canal	
FROM [dirtrab_plus].[dbo].[mf_TerminoContratoMenores] NOLOCK
WHERE 
	TrabRut IS NOT NULL 
	AND ISNUMERIC(TrabRut) <> 0 
	AND TrabRut <> 0 
	AND TrabRut <> 1
-------------------------------------------------
--15 - MINISTRO DE FE (TRABAJO PESADO) ----------
Declare @Interaccion as int = 15;
Declare @Canal as int = 1;
SELECT top 10
	  CASE
		WHEN TrabRut IS NOT NULL AND TrabRut <> ''
		THEN CAST(TrabRut as int)
		ELSE NULL
	  END as RUT	
	, CASE
		WHEN FechaReg IS NOT NULL AND ISDATE(FechaReg) = 1
		THEN CAST(FechaReg as date)
		ELSE NULL
	  END as Fecha
	, CAST(TrabDv AS CHAR(1)) AS DV
	, CAST((
		ISNULL(LTRIM(RTRIM(TrabNombre)),'')+' '+
		ISNULL(LTRIM(RTRIM(TrabPaterno)),'')+' '+
		ISNULL(LTRIM(RTRIM(TrabMaterno)),''))AS VARCHAR(300)) as Nombre
	, CAST(ISNULL(TrabSexo ,'') AS CHAR(1)) AS Sexo 
	, CAST(EmpCodComuna as varchar(50)) as Comuna
	, NULL as Descripcion 
	, NULL as Estado
	, NULL as Fecha_nacimiento
	, CAST(CONCAT(right(replicate(' ',4) + CodOficina,4), '/', right(replicate(' ',4) + Agno,4), '/', CONVERT(VARCHAR, NroActuacion)) as varchar(50)) as Folio 
	, NULL as Telefono
	, @Interaccion as Interaccion
	, @Canal as Canal	
FROM [dirtrab_plus].[dbo].[mf_TrabPesado] NOLOCK
WHERE 
	TrabRut IS NOT NULL 
	AND ISNUMERIC(TrabRut) <> 0 
	AND TrabRut <> 0 
	AND TrabRut <> 1
-------------------------------------------------
--16 - TRAMITE EN LÍNEA (TCP) -------------------
Declare @Interaccion as int = 16
Declare @Canal as int = 4
SELECT top 10	
	CASE
		WHEN tra.RutTrab IS NOT NULL AND tra.RutTrab <> ''
		THEN CAST(tra.RutTrab as int)
		ELSE NULL
	  END as RUT
	, CASE tra.sexo
		WHEN 1 THEN CAST('F' as nvarchar(1))
		WHEN 2 THEN CAST('M' as varchar(1))
	  END as Sexo
	, CAST(tra.dvTrab as varchar(10)) as DV
	, CAST(ISNULL(LTRIM(RTRIM(tra.NombreTrab)),'') as varchar(250)) as Nombre	
	, CAST(tra.codCom as varchar(50)) as Comuna
    , NULL Telefono
    , NULL Correo 
	, CAST(tra.fechaNacimiento as date) as Fecha_nacimiento
	, 'N/A' as Folio 
	, CASE
		WHEN con.fechaRegistro IS NOT NULL AND ISDATE(con.fechaRegistro) = 1
		THEN CAST(con.fechaRegistro AS DATE)
		ELSE NULL
		END as Fecha
	, con.motivoTermino as Descripcion 
	, NULL as Estado
	, @Interaccion as Interaccion
	, @Canal as Canal
FROM ventanilla.dbo.TCP_Contrato con 
Inner join [ventanilla].[dbo].[TCP_Trabajador] as tra  on (con.idTrabajador = tra.idTrabajador)
left join [ventanilla].[dbo].[TCP_Empleador] emp on (emp.Rut = con.rutEmpleador)
WHERE 
	RutTrab IS NOT NULL 
	AND ISNUMERIC(RutTrab) <> 0 
	AND RutTrab <> -1 
	AND RutTrab <> 0 
	and RutTrab > 2000 
	and NombreTrab != '' 
	and rutTrab <> -1
-------------------------------------------------
--17 - TRÁMITE EN LÍNEA (INCLUSIÓN) -------------
Declare @Interaccion as int = 17;
Declare @Canal as int = 4;
SELECT 
	  CASE
		WHEN RUT IS NOT NULL AND RUT <> ''
		THEN CAST(RUT as int)
		ELSE NULL
	  END as RUT	
	, CASE
		WHEN Fecha_Registro IS NOT NULL AND ISDATE(Fecha_Registro) = 1
		THEN CAST(Fecha_Registro as date)
		ELSE NULL
	  END as Fecha	
	, CASE sexo
		WHEN 'H'		 THEN CAST('M' as char(1))
		WHEN 'M'		 THEN CAST('F' as char(1))
		WHEN 'Masculino' THEN CAST('M' as char(1))
		WHEN 'MASCULINO' THEN CAST('M' as char(1))
		WHEN 'Hombre'	 THEN CAST('M' as char(1))
		WHEN 'FENENINO'  THEN CAST('F' as char(1))
		WHEN 'Mujer'	 THEN CAST('F' as char(1))		
		WHEN ''			 THEN NULL
	  END as Sexo
	, CAST(DV as char(1)) as DV
	, CAST((
		ISNULL(LTRIM(RTRIM(Nombre)),'')+' '+
		ISNULL(LTRIM(RTRIM(Apellido_Paterno)),'')+' '+
		ISNULL(LTRIM(RTRIM(Apellido_Materno)),'')) as varchar(300)) as Nombre	
	, CAST(ISNULL(Fecha_Nacimiento,'') as datetime) as Fecha_Nacimiento
	, CAST(Email as varchar(100)) as Correo
	, CAST(Celular as varchar(15)) as Telefono 
	, CAST(Comuna_Trabajador as varchar(50)) as Comuna
	, NULL as Folio 	
	, NULL as Descripcion 
	, NULL as Estado
	, @Interaccion as Interaccion
	, @Canal as Canal	
FROM [ventanilla].[dbo].[Inclusion_Trabajadores] NOLOCK
WHERE 
	RUT IS NOT NULL
	AND ISNUMERIC(RUT) <> 0 
	AND RUT <> 0 
	AND Nombre !='' 
	AND RUT <> 1
-------------------------------------------------
--18 - MINISTRO DE FE (LICENCIA MÉDICA) -------OK
Declare @Interaccion as int = 18;
Declare @Canal as int = NULL;
SELECT top 10
	  CASE
		WHEN DecRut IS NOT NULL AND DecRut <> ''
		THEN CAST(DecRut as int)
		ELSE NULL
	  END as RUT	
	, CASE
		WHEN FechaReg IS NOT NULL AND ISDATE(FechaReg) = 1
		THEN CAST(FechaReg as date)
		ELSE NULL
	  END as Fecha	
	, CAST(DecDv as char(1)) as DV
	, CAST((
		ISNULL((LTRIM(RTRIM(DecNombre))),'')+' '+
		ISNULL((LTRIM(RTRIM(DecPaterno))),'')+' '+
		ISNULL((LTRIM(RTRIM(DecMaterno))),'')) as varchar(300)) as Nombre 
	, CAST(ISNULL(DecSexo ,'') as char(1)) AS Sexo 
	, CAST(EmpCodComuna as varchar(50)) as Comuna
	, CAST(MotivoNeg as varchar(2000)) as Descripcion 
	, NULL as Estado
	, NULL as Fecha_nacimiento
	, CAST((
		right(replicate(' ',4) + CodOficina,4) + '/' + 
		right(replicate(' ',4) + Agno,4) +
		CONVERT(VARCHAR, NroActuacion)) as varchar(200)) as Folio
	, NULL as Telefono
	, @Interaccion as Interaccion
	, @Canal as Canal	
FROM [dirtrab_plus].[dbo].[mf_LicMedica] NOLOCK
WHERE 
	DecRut IS NOT NULL 
	AND ISNUMERIC(DecRut) <> 0 
	AND DecRut <> 0 
	AND DecRut <> 1