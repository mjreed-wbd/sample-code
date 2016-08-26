#!/usr/bin/env php 
<?php
function main() {

  $url = ($url = getenv('AD_LDAP_URL')) ? $url : 'ldap://ldap.turner.com';
  if ($ldap = ldap_connect($url)) {
    


main(ARGV)
// Authentication and Authorization
function checkLogin($user, $passwd) {
  global $CONFIG;
  $result = false;
  if (!$passwd) return false;
  if (function_exists('ldap_connect') && isset($CONFIG['ldap_auth'])) {
    foreach ($CONFIG['ldap_auth'] as $conf) {
      $url = $conf['url'];
      $dn = sprintf($conf['user_dn_format'], $user);
      $ldap = ldap_connect($url);
      if (!$ldap) continue;
      $result = @ldap_bind($ldap, $dn, $passwd);
      ldap_close($ldap);
      if ($result) break;
    }
  } elseif (function_exists('ftp_connect') && isset($CONFIG['ftp_auth'])) {
    $host = $CONFIG['ftp_auth']['host'];
    $ftp = ftp_connect($host);
    if (!$ftp) {
      return false;
    }
    $result = @ftp_login($ftp, $user, $passwd);
    ftp_close($ftp);
  } else {
    $result = false;
  }
  if ($result) {
    return user($user, 'LOGIN');
  } else {
    return false;
  }
}
function isAdmin($user) {
  global $ADMIN_USERS;
  return in_array($user, $ADMIN_USERS);
}
function isCAB($user) {
  global $CAB_USERS;
  $people = getPeopleArray('secondary');
  $allowed = array();
  foreach ($CAB_USERS as $cabuser) {
    $allowed[] = $cabuser;
    if (isset($people[$cabuser]['DELEGATE'])) {
      $allowed[] = $people[$cabuser]['DELEGATE'];
    }
    if (isset($people[$cabuser]['DELEGATE2'])) {
      $allowed[] = $people[$cabuser]['DELEGATE2'];
    }
  }
  return in_array($user, $allowed);
}
function requireLogin($needsAdmin = false) {
  global $APP_LOC;
  if (!isset($_SESSION['uname']) || ($needsAdmin && !isAdmin($_SESSION['uname']))) {
    $self = $APP_LOC['SELF'];
    if ($_SERVER['QUERY_STRING']) {
      $self.= '?' . $_SERVER['QUERY_STRING'];
    }
    setcookie("siteToGo", $self, time() + (86400 * 7 * 52), $APP_LOC['BASE']);
    redirect("login");
    exit(0);
  }
  $uname = $_SESSION['uname'];
  return user($uname);
}
function loggedInUser() {
  if (isset($_SESSION['uname'])) {
    return $_SESSION['uname'];
  } else {
    return null;
  }
}
function logOut() {
  unset($_SESSION['uname']);
}
?>
