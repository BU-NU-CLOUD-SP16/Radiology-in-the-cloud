import subprocess, os
output = '/home/chris/users/chris/hello_world/4_16_2016_11_52_48-268/0_2016-04-16-11-52-49/_chrisRun_'
input = os.path.normpath('/home/chris/DockerPlayground/mri_info.sh')
output2 = os.path.join(output, 'output2.txt')
print input
print output2
string = subprocess.check_output([input], stderr=subprocess.STDOUT, shell=True)
