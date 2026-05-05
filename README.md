# Script de migration Office 2019 → Office 2024

Script PowerShell permettant d'**automatiser la migration de Microsoft Office 2019 vers Office 2024**, en désinstallant proprement l'ancienne version puis en installant la nouvelle à partir d'un package ZIP fourni.

Le script utilise :
- L'outil de déploiement **Office Deployment Tool** (`setup.exe`) embarqué dans le ZIP
- Un fichier de configuration XML pour l'**installation** (`configuration.xml`)
- Un fichier de configuration XML pour la **désinstallation** (`remove.xml`)

---

## ✨ Fonctionnalités

- Vérification des droits administrateur à l'exécution
- Vérification de la présence du package ZIP requis
- Détection automatique d'une installation existante d'Office 2019
- Désinstallation propre d'Office 2019 via `setup.exe /configure remove.xml`
- Installation d'Office 2024 via `setup.exe /configure configuration.xml`
- Vérification post-installation (présence du dossier `Office16`)
- Nettoyage automatique des fichiers temporaires après chaque opération

---

## 🖥️ Déroulement

Le script suit 3 étapes principales :

- **Vérifications préalables**
  Contrôle les droits administrateur et la présence du fichier `Offices.zip`

- **Désinstallation d'Office 2019** *(si détecté)*
  Extrait le ZIP, exécute `setup.exe` avec la configuration de suppression, puis vérifie que l'ancienne version a bien été retirée

- **Installation d'Office 2024**
  Extrait le ZIP, exécute `setup.exe` avec la configuration d'installation, vérifie le succès puis nettoie les fichiers temporaires

---

## 🚀 Utilisation

### 1. Préparer le package

Placer le fichier `Offices.zip` dans le **même dossier** que le script. Le ZIP doit contenir un dossier `Offices/` avec les fichiers nécessaires (voir section Structure).

---

### 2. Lancer le script

⚠️ **Le script doit être exécuté en tant qu'administrateur**

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Install_Office2024.ps1
```

Sans les droits administrateur, le script s'arrêtera immédiatement.

---

### 3. Résultats possibles

| Code de sortie | Signification |
|:-:|---|
| `0` | Succès — Office 2024 est installé correctement |
| `1` | Échec — ZIP introuvable, droits insuffisants, désinstallation échouée ou installation échouée |

---

## ⚠️ Prérequis

- Windows 10 ou Windows 11
- Droits administrateur
- Fichier `Offices.zip` présent à côté du script, contenant :
  - `setup.exe` (Office Deployment Tool)
  - `configuration.xml` (configuration d'installation Office 2024)
  - `remove.xml` (configuration de désinstallation Office 2019)

---

## 📂 Structure du projet

```
.
├── Install_Office2024.ps1
└── Offices.zip
    └── Offices/
        ├── setup.exe
        ├── configuration.xml
        └── remove.xml
```

Les fichiers temporaires sont extraits dans `%TEMP%\Office2024` (installation) et `%TEMP%\Office2019Uninstall` (désinstallation), puis supprimés automatiquement.

---

## 🔐 Sécurité & avertissements

⚠️ Ce script **désinstalle Microsoft Office 2019** avant d'installer Office 2024.

- Les données non sauvegardées dans les applications Office seront perdues
- Les profils Outlook ou configurations spécifiques peuvent nécessiter une reconfiguration
- Vérifier que le contenu du ZIP provient d'une source fiable avant exécution

L'utilisation se fait **à vos propres risques**.

---

## 🧠 Détails techniques

- Script PowerShell 5.1+
- Extraction ZIP via `Expand-Archive`
- Installation/désinstallation via Office Deployment Tool (`setup.exe /configure`)
- Vérification d'installation basée sur la présence de `C:\Program Files\Microsoft Office\root\Office16`
- Nettoyage systématique des dossiers temporaires (avec vérification de suppression)
- Détection du chemin du script via `$MyInvocation.MyCommand.Path`

---

## 📜 Licence

Projet fourni **tel quel**, sans garantie.

Utilisation libre à des fins personnelles ou éducatives.

---

## 🧨 Disclaimer

Ce logiciel modifie l'installation de Microsoft Office sur le poste.

L'auteur ne pourra être tenu responsable :
- d'une perte de données ou de configuration Office
- d'une désinstallation incomplète
- d'un dysfonctionnement après migration