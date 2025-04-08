## **Onglet Notes**
**Cet onglet permet de gérer les notes**. Lorsque vous cliquez sur le bouton Notes dans le menu à gauche, vous verrez le contenu s'afficher à droite. L'interface de l'onglet Notes est divisée en deux parties : l'**en-tête** et le **corps/contenu**.

![Image AxenFlow](Image/009.png)

---

### **En-tête**

![Image AxenFlow](Image/010.png)

L'en-tête de l'onglet Notes contient plusieurs informations essentielles et options d'interaction avec les données :

- **Le nombre de notes enregistrées** : Indique le nombre total d'évaluations enregistrées dans l'application.
- **Le nombre d'éléments sélectionnés** : Affiche le nombre de notes actuellement sélectionnées via les cases à cocher.
- **Les boutons d'action** :

  ***Ajouter*** : Permet d'ajouter une nouvelle note à la fin de la liste. L'ajout ne modifie que l'application et ne touche pas les données des feuilles Excel tant que l'utilisateur ne sauvegarde pas.

  ![Image AxenFlow](Image/011.png)

  ***Sauvegarder*** : Enregistre toutes les modifications effectuées dans l'application vers les feuilles Excel. Une fenêtre de confirmation apparaît pour éviter toute modification accidentelle.

  ![Image AxenFlow](Image/012.png)

  ***Supprimer*** : Supprime les notes sélectionnées à l'aide des cases à cocher. La suppression n'est appliquée que dans l'application tant que le bouton Sauvegarder n'a pas été utilisé. Une fois la sauvegarde effectuée, les suppressions sont appliquées aux feuilles Excel.

  ![Image AxenFlow](Image/013.png)



### **Corps / Contenu**

![Image AxenFlow](Image/014.png)

Le corps de l'onglet Notes présente plusieurs champs permettant de structurer et d'afficher les informations des évaluations.

- **Zones de saisie** :

  ***Case à cocher*** : Chaque ligne de note est accompagnée d'une case permettant de la sélectionner pour des actions comme la suppression.

  ***Matricule*** : Identifiant unique de l'élève concerné.

  ***Nom*** : Nom de l'élève.

  ***Prénom*** : Prénom de l'élève.

  ***Classe*** : Classe de l'élève.

  ***Notes*** : Bouton permettant d'afficher la ligne de notes de l'élève dans la feuille.

  ![Image AxenFlow](Image/015.png)

- **Barre de défilement** : Une barre de défilement permet de naviguer dans la liste des notes lorsque celle-ci devient trop longue pour être affichée en une seule fois.

### **Vérification des données** 

![Image AxenFlow](Image/016.png)

L'application vérifie automatiquement si le matricule fait partie de la liste des élèves. Si elle ne le trouve pas, elle indique "Inconnue" dans le nom et le prénom, en plus de mettre le matricule en rouge.

### **Sélection de tous les éléments**

![Image AxenFlow](Image/017.png)

Une case à cocher située en haut de la liste permet de tout sélectionner ou tout désélectionner en un seul clic.