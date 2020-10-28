# STI - Chapter 8 : Attacking Access Controls

Qu'est-ce que les contrôles d'accès (access controls) ?

Les contrôles d'accès sont des vérifications effectuées afin de restreindre les accès aux ressources selon les niveaux d'accréditation (vertical) et selon l'identité (horizontal) de l'utilisateur. 

## Vulnérabilités communes



| Type de vulnérabilité                                        | Type d'attaque                                               |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Verticale<br /><br />Utiliser des fonctions de l'application quand notre rôle ne le permet normalement pas | Escalade de privilèges verticale - *vertical privilege esalation*<br /><br />Ex : devenir administrateur quand on est un utilisateur lambda |
| Horizontale<br /><br />Accéder aux ressources d'autres utilisateurs du même niveau | Escalade de privilèges horizontale -*horizontal privilege esalation*<br /><br />Ex : un utilisateur lambda peut lire les emails d'un autre utilisateur lambda |
| Context-dependent<br /><br /> L'accès des utilisateurs est limitée à ce qui est autorisée selon l'état actuel de l'application | Accès hors du flux d'exécution normal - *business logic exploitation*<br /><br />Ex : Accéder à une page de paiement en ligne sans passer par l'étape de calcul des frais de port. <br />Sauter des étapes de vérification normalement obligatoires. |

- escalade de privilèges verticale -> devenir admin quand on est utilisateur lambda

Utiliser des fonctions de l'application quand notre rôle ne le permet normalement pas.

- escalade de privilèges horizontale-> accéder aux ressources d'autres utilisateurs au même niveau

Accéder ou modifier des ressources auxquelles nous n'avons pas droit.

- accès hors du flux d'exécution normal -> accéder à une page de paiement en ligne sans passer par l'étape de calcul des frais de port

Sauter des étapes de vérification normalement obligatoires.

### Fonctionnalités non-protégées

- URL (/admin, p.ex.) : Accéder à l'URL d'administration permet l'accès à l'ensemble des fonctionnalités sans contrôle d'accès supplémentaire
  - Le fait que l'URL ne soit pas affichée n'empêche pas l'attaquant d'y accéder, il va pouvoir la trouver autre part (essayer des URLs habituelles, outils de bruteforce, dans le code source, sur internet, ...)
  - Le fait que l'URL d'accès soit "compliquée" ne va pas empêcher l'attaquant de la découvrir 
- Les URLs peuvent être découvertes de diverses manières : 
  - commentaires dans le code source,
  - affichage à l'écran, 
  - historique des navigateurs, favoris,
  - envoi du lien par e-mail (ou autre outil),
  - logs (clients, serveurs, proxys), 
  - script de génération des menus.

#### Accès direct à l'API

L'API doit être sécurisée de la même manière que les pages standards de modification, car les mêmes risques s'appliquent. 

Les fonctions d'administration de l'API doivent être sécurisées de la même manière que les pages admin et les fonctions pour les utilisateurs doivent être sécurisées de la même manière que les pages utilisateurs.

### Fonctions basées sur les identifiants

Lorsque certaines ressources sont accessibles grâce à des identifiants (IDs) et si les contrôles d'accès sont interrompus, un attaquant peut accéder aux ressources d'autres utilisateurs via ces IDs en essayant de les deviner. 

Si ces IDs sont des UID ou GUID, la sécurité est un peu meilleure (on ne peut pas les deviner) mais ces identifiants ne peuvent être considérés comme secrets, l'application est donc tout de même vulnérable. 

L'application fournit énormément de détails sur les identifiants pour d'autres fonctionnalités. 

### Fonctions en plusieurs étapes

Un bon exemple de processus en plusieurs étapes est le processus de paiement au sein d'une entreprise :

- enregistrement de la facture,
- sélection des comptes débiteurs,
- mise à jour du stock,
- validation du paiement.

Si les contrôles d'accès ne sont pas renouvelés à chaque étape, il sera possible de ne pas respecter l'ordre du déroulement et d'effectuer les étapes 2, 3 et 4 sans passer par la 1 qui fait effectivement les vérifications. (-> bypass la première étape)

En cas de paiement par exemple, il vaut mieux revérifier toutes les informations lors de la dernière étape, il ne suffit pas de transmettre en champs cachés les informations, car elles peuvent être interceptées et modifiées par un attaquant.

### Fichiers statiques (== Fonctions basées sur les identifiants)

Similaire aux accès à des fonctions basées sur les identifiants, simplement les fichiers auxquels on accède sont des fichiers statiques (pdf, rapports, binaires, ...). 

### Mauvaise configuration de la plateforme

Le contrôle d'accès peut être effectué avec Apache en prenant en compte la méthode de requête HTTP, l'URL et le rôle utilisateur. Seuls les utilisateurs du groupe admin ont accès aux URLs /admin pour les méthodes POST et GET. 

Pour bypasser ces contrôles, on peut envoyer des requêtes avec des méthodes HTTP non-filtrées (HEAD ou personnalisé). Ces requêtes seront souvent interprétées comme légales au niveau de la plateforme mais traitées comme des requêtes GET au niveau de l'application.

Méthode HEAD : elle doit retourner les mêmes en-têtes que la méthode GET mais sans le corps. Pour cela, la plupart des plateformes exécutent simplement la requête GET et retournent les en-têtes en supprimant le corps de la réponse.

### Méthodes de contrôles d'accès non sécurisées

#### Basés sur des paramètres

L'information concernant l'utilisateur, le rôle ou le niveau d'accès est transmise via un cookie, un champ masqué ou un paramètre de la requête. Cela n'est pas sécurité car un attaquant peut modifier ces champs et usurper l'identité de l'administrateur. 

#### Basés sur l'en-tête Referer

Ce champ indique depuis quelle page web on accède à une ressource. Il est modifiable par l'utilisateur. Une vérification de flux basée sur l'en-tête Referer est facilement contournable par l'utilisateur. 

#### Basés sur la géolocalisation

Localiser l'adresse IP de l'utilisateur n'est pas suffisant pour déterminer s'il peut accéder à une ressource, il peut utiliser un VPN, un proxy web, un appareil avec données ou manipuler certains mécanismes implémentés du côté client pour modifier la localisation.

## Attaque des contrôles d'accès

### Avec différents comptes

Cela permet d'identifier les URLs auxquelles on peut accéder avec différents types de comptes. Une fois les URLs identifiées, on peut essayer d'y accéder avec un compte moins privilégié. Grâce à cela, nous pouvons identifier les différences entre les comptes standards et les comptes privilégiés.

Burp ou d'autres logiciels comparables peuvent permettre de cartographier un site et identifier toutes les fonctionnalités proposées. -> attaque horizontale

Il ne faut pas compter uniquement sur l'outil pour repérer les contrôles d'accès vulnérables, il faut y appliquer nos connaissances pour déceler des vulnérabilités. 

### Avec des processus en plusieurs étapes

Lors de processus en plusieurs étapes, il faut contrôler chaque étape pour éviter qu'une étape soit vulnérable et qu'elle mette ainsi en péril la sécurité de tout le processus. Par exemple, un envoi de formulaire : il faut générer le formulaire, vérifier la manière dont il est complété, confirmer l'envoi et rediriger l'utilisateur. Chaque étape doit être vérifiée, chaque requête également. 

### Avec un accès limité

Dans une application, il est possible de trouver des fonctionnalités qui ne sont plus utilisées mais qui n'ont pas encore été supprimées ou des fonctionnalités qui ont été déployées mais pas encore publiées. 

Pour chaque fonctionnalité déjà trouvée, il faut vérifier si elle donne accès à un sous-ensemble de documents et qu'il n'est effectivement pas possible d'accéder à l'ensemble des documents du même type (via des identifiants, p-e).

### Avec accès direct aux méthodes

Lorsqu'une application utilise des requêtes qui accèdent aux méthodes de l'API du côté serveur, on peut normalement identifier les vulnérabilités avec la méthodologie décrite précédemment. Cependant il faut tout de même chercher à identifier des APIs qui ne seraient pas correctement protégées, par exemple, en appelant des fonctions spécifiées par l'utilisateur sans vérifier qu'elles sont dans une whitelist. 

### A des ressources statiques

S'il est possible d'accéder à des ressources via des URLs, il faut essayer d'utiliser ces URLs directement avec un compte ne devant pas avoir de droits d'accès.

### Via des restrictions sur les méthodes HTTP

Pour toutes les requêtes identifiées, il faut essayer des les exécuter avec des en-têtes différents (GET, POST, HEAD, en-tête invalide) et si elles réussissent, il faut les réessayer avec utilisateur peu privilégié. 

## Sécuriser les contrôles d'accès

- Ne pas se baser sur l'ignorance des utilisateurs pour les URLs et les identifiants des documents
- Ne pas faire confiance aux paramètres entrés par les utilisateurs
- Ne pas faire confiance aux utilisateurs pour utiliser les fonctionnalités comme elles ont été prévues
- Ne pas faire confiance aux utilisateurs pour ne pas détourner les données transmises par le côté client

Les bonnes pratiques : 

- Evaluer et documenter les contrôles d'accès pour chaque partie de l'application (pour les fonctionnalités et les ressources)
- Toutes les décisions d'autorisation doivent être prises à partir de la session de l'utilisateur
- Utiliser un composant central à l'application pour vérifier tous les contrôles d'accès
- Utiliser ce composant central pour valider toutes les requêtes client
- Utiliser des techniques de programmation pour forcer le contrôle d'accès à être effectué et éviter que le développeur passe outre
- Pour les parties sensibles de l'application, effectuer des contrôles supplémentaires, par exemple basés sur l'adresse IP
- Accès à des fichiers statiques : 
  - Accès indirect en passant un nom de fichier à une page dynamique côté serveur qui va implémenter un contrôle d'accès et retourner le fichier (pas rediriger dessus, car cela ne mettrait en place aucun contrôle)
  - Utiliser l'authentification HTTP et d'autres fonctionnalités du serveur d'application pour contrôler l'authentification (cela risque de faire une vérification différente de celle du composant central, il faut donc s'assurer que cela soit consistant)
- Il ne faut faire confiance qu'aux données provenant du côté serveur, et non du côté client. Il faut revalider les identifiants à chaque transmission de données
- Pour des actions critiques, il faut ré-authentifier l'utilisateur à chaque transaction et utiliser un système d'authentification multi-facteurs
- Logger toutes les actions effectuées quand des données sensibles sont concernées

Bénéfices d'utiliser un composant central à l'application : 

- plus grande clarté des contrôles d'accès
- meilleure maintenabilité (plus efficace et sûr)
- plus adaptable
- moins d'erreurs et d'omissions

### Modèle à privilèges en multi-tiers

Dans le cas d'une application multi-tiers, une bonne approche serait de mettre des contrôles d'accès à chaque niveau. Si les contrôles d'accès d'une couche sont compromis, ceux des autres couches offrent toujours une protection et l'attaquant ne pourra pas aller au bout. En plus de cela : 

- Le serveur de l'application peut contrôler les URLs selon le rôle de l'utilisateur
- L'application peut utiliser un compte de base de données séparés avec des privilèges limités pour chaque type d'utilisateur (privilèges en lecture-seule) et spécifier précisément quelles tables sont accessibles
- Utiliser un compte système avec des privilèges limités pour chaque composant

// tableau -> matrice de droits

Concepts de contrôles d'accès :

- Via des techniques de programmation
  - une matrice de droits est stockée dans la base de données 
  - le programme se charge d'appliquer les contrôles (avec un algorithme aussi complexe que nécessaire)
- A la discrétion de l'administrateur (discretionary access control DAC)
  - l'administrateur peut donner explicitement des privilèges à d'autres utilisateurs pour des ressources auxquelles ils ont accès
  - modèle fermé : white list
  - modèle ouvert : black list
- Basés sur des rôles (role-based access control RBAC)
  - chaque rôle donne accès à certains privilèges, pas trop de rôles, ni trop peu, il faut que cela reste gérable et sécurisé
- Via un composant externe
  - utilisation d'un compte de base de données différents pour les groupes d'utilisateurs afin de limiter leurs droits

