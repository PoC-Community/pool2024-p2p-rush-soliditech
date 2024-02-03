#!/usr/bin/python3

import os
import subprocess
import sys

# daemon_name = ["ipfs", "daemon"]
# start_daemon = subprocess.Popen[daemon_name]

directory = "./img_planete/"


files_in_planet = os.listdir(directory)

for name_file in files_in_planet:

    file_metadata = "./output/" + str(int(name_file.split(".")[0]))

    commande_bash = ["ipfs", "add", directory + name_file]

    retour = subprocess.run(commande_bash, capture_output=True, text=True)

    sortie = retour.stdout.strip().split('\n')
    if sortie:
        elements = sortie[-1].split(' ')
        if len(elements) == 3:
            cid = elements[1]

    with open(file_metadata, 'w') as metadata_json:
        metadata_json.write('{\n\t"image": "ipfs://'+ cid + '",\n\t"title": "Title",\n\t"description": "Description"\n}')


# cid the output for the smart contract
        
commande_bash_output = ["ipfs", "add", "-r", "./output/"]

output = subprocess.run(commande_bash_output, capture_output=True, text=True)

end = output.stdout.strip().split('\n')
if end:
    element = end[-1].split(' ')
    cid_output = element[1]
    print("mon cid de sortie", cid_output)
