--01 - DENUNCIAS -------------------------------
select 
	CAST(RutAcc as int) as RUT
	, cast(DvAcc as varchar(10)) as DV
	, (isnull(LTRIM(RTRIM(NomAcc)),'')+' '+isnull(LTRIM(RTRIM(ApePatAcc)),'')+' '+isnull(LTRIM(RTRIM(ApeMatAcc)),'')) as Nombre
	, '' as Sexo
	,CAST('' as date) as 'Fecha_nacimiento'
	,'' as 'Folio' 
	,01 as "Interaccion"
	,1 as 'Canal'
	, CONVERT(VARCHAR(10),FecAcc,105) as Fecha
	, CAST(DescripcionYHecho as varchar(2000)) as Descripcion
	, Estado as "Estado"
	,CAST(comuna as varchar(50)) as Comuna
from [dirtrab_plus].[dbo].[AccidentesLaborales] 
where 
	ISNUMERIC(RutAcc)=1 
	and RutAcc <>1

Union all

select 
	cast(SolRut as int) as RUT
	,cast(SolDV as varchar(10)) as DV
	, CAST(isnull(LTRIM(RTRIM(SolNombres)),'') +' '+isnull(LTRIM(RTRIM(SolMaterno)),'')+' '+isnull(LTRIM(RTRIM(SolPaterno)),'') as Varchar(250)) as Nombre
	, '' as Sexo
	,cast(SolFechaNac as date) as 'Fecha_nacimiento'
	,'' as 'Folio'
	,01 as "Interaccion"
	,1 as 'Canal'
	, CONVERT(VARCHAR(10),FechaRegistro,105) as Fecha
	, CAST(declaracionDenunciante as varchar(2000)) as Descripcion
	, '' as "Estado"
	,CAST(SolIdCoumna as varchar(50)) as Comuna
FROM [dirtrab_plus].[dbo].[df_IngresoSolicitud] 
WHERE 
	SolRut IS NOT NULL 
	and SolRut<>0 
	and SolRut<>1
------------------------------------------------
--02 - CERTIFICADOS ----------------------------
SELECT 
	cast(TrabRut as int) as RUT
	, cast(TrabDv as varchar(10)) as DV
	, CAST(TrabNombre as varchar(250)) as Nombre 
	,'' as Sexo
	,CAST('' as date) as 'Fecha_nacimiento'
	,'' as 'Folio' 
	, 02 as "Interaccion"
	,4 as 'Canal'
	,CASE WHEN PeriodoMes BETWEEN 0 AND 10 THEN RIGHT('0' + CAST(PeriodoMes AS VARCHAR(2)), 2)ELSE CAST(PeriodoMes AS VARCHAR(10))END+'-'+cast(PeriodoAgno as varchar(10)) as Fecha
	,'Certificado Nomina Trabajador' as Descripcion 
	, '' as "Estado"
FROM [dirtrab_plus].[dbo].[cert_NominaTrab] 
where 
	TrabRut !=0 
	and TrabRut<>1 

Union all

SELECT 
	cast(RutTrabajador as int) as RUT
	, DVTrabajador as DV
	, (isnull(LTRIM(RTRIM(NombreTrabajador)),'')) AS Nombre
	,'' as Sexo
	,CAST('' as date) as 'Fecha_nacimiento'
	,'' as 'Folio' 
	, 02 as "Interaccion"
	,4 as 'Canal'
	, cast(RIGHT(periodoMesAno,2)+'-'+SUBSTRING(periodoMesAno,1,4) as varchar(10)) as Fecha
	, 'Dato Previsional' as Descripcion 
	, '' as "Estado"
FROM [ventanilla].[dbo].[CCL_DatoPrevisional2]
where 
	RutTrabajador is not null 
	and ISNUMERIC(RutTrabajador)<>0 
	AND RutTrabajador<>0 
	and NombreTrabajador !='' 
	and RutTrabajador<>1

union all

Select 
	CAST(ruttrab as int) RUT
	, CAST(DVTrab AS VARCHAR(10)) AS DV
	, cast((isnull(LTRIM(RTRIM(NombreTrab)),'')+' '+ isnull(LTRIM(RTRIM(ApPaternoTrab)),'')+' '+isnull(LTRIM(RTRIM(ApMaternoTrab)),'')) as Varchar(255)) as Nombre
	,'' as Sexo
	,CAST('' as date) as 'Fecha_nacimiento'
	,'' as 'Folio' 
	, 02 as "Interaccion"
	,4 as 'Canal'
	, cast((CASE WHEN MesDespido BETWEEN 0 AND 10 THEN RIGHT('0' + CAST(MesDespido AS VARCHAR(2)), 2)ELSE CAST(MesDespido AS VARCHAR(10))END)+'-'+cast(AnoDespido as varchar(10)) as varchar(10)) as Fecha
	, cast('Detalle Despido' as varchar(2000)) as Descripcion 
	, '' as "Estado" 
FROM [ventanilla].[dbo].[CCL_DetalleDespido]
where 
	RutTrab is not null 
	and ISNUMERIC(RutTrab)<>0 
	and RutTrab<>0 and NombreTrab !='' 
	and  RutTrab<>1

Union all

select 
	CAST(RutTrab as int) as RUT
	, cast(DVTrab as varchar(10)) as DV
 	, cast((isnull(LTRIM(RTRIM(NombreTrab)),'')+' '+isnull(LTRIM(RTRIM(ApPaternoTrab)),'')+' '+isnull(LTRIM(RTRIM(ApMaternoTrab)),'')) as VARCHAR(255)) AS Nombre 
	,'' as Sexo
	,CAST('' as date) as 'Fecha_nacimiento'
	,'' as 'Folio' 
	, 02 as "Interaccion"
	,4 as 'Canal'
	, '' as Fecha
	, cast(DetalleMensajeCuadratura as varchar(2000)) as Descripcion 
	, '' as "Estado" 
FROM [ventanilla].[dbo].[CCL_DetalleLAR]  
where RutTrab is not null and ISNUMERIC(RutTrab)<>0 and RutTrab<>0 and NombreTrab !='' and RutTrab<>1

Union all

select 
	cast(Rut as int) as RUT
	, CAST(Dv as varchar(10)) as DV
	, cast((isnull(LTRIM(RTRIM(Nombre)),'')+' '+isnull(LTRIM(RTRIM(Paterno)),'')+' '+isnull(LTRIM(RTRIM(Materno)),'')) as varchar(250)) as Nombre
	, cast(case Sexo when '2' then 'M' when '1' then 'F' end as varchar(10)) as Sexo
	,CAST('' as date) as 'Fecha_nacimiento'
	,'' as 'Folio' 
	, 02 as "Interaccion"
	,4 as 'Canal'
	,CONVERT(VARCHAR(10),FechaInicio,105) as Fecha
	, CAST('Certificado Nomina Trabajador' as varchar(2000)) as Descripcion 
	, '' as "Estado"
FROM [notarios].[dbo].[TrabNomina]
WHERE 
	Rut IS NOT NULL AND ISNUMERIC(Rut)<>0 
	AND Rut<>0 
	AND Rut<>1
-------------------------------------------------
--03 - RECLAMOS ---------------------------------
SELECT 
	CAST(RUT as int) as RUT
	, CAST(Dv as varchar(10)) as DV
	, (isnull(LTRIM(RTRIM(NOMBRE_COMPLETO)),'')+' '+isnull(LTRIM(RTRIM(APELLIDO_PATERNO)),'')+' '+isnull(LTRIM(RTRIM(APELLIDO_MATERNO)),'')) as Nombre  
	, '' as Sexo
	,CAST('' as date) as 'Fecha_nacimiento'
	,'' as 'Folio' 
	, 03 as "Interaccion"
	,4 as 'Canal'
	, '' as Fecha
	, 'Trabajo Asesor' as Descripcion 
	, '' as "Estado"
	,CAST('' as varchar(50)) as Comuna
FROM [conciliaplus].[dbo].[TRABAJADOR_ASESOR] 
WHERE 
	Rut IS NOT NULL 
	AND ISNUMERIC(Rut)<>0 
	AND Rut<>0 
	and RUT<>1

Union all

SELECT 
	cast(Rut as int) as RUT
	, cast(Dv as varchar(10)) as DV
	, cast((isnull(LTRIM(RTRIM(Nombres)),'')+' '+isnull(LTRIM(RTRIM(Paterno)),'')+' '+isnull(LTRIM(RTRIM(Materno)),'')) as varchar(250)) as Nombre
	, cast(Sexo as varchar(10)) as Sexo 
	, CAST('' as date) as 'Fecha_nacimiento'
	, '' as 'Folio' 
	, 03 as "Interaccion"
	, 1 as 'Canal'
	, '' as Fecha
	, CAST('Otro Afectado' as varchar(2000)) as Descripcion 
	, '' as "Estado" 
	,CAST('' as varchar(50)) as Comuna
FROM [dirtrab_plus].[dbo].[df_OtroAfectado] 
WHERE 
	Rut IS NOT NULL 
	AND Rut !=0 
	AND Rut !=1 
	AND Rut !=123

Union all

select 
	cast(Rut as int) as RUT
	, CAST(Dv AS VARCHAR(10)) AS DV
	, CAST(isnull(LTRIM(RTRIM(Nombre)),'')+' '+isnull(LTRIM(RTRIM(Paterno)),'')++isnull(LTRIM(RTRIM(Materno)),'') AS varchar(250)) as Nombre
	, cast(ISNULL((Sexo),'') as varchar(10)) as Sexo 
	, CAST(FechaNac as date) as 'Fecha_nacimiento'
	, '' as 'Folio' 
	, 03 as "Interaccion"
	, 1 as 'Canal'
	, CONVERT(VARCHAR(10),FecInicioRL,105) as Fecha
	, CAST('Reclamos Reclamante' as varchar(2000)) as Descripcion 
	, '' as "Estado"
	,CAST('' as varchar(50)) as Comuna
FROM [dirtrab_plus].[dbo].[rec_Reclamante]
WHERE 
	Rut IS NOT NULL 
	AND ISNUMERIC(Rut)<>0 
	AND Rut<>0 AND Rut<>1

Union all

select 
	cast(RUT as int) as RUT
	, cast(DV as varchar(10)) as DV
	, cast((isnull(LTRIM(RTRIM(NOMBRES)),'')+' '+isnull(LTRIM(RTRIM(APELLIDO_PATERNO)),'')+' '+isnull(LTRIM(RTRIM(APELLIDO_MATERNO)),'')) as varchar(250)) as Nombre
	, cast(case SEXO when '1' then 'M' when '2' then 'F' end as varchar(10)) as Sexo
	, CAST(FECHA_NACIMIENTO as date) as 'Fecha_nacimiento'
	, '' as 'Folio' 
	, 03 as "Interaccion"
	, 1 as 'Canal'
	,cast('' as varchar(10)) as Fecha
	,'Datos Asistentes Trabajador' as Descripcion 
	, '' as "Estado"
	,CAST(DIR_ID_COMUNA as varchar(50)) as Comuna
FROM [conciliaplus].[dbo].[DATOS_ASISTENTES_TRABAJADOR]
WHERE 
	Rut IS NOT NULL 
	AND ISNUMERIC(Rut)<>0 
	AND Rut<>0 
	AND RUT<>1
-------------------------------------------------
--04 - CARTA DE AVISO ---------------------------
select 
	cast(RutTrab as int) AS RUT
	, cast(DVTrab as varchar(10)) as DV
	, cast((isnull(LTRIM(RTRIM(NombresTrab)),'')+' '+isnull(LTRIM(RTRIM(ApPaternoTrab)),'')+' '+isnull(LTRIM(RTRIM(ApMaternoTrab)),'')) as Varchar(255)) as Nombre
	, Sexo as Sexo
	, CAST('' as date) as 'Fecha_nacimiento'
	, '' as 'Folio' 
	, 04 as "Interaccion"
	, 4 as 'Canal'
	, CONVERT(VARCHAR(10),fechaIngreso,105) as Fecha
	, cast(DescripcionHecho as varchar(2000)) as Descripcion 
	, cast(EstadoCotizaciones as varchar(200)) as Estado
	,CAST(IdComunaTrabajo as varchar(50)) as Comuna
FROM [ventanilla].[dbo].[Ven_CartaAviso_Trabajador_Itel] 
WHERE 
	RutTrab IS NOT NULL 
	AND ISNUMERIC(RutTrab)<>0 
	AND RutTrab<>0 
	and NombresTrab !='' 
	and RutTrab<>1

Union all

select 
	cast(TrabRut as int) as RUT
	, cast(TrabDv as varchar(10)) as DV
	, cast((isnull(LTRIM(RTRIM(TrabNombres)),'')+' '+isnull(LTRIM(RTRIM(TrabApPaterno)),'')+' '+isnull(LTRIM(RTRIM(TrabApMaterno)),'')) as varchar(250)) as Nombre
	, cast(case TrabSexo  when 'A' then 'M' when 'D' then 'M' when 'F' then 'F' when 'H' then 'M' when 'L' then 'F' when 'M' then 'M' when '0' then 'M' when 'R' then 'M' when null then '' end as varchar(10)) as Sexo
	, CAST('' as date) as 'Fecha_nacimiento'
	, '' as 'Folio' 
	, 04 as "Interaccion"
	, 4 as 'Canal'
	, CONVERT(VARCHAR(10),FechaReg,105) as Fecha
	, CAST(HechosCausal as varchar(2000)) as Descripcion 
	, cast(EstadoCotizaciones as varchar(200)) as Estado
	,CAST('' as varchar(50)) as Comuna
FROM [ventanilla].[dbo].[ven_CartaAvisoMasivaTrabajador]
where TrabRut is not null 
	and ISNUMERIC(TrabRut)<>0 
	and TrabRut<>0 
	and TrabNombres !='' 
	and TrabRut<>1
-------------------------------------------------
--05 - CONSTANCIA -------------------------------
select 
	cast(rut_dec as int) as RUT
	, CAST(dv_dec AS VARCHAR(255)) as DV
	, cast((isnull(LTRIM(RTRIM(nombres_dec)),'')+' '+isnull(LTRIM(RTRIM(ap_paterno_dec)),'')+' '+isnull(LTRIM(RTRIM(ap_materno_dec)),'')) as varchar(255)) as Nombre 
	, '' as Sexo
	, CAST('' as date) as 'Fecha_nacimiento'
	, '' as 'Folio' 
	, 05 as "Interaccion"
	, 4 as 'Canal'
	, CONVERT(VARCHAR(10),fecha,105) as Fecha
	, cast(declaracion as varchar(2000)) as Descripcion 
	, '' as "Estado" 
	,CAST('' as varchar(50)) as Comuna
FROM [ventanilla].[dbo].[Ven_Constancia]
where 
	rut_dec is not null 
	and ISNUMERIC(rut_dec)<>0 
	and rut_dec<>0 
	and nombres_dec !='' 
	and rut_dec<>1 
	and rut_dec >1000

Union all

Select 
	cast(RUT as int) as RUT
	, CAST(Dv_Dec as varchar(255)) as DV
	, cast((isnull(LTRIM(RTRIM(NombreDec)),'')+' '+ isnull(LTRIM(RTRIM(ApPaterno)),'')+' '+ isnull(LTRIM(RTRIM(ApMaterno)),'')) as varchar(255)) as Nombre
	, '' as Sexo
	, CAST('' as date) as 'Fecha_nacimiento'
	, '' as 'Folio' 
	, 05 as "Interaccion"
	, null as 'Canal'
	, CONVERT(VARCHAR(10),fecha,105) as Fecha
	, cast(declaracion as varchar(2000)) as Descripcion 
	, '' as "Estado"
	,CAST(comuna as varchar(50)) as Comuna
FROM [ventanilla].[dbo].[Ven_Constancia_Itel]
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
Declare @Interaccion as int = 6
Declare @Canal as int = 1
SELECT 
	  CASE
		WHEN MenRut IS NOT NULL AND MenRut <> ''
		THEN cast(MenRut as int)
		ELSE NULL
	  END as RUT
	, CASE
		WHEN MenDv IS NOT NULL AND MenDv <> ''
		THEN cast(MenDv as varchar(10))
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
		ISNULL((LTRIM(RTRIM(MenApMaterno))),'')) as varchar(250)) as Nombre		
	, CAST(MenDomCodComuna as varchar(50)) as Comuna	
	, MenSexo as Sexo
	, NULL as Folio
	, NULL as Estado
	, NULL as Descripcion
	, @Interaccion as Interaccion
	, @Canal as Canal	
FROM [dirtrab_plus].[dbo].[fi_NominaMenor] NOLOCK
WHERE 
	MenRut IS NOT NULL 
	AND ISNUMERIC(MenRut) <> 0 
	AND MenRut <> 0 
	AND MenRut <> 1

Union all

Declare @Interaccion as int = 6
Declare @Canal as int = 1
SELECT 
	  CASE
		WHEN SolRut IS NOT NULL AND SolRut <> ''
		THEN CAST(SolRut as int)
		ELSE NULL
	  END as RUT
	, CASE
		WHEN SolDv IS NOT NULL AND SolDv <> ''
		THEN CAST(SolDv as varchar(10))
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
		ISNULL(LTRIM(RTRIM(SolMaterno)),'')) as varchar(250)) as Nombre
	, CAST(ISNULL(SolSexo ,'') as varchar(10)) AS Sexo		
	, CAST(EmpDireccion as varchar(50)) as Comuna	
	, NULL as Folio 
	, NULL as Estado
	, NULL as Descripcion 
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
Declare @Interaccion as int = 7
Declare @Canal as int = NULL
SELECT 
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
	, CAST(TrabDv as varchar(10)) as DV
	, CAST((
		ISNULL((LTRIM(RTRIM(TrabNombre))),'') +' '+
		ISNULL((LTRIM(RTRIM(TrabPaterno))),'') +' '+
		ISNULL((LTRIM(RTRIM(TrabMaterno))),'')) as varchar(250)) as Nombre
	, CAST(ISNULL(TrabSexo ,'') as varchar(10)) AS Sexo
	, CAST(EmpDireccion as varchar(50)) as Comuna	
	, NULL as Descripcion 
	, NULL as Estado
	, NULL as Folio 
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
Declare @Interaccion as int = 8
Declare @Canal as int = NULL
SELECT 
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
	, CAST(TrabDv as varchar(10)) as DV
	, CAST((
		ISNULL((LTRIM(RTRIM(TrabNombre))),'')+' '+
		ISNULL((LTRIM(RTRIM(TrabPaterno))),'')+' '+
		ISNULL((LTRIM(RTRIM(TrabMaterno))),'')) as varchar(250)) as Nombre
	, CAST(ISNULL(TrabSexo ,'') as varchar(10)) AS Sexo
	, CAST(Motivo as varchar(2000)) as Descripcion 
	, CAST(EmpCodComuna as varchar(50)) as Comuna	
	, NULL as Estado 
	, NULL as Folio 
	, NULL as Fecha_nacimiento
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
Declare @Interaccion as int = 9
Declare @Canal as int = NULL
SELECT 
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
	, CAST(TrabDv as varchar(10)) as DV
	, CAST((
		ISNULL((LTRIM(RTRIM(TrabNombre))),'') +' '+
		ISNULL((LTRIM(RTRIM(TrabPaterno))),'') +' '+
		ISNULL((LTRIM(RTRIM(TrabMaterno))),'')) as varchar(250)) as Nombre
	, CAST(ISNULL(TrabSexo ,'')as varchar(10)) AS Sexo	
	, CAST(EmpCodComuna as varchar(50)) as Comuna	
	, CAST(Declaracion as varchar(2000)) as Descripcion	
	, NULL as Estado
	, NULL as Folio 
	, NULL as Fecha_nacimiento
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
Declare @Interaccion as int = 10
Declare @Canal as int = NULL
SELECT 
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
	, CAST(TrabDv as varchar(10)) as DV
	, CAST((
		isnull((LTRIM(RTRIM(TrabNombre))),'') +' '+
		isnull((LTRIM(RTRIM(TrabPaterno))),'') +' '+
		isnull((LTRIM(RTRIM(TrabMaterno))),'')) as varchar(250)) as Nombre
	, CAST(case TrabSexo when 'F' then 'F' when 'M' then 'M' end as varchar(10)) as Sexo
	, CAST(EmpCodComuna as varchar(50)) as Comuna	
	, NULL as Fecha_nacimiento
	, NULL as Descripcion 
	, NULL as Estado
	, NULL as Folio 
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
Declare @Interaccion as int = 11
Declare @Canal as int = NULL
SELECT 
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
	, CAST(TrabDv as varchar(10)) as DV
	, CAST((
		ISNULL(LTRIM(RTRIM(TrabNombre)),'') +' '+
		ISNULL((LTRIM(RTRIM(TrabPaterno))),'') +' '+
		ISNULL((LTRIM(RTRIM(TrabMaterno))),'')) as varchar(250)) as Nombre
	, CAST(ISNULL(TrabSexo ,'')as varchar(10)) AS Sexo
	, CAST(EmpCodComuna as varchar(50)) as Comuna		
	, NULL as Descripcion 
	, NULL as Estado
	, NULL as Folio
	, NULL as Fecha_nacimiento
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
Declare @Interaccion as int = 12
Declare @Canal as int = NULL
SELECT 
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
	, CAST(TrabDv AS VARCHAR(10)) AS DV
	, CAST((
		isnull(LTRIM(RTRIM(TrabNombre)),'')+' '+
		isnull(LTRIM(RTRIM(TrabPaterno)),'')+' '+
		isnull(LTRIM(RTRIM(TrabMaterno)),'')) AS VARCHAR(255)) as Nombre
	, CAST(case TrabSexo when 'F' then 'F' when 'M' then 'M' end as varchar(10)) as Sexo
	, CAST(EmpCodComuna as varchar(50)) as Comuna
	, NULL as Descripcion 
	, NULL as Estado
	, NULL as Fecha_nacimiento
	, NULL as Folio 
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
Declare @Interaccion as int = 13
Declare @Canal as int = NULL
SELECT 
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
	, CAST(TrabDv AS VARCHAR(10)) AS DV
	, CAST((
		ISNULL(LTRIM(RTRIM(TrabNombre)),'')+' '+
		ISNULL(LTRIM(RTRIM(TrabPaterno)),'')+' '+
		ISNULL(LTRIM(RTRIM(TrabMaterno)),''))AS VARCHAR(255)) as Nombre
	, CAST(ISNULL(TrabSexo ,'') AS VARCHAR(10)) AS Sexo 
	, CAST(EmpCodComuna as varchar(50)) as Comuna	
	, NULL as Descripcion 
	, NULL as Estado
	, NULL as Fecha_nacimiento
	, NULL as Folio 
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
Declare @Interaccion as int = 14
Declare @Canal as int = NULL
SELECT 
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
	, CAST(TrabDv AS VARCHAR(10)) AS DV
	, CAST((
		ISNULL(LTRIM(RTRIM(TrabNombre)),'')+' '+
		ISNULL(LTRIM(RTRIM(TrabPaterno)),'')+' '+
		ISNULL(LTRIM(RTRIM(TrabMaterno)),''))AS VARCHAR(255)) as Nombre
	, CAST(ISNULL(TrabSexo ,'')AS VARCHAR(10)) AS Sexo 
	, CAST(TrabCodComuna as varchar(50)) as Comuna
	, NULL as Descripcion 
	, NULL as Estado
	, NULL as Fecha_nacimiento
	, NULL as Folio 
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
Declare @Interaccion as int = 15
Declare @Canal as int = 1
SELECT 
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
	, CAST(TrabDv AS VARCHAR(10)) AS DV
	, CAST((
		ISNULL(LTRIM(RTRIM(TrabNombre)),'')+' '+
		ISNULL(LTRIM(RTRIM(TrabPaterno)),'')+' '+
		ISNULL(LTRIM(RTRIM(TrabMaterno)),''))AS VARCHAR(255)) as Nombre
	, CAST(ISNULL(TrabSexo ,'') AS VARCHAR(10)) AS Sexo 
	, CAST(EmpCodComuna as varchar(50)) as Comuna
	, NULL as Descripcion 
	, NULL as Estado
	, NULL as Fecha_nacimiento
	, NULL as Folio 
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
SELECT	
	CASE
		WHEN RutTrab IS NOT NULL AND RutTrab <> ''
		THEN CAST(RutTrab as int)
		ELSE NULL
	  END as RUT
	, CASE sexo
		WHEN 1 THEN CAST('F' as nvarchar(1))
		WHEN 2 THEN CAST('M' as varchar(1))
	  END as Sexo
	, CAST(dvTrab as varchar(10)) as DV
	, CAST(ISNULL(LTRIM(RTRIM(NombreTrab)),'') as varchar(250)) as Nombre	
	, CAST(codCom as varchar(50)) as Comuna
	, CAST(fechaNacimiento as date) as Fecha_nacimiento
	, NULL as Folio 
	, NULL as Fecha
	, NULL as Descripcion 
	, NULL as Estado
	, @Interaccion as Interaccion
	, @Canal as Canal
FROM [ventanilla].[dbo].[TCP_Trabajador] NOLOCK
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
Declare @Interaccion as int = 17
Declare @Canal as int = 4
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
		WHEN 'H'		 THEN CAST('M' as varchar(1))
		WHEN 'M'		 THEN CAST('F' as varchar(1))
		WHEN 'Masculino' THEN CAST('M' as varchar(1))
		WHEN 'MASCULINO' THEN CAST('M' as varchar(1))
		WHEN 'Hombre'	 THEN CAST('M' as varchar(1))
		WHEN 'FENENINO'  THEN CAST('F' as varchar(1))
		WHEN 'Mujer'	 THEN CAST('F' as varchar(1))		
		WHEN ''			 THEN NULL
	  END as Sexo
	, CAST(DV as varchar(10)) as DV
	, CAST((
		ISNULL(LTRIM(RTRIM(Nombre)),'')+' '+
		ISNULL(LTRIM(RTRIM(Apellido_Paterno)),'')+' '+
		ISNULL(LTRIM(RTRIM(Apellido_Materno)),'')) as varchar(250)) as Nombre	
	, CAST(ISNULL(Fecha_Nacimiento,'') as datetime) as Fecha_Nacimiento
	, CAST(Email as varchar(100)) as Correo
	, CAST(Celular as varchar(10)) as Telefono 
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
--18 - MINISTRO DE FE (LICENCIA MÉDICA) ---------
Declare @Interaccion as int = 18
Declare @Canal as int = NULL
SELECT 
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
	, CAST(DecDv as varchar(10)) as DV
	, CAST((
		ISNULL((LTRIM(RTRIM(DecNombre))),'')+' '+
		ISNULL((LTRIM(RTRIM(DecPaterno))),'')+' '+
		ISNULL((LTRIM(RTRIM(DecMaterno))),'')) as varchar(250)) as Nombre 
	, CAST(ISNULL(DecSexo ,'') as varchar(10)) AS Sexo 
	, CAST(EmpCodComuna as varchar(50)) as Comuna
	, CAST(MotivoNeg as varchar(2000)) as Descripcion 
	, NULL as Estado
	, NULL as Fecha_nacimiento
	, NULL as Folio
	, @Interaccion as Interaccion
	, @Canal as Canal	
FROM [dirtrab_plus].[dbo].[mf_LicMedica] NOLOCK
WHERE 
	DecRut IS NOT NULL 
	AND ISNUMERIC(DecRut) <> 0 
	AND DecRut <> 0 
	AND DecRut <> 1