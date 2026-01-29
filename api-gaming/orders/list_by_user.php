<?php
require_once(__DIR__ . "/../config/db.php");
require_once(__DIR__ . "/../config/response.php");
require_once(__DIR__ . "/../config/auth.php");
require_login();

$user_id = intval($_GET["user_id"] ?? 0);
if ($user_id <= 0) fail("user_id wajib");

$sql = "SELECT o.id, o.qty, o.total_price, o.created_at,
               p.name AS product_name, p.image_url
        FROM orders o
        JOIN products p ON p.id = o.product_id
        WHERE o.user_id=?
        ORDER BY o.id DESC";
$stmt = $pdo->prepare($sql);
$stmt->execute([$user_id]);
$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

ok($rows, "Riwayat user");
