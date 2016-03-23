#!/bin/bash

instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)

cat << EOF > /home/centos/hello.py
#!/usr/bin/python
from BaseHTTPServer import BaseHTTPRequestHandler,HTTPServer

class HelloHandler(BaseHTTPRequestHandler):

	def do_GET(self):
	  if self.path == "/health":
      self.send_response(200)
    else:
		  self.send_response(200)
		  self.send_header('Content-type','text/plain')
		  self.end_headers()
		  self.wfile.write("Message = ${message}, Instance-Id = $${instance_id}")

try:
	server = HTTPServer(('', 80), HelloHandler)
	server.serve_forever()

except KeyboardInterrupt:
	server.socket.close()
EOF

python /home/centos/hello.py &