# Azure Active Directory

## AAD Objects

| AAD Objects       | Description                                                                                          |
|-------------------|------------------------------------------------------------------------------------------------------|
| Users             | Standard user/member identity.                                                                       |
| Groups            | Group of objects (users, groups, service principals, etc).                                           |
| Applications      | Used as a template to create one or more service principals.                                         |
| Service Principal | Representation or application instance of global application object in a single tenant or directory. |
| Devices           | Managed devices.                                                                                     |
| Roles             | Defines permissions for Azure Active Directory (AAD) objects.                                        |


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
