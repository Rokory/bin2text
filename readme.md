# Atome der digitalen Welt

Dieses kleine Code-Projekt ist inspiriert von Franz Fialas Text und Code auf https://clubcomputer.at/2021/11/24/atome-der-digitalen-welt/

Der Facebook-Account von Mimikama postete auf Facebook kommentarlos folgendes (https://www.facebook.com/mimikama.at/posts/269868261849482

Der Inhalt ist in der Datei raetsel.txt nachzulesen.

Dieses Posting hatte ein großes Echo, fast 1000 Kommentare in einem Tag. Bei einer groben Durchsicht der etwas verunsicherten Kommentatoren fand sich aber kein Interpret dieser Zahlenfolge.

Die Aufgabe besteht nun darin, diese Zahlenfolge lesbar zu machen. Als Sprache wurde PowerShell gewählt.

Die Annahme besteht darin, dass es sich um codierten Text handelt. Jeweils ein Block aus acht 0en und 1en (Oktett) stellt dabei die binäre Codierung eines Zeichens dar.

Die Aufgabenstellung lautet nun, ein Programm zu schreiben, das den Text lesbar macht.

## Lösung 1: Die alte Schule (inspiriert durch den Algorithmus von Franz Fiala)

Mit einer ````for````-Schleife werden die Zeichen in 8er-Blöcken verarbeitet. Bemerkenswert dabei ist, dass eine ````for````-Schleife die Zählervariable nicht immer nur um 1 erhöhen kann, sondern auch um andere Werte, z. B. 8.

Mit der ````Substring````-Methode aus dem .NET-Framework Teilstrings extrahiert werden. Beispiel:

````powershell
$zeile = '01010101011011100111001100100000011101110111'
$p = 8
$oktett = $zeile.Substring($p, 8) # ergibt 01101110
````

Der erste Parameter gibt dabei die Startposition an. Der zweite Parameter gibt die Anzahl der Zeichen an, die ab der Startposition zurückgegeben werden. Wird der zweite Parameter weggelassen, wird der gesamte verbleibenden String zurückgeliefert.

Eine zweite innere ````for````-Schleife verarbeitet dann die einzelnen Zeichen als Bits und bildet mit dem bekannten Algorithmus zur Umwandlung einer Binärzahl in eine Dezimalzahl eine Dezimalzahl.

Auf ein einzelnes Zeichen eines Strings greift man in PowerShell am besten mit

````powershell
$oktett[$i]
````

zu, wobei $i die Position des Zeichens ist. Behandelt man ein Zeichen in Berechnungen wie eine Zahl, so wird der Unicode des Zeichens verwendet. Dazu muss man wissen, dass ````'0'```` den Unicode 48 hat und ````'1'```` den Unicode 49. ````$c - 48```` ergibt also ````0```` oder ````1````, je nachdem, ob ````$c```` vorher ````'0'```` oder ````'1'```` war.

Zuletzt muss die ermittelte Dezimalzahl wieder in ein Zeichen umgewandelt werden. Dies erfolgt am einfachsten durch

````powershell
$zeichen = [char]$dezimalzahl
````

Mit diesen Informationen sollte es auch PowerShell-Einsteigern nicht allzu schwer fallen, die Lösung zu programmieren.

Wer lieber gleich einen Blick auf die Lösung werfen möchte, findet diese in der Datei bin2text.ps1.

Die Lösung hat das Problem, dass Umlaute nicht richtig dargestellt werden. Außerdem werden im modernen Windows Terminal oder in Visual Studio Code bedingt durch die fehlende Decodierung von Unicode als Steuerzeichen interpretiert, was die Anzeige verstümmelt. Im klassischen ````conhost.exe```` von Windows ist die Darstellung mit Ausnahme der Umlaute hingegen korrekt. Wir werden uns diesem Problem in der Lösung 3 widmen.

## Lösung 2: Lassen wir uns durch das .NET-Framework helfen

Die innere Schleife aus Lösung 1, die die Zeichen einzeln in eine Dezimalzahl umwandelt, kann durch einen simplen .NET-Befehl ersetzt werden. Die statische Funktion ````ToInt32```` der Klasse ````convert```` kann einen Text in eine Zahl umwandeln, wobei der zweite Parameter die Basis angibt. ````2```` steht dabei für binär, ````16```` würde für hexadezimal stehen usw. Ein Typ muss in PowerShell wie immer in eckigen Klammern geschreiben werden. Eine statische Methode wird von der Klasse durch zwei Doppelpunkte getrennt. Beispiel:

````powershell
$dezimalzahl = [convert]::ToInt32($oktett, 2)
````

Immerhin spart die Lösung 2 gegenüber Lösung 1 sage und schreibe 3 Zeilen Code (Kopf und Fuß der ````for````-Schleife und die Initialisierung von $zeichen), wie anhand der Datei bin2text2.ps1 leicht nachgeprüft werden kann.

## Lösung 3: Widmen wir uns den Unicode-Zeichen

Da wir es uns nun viel einfacher gemacht und Unmengen an Codezeilen eingespart haben  (3 von 15 Zeilen sind immerhin 20 %, also bitte nicht lachen), können wir uns dem Problem widmen, dass die Umlaute nicht richtig dargestellt werden. Tatsächlich ist der Text in UTF-8 codiert. Eine verständliche Erklärung von UTF-8 findet sich wie so oft in Wikipedia (https://en.wikipedia.org/wiki/UTF-8).

Lösung 3 führt keine neuen Programmiertechniken ein, hat aber einen komplexeren Algorithmus. Nach sorgfältigem Lesen des o. a. Wikipedia-Artikels sollte die Implementierung möglich sein. Wer zu faul ist, selbst nachzudenken, findet die Lösung in der Datei bin2text3.ps1.

Lösung 3 hat 24 Zeilen Code, ist also um 100 % länger als Lösung 2 und aufgrund einiger zweier zusätzlicher Verzweigungen und einer zusätzlichen Schleife um 300 % komplexer, was wieder einmal zeigt, warum Umlaute unter Informatikern so unbeliebt sind. :-)
