<?php

class Api
{
    private $db;

    function __construct()
    {
        $this->db = $pdo = new PDO(
            'mysql:host=localhost;dbname=united',
            'website',
            'password'
        ); 
    }

    public function login($username, $password)
    {
        $r = $this->db->prepare('CALL `login`(:username, :password)');
        $r->bindParam(':username', $username, PDO::PARAM_STR);
        $r->bindParam(':password', $password, PDO::PARAM_STR);
        $r->execute();

        $v = $r->fetch();

        $r->closeCursor();

        return $v['user_id'];
    }
}

?>