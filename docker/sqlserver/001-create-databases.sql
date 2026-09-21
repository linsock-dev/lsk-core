/*
  Esquema mínimo para el entorno Docker de desarrollo.

  Crea, sin alterar objetos existentes, las bases y las tablas que exige
  src/batabase/initial-data/001-bootstrap.sql. Luego de este script, edite
  y ejecute 001-bootstrap.sql por separado para registrar el cliente y el
  usuario administrador inicial.
*/
IF DB_ID(N'tmssSysPrd') IS NULL
BEGIN
    CREATE DATABASE [tmssSysPrd];
END;
GO

IF DB_ID(N'tmssTeam2') IS NULL
BEGIN
    CREATE DATABASE [tmssTeam2];
END;
GO

/* CORE: tmssSysPrd */
USE [tmssSysPrd];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.SYS_LNG', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SYS_LNG](
 [LngCod] [nvarchar](20) NOT NULL, [LngTxt] [nvarchar](50) NOT NULL, [LngLocTxt] [nvarchar](40) NULL, [DocSts] [nvarchar](2) NOT NULL, [CteDte] [smalldatetime] NOT NULL, [CteUsr] [nvarchar](20) NOT NULL, [UpdDte] [smalldatetime] NULL, [UpdUsr] [nvarchar](20) NULL,
 CONSTRAINT [PK_SYS_LNG] PRIMARY KEY CLUSTERED ([LngCod] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];
END;
GO
IF OBJECT_ID(N'dbo.SYS_CNX', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SYS_CNX](
 [SysCnxCod] [int] IDENTITY(1,1) NOT NULL, [SysCnxCodExt] [nvarchar](10) NULL, [SysCnxTxt] [nvarchar](50) NOT NULL, [SysCnxPth] [nvarchar](50) NULL, [SysCnxSrv] [nvarchar](50) NULL, [SysCnxDb] [nvarchar](50) NULL, [SysCnxUsr] [nvarchar](50) NULL, [SysCnxPwd] [nvarchar](50) NULL, [SysCnxFlePth] [nvarchar](250) NULL, [DocSts] [nvarchar](2) NOT NULL, [CteDte] [smalldatetime] NOT NULL, [CteUsr] [nvarchar](20) NOT NULL, [UpdDte] [smalldatetime] NULL, [UpdUsr] [nvarchar](20) NULL,
 CONSTRAINT [PK_SYS_CNX] PRIMARY KEY CLUSTERED ([SysCnxCod] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];
END;
GO
IF OBJECT_ID(N'dbo.SLS_CUS', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SLS_CUS](
 [BusCod] [nvarchar](20) NOT NULL, [CusCod] [int] IDENTITY(1,1) NOT NULL, [CusCodExt] [nvarchar](20) NULL, [CusTxt] [nvarchar](50) NOT NULL, [AdrNum] [int] NULL, [CusCmt] [nvarchar](4000) NULL, [SlsPrcLstCod] [int] NULL, [SlsGrpCod] [int] NULL, [PayTrmCod] [int] NULL, [CusTypCod] [int] NULL, [DocSts] [nvarchar](2) NOT NULL, [CteDte] [smalldatetime] NOT NULL, [CteUsr] [nvarchar](20) NOT NULL, [UpdDte] [smalldatetime] NULL, [UpdUsr] [nvarchar](20) NULL, [SysDocClsCod] [int] NULL,
 CONSTRAINT [PK_SLS_CUS] PRIMARY KEY CLUSTERED ([BusCod] ASC, [CusCod] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];
END;
GO
IF OBJECT_ID(N'dbo.SYS_APP_MDL', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SYS_APP_MDL](
 [codMDL] [nvarchar](20) NOT NULL, [desMDL] [varchar](255) NOT NULL, [ObjOrd] [int] NULL, [OBJLng] [nvarchar](2) NOT NULL, [OBJSts] [nvarchar](1) NOT NULL, [KeyMDL] [varchar](255) NULL, [DocSts] [nvarchar](2) NULL, [CteDte] [smalldatetime] NULL, [CteUsr] [nvarchar](20) NULL, [UpdDte] [smalldatetime] NULL, [UpdUsr] [nvarchar](20) NULL, [mdlpic] [nvarchar](255) NULL,
 CONSTRAINT [PK_SYS_APP_MDL] PRIMARY KEY CLUSTERED ([codMDL] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];
END;
GO
IF OBJECT_ID(N'dbo.SYS_APP_PRG', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SYS_APP_PRG](
 [codMDL] [nvarchar](20) NOT NULL, [codPRG] [nvarchar](20) NOT NULL, [desPRG] [nvarchar](40) NULL, [PRGFrmDat] [varchar](255) NULL, [PRGPictName] [varchar](255) NULL, [OBJLng] [nvarchar](2) NOT NULL, [OBJSts] [nvarchar](1) NOT NULL, [OBJOrd] [int] NULL, [PRGMnuChl] [nvarchar](50) NULL, [PRGMnuPar] [nvarchar](50) NULL, [PRGGrp] [varchar](255) NULL, [VewCod] [nvarchar](250) NULL, [PrgMnuHde] [int] NULL, [DocSts] [nvarchar](2) NULL, [CteDte] [smalldatetime] NULL, [CteUsr] [nvarchar](20) NULL, [UpdDte] [smalldatetime] NULL, [UpdUsr] [nvarchar](20) NULL, [PrgTypCod] [nvarchar](1) NULL, [SysObjId] [int] NULL, [PrgTrx] [nvarchar](5) NULL, [SysCfgObj] [int] NULL, [PrgCodExt] [int] IDENTITY(1,1) NOT NULL, [prgnavurl] [nvarchar](400) NULL,
 CONSTRAINT [PK_SYS_APP_PRG] PRIMARY KEY CLUSTERED ([codMDL] ASC, [codPRG] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];
END;
GO
IF OBJECT_ID(N'dbo.SYS_SEC_OPR', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SYS_SEC_OPR](
 [codMDL] [nvarchar](20) NOT NULL, [codPRG] [nvarchar](20) NOT NULL, [codOPR] [nvarchar](20) NOT NULL, [OprTxt] [nvarchar](40) NOT NULL, [OprPctNme] [nvarchar](50) NULL, [OprShwInGrd] [int] NULL, [DocSts] [nvarchar](2) NOT NULL, [CteDte] [smalldatetime] NOT NULL, [CteUsr] [nvarchar](20) NOT NULL, [UpdDte] [smalldatetime] NULL, [UpdUsr] [nvarchar](20) NULL, [OprNavUrl] [nvarchar](250) NULL,
 CONSTRAINT [PK_SYS_SEC_OPR] PRIMARY KEY CLUSTERED ([codMDL] ASC, [codPRG] ASC, [codOPR] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];
END;
GO
IF OBJECT_ID(N'dbo.SYS_FNC', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SYS_FNC](
 [SysFncCod] [int] IDENTITY(1,1) NOT NULL, [SysFncCodExt] [nvarchar](20) NULL, [SysFncTxt] [nvarchar](50) NOT NULL, [SysFncTtl] [nvarchar](400) NULL, [SysFncDes] [nvarchar](max) NOT NULL, [AutLvl] [int] NULL, [SysFncHde] [int] NULL, [MdlCod] [nvarchar](20) NOT NULL, [SysFncPic] [nvarchar](250) NULL, [SysFncAtrVal001] [nvarchar](max) NULL, [DocSts] [nvarchar](2) NOT NULL, [CteDte] [smalldatetime] NOT NULL, [CteUsr] [nvarchar](20) NOT NULL, [UpdDte] [smalldatetime] NULL, [UpdUsr] [nvarchar](20) NULL,
 CONSTRAINT [PK_SYS_FNC] PRIMARY KEY CLUSTERED ([SysFncCod] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
END;
GO
IF OBJECT_ID(N'dbo.SYS_FNC_PRG', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SYS_FNC_PRG](
 [SysFncCod] [int] NOT NULL, [MdlCod] [nvarchar](20) NOT NULL, [PrgCod] [nvarchar](20) NOT NULL, [OprCod] [nvarchar](20) NOT NULL, [DocSts] [nvarchar](2) NOT NULL, [CteDte] [smalldatetime] NOT NULL, [CteUsr] [nvarchar](20) NOT NULL, [UpdDte] [smalldatetime] NULL, [UpdUsr] [nvarchar](20) NULL,
 CONSTRAINT [PK_SYS_FNC_PRG] PRIMARY KEY CLUSTERED ([SysFncCod] ASC, [MdlCod] ASC, [PrgCod] ASC, [OprCod] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];
END;
GO
IF OBJECT_ID(N'dbo.SYS_FNC_SUB', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SYS_FNC_SUB](
 [SysFncSubCod] [int] IDENTITY(1,1) NOT NULL, [SysFncCod] [int] NOT NULL, [CusCod] [int] NOT NULL, [SysFncSubStrDte] [datetime] NOT NULL, [SysFncSubEndDte] [datetime] NOT NULL, [DocSts] [nvarchar](50) NOT NULL, [CteDte] [smalldatetime] NOT NULL, [CteUsr] [nvarchar](20) NOT NULL, [UpdDte] [smalldatetime] NULL, [UpdUsr] [nvarchar](20) NULL,
 CONSTRAINT [PK_SYS_FNC_SUB] PRIMARY KEY CLUSTERED ([SysFncSubCod] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];
END;
GO

/* CUSTOMERS: tmssTeam2 */
USE [tmssTeam2];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
IF OBJECT_ID(N'dbo.ADM_BUS', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ADM_BUS](
 [BusCod] [nvarchar](20) NOT NULL, [BusCodExt] [nvarchar](20) NULL, [BusTxt] [nvarchar](50) NOT NULL, [AdrNum] [int] NULL, [BusActStr] [datetime] NULL, [BusCmt] [nvarchar](max) NULL, [CurCod] [nvarchar](5) NULL, [DocSts] [nvarchar](2) NOT NULL, [CteDte] [smalldatetime] NOT NULL, [CteUsr] [nvarchar](20) NOT NULL, [UpdDte] [smalldatetime] NULL, [UpdUsr] [nvarchar](20) NULL, [BusAtr] [nvarchar](max) NULL, [LngCod] [nvarchar](20) NULL, [HhrOrgChtCod] [int] NULL,
 CONSTRAINT [PK_ADM_BUS] PRIMARY KEY CLUSTERED ([BusCod] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
END;
GO
IF OBJECT_ID(N'dbo.SYS_SEC_USR', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SYS_SEC_USR](
 [UsrCod] [nvarchar](20) NOT NULL, [UsrTxt] [nvarchar](82) NULL, [UsrPwd] [nvarchar](512) NOT NULL, [UsrCntHrs] [nvarchar](35) NULL, [UsrPrfWndRfh] [int] NULL, [UsrPrfWndSty] [nvarchar](50) NULL, [LngCod] [nvarchar](2) NULL, [UsrAccErrLstDte] [smalldatetime] NULL, [UsrAccErrQty] [int] NULL, [UsrAccTrmAgrDte] [smalldatetime] NULL, [UsrAccTrmDsgDte] [smalldatetime] NULL, [UsrSysAcc] [int] NULL, [UsrAutLvl] [int] NULL, [UsrAccLck] [nvarchar](1) NULL, [DocSts] [nvarchar](2) NOT NULL, [CteDte] [smalldatetime] NOT NULL, [CteUsr] [nvarchar](20) NOT NULL, [UpdDte] [smalldatetime] NULL, [UpdUsr] [nvarchar](20) NULL, [UsrAtr001] [nvarchar](4000) NULL, [UsrPwdChg] [nvarchar](1) NULL, [UsrPwdChgDte] [smalldatetime] NULL,
 CONSTRAINT [PK_SYS_SEC_USR] PRIMARY KEY CLUSTERED ([UsrCod] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];
END;
GO
IF OBJECT_ID(N'dbo.SYS_SEC_USR_BUS', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SYS_SEC_USR_BUS](
 [UsrCod] [nvarchar](15) NOT NULL, [BusCod] [nvarchar](20) NOT NULL, [UsrTrmAcp] [smalldatetime] NULL,
 CONSTRAINT [PK_SYS_SEC_USR_BUS] PRIMARY KEY CLUSTERED ([UsrCod] ASC, [BusCod] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];
END;
GO
IF OBJECT_ID(N'dbo.SYS_SEC_GRP', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SYS_SEC_GRP](
 [BusCod] [nvarchar](20) NOT NULL, [UsrGrpCod] [nvarchar](20) NOT NULL, [UsrGrpTxt] [nvarchar](40) NOT NULL, [DocSts] [nvarchar](2) NOT NULL, [CteDte] [smalldatetime] NOT NULL, [CteUsr] [nvarchar](20) NOT NULL, [UpdDte] [smalldatetime] NULL, [UpdUsr] [nvarchar](20) NULL, [UsrAutLvl] [int] NULL, [UsrGrpAtr001] [nvarchar](4000) NULL,
 CONSTRAINT [PK_SYS_SEC_GRP] PRIMARY KEY CLUSTERED ([BusCod] ASC, [UsrGrpCod] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];
END;
GO
IF OBJECT_ID(N'dbo.SYS_SEC_USR_GRP', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SYS_SEC_USR_GRP](
 [BusCod] [nvarchar](20) NOT NULL, [UsrCod] [nvarchar](15) NOT NULL, [UsrGrpCod] [nvarchar](20) NOT NULL, [DocSts] [nvarchar](2) NOT NULL, [CteDte] [smalldatetime] NOT NULL, [CteUsr] [nvarchar](20) NOT NULL, [UpdDte] [smalldatetime] NULL, [UpdUsr] [nvarchar](20) NULL,
 CONSTRAINT [PK_SYS_SEC_USR_GRP] PRIMARY KEY CLUSTERED ([BusCod] ASC, [UsrCod] ASC, [UsrGrpCod] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];
END;
GO
IF OBJECT_ID(N'dbo.SYS_SEC_PER', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SYS_SEC_PER](
 [BusCod] [nvarchar](20) NOT NULL, [GrpCod] [nvarchar](20) NOT NULL, [UsrCod] [nvarchar](20) NOT NULL, [MdlCod] [nvarchar](20) NOT NULL, [PrgCod] [nvarchar](20) NOT NULL, [OprCod] [nvarchar](20) NOT NULL, [UsrPerTyp] [int] NOT NULL,
 CONSTRAINT [PK_SYS_SEC_PER] PRIMARY KEY CLUSTERED ([BusCod] ASC, [GrpCod] ASC, [UsrCod] ASC, [MdlCod] ASC, [PrgCod] ASC, [OprCod] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];
END;
GO
