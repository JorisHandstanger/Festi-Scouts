<?php

require_once WWW_ROOT . 'dao' . DIRECTORY_SEPARATOR . 'DAO.php';

class UserDAO extends DAO {

  public function selectAll() {
    $sql = "SELECT *
    				FROM `fsUsers`";
    $stmt = $this->pdo->prepare($sql);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
  }

  public function getTotem() {
    $sql = "(SELECT bijvNw as Totem FROM fsBN ORDER BY RAND() LIMIT 1)
						UNION ALL
						(SELECT Animal as Totem FROM fsAnimals ORDER BY RAND() LIMIT 1)";
    $stmt = $this->pdo->prepare($sql);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
  }

  public function selectByTotem($totem) {
		$sql = "SELECT *
						FROM `fsUsers`
						WHERE `totem` = :totem";
		$stmt = $this->pdo->prepare($sql);
		$stmt->bindValue(':totem', $totem);
		$stmt->execute();
		$result = $stmt->fetch(PDO::FETCH_ASSOC);
		if($result){
			return $result;
		}
		return [];
	}

	public function selectById($id) {
		$sql = "SELECT *
						FROM `fsUsers`
						WHERE `id` = :id";
		$stmt = $this->pdo->prepare($sql);
		$stmt->bindValue(':id', $id);
		$stmt->execute();
		$result = $stmt->fetch(PDO::FETCH_ASSOC);
		if($result){
			return $result;
		}
		return [];
	}

	public function delete($id) {
		$sql = "DELETE
						FROM `fsUsers`
						WHERE `id` = :id";
		$stmt = $this->pdo->prepare($sql);
		$stmt->bindValue(':id', $id);
		return $stmt->execute();
	}

	public function insert($data) {
		$errors = $this->getValidationErrors($data);
		if(empty($errors)) {
			$sql = "INSERT INTO `fsUsers` (`totem`, `animalImage`, `backImage`)
							VALUES (:totem, :animalImage, :backImage)";
			$stmt = $this->pdo->prepare($sql);
			$stmt->bindValue(':totem', $data['totem']);
			$stmt->bindValue(':animalImage', $data['animalImage']);
			$stmt->bindValue(':backImage', $data['backImage']);
			if($stmt->execute()) {
				$insertedId = $this->pdo->lastInsertId();
				return $this->selectById($insertedId);
			}
		}
		return false;
	}


	public function getValidationErrors($data) {
		$errors = array();
		if(empty($data['totem'])) {
			$errors['totem'] = 'field totem has no value';
		}
		if(empty($data['animalImage'])) {
			$errors['animalImage'] = 'field animalImage has no value';
		}
		if(empty($data['backImage'])) {
			$errors['backImage'] = 'field backImage has no value';
		}
		return $errors;
	}

}
