<?php

require_once WWW_ROOT . 'dao' . DIRECTORY_SEPARATOR . 'DAO.php';

class BadgesDAO extends DAO {

  public function selectAll() {
    $sql = "SELECT *
    				FROM `fsBadges`";
    $stmt = $this->pdo->prepare($sql);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
  }

  public function selectByUserId($id) {
    $sql = "SELECT `fsBadges`.* FROM `fsBadges`
    				INNER JOIN `fsBadgesDone` ON `fsBadges`.`id` = `fsBadgesDone`.`badge_id`
    				WHERE `fsBadgesDone`.`user_id` = :id";
   	$stmt = $this->pdo->prepare($sql);
   	$stmt->bindValue(':id', $id);
		$stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
  }

  public function insertCompleted($data) {
			$sql = "INSERT INTO `fsBadgesDone` (`user_id`, `badge_id`, `image`)
							VALUES (:user_id, :badge_id, :image)";
			$stmt = $this->pdo->prepare($sql);
			$stmt->bindValue(':user_id', $data['userId']);
			$stmt->bindValue(':badge_id', $data['badgeId']);
			$stmt->bindValue(':image', $data['image']);
			if($stmt->execute()) {
				return $this->pdo->lastInsertId();;
			}
	}
}
