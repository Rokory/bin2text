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
    #region Verarbeitung

    # Wir verarbeiten die Bits jeder Zeile in 8er-Blöchen
    for ($p = 0; $p -lt $zeile.Length; $p += 8) {
        #region Initialisierung

        # $dezimalzahl soll den Zahlenwert der Binärzahl enthalten und ist zunächst 0
        $dezimalzahl = 0

        #endregion

        #region Eingabe

        # Wir nehmen die nächsten 8 Zeichen ab $p
        $oktett = $zeile.Substring($p, 8)

        #endregion Eingabe

        #region Verarbeitung
        
        # 8 Zeichen der Zeile werden gelesen, beginnend bei der höchsten Stelle
        for ($i = 0; $i -lt 8; $i++) {
            
            <# 
                $oktett[$i] ist die i-te Stelle und kann entweder "0" (= 
                ASCII-48) oder "1" (= ASCII-49) sein. Zieht man 48 ab, erhält
                man 0 oder 1. Man zählt diesen Wert zu $dezimalzahl und verdoppelt vorher 
                $dezimalzahl. Der Grund für diese Verdoppelung ist, dass jede Stelle den 
                doppelten Wert der jeweils nächsten hat. Nach der 8. 
                Wiederholung wurde also ein 1er an der ersten Stelle mit 2 ^ 7 =
                128 multipliziert.
            #>
            $dezimalzahl = $dezimalzahl * 2 + ($oktett[$i] - 48)
        }
        
        <# 
            Damit die Zahl als Zeichen ausgegeben wird, muss man sie vorher in 
            ein Zeichen umwandeln
        #>
        $zeichen = [char]$dezimalzahl

        #endregion Verarbeitung

        #region Ausgabe

        $nachricht += $zeichen

        #endregion Ausgabe
    }
}

#endregion Verarbeitung

#region Ausgabe

Clear-Host
Write-Host $nachricht

#endregion Ausgabe