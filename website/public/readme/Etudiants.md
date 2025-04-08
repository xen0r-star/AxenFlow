## **Onglet Eleves**
Lorsque vous cliquez sur le bouton Eleves dans le menu à gauche, vous verrez le contenu s'afficher à droite. L'interface de l'onglet Eleves est divisée en deux parties : **l'en-tête** et le **corps/contenu**.

![Image AxenFlow](Image/050.png)


---

### **En-tête**
![Image AxenFlow](Image/051.png)

L'en-tête de l'onglet Élèves contient plusieurs informations essentielles et options d'interaction avec les données :

- **Le nombre d'élèves** : Affiche le nombre total d'élèves actuellement enregistrés dans l'application.
- **Le nombre d'éléments sélectionnés** : Indique combien d'élèves ont été sélectionnés via les cases à cocher.
- **Les boutons d'action** :

  ***Ajouter*** : Permet d'ajouter un nouvel élève à la fin de la liste des élèves. L'ajout ne modifie que l'application et n'impacte pas les données dans les feuilles Excel, ce qui permet de tester sans modifier la base de données réelle.

  ![Image AxenFlow](Image/052.png)


  ***Sauvegarder*** : Ce bouton permet d'enregistrer toutes les modifications effectuées dans l'application vers les feuilles Excel. Un message de confirmation apparaît avant d'effectuer les changements, afin de vous assurer que vous souhaitez bien enregistrer les données.

  ![Image AxenFlow](Image/053.png)


  ***Supprimer*** : Permet de supprimer les données sélectionnées dans l'application. Pour ce faire, vous devez cocher les cases correspondantes aux éléments à supprimer. Notez que la suppression ne se fait que dans l'application, tant que vous n'avez pas cliqué sur le bouton Sauvegarder. Une fois la sauvegarde effectuée, les suppressions seront appliquées dans les feuilles Excel.

  ![Image AxenFlow](Image/054.png)


### **Corps / Contenu**
![Image AxenFlow](Image/029.png)

Le corps de l'onglet Élèves présente plusieurs zones de saisie et d'interaction avec les informations des élèves.

- **Zones de saisie** :

  ***Case à cocher***: Chaque élève est accompagné d'une case à cocher permettant de sélectionner ou désélectionner un élève pour des actions comme la suppression ou l'envoi d'email.

  ***Matricule*** : Le matricule de l'élève.

  ***Nom*** : Le nom de l'élève.

  ***Prénom*** : Le prénom de l'élève.

  ***Orientation*** : L'orientation ou la filière de l'élève.

  ***Email*** : L'email de l'élève, sous le format attendu : [matricular@student.helha.be](mailto:matricule@student.helha.be).

- **Barre de défilement** : Une barre de défilement est présente sur le côté pour permettre de faire défiler les différents élèves et consulter les données.

### **Vérification des données** 

![Image AxenFlow](Image/030.png)

L'application vérifie automatiquement la validité des informations saisies dans les champs de matricule et email :

- **Matricule** : Le matricule doit commencer par "LA" suivi de six chiffres. Si cette règle n'est pas respectée, le texte devient rouge pour vous alerter.
- **Email** : L'email doit suivre le format [matricular@student.helha.be](mailto:matricule@student.helha.be). Si l'email n'est pas conforme, il sera également mis en rouge.


### **Sélection de tous les éléments**

![Image AxenFlow](Image/031.png)

En haut du corps de la page, juste au-dessus du premier élément de la liste, se trouve une case à cocher supplémentaire. Cette case permet de sélectionner ou de désélectionner tous les élèves présents dans la liste d'un seul coup.