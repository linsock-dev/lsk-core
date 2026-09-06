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

if (!extension_loaded('sqlsrv')) {
  $result['message'] = 'La extensión sqlsrv no está cargada.';
} else {
  $connectionInfo = array(
    'Database' => 'tmssTeam2',
    'UID' => 'sa',
    'PWD' => 'TuPassword123!',
    'CharacterSet' => 'UTF-8',
  );

  $connection = sqlsrv_connect('192.168.0.222', $connectionInfo);

  if ($connection === false) {
    $result['message'] = print_r(sqlsrv_errors(), true);
  } else {
    $statement = sqlsrv_query($connection, 'SELECT TOP (1) 1 AS connection_ok FROM dbo.hlt_pat');

    if ($statement === false) {
      $result['message'] = print_r(sqlsrv_errors(), true);
    } else {
      $result['status'] = 'ok';
      $result['message'] = 'Conexión y SELECT sobre dbo.hlt_pat correctos.';
      sqlsrv_free_stmt($statement);
    }

    sqlsrv_close($connection);
  }
}

phpinfo();
?>
<hr>
<section>
  <h1>Diagnóstico de SQL Server</h1>
  <p><strong>Servidor:</strong> 192.168.0.222</p>
  <p><strong>Base:</strong> tmssTeam2</p>
  <p><strong>Consulta:</strong> <code>SELECT TOP (1) 1 AS connection_ok FROM dbo.hlt_pat</code></p>
  <p><strong>Resultado:</strong> <?= htmlspecialchars($result['status'], ENT_QUOTES, 'UTF-8') ?></p>
  <pre><?= htmlspecialchars($result['message'], ENT_QUOTES, 'UTF-8') ?></pre>
</section>
