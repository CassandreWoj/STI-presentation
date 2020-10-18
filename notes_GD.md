## Introduction

Le mécanisme de sécurité des accès de contrôles sont basé sur l'authentification et la gestion de session. Lors que ce mécanisme est défectueux, un attaquant peut compromettre l'ensemble de l'application, prendre le contrôle des fonctionnalités administrateurs et avoir accès à des données sensible. 

Une des raisons de leur faiblesse est que les contrôles d'accès ont besoin d'être effectués pour chaque request/opération d'un utilisateur. La conception est réalisé par un humain et ne peut être résolue grâce à la technologie.

Les vulnérabilités des accès de contrôles permettent d'effectuer des actions qu'on ne devrait pas pouvoir faire et ainsi permettre d'avoir accès à des donnes protégées.



### Common Vulnerabilities

Le contrôle d'accès peut être divisé en trois catégories : `vertical`, `horizontal` et `context-dependent`. 

###### *Vertical*

Cette catégorie permet à différent types d'utilisateurs d'avoir accès à plusieurs fonctionnalités de l'application. 

Exemple : 

- cas simple : division entre utilisateurs lambda et administrateur
- cas complexe : implique des rôles d'utilisateurs qui permettent l'accès à des fonctionnalités spécifiques. Chaque utilisateur reçoit un rôle ou une combinaison de rôles différents.

###### *Horizontal*

Les contrôles d'accès horizontaux permettent aux utilisateurs d'accéder à une gamme de ressources du même type.

Exemple :

- une application de messagerie Web permet  uniquement de lire les emails, envoyer des mails
- une banque en ligne peut nous autoriser de transférer de l'argent

###### *Context*-dependent

Cette troisième catégorie assure que l'accès des utilisateurs est limitée à ce qui est autorisé selon l'état actuel de application.

Exemple :

*Si un utilisateur suit plusieurs étapes d'un processus, des contrôles d'accès dépendent du contexte et peuvent empêcher l'utilisateur d'accéder aux étapes dans l'ordre indiqué.*



Dans plusieurs cas, les catégories `verticale` et `horizontale` sont étroitement liées. 

*Exemple* : dans le cadre d'une application qui gère les factures fournisseurs, un responsable aura potentiellement plus de droit qu'un simple employé. Les deux peuvent payer des factures d'un montant < 10'000 CHF alors que le responsable peut payer des factures > 10'000 CHF. Ainsi un directeur financier pourrait consulter les paiements réalisés mais pas effectuer les paiements.



**Catégorie d'attaque** - On estime qu'un système de contrôle d'accès est défectueux si un utilisateur peut accéder à des fonctionnalités ou des ressources pour lesquelles il n'est pas autorisé. Il existe trois types d'attaques contre ces systèmes correspondant aux trois types de contrôles : `vertical privilege escalation`, `horizontal privilege escalation` et `business logic exploitation`. 

###### *vertical privilege escalation*

Cette catégorie se produit lorsqu'un utilisateur peut exécuter des fonctions que son rôle ne lui permet pas. 

*Par exemple :* *un utilisateur ordinaire peut effectuer des tâches administratives ou l'employé peut effectué des paiements de > 10'000 CHF comme le responsable.*

###### *horizontal privilege escalation*

L'escalade de privilège se produit quand un utilisateur peut afficher/modifier les ressources auxquelles il n'a pas droit. 

*Par exemple : utiliser une application de messagerie web pour lire les emails d'autres personnes.* 

###### *business logic exploitation*

L'exploitation de la logique métier se produit lorsqu'un utilisateur peut exploiter une faille dans la machine à état de l'application pour accéder à une ressource clé. 

*Par exemple : un utilisateur peut contourner l'étape du paiement lors de la séquence de paiement d'un achat en ligne.*



Il est commun qu'une vulnérabilité l'élévation de privilège horizontale mène immédiatement à une attaque élévation de privilège verticale. 

*Par exemple : un utilisateur trouve un moyen de définir le mot de passe d'un autre utilisateur. Il peut attaquer un compte administrateur et prendre le contrôle de l'application.*



### Completely Unprotected Functionality

Dans beaucoup de cas, il suffit de connaître l'url précis pour accéder aux fonctionnalités et ressources sensibles. Le contrôle d'accès est effectué comme suit : lorsqu'un utilisateur connecté en tant qu'administrateur voit le lien alors qu'un utilisateur lambda ne le voit pas. C'est donc une différence de design qui "protège". 

*Par exemple : http://monsite_tropsecure.com/admin* ou *http://site.com/choix/secure/4323/DoAdminMenu.jsp*

Les "protections" reposent sur l'hypothèse qu'un attaquant ne connaîtra/découvrira pas l'URL. Potentiellement plus "compliqué" pour un étranger car il y a la barrière de la langue. Parfois, il est possible de retrouver ces URLs cachées à l'aide du code côté client grâce à du JS ou de commentaire HTML.

``````js
#Exemple JS
var isAdmin = false;
...
if (isAdmin)
{
adminMenu.addItem(“/menus/secure/ff457/addNewPortalUser2.jsp”,
“create a new user”);
}
``````

#### Direct Access to Methods

utilise API - souvent exposé par interface Java. Possible quand côté serveur est déplacé dans une extension navigateur ....



### Identifier-Based Functions

une fonction est utilisée pour avoir accès à une ressource spécifique, on utilise en général un identifiant de la ressource transmise au serveur dans un paramètre de requête URL ou dans un POST request. 

*Par exemple : Le lien suivant permet d'afficher le document appartenant à un utilisateur (visible sur sa page uniquement) https://onPasseParUnGet.php/ViewDocument.php?docid=1280149120*. Ainsi tous les utilisateur se servant de ce lien peuvent l'afficher. 

L'attaquant doit donc connaitre le chemin + l'ID. L'ID peut être généré aléatoirement ou avec GUID mais reste facilement trouvable. -> utilisation des journaux d'accès = mine d'or



### Multistage Functions

Certains types de fonctions sont implémentés sur plusieurs étapes. Le contrôle d'accès s'effectue sur la première étape => on check s'il peut effectuer l'action mais si on bypass la première on peut effectuer l'action car on ne vérifie plus aux étapes d'après si on a le droit. = l'utilisateur lambda pourrait ajouter un compte admin et ainsi avoir contrôle total.

*Par exemple : l'applications vérifie que le compte source sélectionné pour le transfert = utilisateur actuel, puis demande info sur le transfert (dest + montant). Si user intercepte la demande POST finale du process, il peut effectuer une attaque d'escalade de privilège horizontale et de transférer des fonds depuis un compte d'un autre utilisateur.*



### Static Files

Lorsque les utilisateurs accèdent à des fonctionnalités et ressources protégées avec des requêtes vers des pages dynamiques, sur chaque page = contrôle accès approprié et confirmation des privilèges de l'utilisateur pour effectuer l'action.

Souvent lorsqu'on utilise des ressources static => pas de contrôle d'accès qui vérifie les privilèges requis. Suffit connaître le schéma de l'URL.



### Platform Misconfiguration

Utilisation du contrôles aux niveau serveur Web ou application platform layer pour le contrôle d'accès. Acccéder aux chemins (URL) spécifique est restreint en fonction du rôle de l'utilisateur dans l'appli. 

Exemple : chemin /admin => uniquement pour user qui font parti du groupe administrateurs.

Mais si erreur dans la configuration des contrôles => accès non autorisé. LLa configuration prend la forme de règles (similaire à un pare-feu) qui autorisent/refusent l'accès  à : `HTTP request method`, `URL path` et `User role`.

Si on configure mal, on pourrait bloquer le POST au lieu d'autoriser uniquement celui là (qui est vérifié) et ainsi un attaquant peut passer par un GET (selon les API utilisé) et ainsi effectué une request alors qu'il n'y est pas autorisé de base.

-> utilisation de HEAD

***HEAD peut être pas mal pour une démo***



### Insecure Access Control Methods

##### Parameter-Based Access Control

L'application détermine le rôle/niveau d'accès de l'utilisateur lors de sa connexion. Transmis via champ forme masquée/cookie ou param prédéfini. Utilise ce paramètre pour décidé l'accès ou non. 

*Par exemple : un administrateur une fois co verra - https://wahh-app.com/login/home.jsp?admin=true alors qu'un utilisateur lambda verra - https://wahh-app.com/login/home.jsp*

Tous les users qui connaissent le paramètre peuvent accéder à des fonctions admin.

##### Referer-Based Access Control

Utilisation de l'entête HTTP Referer comme base pour prendre les décisions de contrôle d'accès. 

Par exemple : On vérifie que l'utilisateur a effectué une action depuis une page précise (page nécessite un "privilège requis" pour y avoir accès) et donc on ne vérifie pas que l'utilisateur ait vraiment les droits pour l'effectuer. Cassable car l'entête Referer est côté client = modifiable par l'utilisateur.

##### Location-Based Access Control

Bloque accès selon l'emplacement géographique de l'utilisateur. Par exemple avec IP. Contrôle facile à contourner car :

- Utilisation proxy web basé sur l'emplacement requis

- Utilisation d'un VPN 

- Utilisation d'un appareil mobile prenant en charge le data roaming

- Manipulation des mécanismes côté client pour la géolocalisation

  

### Attacking Access Controls

Hack steps

1. les fonctions application donnent-elles accès aux utilisateurs individuels un sous-ensemble de données ?
2. Y a-t-il différents niveaux d'utilisateurs qui ont différentes fonctions? (Admin/lambda/gestionnaire/...)
3. Les administrateurs utilisent-ils des fonctionnalités intégrées à la même application pour la configurer/la surveiller. 
4. Quelles fonctions/ressources de données au sein de l'application avez-vous identifiées qui permettraient d'augmenter les privilèges actuels ?
5. Existe-il des identifiants (param URL / POST) qui signalent qu'un paramètre est utilisé pour suivre le niveau d'accès.

#### Testing with Different User Accounts

Tester efficacité avec plusieurs compte. On peut donc facilement voir si les ressources/fonctionnalités peuvent être accédées illégalement.

Hack steps 

1. Utiliser compte avec le + de privilèges (pour déterminer toutes les fonctionnalités) puis prendre des comptes avec moins de droits pour verticcal privilege escalation.
2. ..... tester si horizontal privilege escalation est possible ?

#### Testing Multistage Processes

#### Testing with Limited Access

#### Testing Direct Access to Methods

#### Testing Controls Over Static Resources

#### Testing Restrictions on HTTP Methods

- ### Securing Access Controls
- ### A Multilayered Privilege Model