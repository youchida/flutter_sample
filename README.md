# Projet Flutter – Mini Jeu

## 👥 Membres du groupe  
- ADEYEMI James
- DJIGBEGNONHOU Bertille
- ADELAKOUN Mastella

## 🎨 Thème choisi  
Fruits  

## 🎮 Description du jeu  
Le joueur doit cliquer sur l’image du fruit demandé parmi une grille de 9 images affichées à l’écran.  
Le jeu propose un système de niveaux progressifs, un score, des vies limitées et une interface moderne avec effets visuels et sonores.

## 🔧 Modifications réalisées  
- Suppression des noms sous les images pour rendre le jeu plus amusant.  
- Ajout d’un **système de niveaux** (30s → 45s → 60s).  
- Mise en place d’un **système de vies** (3 erreurs max par niveau).  
- Sauvegarde du **meilleur score** avec `shared_preferences`.  
- Ajout d’une **progression visuelle par étoiles ⭐.  
- Amélioration du design : dégradés colorés, boutons stylés, trophée doré.  
- Ajout de sons de victoire et de défaite.  

## ⚠️ Difficultés rencontrées  
- Gestion des assets (images et sons) dans `pubspec.yaml`.  
- Problèmes d’indentation YAML au début.  
- Mise en place de la logique pour les vies et la progression des niveaux.  
- Sauvegarde et affichage du high score.  

## 💡 Solutions ou apprentissages  
- Compréhension de la gestion des assets dans Flutter.  
- Utilisation de `Timer` pour gérer le temps restant.  
- Découverte et utilisation de `shared_preferences` pour sauvegarder des données localement.  
- Amélioration des compétences en design Flutter (gradients, widgets stylés).  
- Apprentissage de la structuration du code et de la logique de jeu.  

## 🚀 Améliorations possibles  
- Ajouter une **barre de progression animée** en plus des étoiles.  
- Intégrer un **classement en ligne** pour comparer les scores entre joueurs.  
- Ajouter un **mode hardcore** (temps réduit, fruits qui changent plus vite).  
- Intégrer des **animations de transition** entre les niveaux.  
- Ajouter plus de thèmes (animaux, drapeaux, etc.) pour varier le jeu.  
