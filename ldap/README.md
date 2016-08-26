These files show examples of interacting with the Turner Active Directory
instance using LDAP.  

The preferred access points are these, in order:

1. `ldap://ldap.turner.com` with TLS negotiation enabled. 
2. `ldaps://ldap.turner.com`, using all-SSL-all-the-time.

Both of the above will require that you either configure your LDAP client library to trust the
server certificate or disable certificate validation.

If you absolutely cannot get the secure versions to work for some reason, the plaintext port
is open at `ldap://ldap.turner.com`. But binding to it will require sending the password in
the clear, in violation of ISO policy.

##ActiveDirectory Notes

User entries in AD live under `CN=Users,DC=turner,DC=com`. While you can bind
with the actual Distinguished Name, as in other LDAP services, the DN is
formatted oddly and hard to predict if you don't know it.  For instance, mine
is `CN=Reed\, Mark (TBS),CN=Users,DC=turner,DC=com`.  Fortunately, you can also
bind using the format `Turner\\$sAMAccountName`, in my case `Turner\mjreed`.
