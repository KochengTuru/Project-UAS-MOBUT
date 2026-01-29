<?php
function ok($data = [], $message = "OK") {
  header('Content-Type: application/json; charset=utf-8');
  echo json_encode(["success" => true, "message" => $message, "data" => $data]);
  exit;
}

function fail($message = "Failed", $code = 400, $extra = []) {
  header('Content-Type: application/json; charset=utf-8');
  http_response_code($code);
  echo json_encode(array_merge(["success" => false, "message" => $message], $extra));
  exit;
}
