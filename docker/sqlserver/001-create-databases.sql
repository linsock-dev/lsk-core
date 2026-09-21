/*
  Bases vacías para el entorno Docker de desarrollo.

  Los objetos de cada base se instalan después, desde src/batabase/core y
  src/batabase/customers, respetando el orden indicado en initial-data/README.md.
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
