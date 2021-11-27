# Decodiere eine binär als 0 und 1 codierte Textdatei.

#region Initialisierung

$eingabedateiPfad = '.\raetsel.txt'

# In dieser Variable werden wir das Ergebnis speichern
$nachricht = ''

#endregion Initialisierung

#region Eingabe

$eingabeText = Get-Content -Path $eingabedateiPfad

#endregion eingabe

#region Verarbeitung

<#
    Die Zeilen der Eingabedatei werden in einem Array von Strings gespeichert.
    Wir gehen die Elemente des Arrays mit foreach durch, um jede Zeile zu
    verarbeiten.
#>
foreach ($zeile in $eingabeText) {

    # Verarbeite die Zeichen 0 und 1 in 8er-Blöcken
    for ($p = 0; $p -lt $zeile.Length; $p += 8) {
        #region Eingabe

        # Extrahiere einen 8er-Block
        $oktett = $zeile.Substring($p, 8)

        #endregion Eingabe

        #region Verarbeitung
            
        <#
            Jetzt konvertieren wir die binäre Repräsentation unseres
            Zeichens in eine Dezimalzahl. Dabei hilft uns das
            .NET-Framework.
        #>

        $dezimalzahl = [convert]::ToInt32($oktett, 2)

        # Eine Zahl kann direkt in ein Zeichen konvertiert werden

        $zeichen = [char] $dezimalzahl
        
        #endregion Verarbeitung

        #region Ausgabe

        # Nun hängen wir das ermittelte Zeichen an unsere Nachricht an

        $nachricht += $zeichen

        #endregion Ausgabe

    }
}

#region Ausgabe

Clear-Host
Write-Host $nachricht

#endregion Ausgabe