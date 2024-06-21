import paramiko
import sys

def connect_ssh(username, hostname):
    try:
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(hostname, username=username)
        command = 'uname -a'
        stdin, stdout, stderr = ssh.exec_command(command)
        print(f"Output from {command} on {hostname}:")
        for line in stdout:
            print(line.strip())
        ssh.close()
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 connectSSH.py <username> <hostname>")
        sys.exit(1)
    
    username = sys.argv[1]
    hostname = sys.argv[2]
    
    connect_ssh(username, hostname)
