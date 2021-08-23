# ScriptFireWallBash
Moulinette bash firewall Linux

C'est une groosse moulinette qui avec ipTables, permet de filtrer des IP par pays ( via la site web ipdeny.com).
Vous avez la possibilité de block / unblock et recuperer les IP bloqued par pays.


Utilisation:
git clone 
cd ScriptFireWallBash
chmod +x live.sh
{ avec une simple IP}
./live.sh block 192.168.x.x
ou alors 
./live.sh unblock 192.168.x.x

{ avec un CIDR }
./live.sh block 192.168.0.0/16

{ avec un pays }
./live block country de

