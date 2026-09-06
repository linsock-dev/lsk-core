<?php
declare(strict_types=1);

/**
 * Diagnóstico temporal de PHP y SQL Server.
 * Retirar o proteger este archivo antes de exponer el entorno fuera de localhost.
 */

$result = array(
  'status' => 'error',
  'message' => '',
);
$server = '';
$database = '';
$configFile = __DIR__ . '/../system/engine/tmssDatabaseCfg.php';

if (!is_file($configFile)) {
  $result['message'] = 'No se encontró tmssDatabaseCfg.php en la configuración estándar de la aplicación.';
} else if (!extension_loaded('sqlsrv')) {
  $result['message'] = 'La extensión sqlsrv no está cargada.';
} else {
  include $configFile;

  $server = $lv_tmssDatabaseCfgCnxInf['srv'] ?? '';
  $database = $lv_tmssDatabaseCfgCnxInf['db'] ?? '';

  if ($server === '' || $database === '' || !isset($lv_tmssDatabaseCfgCnxInf['usr'], $lv_tmssDatabaseCfgCnxInf['pwd'])) {
    $result['message'] = 'La configuración de SQL Server está incompleta.';
  } else {
    $connectionInfo = array(
      'Database' => $database,
      'UID' => $lv_tmssDatabaseCfgCnxInf['usr'],
      'PWD' => $lv_tmssDatabaseCfgCnxInf['pwd'],
      'CharacterSet' => 'UTF-8',
      // El SQL Server de diagnóstico usa un certificado autofirmado.
      'Encrypt' => true,
      'TrustServerCertificate' => true,
    );

    $connection = sqlsrv_connect($server, $connectionInfo);

    if ($connection === false) {
      $result['message'] = print_r(sqlsrv_errors(), true);
    } else {
      $statement = sqlsrv_query($connection, 'SELECT TOP (1) 1 AS connection_ok FROM dbo.hlt_pat');

      if ($statement === false) {
        $result['message'] = print_r(sqlsrv_errors(), true);
      } else {
        $result['status'] = 'ok';
        $result['message'] = 'Conexión cifrada y SELECT sobre dbo.hlt_pat correctos (certificado autofirmado aceptado sólo para diagnóstico).';
        sqlsrv_free_stmt($statement);
      }

      sqlsrv_close($connection);
    }
  }
}

phpinfo();
?>
<hr>
<section>
  <h1>Diagnóstico de SQL Server</h1>
  <p><strong>Servidor:</strong> <?= htmlspecialchars($server, ENT_QUOTES, 'UTF-8') ?></p>
  <p><strong>Base:</strong> <?= htmlspecialchars($database, ENT_QUOTES, 'UTF-8') ?></p>
  <p><strong>Consulta:</strong> <code>SELECT TOP (1) 1 AS connection_ok FROM dbo.hlt_pat</code></p>
  <p><strong>Resultado:</strong> <?= htmlspecialchars($result['status'], ENT_QUOTES, 'UTF-8') ?></p>
  <pre><?= htmlspecialchars($result['message'], ENT_QUOTES, 'UTF-8') ?></pre>
</section>
