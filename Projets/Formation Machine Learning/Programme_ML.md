# Programme — Formation Machine Learning (orientée data engineer)

> Feuille de route **proposée** (à ajuster avec Victor avant de démarrer). Même méthode que le parcours
> data engineer : fiche → exercices, un thème à la fois, mini-projet de synthèse en fin d'étape.
> Objectif : comprendre / entraîner / évaluer un modèle **et** faire le lien ML ↔ data engineering.
> On s'appuie sur ce qui est déjà acquis (Python, pandas).

## Phase 0 — Les fondamentaux (le vocabulaire)
- Qu'est-ce que le ML ? Apprendre à partir de données vs programmer des règles.
- **Supervisé vs non-supervisé** ; **régression** (prédire un nombre) vs **classification** (prédire une catégorie).
- La démarche : jeu d'**entraînement / test** (`train_test_split`), pourquoi on sépare.
- **Sur-apprentissage (overfitting) vs sous-apprentissage** — l'intuition clé.

## Phase 1 — Premier modèle avec scikit-learn
- L'API scikit-learn : `fit` (apprendre) / `predict` (prédire) — toujours la même logique.
- Une **régression linéaire** simple, puis un **classifieur** (k plus proches voisins, ou régression logistique).
- Charger des données (pandas, déjà su) → séparer X (variables) et y (cible) → entraîner → prédire.

## Phase 2 — Évaluer un modèle
- Régression : **MAE, RMSE, R²**. Classification : **accuracy, précision, rappel, F1, matrice de confusion**.
- Pourquoi l'accuracy seule trompe (jeux déséquilibrés).
- **Validation croisée** (cross-validation) : évaluer sans se mentir.

## Phase 3 — Préparer les données (feature engineering)
- Encodage des variables **catégorielles** (One-Hot) ; **normalisation / standardisation** des variables numériques.
- Gestion des valeurs manquantes côté ML (`SimpleImputer`).
- Le **`Pipeline`** scikit-learn + `ColumnTransformer` : enchaîner préparation + modèle proprement (très proche de ta logique ETL).

## Phase 4 — Les modèles qui comptent
- **Arbre de décision**, puis **forêt aléatoire** (Random Forest).
- **Gradient boosting** (XGBoost / LightGBM) — les modèles gagnants sur données tabulaires.
- Régularisation, réglage des hyperparamètres (`GridSearchCV`).

## Phase 5 — Non supervisé (survol)
- **Clustering** (k-means) : regrouper sans étiquettes.
- **Réduction de dimension** (PCA) : l'idée, à quoi ça sert.

## Phase 6 — ML ↔ Data Engineering / MLOps (le lien avec ton métier)
- Comment un **data engineer sert un modèle** : batch scoring vs temps réel.
- **Pipelines de features**, notion de **feature store**, versionner données et modèles.
- Sérialiser un modèle (`joblib`), l'exposer (aperçu d'une API), et où Airflow / Spark rentrent en jeu.

## Phase 7 — Projet ML de portfolio
- Un projet **end-to-end** : un jeu de données réel → préparation → modèle → évaluation → petit rapport,
  documenté sur GitHub. Le pendant ML de ton `projet-01-etl`.

---

*À valider : profondeur souhaitée (survol pour l'entretien vs plus poussé), et rythme. Ensuite on démarre
la Phase 0 comme pour le parcours DE (fiche + exercice).*
