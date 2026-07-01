<?php
require_once __DIR__ . '/config/db.php';

$pdo = getDbConnection();
$method = $_SERVER['REQUEST_METHOD'];
$input = json_decode(file_get_contents('php://input'), true);

if ($method === 'GET') {
    $studentId = $_GET['student_id'] ?? null;
    if (!$studentId) { http_response_code(400); echo json_encode(['error' => 'student_id required']); exit; }
    $stmt = $pdo->prepare('SELECT * FROM fees WHERE student_id = ? ORDER BY due_date');
    $stmt->execute([$studentId]);
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    exit;
}

if ($method === 'POST') {
    // Record a payment against a fee record
    $feeId = $input['fee_id'];
    $amount = $input['amount_paid'];

    $stmt = $pdo->prepare('SELECT amount_due, amount_paid FROM fees WHERE id = ?');
    $stmt->execute([$feeId]);
    $fee = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$fee) { http_response_code(404); echo json_encode(['error' => 'Fee record not found']); exit; }

    $newPaid = $fee['amount_paid'] + $amount;
    $status = $newPaid >= $fee['amount_due'] ? 'paid' : ($newPaid > 0 ? 'partial' : 'pending');

    $update = $pdo->prepare('UPDATE fees SET amount_paid = ?, status = ? WHERE id = ?');
    $update->execute([$newPaid, $status, $feeId]);

    echo json_encode(['success' => true, 'amount_paid' => $newPaid, 'status' => $status]);
    exit;
}

http_response_code(405);
echo json_encode(['error' => 'Method not allowed']);
