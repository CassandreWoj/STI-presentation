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



- #### Direct Access to Methods

### Identifier-Based Functions

### Multistage Functions

### Static Files

### Platform Misconfiguration

### Insecure Access Control Methods

- Parameter-Based Access Control
- Referer-Based Access Control
- Location-Based Access Control

### Attacking Access Controls

### Testing with Different User Accounts

### Testing Multistage Processes

### Testing with Limited Access

### Testing Direct Access to Methods

### Testing Controls Over Static Resources

### Testing Restrictions on HTTP Methods

- ### Securing Access Controls
- ### A Multilayered Privilege Model