## **Onglet Email**
**Cet onglet permet de configurer et d'envoyer des e-mails**. L'interface de l'onglet Email est divisée en deux parties : l'**en-tête** et le **corps/contenu**. 

![Image AxenFlow](Image/018.png)

---

### **En-tête**

![Image AxenFlow](Image/019.png)

Dans l'en-tête, vous pouvez sélectionner le mode d'envoi des e-mails, avec plusieurs options : Relevé de notes, Programme annuel de l'étudiant, Attribution. Ces options déterminent le type de contenu que vous souhaitez envoyer à vos destinataires.

### **Corps / Contenu**
Le corps de l'onglet Email contient plusieurs sections essentielles pour configurer le contenu des e-mails à envoyer.

**1. Le "À"**

Le champ "À" contient le patron d'adresse e-mail à envoyer. Ce champ est automatiquement géré par l'application et n'est pas modifiable.

**2. L'objet du mail**

L'objet de l'e-mail. Il prend en compte éléments dynamiques comme ***[Nom]***, ***[Prénom]*** et ***[Année]***. Ces éléments seront automatiquement remplacés par les véritables valeurs lorsque l'application enverra les e-mails.


**3. Le contenu de l'email**

Le corps de l'email. Il prend en compte éléments dynamiques comme ***[Nom]***, ***[Prénom]***, ***[Année]*** et pour la catégorie Attribution, l'élément ***[Missions]*** sera également intégré dans le contenu de l'email.

![Image AxenFlow](Image/020.png)


**4. Options d'email**

L'option de type de Email vous permet de choisir entre deux formats d'email :

- Texte brut (sans mise en forme)
- Contenu formaté (avec mise en forme)
  ![Image AxenFlow](Image/021.png)

**5. Nom du fichier**
  Le nom du fichier. Il peut inclure des éléments dynamiques comme ***[Nom]***, ***[Prénom]*** et ***[Classe]***.

**6. Format du fichier**
  Choisissez si les fichiers doivent être au format PDF ou XLSX.

**7. Emplacement des fichiers**
  Vous pouvez définir le dossier où les fichiers seront stockés (par défaut, dans le dossier Projet2025 sur le bureau).


**8. Sélection des informations**
  Cette option vous permet de choisir si vous souhaitez inclure toutes les informations ou uniquement le minimum (en excluant les données vides).

  ![Image AxenFlow](Image/022.png)

**9. Mode d'envoi**

Vous avez deux choix pour l'envoi des e-mails :

- ***Envoyer à tous*** : Créer un fichier et envoyer un e-mail à toutes les personnes ayant accès aux informations dans les feuilles de données.
- ***Envoyer aux sélectionnés*** : Créer un fichier et envoyer un e-mail uniquement aux personnes sélectionnées via les cases à cocher présentes sur les différentes pages.

**10. Création de fichier**

Vous pouvez choisir entre deux méthodes pour gérer la création des fichiers :

- ***Manuelle*** : Gérer tous les fichiers manuellement avant de les envoyer.

  ![Image AxenFlow](Image/023.png)

- ***Automatique*** : Créer tous les fichiers automatiquement sans intervention manuelle.

  ![Image AxenFlow](Image/024.png)

**11. Boutons d'Action**

![Image AxenFlow](Image/025.png)

En bas de l'interface, vous trouverez 5 boutons pour gérer vos e-mails et fichiers :

- ***Vider*** : Supprime toutes les informations saisies dans les formulaires.
- ***Importer*** : Permet de préremplir tous les champs depuis un fichier exporté par l'application.
- ***Exporter*** : Permet d'exporter un fichier à remplir pour une utilisation future.
- ***Prévisualiser*** : Permet de visualiser un e-mail de test sans l'envoyer, pour voir à quoi ressemblera l'e-mail final. 

  ![Image AxenFlow](Image/026.png)

- ***Envoyer*** : Crée et envoie les e-mails selon les configurations définies dans les sections précédentes.


### **Barre de progression lors de l'envoi**
Lorsque vous cliquez sur le bouton Envoyer, une barre de progression s'affiche. Cette barre vous permet de suivre en temps réel l'avancement de l'envoi des e-mails et des créations de fichiers. Elle indique clairement les étapes que le programme est en train d'effectuer, vous permettant ainsi de savoir où en est le processus.

![Image AxenFlow](Image/027.png)