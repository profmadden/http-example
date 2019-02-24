<?php
# PHP script accepts a value from a POST, and then
# doubles it.  It returns a JSON array -- putting a few things
# in to it, for debugging and experimentation use.
# There's status number (so you could send back an error code),
# the actual input value for sanity checking.
# and a string result, in case you want to work with a string.

$x = $_POST["value"];
$x = 2 * $x;

$result[] = array('result' => $x, 'status' => 0, 'input' => $_POST["value"], 'string' => "a string");

$js = json_encode($result);

echo $js;
?>