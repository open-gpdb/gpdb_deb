## python-idna

python-idna build for python2 + jammy

## Sources

v2.6 https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz
v3.4 https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz

## Patch history

1. CVE-2024-3651.patch extracted from 2.6-1ubuntu0.1~esm1 (bionic)
   
   looks like backported from v3.3.x Debian patch https://sources.debian.org/patches/python-idna/3.3-1+deb12u1/

   addresses `USN-6780-1` aka `CVE-2024-3651`
