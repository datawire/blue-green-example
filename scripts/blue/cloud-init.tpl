#!/bin/bash

instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)


cat << EOF > /lib/systemd/system/hello.service
[Unit]
Description=Hello
After=network.target
ConditionPathExists=/home/centos/hello.py

[Service]
ExecStart=/bin/python /home/centos/hello.py
Type=simple
Restart=on-failure
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

cat << EOF > /home/centos/hello.py
#!/usr/bin/python
from BaseHTTPServer import BaseHTTPRequestHandler,HTTPServer

class HelloHandler(BaseHTTPRequestHandler):
  def do_GET(self):
    if self.path == "/health":
      self.send_response(200)
      self.end_headers()
    else:
      self.send_response(200)
      self.send_header('Content-type','text/plain')
      self.end_headers()
      self.wfile.write("Message = I am blue!, Instance-Id = $${instance_id}")

try:
  server = HTTPServer(('', 80), HelloHandler)
  server.serve_forever()

except KeyboardInterrupt:
  server.socket.close()

EOF

systemctl enable hello.service
systemctl start hello.service