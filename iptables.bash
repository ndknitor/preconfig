# Apply new rules: iptables-restore < /etc/iptables/rules.v4

# Default policy to drop all incoming traffic
-P INPUT DROP
-P FORWARD DROP
-P OUTPUT ACCEPT

# Allow all established connections
-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow localhost
-A INPUT -i lo -j ACCEPT

# Allow specific IPs to access PostgreSQL on port 5432
-A INPUT -p tcp --dport 5432 -s 192.168.1.100 -j ACCEPT
-A INPUT -p tcp --dport 5432 -s 192.168.1.101 -j ACCEPT

# Allow all incoming traffic on MySQL port 3306
-A INPUT -p tcp --dport 3306 -j ACCEPT
