## **Onglet Missions**
**Cet onglet permet de gérer les missions**. Lorsque vous cliquez sur le bouton Missions dans le menu à gauche, vous verrez le contenu s'afficher à droite. L'interface de l'onglet Missions est divisée en deux parties : l'**en-tête** et le **corps/contenu**.

![Image AxenFlow](Image\001.png)

---

### **En-tête**

![Image AxenFlow](Image\002.png)

L'en-tête de l'onglet Missions contient plusieurs informations essentielles et options d'interaction avec les données :

- **Le nombre de missions** : Affiche le nombre total de missions actuellement enregistrées dans l'application.
- **Le nombre d'éléments sélectionnés** : Indique combien de missions ont été sélectionnées via les cases à cocher.
- **Les boutons d'action** :

  ***Ajouter*** : Permet d'ajouter une nouvelle mission à la fin de la liste. Comme pour les autres onglets, l'ajout ne modifie que l'application et n'a aucun impact sur les données des feuilles Excel tant qu'elles ne sont pas sauvegardées.

  ![Image AxenFlow](Image\003.png)

  ***Sauvegarder*** : Enregistre toutes les modifications effectuées dans l'application vers les feuilles Excel. Un message de confirmation s'affiche avant l'enregistrement pour éviter toute erreur accidentelle.

  ![Image AxenFlow](Image\004.png)

  ***Supprimer*** : Supprime les missions sélectionnées à l'aide des cases à cocher. La suppression est uniquement appliquée dans l'application tant que le bouton Sauvegarder n'a pas été utilisé. Une fois la sauvegarde effectuée, les suppressions seront appliquées aux feuilles Excel.

  ![Image AxenFlow](Image\005.png)


### **Corps / Contenu**

![Image AxenFlow](Image\006.png)

Le corps de l'onglet Missions présente plusieurs champs pour organiser et afficher les informations des missions assignées aux enseignants et aux élèves.

- **Zones de saisie :**

  ***Case à cocher*** : Chaque mission est accompagnée d'une case permettant de la sélectionner pour des actions comme la suppression.

  ***Abréviation*** : Une abréviation spécifique identifiant l'enseignant.

  ***Nom*** : Nom complet de l'enseignant.

  ***Prénom*** : Prénom de l'enseignant.

  ***Orientation*** : La section où l'enseignant doit effectuer sa mission.

  ***Mission*** : Description ou intitulé de la mission attribuée.

- **Barre de défilement** : Une barre de défilement est disponible sur le côté pour naviguer facilement entre les différentes missions, surtout si la liste est longue.

### **Vérification des données** 

![Image AxenFlow](Image\007.png)

L'application vérifie automatiquement si l'abréviation fait partie de la liste des enseignants. Si elle ne la trouve pas, elle indique "Inconnue" dans le nom et le prénom, en plus de mettre l'abréviation en rouge.


### **Sélection de tous les éléments**

![Image AxenFlow](Image\008.png)

En haut du corps de la page, juste au-dessus du premier élément de la liste, se trouve une case à cocher supplémentaire. Cette case permet de sélectionner ou de désélectionner tous les missions.