<?php
require_once __DIR__ . '/config/db.php';

$pdo = getDbConnection();
$method = $_SERVER['REQUEST_METHOD'];
$input = json_decode(file_get_contents('php://input'), true);

switch ($method) {
    case 'GET':
        if (isset($_GET['id'])) {
            $stmt = $pdo->prepare('SELECT * FROM students WHERE id = ?');
            $stmt->execute([$_GET['id']]);
            echo json_encode($stmt->fetch(PDO::FETCH_ASSOC));
        } else {
            $classFilter = $_GET['class'] ?? null;
            if ($classFilter) {
                $stmt = $pdo->prepare('SELECT * FROM students WHERE class_name = ? ORDER BY full_name');
                $stmt->execute([$classFilter]);
            } else {
                $stmt = $pdo->query('SELECT * FROM students ORDER BY full_name');
            }
            echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
        }
        break;

    case 'POST':
        $stmt = $pdo->prepare(
            'INSERT INTO students (admission_no, full_name, class_name, section, date_of_birth, parent_name, parent_contact, address)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)'
        );
        $stmt->execute([
            $input['admission_no'], $input['full_name'], $input['class_name'], $input['section'] ?? null,
            $input['date_of_birth'] ?? null, $input['parent_name'] ?? null,
            $input['parent_contact'] ?? null, $input['address'] ?? null
        ]);
        echo json_encode(['success' => true, 'id' => $pdo->lastInsertId()]);
        break;

    case 'PUT':
        $id = $_GET['id'] ?? null;
        if (!$id) { http_response_code(400); echo json_encode(['error' => 'id required']); exit; }
        $stmt = $pdo->prepare(
            'UPDATE students SET full_name=?, class_name=?, section=?, parent_name=?, parent_contact=?, address=? WHERE id=?'
        );
        $stmt->execute([
            $input['full_name'], $input['class_name'], $input['section'] ?? null,
            $input['parent_name'] ?? null, $input['parent_contact'] ?? null,
            $input['address'] ?? null, $id
        ]);
        echo json_encode(['success' => true]);
        break;

    case 'DELETE':
        $id = $_GET['id'] ?? null;
        if (!$id) { http_response_code(400); echo json_encode(['error' => 'id required']); exit; }
        $stmt = $pdo->prepare('DELETE FROM students WHERE id = ?');
        $stmt->execute([$id]);
        echo json_encode(['success' => true]);
        break;

    default:
        http_response_code(405);
        echo json_encode(['error' => 'Method not allowed']);
}
