/*
  Datos iniciales para una instalación vacía de TEMASIS.

  Ejecute este archivo después de instalar los objetos de:
    - ../core/
    - ../customers/

  El script presupone que el core y la base del cliente están en la misma
  instancia de SQL Server. Si el cliente está en otra instancia, adaptar el
  bloque de cliente y registrar su conexión y suscripción desde el core.

  No contiene secretos reales. Reemplace todos los valores marcados como
  REEMPLAZAR antes de ejecutarlo. La contraseña se guarda como SHA-256 de su
  versión en mayúsculas, igual que el formulario de acceso por defecto.
*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @CoreDatabase sysname = N'tmssSysPrd';
DECLARE @CustomerDatabase sysname = N'tmssTeam2';

DECLARE @ConnectionCode nvarchar(10) = N'REEMPLAZAR';
DECLARE @CustomerBusinessCode nvarchar(20) = N'REEMPLAZAR';
DECLARE @CustomerName nvarchar(50) = N'REEMPLAZAR';
DECLARE @CustomerSqlServer nvarchar(50) = N'REEMPLAZAR';
DECLARE @CustomerSqlUser nvarchar(50) = N'REEMPLAZAR';
DECLARE @CustomerSqlPassword nvarchar(50) = N'REEMPLAZAR';

DECLARE @BootstrapUser nvarchar(15) = N'ADMIN';
DECLARE @BootstrapUserName nvarchar(82) = N'Administrador inicial';
DECLARE @BootstrapPassword nvarchar(128) = N'REEMPLAZAR';
DECLARE @BootstrapGroup nvarchar(20) = N'ADMIN';

IF DB_ID(@CoreDatabase) IS NULL
BEGIN
  ;THROW 51000, N'La base del core no existe.', 1;
END;

IF DB_ID(@CustomerDatabase) IS NULL
BEGIN
  ;THROW 51001, N'La base del cliente no existe.', 1;
END;

IF @ConnectionCode = N'REEMPLAZAR'
   OR @CustomerBusinessCode = N'REEMPLAZAR'
   OR @CustomerName = N'REEMPLAZAR'
   OR @CustomerSqlServer = N'REEMPLAZAR'
   OR @CustomerSqlUser = N'REEMPLAZAR'
   OR @CustomerSqlPassword = N'REEMPLAZAR'
   OR @BootstrapPassword = N'REEMPLAZAR'
BEGIN
  ;THROW 51002, N'Reemplace todos los valores REEMPLAZAR antes de ejecutar el script.', 1;
END;

IF NULLIF(LTRIM(RTRIM(@ConnectionCode)), N'') IS NULL
   OR NULLIF(LTRIM(RTRIM(@CustomerBusinessCode)), N'') IS NULL
   OR NULLIF(LTRIM(RTRIM(@CustomerName)), N'') IS NULL
   OR NULLIF(LTRIM(RTRIM(@CustomerSqlServer)), N'') IS NULL
   OR NULLIF(LTRIM(RTRIM(@CustomerSqlUser)), N'') IS NULL
   OR NULLIF(LTRIM(RTRIM(@CustomerSqlPassword)), N'') IS NULL
   OR NULLIF(LTRIM(RTRIM(@BootstrapUser)), N'') IS NULL
   OR NULLIF(LTRIM(RTRIM(@BootstrapPassword)), N'') IS NULL
   OR NULLIF(LTRIM(RTRIM(@BootstrapGroup)), N'') IS NULL
BEGIN
  ;THROW 51004, N'Los parámetros requeridos no pueden estar vacíos.', 1;
END;

IF LEN(@ConnectionCode) > 10
   OR LEN(@CustomerBusinessCode) > 20
   OR LEN(@CustomerName) > 50
   OR LEN(@CustomerDatabase) > 50
   OR LEN(@CustomerSqlServer) > 50
   OR LEN(@CustomerSqlUser) > 50
   OR LEN(@CustomerSqlPassword) > 50
   OR LEN(@BootstrapUser) > 15
   OR LEN(@BootstrapUserName) > 82
   OR LEN(@BootstrapGroup) > 20
BEGIN
  ;THROW 51003, N'Uno de los parámetros excede el tamaño definido por las tablas.', 1;
END;

DECLARE @CoreSql nvarchar(max) = N'
USE ' + QUOTENAME(@CoreDatabase) + N';

IF OBJECT_ID(N''dbo.SYS_CNX'', N''U'') IS NULL
   OR OBJECT_ID(N''dbo.SLS_CUS'', N''U'') IS NULL
   OR OBJECT_ID(N''dbo.SYS_LNG'', N''U'') IS NULL
   OR OBJECT_ID(N''dbo.SYS_APP_MDL'', N''U'') IS NULL
   OR OBJECT_ID(N''dbo.SYS_APP_PRG'', N''U'') IS NULL
   OR OBJECT_ID(N''dbo.SYS_SEC_OPR'', N''U'') IS NULL
   OR OBJECT_ID(N''dbo.SYS_FNC'', N''U'') IS NULL
   OR OBJECT_ID(N''dbo.SYS_FNC_PRG'', N''U'') IS NULL
   OR OBJECT_ID(N''dbo.SYS_FNC_SUB'', N''U'') IS NULL
BEGIN
  ;THROW 51010, N''El esquema del core no está instalado por completo.'', 1;
END;

DECLARE @Now smalldatetime = CONVERT(smalldatetime, GETDATE());

IF NOT EXISTS (SELECT 1 FROM dbo.SYS_LNG WHERE LngCod = N''ES'')
BEGIN
  INSERT INTO dbo.SYS_LNG (LngCod, LngTxt, LngLocTxt, DocSts, CteDte, CteUsr)
  VALUES (N''ES'', N''Español'', N''Español'', N''A'', @Now, @BootstrapUser);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.SYS_CNX WHERE SysCnxCodExt = @ConnectionCode)
BEGIN
  INSERT INTO dbo.SYS_CNX
    (SysCnxCodExt, SysCnxTxt, SysCnxSrv, SysCnxDb, SysCnxUsr, SysCnxPwd,
     DocSts, CteDte, CteUsr)
  VALUES
    (@ConnectionCode, @CustomerName, @CustomerSqlServer, @CustomerDatabase,
     @CustomerSqlUser, @CustomerSqlPassword, N''A'', @Now, @BootstrapUser);
END;

IF NOT EXISTS
  (SELECT 1 FROM dbo.SLS_CUS WHERE BusCod = N''TEMASIS'' AND CusCodExt = @CustomerBusinessCode)
BEGIN
  INSERT INTO dbo.SLS_CUS (BusCod, CusCodExt, CusTxt, DocSts, CteDte, CteUsr)
  VALUES (N''TEMASIS'', @CustomerBusinessCode, @CustomerName, N''A'', @Now, @BootstrapUser);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.SYS_APP_MDL WHERE CodMDL = N''SYS'')
BEGIN
  INSERT INTO dbo.SYS_APP_MDL
    (CodMDL, DesMDL, ObjOrd, OBJLng, OBJSts, DocSts, CteDte, CteUsr, MdlPic)
  VALUES
    (N''SYS'', N''Sistema'', 1, N''ES'', N''A'', N''A'', @Now, @BootstrapUser,
     N''class:fas fa-cog'');
END;

IF NOT EXISTS
  (SELECT 1 FROM dbo.SYS_APP_PRG WHERE CodMDL = N''SYS'' AND CodPRG = N''USR'')
BEGIN
  INSERT INTO dbo.SYS_APP_PRG
    (CodMDL, CodPRG, DesPRG, PRGFrmDat, OBJLng, OBJSts, ObjOrd,
     PRGMnuChl, PRGMnuPar, PrgMnuHde, DocSts, CteDte, CteUsr, PrgTypCod)
  VALUES
    (N''SYS'', N''USR'', N''Alta de usuarios'', N''?prg=syssecusr&act=01'',
     N''ES'', N''A'', 1, N'''', N'''', 0, N''A'', @Now, @BootstrapUser, N''1'');
END;

;WITH Operations (OprCod, OprTxt) AS (
  SELECT * FROM (VALUES
    (N''**'', N''Acceder''),
    (N''01'', N''Crear''),
    (N''02'', N''Modificar''),
    (N''03'', N''Consultar''),
    (N''04'', N''Eliminar''),
    (N''08'', N''Listar''),
    (N''17'', N''Desbloquear''),
    (N''25'', N''Mi cuenta'')
  ) AS ValuesList (OprCod, OprTxt)
)
INSERT INTO dbo.SYS_SEC_OPR
  (CodMDL, CodPRG, CodOPR, OprTxt, OprShwInGrd, DocSts, CteDte, CteUsr)
SELECT N''SYS'', N''USR'', OprCod, OprTxt, 0, N''A'', @Now, @BootstrapUser
FROM Operations O
WHERE NOT EXISTS (
  SELECT 1
  FROM dbo.SYS_SEC_OPR CurrentRow
  WHERE CurrentRow.CodMDL = N''SYS''
    AND CurrentRow.CodPRG = N''USR''
    AND CurrentRow.CodOPR = O.OprCod
);

IF NOT EXISTS (SELECT 1 FROM dbo.SYS_FNC WHERE SysFncCodExt = N''BOOTSTRAP_SYS_USR'')
BEGIN
  INSERT INTO dbo.SYS_FNC
    (SysFncCodExt, SysFncTxt, SysFncTtl, SysFncDes, AutLvl, SysFncHde,
     MdlCod, DocSts, CteDte, CteUsr)
  VALUES
    (N''BOOTSTRAP_SYS_USR'', N''Administración inicial'', N''Administración inicial'',
     N''Permite crear y administrar usuarios durante la configuración inicial.'',
     9, 0, N''SYS'', N''A'', @Now, @BootstrapUser);
END;

DECLARE @SysFncCod int = (
  SELECT TOP (1) SysFncCod
  FROM dbo.SYS_FNC
  WHERE SysFncCodExt = N''BOOTSTRAP_SYS_USR''
  ORDER BY SysFncCod
);

DECLARE @CusCod int = (
  SELECT TOP (1) CusCod
  FROM dbo.SLS_CUS
  WHERE BusCod = N''TEMASIS'' AND CusCodExt = @CustomerBusinessCode
  ORDER BY CusCod
);

IF @SysFncCod IS NULL OR @CusCod IS NULL
BEGIN
  ;THROW 51011, N''No se pudieron resolver la funcionalidad o el cliente del core.'', 1;
END;

;WITH Operations (OprCod) AS (
  SELECT * FROM (VALUES
    (N''**''), (N''01''), (N''02''), (N''03''),
    (N''04''), (N''08''), (N''17''), (N''25'')
  ) AS ValuesList (OprCod)
)
INSERT INTO dbo.SYS_FNC_PRG
  (SysFncCod, MdlCod, PrgCod, OprCod, DocSts, CteDte, CteUsr)
SELECT @SysFncCod, N''SYS'', N''USR'', OprCod, N''A'', @Now, @BootstrapUser
FROM Operations O
WHERE NOT EXISTS (
  SELECT 1
  FROM dbo.SYS_FNC_PRG CurrentRow
  WHERE CurrentRow.SysFncCod = @SysFncCod
    AND CurrentRow.MdlCod = N''SYS''
    AND CurrentRow.PrgCod = N''USR''
    AND CurrentRow.OprCod = O.OprCod
);

IF NOT EXISTS (
  SELECT 1
  FROM dbo.SYS_FNC_SUB
  WHERE SysFncCod = @SysFncCod AND CusCod = @CusCod
)
BEGIN
  INSERT INTO dbo.SYS_FNC_SUB
    (SysFncCod, CusCod, SysFncSubStrDte, SysFncSubEndDte, DocSts, CteDte, CteUsr)
  VALUES
    (@SysFncCod, @CusCod, CONVERT(datetime, ''20000101'', 112),
     CONVERT(datetime, ''20991231'', 112), N''A'', @Now, @BootstrapUser);
END;
';

DECLARE @CustomerSql nvarchar(max) = N'
USE ' + QUOTENAME(@CustomerDatabase) + N';

IF OBJECT_ID(N''dbo.ADM_BUS'', N''U'') IS NULL
   OR OBJECT_ID(N''dbo.SYS_SEC_USR'', N''U'') IS NULL
   OR OBJECT_ID(N''dbo.SYS_SEC_USR_BUS'', N''U'') IS NULL
   OR OBJECT_ID(N''dbo.SYS_SEC_GRP'', N''U'') IS NULL
   OR OBJECT_ID(N''dbo.SYS_SEC_USR_GRP'', N''U'') IS NULL
   OR OBJECT_ID(N''dbo.SYS_SEC_PER'', N''U'') IS NULL
BEGIN
  ;THROW 51020, N''El esquema de la base de cliente no está instalado por completo.'', 1;
END;

DECLARE @Now smalldatetime = CONVERT(smalldatetime, GETDATE());
DECLARE @PasswordHash nvarchar(64) =
  LOWER(CONVERT(varchar(64), HASHBYTES(''SHA2_256'', UPPER(@BootstrapPassword)), 2));

IF NOT EXISTS (SELECT 1 FROM dbo.ADM_BUS WHERE BusCod = @CustomerBusinessCode)
BEGIN
  INSERT INTO dbo.ADM_BUS
    (BusCod, BusCodExt, BusTxt, LngCod, DocSts, CteDte, CteUsr)
  VALUES
    (@CustomerBusinessCode, @CustomerBusinessCode, @CustomerName, N''ES'', N''A'',
     @Now, @BootstrapUser);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.SYS_SEC_USR WHERE UsrCod = @BootstrapUser)
BEGIN
  INSERT INTO dbo.SYS_SEC_USR
    (UsrCod, UsrTxt, UsrPwd, LngCod, UsrSysAcc, UsrAutLvl, UsrAccLck,
     DocSts, CteDte, CteUsr, UsrPwdChg, UsrPwdChgDte)
  VALUES
    (@BootstrapUser, @BootstrapUserName, @PasswordHash, N''ES'', 0, 9, N'''',
     N''A'', @Now, @BootstrapUser, N''0'', @Now);
END;

IF NOT EXISTS (
  SELECT 1
  FROM dbo.SYS_SEC_USR_BUS
  WHERE UsrCod = @BootstrapUser AND BusCod = @CustomerBusinessCode
)
BEGIN
  INSERT INTO dbo.SYS_SEC_USR_BUS (UsrCod, BusCod)
  VALUES (@BootstrapUser, @CustomerBusinessCode);
END;

IF NOT EXISTS (
  SELECT 1
  FROM dbo.SYS_SEC_GRP
  WHERE BusCod = @CustomerBusinessCode AND UsrGrpCod = @BootstrapGroup
)
BEGIN
  INSERT INTO dbo.SYS_SEC_GRP
    (BusCod, UsrGrpCod, UsrGrpTxt, DocSts, CteDte, CteUsr, UsrAutLvl)
  VALUES
    (@CustomerBusinessCode, @BootstrapGroup, N''Administradores'', N''A'',
     @Now, @BootstrapUser, 9);
END;

IF NOT EXISTS (
  SELECT 1
  FROM dbo.SYS_SEC_USR_GRP
  WHERE BusCod = @CustomerBusinessCode
    AND UsrCod = @BootstrapUser
    AND UsrGrpCod = @BootstrapGroup
)
BEGIN
  INSERT INTO dbo.SYS_SEC_USR_GRP
    (BusCod, UsrCod, UsrGrpCod, DocSts, CteDte, CteUsr)
  VALUES
    (@CustomerBusinessCode, @BootstrapUser, @BootstrapGroup, N''A'', @Now,
     @BootstrapUser);
END;

;WITH Operations (OprCod) AS (
  SELECT * FROM (VALUES
    (N''**''), (N''01''), (N''02''), (N''03''),
    (N''04''), (N''08''), (N''17''), (N''25'')
  ) AS ValuesList (OprCod)
)
INSERT INTO dbo.SYS_SEC_PER
  (BusCod, GrpCod, UsrCod, MdlCod, PrgCod, OprCod, UsrPerTyp)
SELECT @CustomerBusinessCode, @BootstrapGroup, N''**'', N''SYS'', N''USR'',
       OprCod, 1
FROM Operations O
WHERE NOT EXISTS (
  SELECT 1
  FROM dbo.SYS_SEC_PER CurrentRow
  WHERE CurrentRow.BusCod = @CustomerBusinessCode
    AND CurrentRow.GrpCod = @BootstrapGroup
    AND CurrentRow.UsrCod = N''**''
    AND CurrentRow.MdlCod = N''SYS''
    AND CurrentRow.PrgCod = N''USR''
    AND CurrentRow.OprCod = O.OprCod
);
';

BEGIN TRY
  BEGIN TRANSACTION;

  EXEC sys.sp_executesql
    @CoreSql,
    N'@ConnectionCode nvarchar(10), @CustomerBusinessCode nvarchar(20),
      @CustomerName nvarchar(50),
      @CustomerSqlServer nvarchar(50), @CustomerDatabase sysname,
      @CustomerSqlUser nvarchar(50), @CustomerSqlPassword nvarchar(50),
      @BootstrapUser nvarchar(15)',
    @ConnectionCode = @ConnectionCode,
    @CustomerBusinessCode = @CustomerBusinessCode,
    @CustomerName = @CustomerName,
    @CustomerSqlServer = @CustomerSqlServer,
    @CustomerDatabase = @CustomerDatabase,
    @CustomerSqlUser = @CustomerSqlUser,
    @CustomerSqlPassword = @CustomerSqlPassword,
    @BootstrapUser = @BootstrapUser;

  EXEC sys.sp_executesql
    @CustomerSql,
    N'@CustomerBusinessCode nvarchar(20), @CustomerName nvarchar(50),
      @BootstrapUser nvarchar(15), @BootstrapUserName nvarchar(82),
      @BootstrapPassword nvarchar(128), @BootstrapGroup nvarchar(20)',
    @CustomerBusinessCode = @CustomerBusinessCode,
    @CustomerName = @CustomerName,
    @BootstrapUser = @BootstrapUser,
    @BootstrapUserName = @BootstrapUserName,
    @BootstrapPassword = @BootstrapPassword,
    @BootstrapGroup = @BootstrapGroup;

  COMMIT TRANSACTION;
END TRY
BEGIN CATCH
  IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION;
  THROW;
END CATCH;

PRINT N'Datos iniciales creados o ya existentes.';
