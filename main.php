<form method="post" action="main.php">
    <input name="username">
    <input name="password" type="password">
    <select name="choix"><option value="default">defaut</option></select>
    <input name="choixunique" type="radio">
    <input name="choix2" type="check">
    <textarea name="messag"></textarea>
    <button><?php echo "pouet"; ?></button>
</form>

<?php

require('api.php');

$pdo = new PDO(
    'mysql:host=localhost;dbname=united',
    'website',
    'password'
);

if (isset($_POST['username']) && isset($_POST['password']))
{
    $api = new Api();
    echo $api->login($_POST['username'], $_POST['password']);

    $username = $_POST['username'];
    $password = $_POST['password'];



    $r = $pdo->prepare('CALL `login`(:username, :password)');
    $r->bindParam(':username', $username, PDO::PARAM_STR);
    $r->bindParam(':password', $password, PDO::PARAM_STR);
    $r->execute();

    $v = $r->fetch();

    $r->closeCursor();

    $user_id = $v['user_id'];

    $r = $pdo->prepare('CALL `get_user_info`(:user_id)');
    $r->bindParam(':user_id', $user_id, PDO::PARAM_INT);
    $r->execute();

    $user_info = $r->fetch();

    $r->closeCursor();

    $r = $pdo->prepare('CALL `get_suggested_projects`(:user_id)');
    $r->bindParam(':user_id', $user_id, PDO::PARAM_INT);
    $r->execute();

    $suggested_projects = $r->fetchAll();

    $r->closeCursor();

    for ($i = 0; i < count($suggested_projects); ++$i)
    {
        $project = $suggested_projects[$i];


    }
}



?>

<?php if (isset($user_info) { echo htmlentities($user_info['first_name']); } ?>