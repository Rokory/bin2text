
<#
    Decodiere eine binär als 0 und 1 codierte Textdatei. Der Text ist als UTF-8
    codiert. Für Details zu UTF-8 siehe z. B. 
    https://en.wikipedia.org/wiki/UTF-8
#>

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
    for ($i = 0; $i -lt $zeile.Length; $i += 8) {
        #region Initialisierung
        
        $zeichen = ''

        #endregion Initialisierung

        #region Eingabe

        # Extrahiere einen 8er-Block
        $oktett = $zeile.Substring($i, 8)

        #endregion Eingabe

        #region Verarbeitung

        <#
            In UTF-8 kann jedes Zeichen 1 - 4 Oktette lang sein. Wenn ein
            Zeichen aus mehr als einem Oktett besteht, beginnen die
            nachfolgenden Oktette mit binär 10. Diese müssen hier übersprungen
            werden.
        #>
        if ($oktett.Substring(0, 2) -ne '10') {
            <#
                Die Anzahl der Oktette, aus denen ein Zeichen besteht wird durch
                die höchst signifikanten (linken) Bits definiert. Diese werden
                immer durch ein 0-Bit terminiert. Sind die zwei linken Bits
                gesetzt, besteht das Zeichen aus 2 Oktetten, bei 3 Bits aus 3,
                usw.

                Um die Anzahl der Oktette zu ermitteln, suchen wir ab der 
                aktuellen Position $i nach der nächsten 0. Da die Positionen
                immer bei 0 zu zählen beginnen, definiert die Position der 0 die
                Anzahl der Oktette.
            #>
            $anzahlOktette = $zeile.Substring($i).IndexOf('0')
            <#
                Vom ersten Oktett müssen nun die Bits bis zum ersten 0-Bit
                entfernt werden. Wir speichern die binäre Repräsentation des
                Zeichens nun laufend in der Variable $binaer
            #>
            $binaer = $zeile.Substring(
                $i + $anzahlOktette + 1,
                8 - $anzahlOktette - 1
            )

            <#
                Es gibt den Sonderfall der ersten 127 Zeichen. Bei diesen ist
                schon das erste Bit 0 (ASCII-Kompatibilität). Bei diesen Zeichen
                wird die nachfolgende for-Schleife nicht ausgeführt.
                In allen anderen Fällen durchlaufen wir nun die nachfolgenden
                Oktette. Ausnahmsweise beginnen wir mit 1 zu zählen, um uns das
                laufende Addieren von 1 zu ersparen
            #>
            
            for ($z = 1; $z -lt $anzahlOktette; $z++) {

                #region Initialisierung

                $binaerTeil = ''

                #endregion Initialisierung

                #region Eingabe

                # Extrahiere den nächsten 8er-Block
                $oktett = $zeile.Substring($i + $z * 8, 8)

                #endregion Eingabe

                #region Verarbeitung

                <# 
                    Überprüfe, ob die ersten zwei Bits 10 sind. Das kennzeichnet
                    ein Fortsetzungsoktett. Das sollte immer der Fall sein, aber
                    Vorsicht ist die Mutter der Porzellankiste. :-)
                #>
                if ($oktett.Substring(0, 2) -eq '10') {
                    <#
                        Die ersten zwei Bits des Oktetts lassen wir fallen, weil
                        diese ja nur das Kennzeichen für die Fortsetzung sind.
                    #>
                    $binaerTeil =  $oktett.Substring(2, 6)
                }

                #endregion Verarbeitung

                #region Ausgabe

                <#
                    Nun erweitern wird die binäre Repräsentation unseres
                    Zeichens um die Forsetzungsbits.
                #>

                $binaer += $binaerTeil

                #endregion Ausgabe
            }
            
            <#
                Jetzt konvertieren wir die binäre Repräsentation unseres
                Zeichens in eine Dezimalzahl. Dabei hilft uns das
                .NET-Framework.
            #>

            $dezimalzahl = [convert]::ToInt32($binaer, 2)

            # Eine Zahl kann direkt in ein Zeichen konvertiert werden

            $zeichen = [char] $dezimalzahl
        }
        
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