rsync -avz -e "ssh -p 80 -o StrictHostKeyChecking=no" --progress /Users/hobochild/Desktop/sshd-sync/src/ root@192.168.1.64:/data/.resin-watch

rsync -avz -e "ssh -p 80 -o \"ProxyCommand nc -X connect -x vpn.resinstaging.io:3128 %h %p\" -o StrictHostKeyChecking=no" --progress /Users/hobochild/Desktop/sshd-sync/src/ root@a777b9bb10b2b31c5cfc780aad0ee2f2089b7c38bb7596b20047efd0eb1494.resin:/data/.resin-watch

rsync -avz --rsh="ssh -p 80 -o \"ProxyCommand nc -X connect -x vpn.resinstaging.io:3128 %h %p\" -o StrictHostKeyChecking=no" --progress /Users/hobochild/Desktop/sshd-sync/src/ root@a777b9bb10b2b31c5cfc780aad0ee2f2089b7c38bb7596b20047efd0eb1494.resin:/data/.resin-watch
