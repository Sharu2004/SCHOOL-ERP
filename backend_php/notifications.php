<?php
require_once __DIR__ . '/config/db.php';

$pdo = getDbConnection();
$method = $_SERVER['REQUEST_METHOD'];
$input = json_decode(file_get_contents('php://input'), true);

if ($method === 'GET') {
    $class = $_GET['class'] ?? null;
    if ($class) {
        $stmt = $pdo->prepare('SELECT * FROM notifications WHERE target_class = ? OR target_class = "ALL" ORDER BY created_at DESC');
        $stmt->execute([$class]);
    } else {
        $stmt = $pdo->query('SELECT * FROM notifications ORDER BY created_at DESC');
    }
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    exit;
}

if ($method === 'POST') {
    $stmt = $pdo->prepare('INSERT INTO notifications (title, message, target_class, created_by) VALUES (?, ?, ?, ?)');
    $stmt->execute([
        $input['title'], $input['message'], $input['target_class'] ?? 'ALL', $input['created_by'] ?? null
    ]);
    echo json_encode(['success' => true, 'id' => $pdo->lastInsertId()]);
    exit;
}

http_response_code(405);
echo json_encode(['error' => 'Method not allowed']);
