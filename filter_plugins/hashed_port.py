import hashlib
from ansible.parsing.yaml.objects import AnsibleUnicode

class FilterModule(object):
    def filters(self):
        return {
                'hashed_port': self.hashed_port
                }

    def hashed_port(self, s):
        h = int(hashlib.sha1(s.encode('utf-8')).hexdigest(), 16) % (10 ** 4)
        return h+10000
