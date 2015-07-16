TLS plugin for Fuel
===================

TLS plugin
---------------

Overview
--------
By default the openstack environment is configured with Http protocol. This plugin allows to configure Horizon, and novnc to use Https connexion by using Transport LAyer security (TLS) protocol to improve security.

This repo contains all necessary files to build Https Fuel plugin.

Requirements
------------

| Requirement                      | Version/Comment                                         |
|----------------------------------|---------------------------------------------------------|
| Mirantis Openstack compatibility | 6.1                                                     |
|----------------------------------|---------------------------------------------------------|
| Crt & Key files                  | You have a crt & key files to provide before deployment |

Recommendations
---------------

None.

Limitations
-----------

Securing apis is not yet implemented. Scope of the plugin only openstack dashboard and novnc for now 

Installation Guide
==================

Https plugin installation
----------------------------

1. Clone the fuel-plugin repo from: https://github.com/stackforge/fuel-plugin-tls.git

    ``git clone``

2. Install the Fuel Plugin Builder:

    ``pip install fuel-plugin-builder``

3. Build tls Fuel plugin:

   ``fpb --build fuel-plugin-tls/``

4. The tls-<x.x.x>.rpm file will be created in the plugin folder (fuel-plugin-tls)

5. Move this file to the Fuel Master node with secure copy (scp):

   ``scp tls-<x.x.x>.rpm root@:<the_Fuel_Master_node_IP address>:/tmp``
   ``cd /tmp``

6. Install the tls plugin:

   ``fuel plugins --install tls-<x.x.x>.rpm``

6. Plugin is ready to use and can be enabled on the Settings tab of the Fuel web UI.

User Guide
==========

https plugin configuration
-----------------------------

1. Create a new environment with the Fuel UI wizard

2. Add a node with the "Compute" role.

3. Click on the settings tab of the Fuel web UI

4. Scroll down the page, select the "Https plugin" checkbox
   and fill-in the requiered fields
    - the certificate .crt content
    - the certificate .key content

	
You must pass your .crt, .key, .ca files via fuel UI (settings tab)
When you pass the content of the files in fuel ui, some "space" characters will appear, don't care about this puppet will remove it.

CRT file must be in the following format : 

-----BEGIN CERTIFICATE-----
MIIDXTCCAkWgAwIBAgIJAJHydV1v41XIMA0GCSqGSIb3DQEBBQUAMEUxCzAJBgNV
BAYTAkZSMRMwEQYDVQQIDApTb21lLVN0YXRlMSEwHwYDVQQKDBhJbnRlcm5ldCBX
aWRnaXRzIFB0eSBMdGQwHhcNMTUwMTMwMTAyNDU3WhcNMTYwMTMwMTAyNDU3WjBF
MQswCQYDVQQGEwJGUjETMBEGA1UECAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50
ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAqwHssa1A2alSVh8ZZvKffGaix7mSFMDsFjUgPShqbAZ8xGQynvrHPel9
A8E6ml0sGzHDwk8gobpu7k1wuMhcs7Np88xu5GtR1DhZWQ8MUGWHfflyjguMjtzF
pZg4j0M14SE2INwwsRRtvC0/aeV1/q7HqfTk7+y01g/N4OKvYwndNp2lbSjBZZF4
qbL9QD5iesOptxRryJ8tcm47i6hC4LTunz9pgVI13rtlOoqtXjf07ytMydBbzpeR
4joaPAjbPf5ywf+I/n8XFxy6QPC9qAm2H3Gpo/5bb7+9S8AOhYqvWEKNotvyX1E8
aiDLV+LHkL45Xpx47YBty6L8qNuejwIDAQABo1AwTjAdBgNVHQ4EFgQUVQNmpJDO
w5eVB3yjU80NUZSKZlcwHwYDVR0jBBgwFoAUVQNmpJDOw5eVB3yjU80NUZSKZlcw
DAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQUFAAOCAQEAqadjZT7kMXRf5bp14nfI
20m6G/i5aHBo+0v+6lRtmk5wD/D6VsOh+R/HjjDDo68y/WEWXxQbuOYX+HZCABpf
VTA4oLvY4t3gtzt9Q21VtK/l5e3yyxo2JBnsPqc5wmWDlNO8aImF+QrvovkuyTV5
mX6suZgby4eTllmVzBNK/+FMuPlsSPwB8SxEbu04aOIcwbn4LCCZJZEG6INVGSS8
SRg1iER8mu2Jf45JKkMFDqUhCUp/ejM2t686O7olqKtmF53rDSBnzhtabdgTIx3F
RjCb281gwvwSgyFfUgt5TIIq1o/kci2N33zuxaifFVz6DtDxKegoZg73bUMg/OA2
bg==
-----END CERTIFICATE-----

KEY file must be in the following format : 

-----BEGIN PRIVATE KEY-----
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCrAeyxrUDZqVJW
Hxlm8p98ZqLHuZIUwOwWNSA9KGpsBnzEZDKe+sc96X0DwTqaXSwbMcPCTyChum7u
TXC4yFyzs2nzzG7ka1HUOFlZDwxQZYd9+XKOC4yO3MWlmDiPQzXhITYg3DCxFG28
LT9p5XX+rsep9OTv7LTWD83g4q9jCd02naVtKMFlkXipsv1APmJ6w6m3FGvIny1y
bjuLqELgtO6fP2mBUjXeu2U6iq1eN/TvK0zJ0FvOl5HiOho8CNs9/nLB/4j+fxcX
HLpA8L2oCbYfcamj/ltvv71LwA6Fiq9YQo2i2/JfUTxqIMtX4seQvjlenHjtgG3L
ovyo256PAgMBAAECggEAD3iAGl7rNAXefg4YNTkT9qQua9U9AwWlFik+PmounpFD
rlzGO53CcrZx6eoMTDTLrbYl2Klh8V+1c3esD/uIb3V2y2ieS6nt4D4szyLOYWOe
C2aK15Dx6WbNtrp7u3JAKJrhk7135j1L5C9PwlvQ/fZ/979BCvemMIuDe6nmZhYz
eZ69glGwDqCWtJpKX767ivfpylkWKc2hWIdOmxBsa4PQ4KGEjxl62MCGTAxLkHhB
YsBzyIV4h2NLPoMrSZYY8ImndUNEWqvg9g1kZFR2lI9dlosf/A4F+K5v8Le3wLLJ
bkRISLeEX31iWV1/XlQI98V2fLyveNfgpeU+Sy7v8QKBgQDaW7XYr2ig4wYPUh+z
Dh8jYGVg+Mht/Dnfa3ND3zYQwuoGp8p2n2yDroM/PGlU0X9+Vrjz8fQoxLdbpnMG
o2VH5TpTtuCUOh/bzSBuZHWIX83n0V0Ff8M/bLdNHYc07oC6p+7DlVljy8YEvAUc
lfZ2LajSCrrkBluH+V1D1NyP9wKBgQDIfJimT4J0AHc7sfI9Bmv17gxi++qlom+e
KHU9mvU4CMxQZNoQACm/C5a0ilh1DptIDLsfEp0obEkFEAVY6CfOTMe/lNN/iuR+
WMe64gOnOhLd+36IdPkA3aqsO+GGSE2F75hJ0Ll5l3vEUgRVxqe9NbqA7GCDyCCl
JrBy57fwKQKBgGw8C05F3CHrhiRv+6CAfnTFolrH1mmWHYWeODtLV/xE8UWtRBE6
gspe5VWh90AAvCZ+jBz3MKRIpe56+gcvVNOnTxsRyg4PJZ2I9uthRlT70A95WpeQ
NdKpa86AtXVKR2q+NP6jd/ScnCHapNn/h3Qau9SpVuwSLqqes1kdGNsPAoGAG0pi
mRjvoAzELjsNx2LNZV+vDfZOvZc77GKDewxR3vvLnBHuYQk0pY3VSOQgIGcJmigp
fJRTEkKTOf4xTCXl7T4kXp7Kn2zvp4c8QOMtLiFImjD2y2pozsZdyi4oh9flvZqc
t0eTR8roDRRBBNAS2z2qEoyaorWmQ/TdRfbm4ekCgYALU22vbyuPX5AVPdD0vWv4
zLL+l0MMMRviMu1NSa9L95vVdc/C0cGaLEZ7U4x2pd+J54q+DjjIRMn2knrbBZQf
X43ceACVpWiv5DmBtEUrB8dbwxEJFaoPGqEswwdh1FDxzfsPdapyqGI5B8zRjnpa
SR2QEYok/8lZeDgUOhXkGg==
-----END PRIVATE KEY-----

CA file must be in the following format : 

-----BEGIN CERTIFICATE-----
MIIDXTCCAkWgAwIBAgIJAJHydV1v41XIMA0GCSqGSIb3DQEBBQUAMEUxCzAJBgNV
BAYTAkZSMRMwEQYDVQQIDApTb21lLVN0YXRlMSEwHwYDVQQKDBhJbnRlcm5ldCBX
aWRnaXRzIFB0eSBMdGQwHhcNMTUwMTMwMTAyNDU3WhcNMTYwMTMwMTAyNDU3WjBF
MQswCQYDVQQGEwJGUjETMBEGA1UECAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50
ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAqwHssa1A2alSVh8ZZvKffGaix7mSFMDsFjUgPShqbAZ8xGQynvrHPel9
A8E6ml0sGzHDwk8gobpu7k1wuMhcs7Np88xu5GtR1DhZWQ8MUGWHfflyjguMjtzF
pZg4j0M14SE2INwwsRRtvC0/aeV1/q7HqfTk7+y01g/N4OKvYwndNp2lbSjBZZF4
qbL9QD5iesOptxRryJ8tcm47i6hC4LTunz9pgVI13rtlOoqtXjf07ytMydBbzpeR
4joaPAjbPf5ywf+I/n8XFxy6QPC9qAm2H3Gpo/5bb7+9S8AOhYqvWEKNotvyX1E8
aiDLV+LHkL45Xpx47YBty6L8qNuejwIDAQABo1AwTjAdBgNVHQ4EFgQUVQNmpJDO
w5eVB3yjU80NUZSKZlcwHwYDVR0jBBgwFoAUVQNmpJDOw5eVB3yjU80NUZSKZlcw
DAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQUFAAOCAQEAqadjZT7kMXRf5bp14nfI
20m6G/i5aHBo+0v+6lRtmk5wD/D6VsOh+R/HjjDDo68y/WEWXxQbuOYX+HZCABpf
VTA4oLvY4t3gtzt9Q21VtK/l5e3yyxo2JBnsPqc5wmWDlNO8aImF+QrvovkuyTV5
mX6suZgby4eTllmVzBNK/+FMuPlsSPwB8SxEbu04aOIcwbn4LCCZJZEG6INVGSS8
SRg1iER8mu2Jf45JKkMFDqUhCUp/ejM2t686O7olqKtmF53rDSBnzhtabdgTIx3F
RjCb281gwvwSgyFfUgt5TIIq1o/kci2N33zuxaifFVz6DtDxKegoZg73bUMg/OA2
bg==
-----END CERTIFICATE-----

Here is a screenshot of the fields

![tls fields](./figures/tls-plugin.png "tls-fields")

Deployment details
------------------

Configure Horizon to use tls option
Configure apache to use Https connexions, and set certificate files
Restart Apache
Configure Nova with novnc https option
Restart Nova
For HA deployment add horizon tls to haproxy configuration
and restart ha_proxy

Known issues
------------

None.

Release Notes
-------------

**2.0.0**

* migrate plugins from 1.0.0 to 2.0.0 package version

**1.0.0**

* Initial release of the plugin



