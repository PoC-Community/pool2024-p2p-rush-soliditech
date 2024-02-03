#!/usr/bin/python3

import os
import subprocess
import re

directory_image = "./img_planete/"
directory_metadata = "./output/"
file_detail = "./value.txt"

print("start the deploiment")
# ouvre le fichier qui contient le titre et la descritpion

with open (file_detail, 'r') as fichier:
    lignes = fichier.readlines()
pos = 0

# ouvre le dossier d'image de planète et le parcours
files_in_planet = os.listdir(directory_image)

for name_file in files_in_planet:
    file_metadata = directory_metadata + str(int(name_file.split(".")[0]))
    commande_bash = ["pinata-cli", "-u", directory_image + name_file] # lance une commande bash qui envoie l'image en ipfs

    retour = subprocess.run(commande_bash, capture_output=True, text=True)
    verif_cid = re.search(r"IpfsHash: '([^']+)'", retour.stdout) #récupère le cid de l'image 
    cid = verif_cid.group(1)

# récupère les donnée du filr_detail
    Title, description = lignes[pos].strip().split(',', 1)  
    pos += 1

# créer un fichier métadata de l'image avec son cid, titre et description
    with open(file_metadata, 'w') as metadata_json:
        metadata_json.write('{{\n\t"image": "ipfs://{0}",\n\t"title": "{1}",\n\t"description": "{2}"\n}}'.format(cid, Title, description.strip()))
    print('\t' + name_file, "added to ipfs !")

print("end of the deploiment")

# envoie le fichier output en ipfs sur la blockchain
# il contient tout les fichiers metadata des images envoyée
commande_bash_output = ["pinata-cli", "-u", "./output/"]
output = subprocess.run(commande_bash_output, capture_output=True, text=True)
verif_cid_output = re.search(r"IpfsHash: '([^']+)'", output.stdout)
output_cid = verif_cid_output.group(1)

# pour vérifier que tout est bon taper dans votre barre de recherche :
print("lien du déploiment sur l'ipfs :", "https://ipfs.io/ipfs/"+ output_cid)

