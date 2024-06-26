import sys
import paramiko

def ssh_connect(hostname, username, password, port=22):
    try:
       
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(hostname, port=port, username=username, password=password)
        print(f"Conectat la {hostname}")
        stdin, stdout, stderr = client.exec_command('ls -l')
        output = stdout.read().decode()
        print(f"Outputul comenzii 'ls -l' pe {hostname}:")
        print(output)

    except Exception as e:
        print(f"Eroare la conectarea SSH: {e}")
    finally:
        client.close()
if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Mod de utilizare: python script.py hostname username")
        sys.exit(1)

    hostname = sys.argv[1]
    username = sys.argv[2]
    port = 22 
    password = input(f"Introdu parola pentru utilizatorul {username}: ")

    ssh_connect(hostname, username, password, port)
