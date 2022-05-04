<#  Script PowerShell
    Titre: Copie par extension
    Description: Permet de recuperer tout les fichiers avec une
                 extension choisie a partir d'un répertoire et de tous ses sous-dossiers
                 et de les copier a un endroit choisi.
    Auteur: Eric Chabot
    Date de création: 2022-04-10
    Version 1.2
    Note de version: Division de Grande fonction en plusieurs petites, ajout de la possibilité de creer
                     Le dossier de destinatiion.
#>

###############################################################################
# Fonctions
Function afficheMenu
    {
    Clear-Host
    write-host "**********************************************************************************"
    Write-Host "*                              Copie par Extension                               *"
    Write-Host "*                                                                                *"
    Write-Host "*                 Permet de recuperer tout les fichiers avec une                 *"
    Write-Host "*    extension choisie a partir d'un repertoire et de tous ses sous-dossiers     *"
    Write-Host "*                     et de les copier a un endroit choisi.                      *"
    Write-Host "*                                                                                *"
    Write-Host "*   Entrez le nom des dossier source et destination selon le format C:\dossier   *"
    Write-Host "*                                                                                *"
    Write-Host "*  1) Recuperer les images: .jpg                                                 *"
    Write-Host "*  2) Recuperer les fichiers: .pdf                                               *"
    Write-Host "*  3) Recuperer les fichiers Word: .doc ou .docx                                 *"
    Write-Host "*  4) Recuperer les fichiers Excel: .xls ou .xlsx                                *"
    Write-Host "*  5) Recuperer les fichiers texte: .txt                                         *"
    Write-Host "*  6) Recuperer les fichiers CSV: .csv                                           *"
    Write-Host "*  7) Recuperer les fichiers avec une extention de votre choix                   *"
    Write-Host "*  8) Quitter                                                                    *"
    Write-Host "*                                                                                *"
    write-host "**********************************************************************************"
    }

Function ecrirePath {
    $Script:path = Read-Host "Entrez le chemin de la sources"
    testPath
}

Function testPath {
    if (-not(Test-Path -Path $path))
        {
        Write-Host "Ce dossier n'existe pas !"
        ecrirePath
        }
    $path = $path + "\*"
    ecrireDestination
}

Function ecrireDestination {
    $Script:destination = Read-Host "Entrez le chemin de la destination"
    testDestination
}

Function testDestination {
    if (-not(Test-Path -Path $destination))
        {
        $creation = Read-Host "Ce dossier n'existe pas, voulez-vous le creer ? Oui (o) ou Non (n)"

        Switch ($creation)
            {
            "o"
                {
                New-Item -Path $destination -ItemType Directory
                copie
                }
            "n"
                {
                ecrireDestination
                }
            default
                {
                Write-Warning "Ce choix n'est pas valide"
                ecrireDestination
                }
            }
        }
    copie
}

Function copie {
    $getArgumentList = @{
        Path    = $path;
        Include = $typeDeFichier;
        Recurse = $True
    }

    $copyArgumentList = @{
        Destination = $destination
    }

    Get-ChildItem @getArgumentList | Copy-Item @copyArgumentList

    Write-Host "Les fichiers ont ete copies."
}


do
{
    Clear-Host

    afficheMenu

    Write-Host "Veuillez faire un choix : " -NoNewline
    $choix = Read-Host

    Switch ($choix)
        {
            "1"
                {
                $typeDeFichier = "*.jpg"
                ecrirePath
                }
            "2"
                {
                $typeDeFichier = "*.pdf"
                ecrirePath
                }
            "3"
                {
                $typeDeFichier = "*.doc", "*.docx"
                ecrirePath
                }
            "4"
                {
                $typeDeFichier = "*.xls", "*.xlsx"
                ecrirePath
                }
            "5"
                {
                $typeDeFichier = "*.txt"
                ecrirePath
                }
            "6"
                {
                $typeDeFichier = "*.csv"
                ecrirePath
                }
            "7"
                {
                $typeDeFichier = Read-Host "Tapez l'extension a rechercher avec le point devant"
                $typeDeFichier = "*" + $typeDeFichier
                ecrirePath
                }
            "8"
                {
                Exit
                }

            default
                {
                Write-Warning "Ce choix n'est pas valide"
                }
        }

    Write-Host ""
    Pause

}While ($true)
