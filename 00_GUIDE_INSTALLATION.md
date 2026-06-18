# Guide d'installation — Tout pour démarrer sereinement

> Objectif : installer et **comprendre** ton environnement de travail une bonne fois,
> pour ne plus jamais bloquer sur « comment je lance mon code / mon projet / ma base ».
> Tout est **gratuit**. Pensé pour **Windows**. Suis les sections dans l'ordre.

---

## 0. Vue d'ensemble — quoi installer et dans quel ordre

| # | Outil | Rôle (en une phrase) | Quand |
|---|-------|----------------------|-------|
| 1 | **Python** | Le langage que tu vas écrire | Maintenant |
| 2 | **VS Code** | Ton éditeur principal (= ton atelier) | Maintenant |
| 3 | **Git** | Sauvegarder l'historique de ton code | Maintenant |
| 4 | **Compte GitHub** | Héberger ton code en ligne (ton portfolio) | Maintenant |
| 5 | **PostgreSQL** | La base de données SQL | Maintenant |
| 6 | **DBeaver** | Le logiciel pour écrire tes requêtes SQL | Maintenant |
| 7 | **Java (JDK)** | Pour le survol Java | **Semaine 7 seulement** |

Compte ~1h à 1h30 pour tout installer. Prends ton temps, c'est la fondation.

---

## 1. Les concepts AVANT les clics (5 min de lecture qui t'évitent des heures de galère)

**Éditeur / IDE.** Un *éditeur de code* est un logiciel pour écrire du code (comme Word, mais pour
programmer). Un *IDE* (Integrated Development Environment = environnement de développement intégré)
est un éditeur enrichi : il lance ton code, repère tes erreurs, gère Git, etc. **VS Code** est entre
les deux : léger mais on lui ajoute des *extensions* pour qu'il devienne un IDE complet.

**Le terminal.** C'est la fenêtre où tu tapes des commandes texte (au lieu de cliquer). Sous Windows
il s'appelle **PowerShell**. VS Code en a un intégré (menu *Terminal > New Terminal*). Tu y taperas
des choses comme `python mon_script.py` ou `git commit`. Pas de panique : tu copieras des commandes,
tu n'as rien à inventer.

**Interprété vs compilé.** *Python est interprété* : tu écris, tu lances, ça s'exécute directement,
**aucune compilation**. *Java est compilé* : il faut d'abord le transformer (`javac`) avant de le
lancer (`java`) — mais tu ne touches à ça qu'en Semaine 7. **Le C++ ne fait pas partie de ton
parcours**, oublie-le.

**pip.** C'est le gestionnaire de paquets de Python : la commande qui installe des bibliothèques
(pandas, etc.). Exemple : `pip install pandas`.

**Environnement virtuel (`venv`).** Un dossier isolé qui contient les bibliothèques **d'UN projet**.
Pourquoi ? Pour que le projet A (qui veut pandas v2) n'entre pas en conflit avec le projet B (qui veut
pandas v1). Règle simple : **1 projet = 1 venv**. Tu le crées au début de chaque projet.

```
Sans venv : toutes les libs mélangées sur ton PC  ->  conflits, galères
Avec venv : chaque projet a sa propre boîte de libs ->  propre, reproductible
```

**Git vs GitHub.** *Git* = l'outil sur ton PC qui enregistre l'historique de ton code (comme des
« sauvegardes » nommées). *GitHub* = le site web où tu envoies cet historique pour le stocker en ligne
et le montrer (ton futur portfolio). Le schéma mental :

```
   Ton dossier         git add        Zone de         git commit      Historique
  (tu modifies)  ----------------->   préparation  ------------------> local (sur ton PC)
                                                                            |
                                                                            | git push
                                                                            v
                                                                     GitHub (en ligne)
```

---

## 2. Installer Python

1. Va sur **https://www.python.org/downloads/** → clique sur le gros bouton *Download Python 3.x*.
2. Lance l'installateur. **TRÈS IMPORTANT** : coche la case **« Add python.exe to PATH »** en bas de
   la première fenêtre (sinon le terminal ne trouvera pas Python). Puis *Install Now*.
3. Vérifie : ouvre **PowerShell** (touche Windows, tape « PowerShell », Entrée) et tape :
   ```
   python --version
   pip --version
   ```
   Tu dois voir un numéro de version pour chacun. Si oui : Python est prêt.

> Si `python` n'est pas reconnu : tu as oublié de cocher « Add to PATH ». Désinstalle et recommence
> en cochant la case.

---

## 3. VS Code — ton outil principal

### 3.1 Installer
1. **https://code.visualstudio.com/** → *Download for Windows* → installe (laisse les options par défaut,
   coche « Add to PATH » et « Open with Code » si proposé).

### 3.2 Les extensions à ajouter (c'est ce qui transforme VS Code en IDE)
Dans VS Code, clique sur l'icône **Extensions** (les 4 carrés, à gauche) et installe, une par une, en
tapant leur nom dans la recherche :

- **Python** (éditeur : Microsoft) — exécute ton code Python, gère les venv. *(installe aussi Pylance automatiquement, qui aide à l'autocomplétion)*
- **Jupyter** (Microsoft) — pour ouvrir et exécuter des notebooks `.ipynb` directement dans VS Code
- **SQLTools** (Matheus Teixeira) — pour écrire du SQL depuis VS Code
- **SQLTools PostgreSQL/Cockroach Driver** — le pilote pour connecter SQLTools à PostgreSQL
- *(Semaine 7, plus tard)* **Extension Pack for Java** (Microsoft)
- *(optionnel, confort)* **French Language Pack** si tu veux l'interface en français

### 3.3 « Créer un projet » dans VS Code = ouvrir un DOSSIER
C'est le point qui déroute au début : **dans VS Code, il n'y a pas de bouton « Nouveau projet »**.
Un projet, c'est juste **un dossier**. Le workflow :

1. Menu **File > Open Folder…**
2. Choisis ton dossier de projet (ex : `…/Claude/parcours-data-eng/projet-01-etl`)
3. VS Code affiche à gauche tous les fichiers du dossier : **c'est ton projet**.

Tout ce que tu fais (créer un fichier `.py`, lancer du code, Git) se passe **dans ce dossier ouvert**.

### 3.4 Lancer un script Python (2 façons)
- **Façon simple** : ouvre un fichier `.py`, clique sur le **▶️ en haut à droite** (« Run Python File »).
- **Façon terminal** (celle des pros) : *Terminal > New Terminal*, puis tape `python nom_du_fichier.py`.

### 3.5 Le terminal intégré
*Terminal > New Terminal* (ou raccourci `Ctrl + ù`). Il s'ouvre **déjà placé dans le dossier de ton
projet** — pratique pour lancer `python`, `pip`, `git` sans te déplacer.

### 3.6 Créer ton environnement virtuel pour un projet
Une fois le dossier du projet ouvert, dans le terminal intégré :
```
python -m venv venv          # crée le dossier isolé "venv"
venv\Scripts\activate        # l'active (tu verras (venv) apparaître à gauche)
pip install -r requirements.txt   # installe les libs listées dans le fichier
```
> `requirements.txt` est déjà présent dans chaque dossier projet de ton arborescence.
> Quand `(venv)` est affiché, tu travailles bien dans l'environnement du projet.

### 3.7 Et Jupyter Lab dans tout ça ?
Tu peux le garder pour explorer vite. Mais **VS Code ouvre aussi les notebooks** (grâce à l'extension
Jupyter) : tu auras tes notebooks ET tes scripts au même endroit. Au quotidien, VS Code suffit.

---

## 4. Git + GitHub

### 4.1 Créer ton compte GitHub
1. **https://github.com/** → *Sign up*. Choisis un nom d'utilisateur **propre et pro** (il apparaîtra
   dans l'URL de tes projets, que tu mettras sur ton CV). Plan **gratuit**.

### 4.2 Installer Git
1. **https://git-scm.com/download/win** → l'installateur se télécharge. Laisse **toutes les options
   par défaut** (clique « Next » jusqu'au bout).
2. Vérifie dans PowerShell : `git --version` → un numéro de version doit s'afficher.

### 4.3 Configurer Git (une seule fois)
Dans le terminal, remplace par tes infos (le même email que GitHub) :
```
git config --global user.name "Victor Robalo"
git config --global user.email "victor.robalo2001@gmail.com"
```

### 4.4 Lier VS Code à GitHub
Dans VS Code, clique sur l'icône **compte** (en bas à gauche) → *Sign in with GitHub*. Ça évite de
retaper ton mot de passe à chaque envoi.

### 4.5 Envoyer ton premier projet sur GitHub (le cycle complet)
Ouvre le dossier `parcours-data-eng` dans VS Code, puis dans le terminal :
```
git init                       # transforme le dossier en dépôt Git
git add .                      # prépare TOUS les fichiers (le "." = tout)
git commit -m "Initial commit" # enregistre une "sauvegarde" nommée
```
Ensuite, sur GitHub.com : bouton **New repository**, nomme-le `parcours-data-eng`, **ne coche rien**
(pas de README), *Create*. GitHub t'affiche alors les 2 commandes à copier (elles ressemblent à) :
```
git remote add origin https://github.com/TON-PSEUDO/parcours-data-eng.git
git branch -M main
git push -u origin main        # envoie tout en ligne
```
Rafraîchis la page GitHub : ton code est là. **Bravo, ton portfolio existe.**

> Au quotidien ensuite, le cycle se résume à 3 commandes : `git add .` → `git commit -m "message"` → `git push`.

---

## 5. PostgreSQL + DBeaver (la base de données et son client)

**Pourquoi deux choses ?** *PostgreSQL* = le moteur de base de données (le « entrepôt » qui stocke les
données). *DBeaver* = le logiciel avec lequel tu écris tes requêtes et vois les résultats (le
« tableau de bord »). On a besoin des deux.

### 5.1 Installer PostgreSQL
1. **https://www.postgresql.org/download/windows/** → *Download the installer*.
2. Lance l'installation. Laisse les options par défaut. **NOTE BIEN LE MOT DE PASSE** que tu choisis
   pour l'utilisateur `postgres` — tu en auras besoin pour te connecter. Écris-le quelque part.
3. Le port par défaut est **5432** (laisse tel quel).

### 5.2 Installer DBeaver (ton client SQL — recommandé)
1. **https://dbeaver.io/download/** → *DBeaver Community* (gratuit) → installe.
2. Ouvre DBeaver → bouton **Nouvelle connexion** (prise électrique en haut à gauche) → choisis
   **PostgreSQL** → renseigne :
   - Host : `localhost`
   - Port : `5432`
   - Database : `postgres`
   - Username : `postgres`
   - Password : *(celui noté à l'étape 5.1)*
   → *Test Connection* (DBeaver proposera de télécharger un pilote, accepte) → *Finish*.
3. Tu peux maintenant ouvrir un éditeur SQL (*SQL Editor > New SQL Script*) et écrire tes requêtes.

> Alternative dans VS Code : l'extension **SQLTools** fait la même chose sans quitter l'éditeur.
> Commence avec DBeaver (plus visuel), tu testeras SQLTools plus tard si tu veux tout centraliser.

---

## 6. Java (Semaine 7 SEULEMENT — n'installe pas maintenant)

Quand tu y arriveras :
1. **https://adoptium.net/** → télécharge **Temurin JDK** (JDK = Java Development Kit, gratuit) →
   installe (laisse les options par défaut).
2. Dans VS Code, installe l'extension **Extension Pack for Java**.
3. Le cycle Java (rappel : Java se **compile**) sur un fichier `Hello.java` :
   ```
   javac Hello.java   # compile -> crée Hello.class
   java Hello         # exécute
   ```
   En réalité, l'extension Java de VS Code te met un ▶️ et fait les deux pour toi. C'est juste utile
   de savoir ce qui se passe dessous (ça peut tomber en entretien).

---

## 7. Checklist finale — coche au fur et à mesure

- [ ] Python installé (case « Add to PATH » cochée) — `python --version` fonctionne
- [ ] VS Code installé
- [ ] Extensions VS Code : Python, Jupyter, SQLTools, SQLTools PostgreSQL Driver
- [ ] Git installé — `git --version` fonctionne
- [ ] Git configuré (`user.name` et `user.email`)
- [ ] Compte GitHub créé + connecté dans VS Code
- [ ] `parcours-data-eng` poussé sur GitHub (premier `push` réussi)
- [ ] PostgreSQL installé (**mot de passe noté !**)
- [ ] DBeaver installé et connecté à PostgreSQL (Test Connection OK)
- [ ] *(Semaine 7)* Java JDK + extension Java

---

## 8. Vérification express (à lancer dans un terminal une fois tout installé)

```
python --version      # -> Python 3.x.x
pip --version         # -> pip xx.x
git --version         # -> git version 2.x
```

Si les trois répondent, ton environnement est prêt. Tu peux ouvrir le dossier `projet-01-etl`
dans VS Code et commencer sereinement.

---

### Récap de la logique (à garder en tête)
- **VS Code** = ton atelier : tu y ouvres un **dossier** (= un projet), tu écris, tu lances, tu gères Git.
- **1 projet = 1 dossier = 1 venv.** Tu actives le venv avant de travailler.
- **Git** sauvegarde en local, **GitHub** héberge en ligne. Cycle : `add` → `commit` → `push`.
- **PostgreSQL** stocke les données, **DBeaver** sert à les interroger en SQL.
- **Python** s'exécute sans compilation ; **Java** se compile (Semaine 7) ; **pas de C++**.
