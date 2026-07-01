<?php
require_once __DIR__ . '/config/db.php';

$pdo = getDbConnection();
$method = $_SERVER['REQUEST_METHOD'];
$input = json_decode(file_get_contents('php://input'), true);

if ($method === 'GET') {
    // GET attendance.php?student_id=1  OR  attendance.php?date=2026-07-01&class=10
    if (isset($_GET['student_id'])) {
        $stmt = $pdo->prepare('SELECT * FROM attendance WHERE student_id = ? ORDER BY attendance_date DESC');
        $stmt->execute([$_GET['student_id']]);
        echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    } elseif (isset($_GET['date'])) {
        $stmt = $pdo->prepare(
            'SELECT a.*, s.full_name, s.class_name FROM attendance a
             JOIN students s ON s.id = a.student_id
             WHERE a.attendance_date = ?' . (isset($_GET['class']) ? ' AND s.class_name = ?' : '')
        );
        $params = isset($_GET['class']) ? [$_GET['date'], $_GET['class']] : [$_GET['date']];
        $stmt->execute($params);
        echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'student_id or date parameter required']);
    }
    exit;
}

if ($method === 'POST') {
    // Mark attendance (single or bulk via "records" array)
    $records = $input['records'] ?? [$input];
    $stmt = $pdo->prepare(
        'INSERT INTO attendance (student_id, attendance_date, status, marked_by)
         VALUES (?, ?, ?, ?)
         ON DUPLICATE KEY UPDATE status = VALUES(status), marked_by = VALUES(marked_by)'
    );
    foreach ($records as $r) {
        $stmt->execute([$r['student_id'], $r['attendance_date'], $r['status'], $r['marked_by'] ?? null]);
    }
    echo json_encode(['success' => true, 'count' => count($records)]);
    exit;
}

http_response_code(405);
echo json_encode(['error' => 'Method not allowed']);
