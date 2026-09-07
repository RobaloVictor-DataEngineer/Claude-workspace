# Guide — générer un CV personnalisé « parfait » à chaque offre

Ce dossier contient une petite machine à CV : ton style reproduit une fois, ton contenu figé une fois,
et un script qui sort un PDF adapté à chaque offre. Objectif : un CV cohérent, sans faute, sans invention,
en 30 secondes — et automatisable plus tard en tâche programmée.

## Les fichiers

- `template.html` — ton design (bandeau navy, 2 colonnes, icônes). **On n'y touche presque jamais.**
- `cv_master.json` — **ton contenu véridique et figé** (expériences, puces, études, langues…).
- `generate_cv.py` — le script qui fabrique le PDF.
- `../generes/` — les CV produits atterrissent ici, un fichier par offre et par date.

## La règle d'or

On part de ton CV **figé**. Par offre, je n'ajuste que **3 choses** :

1. le **titre** sous ton nom (ex. « Data Engineer » → « Data Engineer BigQuery / dbt »),
2. le **paragraphe de présentation** (reformulé avec les mots de l'offre),
3. l'**ordre des blocs de compétences** (mettre en avant ce que l'offre demande).

Je ne modifie **jamais** tes expériences, tes puces, tes chiffres, tes études. **Zéro invention.**
Si une offre demande une compétence que tu n'as pas, on ne la met pas — on met en avant ce qui est vrai et proche.

## Comment me briefer (à chaque offre)

Colle-moi simplement l'offre, ou donne-moi ces infos :

- **Intitulé exact** du poste (ex. « Data Engineer H/F »)
- **Entreprise** (pour nommer le fichier)
- **5 à 8 mots-clés / technos** cités dans l'offre (ex. Snowflake, dbt, Airflow, Python, dashboards…)
- (facultatif) ce que l'offre **valorise** (ex. « fiabilité des données », « pharma », « cloud GCP »)

À partir de ça, je remplis un petit fichier d'offre et je lance la génération. Tu récupères le PDF dans `generes/`.

## Le fichier d'offre (ce que je remplis pour toi)

```json
{
  "entreprise": "Doctolib",
  "intitule": "Data Engineer BigQuery",
  "role": "Data Engineer — BigQuery / dbt",
  "presentation": "Ingénieur en Data Engineering… (reformulé avec les mots de l'offre)",
  "ordre_competences": ["etl", "prog", "bi", "ml"],
  "footer": ""
}
```

Les `id` de compétences disponibles : `prog` (Programmation), `etl` (Data/ETL & bases),
`bi` (Data viz & BI), `ml` (Machine learning & IA).

## Lancer la génération (si tu veux le faire toi-même)

```bash
cd "_generateur_cv"
python3 generate_cv.py                     # CV par défaut (Data Engineer, IdF)
python3 generate_cv.py --offre offre.json  # CV ajusté pour une offre
```

Dépendances (déjà installées côté Claude) : `jinja2`, `weasyprint`.

## Deux choses à finaliser une fois

- **Ta photo** : pour l'instant le rond affiche « VR ». Dépose une photo carrée dans ce dossier
  (ex. `photo.jpg`) et dis-le moi : je renseigne le champ `photo` du master, et elle apparaîtra dans le rond.
- **Vérifier le contenu figé** : relis `cv_master.json` une fois. Tout ce qui y est écrit est repris tel quel.

## En tâche programmée (l'étape d'après)

Quand tu valideras le rendu, on branche ça sur ta **veille d'offres** : à chaque offre pertinente trouvée,
je prépare automatiquement un **brouillon de CV adapté** (+ la lettre de motivation) et je le range dans
`generes/`, avec une courte note « pourquoi ces ajustements ». **Tu relis et tu valides avant d'envoyer** —
jamais d'envoi automatique.
