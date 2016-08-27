These files show examples of interacting with the Turner Active Directory
instance using LDAP. They are all implementations of the same command-line 
program, which looks someone up in the directory and displays their phone number. 

They look for a credentials in the environment (specifically, `AD_LDAP_BIND_USER`
and `AD_LDAP_BIND_PASSWORD`). User entries in our AD live under
`CN=Users,DC=turner,DC=com`, with distinguished names that are not necessarily
predictable (for instance, mine is `CN=Reed\, Mark
(TBS),CN=Users,DC=turner,DC=com`).  Fortunately, you can instead bind using the
format `Turner\\$sAMAccountName`, in my case `Turner\mjreed`.

You can also override the URL with `AD_LDAP_URL`, but it defaults to
`ldap://ldap.turner.com` if that is not set.

If you just type `make`, it will prompt for the credentials, set the environment
variables, and run the spectests. You will need the respective interpreters and access
to ldap.turner.com forthem to pass, of course.

The preferred access methods are these, in order:

1. `ldap://ldap.turner.com` with TLS negotiation enabled.
2. `ldaps://ldap.turner.com`, using all-SSL-all-the-time.

Both of the above will require that you either configure your LDAP client
library to trust the server certificate or disable certificate validation.

If you absolutely cannot get the secure versions to work for some reason, the
plaintext port at `ldap://ldap.turner.com` will also work without negotiating
TLS. But binding to it will require sending the password in the clear, in
violation of ISO policy.
