# Azure Active Directory

## AAD Objects

users
- standard user/member identity
groups
- group of objects (users, group, service principals, etc)
applications
- used as a template to create one or more service principals
service principal
- representation or application instance of global application object in a single tenant or directory
devices
- managed devices 
roles
- defines permissions for AAD objects


### AAD users
Standard identity for a user.
• Users can be internal or external
• Internal: <alias>@<tenant».onmicrosoft.com
.
External: <alias>_<HomeTenant»#EXT#@<tenant».onmicrosoft.com
•
Example:
Leron.Gray@stormspotter.onmicrosoft.com
Leron.Gray_microsoft.com#EXT#@stormspotter.onmicrosoft.com
