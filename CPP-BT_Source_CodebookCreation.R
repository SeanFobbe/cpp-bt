#'---
#'title: "Codebook | Corpus der Plenarprotokolle des Bundestags (CPP-BT)"
#'author: Seán Fobbe
#'geometry: margin=3cm
#'papersize: a4
#'fontsize: 11pt
#'output:
#'  pdf_document:
#'    toc: true
#'    toc_depth: 3
#'    number_sections: true
#'    pandoc_args: --listings
#'    includes:
#'      in_header: General_Source_TEX_Preamble_DE.tex
#'      before_body: [CPP-BT_Source_TEX_Definitions.tex,CPP-BT_Source_TEX_CodebookTitle.tex]
#'bibliography: packages.bib
#'nocite: '@*'
#' ---

#'\newpage

#+ echo = FALSE 
knitr::opts_chunk$set(fig.width=12,
                      fig.height=8,
                      fig.pos = "center",
                      echo=FALSE,
                      warning=FALSE,
                      message=FALSE)


############################
### Packages
############################

#+
library(knitr)        # Professionelles Reporting
library(kableExtra)   # Verbesserte Automatisierte Tabellen
library(magick)       # Fortgeschrittene Verarbeitung von Grafiken
library(parallel)     # Parallelisierung in Base R
library(ggplot2)      # Fortgeschrittene Datenvisualisierung
library(scales)       # Skalierung von Diagrammen
library(data.table)   # Fortgeschrittene Datenverarbeitung




###################################
### Zusätzliche Funktionen einlesen
###################################

source("General_Source_Functions.R")



############################
### Vorbereitung
############################

datasetname <- "CPP-BT"
doi.concept <- "10.5281/zenodo.4542661"  # checked
doi.version <- "10.5281/zenodo.4542662"  # checked


files.zip <- list.files(pattern="\\.zip")

datestamp <- unique(tstrsplit(files.zip,
                              split = "_")[[2]])

prefix <- paste0("ANALYSE/",
                 datasetname,
                 "_")



############################
### Tabellen einlesen
############################

table.wahlperiode <- fread(paste0(prefix, "01_Frequenztabelle_var-wahlperiode.csv"))[,c(1:2,4:5)]
table.jahr <- fread(paste0(prefix, "01_Frequenztabelle_var-jahr.csv"))[,c(1:2,4:5)]


stats.ling <-  fread(paste0(prefix, "00_KorpusStatistik_ZusammenfassungLinguistisch.csv"))
stats.docvars <- fread(paste0(prefix, "00_KorpusStatistik_ZusammenfassungDocvarsQuantitativ.csv"))


summary.corpus <- fread(paste(datasetname, datestamp, "DE_CSV_Metadaten.csv", sep = "_"))



hashfile <- paste(datasetname, datestamp, "KryptographischeHashes.csv", sep = "_")
signaturefile <- paste(datasetname, datestamp, "FobbeSignaturGPG_Hashes.gpg", sep = "_")




#'# Einführung

#' Der **Deutsche Bundestag** ist das Parlament der Bundesrepublik Deutschland. Der Bundestag und der Bundesrat bilden gemeinsam die Legislative auf Bundesebene und somit die primäre Quelle für das deutsche Bundesrecht. Vor der Verabschiedung von Gesetzen werden diese im Plenum des Bundestages in bis zu drei regulären Lesungen behandelt. Bei Einschaltung des Vermittlungsausschusses findet eine vierte Lesung statt, bei Überstimmung von Einsprüchen des Bundesrates eine fünfte. Der Wortlaut der legislativen Beratungen und politischen Debatten des Bundestages wird in **Plenarprotokollen** festgehalten.
#'
#' Dem **Bundesrecht** kommt im Normengefüge der Bundesrepublik Deutschland herausragende Bedeutung zu. Zwar sind die Länder gemäß Art. 30, 70 GG primär für die Gesetzgebung zuständig, im Katalog der Art. 71 ff GG sind aber derart viele Kompetenzen dem Bund zugewiesen, dass das Bundesrecht praktisch jedes rechtliche Problem in der Bundesrepublik dominiert. Ausnahmen sind in der Regel nur die Bereiche innere Sicherheit, Bildung und Kultur, die weitgehend in der Hand der Bundesländer verblieben sind. Aber auch in diesen Bereichen finden sich Regelungen des Bundes. Beispiele dafür sind manche Regelungen des Bundespolizeigesetzes (BPolG) oder das Kulturgutschutzgesetz (KGSG).
#'
#' Bundesgesetze werden vom Bundestag im Zusammenwirken mit dem Bundesrat erlassen und vom Bundespräsidenten ausgefertigt (Art. 76 ff GG). Das Initiativrecht liegt bei Abgeordneten aus der Mitte des Bundestags, der Bundesregierung und dem Bundesrat (Art. 76 Abs. 1 GG). Der Bundesrat ist je nach Gesetzescharakter mit einem Zustimmungserfordernis oder einem Einspruchsrecht beteiligt (Art. 77, 78 GG).
#'
#'Die quantitative Analyse von politischen Texten ist mittlerweile fester Bestandteil des Forschungsprogramms der Politikwissenschaften, steht in den Rechtswissenschaften aber noch ganz am Anfang. Speziell auf den Deutschen Bundestag bezogen wird seit einigen Jahren der herausragende "GermaParl"-Korpus durch das PolMine-Projekt unter Leitung von Professor Dr. Andreas Blätte herausgegeben.\footnote{\url{https://polmine.github.io/GermaParl/}} Dieser dokumentiert die Plenarprotokolle des Bundestages von der 13. bis zur 18. Wahlperiode.
#'
#' Der **\datatitle\ (\datashort)** knüpft an diese Tradition an, will aber Forschungslücken schließen, indem er den "GermaParl"-Korpus an Umfang, Offenheit und wissenschaftlicher Reproduzierbarkeit übertrifft. Eine Gegenüberstellung der zentralen Unterschiede findet sich unter Punkt \ref{polmine}. Ein vergleichbar umfangreicher Korpus wurde möglicherweise von der Universität Siegen veröffentlicht, war aber im Februar 2021 seit über einem Jahr offline.\footnote{\url{https://diskurslinguistik.net/korpus-repository/}} In Anbetracht der flächendeckenden Verfügbarkeit von hochwertigen wissenschaftlichen Repositorien ist ein Datensatz mit einer solchen Erreichbarkeitslücke keine vertretbare Grundlage für reproduzierbare Forschung.
#' 
#'In einem funktionierenden Rechtsstaat muss die Gesetzgebung öffentlich, transparent und nachvollziehbar sein. Im 21. Jahrhundert bedeutet dies auch, dass sie quantitativen Analysen zugänglich sein muss. Der Erstellung und Aufbereitung des Datensatzes liegen daher die Prinzipien der allgemeinen Verfügbarkeit durch Urheberrechtsfreiheit, strenge Transparenz und vollständige wissenschaftliche Reproduzierbarkeit zugrunde. Die FAIR-Prinzipien (Findable, Accessible, Interoperable and Reusable) für freie wissenschaftliche Daten inspirieren sowohl die Konstruktion, als auch die Art der Publikation.\footnote{Wilkinson, M., Dumontier, M., Aalbersberg, I. et al. The FAIR Guiding Principles for Scientific Data Management and Stewardship. Sci Data 3, 160018 (2016). \url{https://doi.org/10.1038/sdata.2016.18}}





#+
#'# Nutzung

#' Die Daten sind in offenen, interoperablen und weit verbreiteten Formaten (CSV, TXT, XML) veröffentlicht. Sie lassen sich grundsätzlich mit allen modernen Programmiersprachen (z.B. R, Python), sowie mit grafischen Programmen nutzen.
#'
#' **Wichtig:** Nicht vorhandene Werte sind sowohl in den Dateinamen als auch in der CSV-Datei mit "NA" codiert.


#+
#'## CSV-Dateien
#' Am einfachsten ist es die **CSV-Dateien** einzulesen. CSV\footnote{Das CSV-Format ist in RFC 4180 definiert, siehe \url{https://tools.ietf.org/html/rfc4180}} ist ein einfaches und maschinell gut lesbares Tabellen-Format. In diesem Datensatz sind die Werte komma-separiert. Jede Spalte entspricht einer Variable, jede Zeile einem Plenarprotokoll. Die Variablen sind unter Punkt \ref{variables} genauer erläutert.
#'
#' Zum Einlesen empfehle ich für **R** dringend das package **data.table** (via CRAN verfügbar). Dessen Funktion **fread()** ist etwa zehnmal so schnell wie die normale **read.csv()**-Funktion in Base-R. Sie erkennt auch den Datentyp von Variablen sicherer. Beispiel:

#+ eval = FALSE, echo = TRUE
library(data.table)
dt <- fread("./filename.csv")






#+
#'## TXT-Dateien
#'Die **TXT-Dateien** inklusive Metadaten können zum Beispiel mit **R** und dem package **readtext** (via CRAN verfügbar) eingelesen werden. Beispiel:

#+ eval = FALSE, echo = TRUE
library(readtext)
txt <- readtext("./*.txt",
                docvarsfrom = "filenames", 
                docvarnames = c("datensatz",
                                "organ",
                                "dokumentart",
                                "wahlperiode",
                                "nummer_dok",
                                "datum"),
                dvsep = "_", 
                encoding = "UTF-8")



#+
#'## XML-Dateien
#' Das Einlesen der **XML-Rohdaten** ist technisch anspruchsvoller als das Einlesen der CSV- oder TXT-Varianten. Da die XML-Dateien bis zur 18. Wahlperiode keine besonders komplexe Datenstruktur aufweisen wird sich in den meisten Fällen kein Mehrwert gegenüber dem CSV- oder TXT-Format ergeben. Falls Sie dennoch die XML-Dateien nutzen möchten, lesen Sie bitte die Document Type Definition (DTD) genau und greifen Sie ggf. auf den im Source Code zur Verfügung gestellten XML Parser zurück.



#+
#'# Konstruktion

#+
#'## Datenquelle


#'\begin{centering}
#'\begin{longtable}{P{3.5cm}p{10.5cm}}

#'\toprule
#'Datenquelle & Vollzitat\\
#'\midrule

#'Primäre Datenquelle & \url{https://www.bundestag.de/services/opendata} \\


#'\bottomrule

#'\end{longtable}
#'\end{centering}


#+
#'## Beschreibung
#'Der Datensatz ist eine digitale Zusammenstellung von (fast) allen Plenarprotokollen des Deutschen Bundestages. Diese sind auf dessen Open Data Portal als XML-Dateien maschinenlesbar zur Verfügung gestellt. Die derzeitige Sammlung beschränkt sich auf die Protokolle der 1. bis 18. Wahlperiode.
#'
#' Die Stichtage des Abrufs für jede Version entsprechen exakt der Versionsnummer.
#'
#'Zusätzlich zu den aufbereiteten maschinenlesbaren Formaten (CSV und TXT) sind die XML-Rohdaten enthalten, damit AnalystInnen gegebenenfalls ihre eigene Konvertierung vornehmen können. Die XML-Rohdaten wurden inhaltlich nicht verändert.

#+
#'## Sammlung der Daten
#' Die Daten wurden vollautomatisiert gesammelt und mit Abschluss der Verarbeitung kryptographisch signiert. Das Open Data Portal des Bundestages ist ausdrücklich für die vollautomatisierte Datensammlung freigegeben (\enquote{offenen Daten können zur maschinellen Weiterverarbeitung genutzt werden}\footnote{\url{https://www.bundestag.de/services/opendata}}). Der Abruf geschieht ausschließlich über TLS-verschlüsselte Verbindungen.
#'

#+
#'## Source Code und Compilation Report
#' Der gesamte Source Code --- sowohl für die Erstellung des Datensatzes, als auch für dieses Codebook --- ist öffentlich einsehbar und dauerhaft erreichbar im wissenschaftlichen Archiv des CERN hier hinterlegt: \softwareversionurldoi\
#'
#'
#' Mit jeder Kompilierung des vollständigen Datensatzes wird auch ein umfangreicher **Compilation Report** in einem attraktiv designten PDF-Format erstellt. Der Compilation Report enthält den vollständigen Source Code, dokumentiert relevante Rechenergebnisse, gibt sekundengenaue Zeitstempel an und ist mit einem klickbaren Inhaltsverzeichnis versehen. Er ist zusammen mit dem Source Code hinterlegt. Wenn Sie sich für Details der Herstellung interessieren, lesen Sie diesen bitte zuerst.


#'\newpage

#+
#'## Einschränkungen
#'Nutzer sollten folgende wichtige Einschränkungen beachten:
#' 
#'\begin{enumerate}
#'\item Der Datensatz enthält nur das, was der Bundestag auch tatsächlich veröffentlicht (\emph{publication bias}).
#'\item Es werden nur XML-Dateien abgerufen (\emph{file type bias}).
#'\item Die Sammlung beschränkt sich zunächst auf die 1. bis 18. Wahlperiode (\emph{temporal bias}). Die Frequenztabellen geben hierzu genauer Auskunft. Weitere Wahlperioden werden in Zukunft berücksichtigt.
#'\end{enumerate}

#+
#'## Urheberrechtsfreiheit von Rohdaten und Datensatz 

#'An Plenarprotokollen besteht gem. § 5 Abs. 1 UrhG kein Urheberrecht, da sie amtliche Werke sind. § 5 UrhG ist auf amtliche Datenbanken analog anzuwenden (BGH, Beschluss vom 28.09.2006, I ZR 261/03, \enquote{Sächsischer Ausschreibungsdienst}).
#'
#' Alle eigenen Beiträge (z.B. durch Zusammenstellung und Anpassung der Metadaten) und damit den gesamten Datensatz stelle ich gemäß einer \emph{CC0 1.0 Universal Public Domain Lizenz} vollständig urheberrechtsfrei.



#+
#'## Metadaten

#+
#'### Allgemein
#'Die Metadaten wurden ausschließlich aus dem Inhalt der XML-Dateien extrahiert bzw. berechnet. Der volle Satz an Metadaten ist nur in den CSV-Dateien enthalten. Alle hinzugefügten Metadaten sind zusammen mit dem Source Code vollständig maschinenlesbar dokumentiert.
#' 
#'Die Dateinamen der TXT-Dateien enthalten den Namen des Datensatzes, den Namen des Organs, die Art des Dokuments, die Wahlperiode, die laufende Nummer des Dokuments und das Datum der Sitzung (Langform nach ISO-8601, d.h. YYYY-MM-DD).


#+
#'### Schema für die TXT-Dateinamen

#'\begin{verbatim}
#'[datensatz]_[organ]_[dokumentart]_[wahlperiode]_[nummer_dok]_[datum]
#'\end{verbatim}

#+
#'### Beispiel eines Dateinamens

#'\begin{verbatim}
#'CPP-BT_Bundestag_Plenarprotokoll_1_6_1949-09-21.txt
#'\end{verbatim}

#+
#'## Qualitätsprüfung

#'Die möglichen Werte der jeweiligen Variablen wurden durch Frequenztabellen und Visualisierungen auf ihre Plausibilität geprüft. Insgesamt werden zusammen mit jeder Kompilierung eine Vielzahl Tests zur Qualitätsprüfung durchgeführt. Alle Ergebnisse der Qualitätsprüfungen sind aggregiert im Compilation Report zusammen mit dem Source Code und einzeln im Archiv \enquote{ANALYSE} zusammen mit dem Datensatz veröffentlicht.






#+
#'# Varianten und Zielgruppen

#' Dieser Datensatz ist in verschiedenen Varianten verfügbar, die sich an unterschiedliche Zielgruppen richten. Zielgruppe sind nicht nur quantitativ forschende Politik- und RechtswissenschaftlerInnen, sondern auch traditionell arbeitende ForscherInnen. Idealerweise müssen quantitative Methoden ohnehin immer durch qualitative Interpretation, Theoriebildung und kritische Auseinandersetzung verstärkt werden (\emph{mixed methods}).
#'
#' Lehrende werden zudem von den vorbereiteten Tabellen und Diagrammen besonders profitieren, die Zeit im universitären Alltag sparen und bei der Erläuterung der Charakteristika der Daten hilfreich sein werden. Alle Tabellen und Diagramme liegen auch als separate Dateien vor um sie einfach z.B. in Präsentations-Folien oder Handreichungen zu integrieren.

#'\begin{centering}
#'\begin{longtable}{P{3.5cm}p{10.5cm}}

#'\toprule


#'Variante & Zielgruppe und Beschreibung\\

#'\midrule
#'
#'\endhead

#' CSV\_Datensatz & \textbf{Legal Tech/Quantitative Forschung}. Diese CSV-Datei ist die für statistische Analysen empfohlene Variante des Datensatzes. Sie enthält den Volltext aller Dokumente, sowie alle in diesem Codebook beschriebenen Metadaten.\\
#' CSV\_Metadaten & \textbf{Legal Tech/Quantitative Forschung}. Wie die andere CSV-Datei, nur ohne den Inhalt der Dokumente. Sinnvoll für AnalystInnen, die sich nur für die Metadaten interessieren und Speicherplatz sparen wollen.\\
#'TXT & \textbf{Traditionelle Forschung}. Die TXT-Dateien stellen einen Kompromiss zwischen den Anforderungen quantitativer und qualitativer Forschung dar und können sowohl als Lesefassung, als auch als Grundlage für quantitative Analysen benutzt werden. Die Dateinamen sind so konzipiert, dass sie auch für traditionelle qualitative Arbeit einen erheblichen Mehrwert bieten. Im Vergleich zu den CSV-Dateien enthalten die Dateinamen nur einen reduzierten Umfang an Metadaten, um Kompatibilitätsprobleme unter Windows zu vermeiden und die Lesbarkeit zu verbessern.\\
#' ANALYSE & \textbf{Alle Lehrenden und Forschenden}. Dieses Archiv enthält alle während dem Kompilierungs- und Prüfprozess erstellten Tabellen (CSV) und Diagramme (PDF, PNG) im Original. Sie sind inhaltsgleich mit den in diesem Codebook verwendeten Tabellen und Diagrammen. Das PDF-Format eignet sich besonders für die Verwendung in gedruckten Publikationen, das PNG-Format besonders für die Darstellung im Internet. AnalystInnen mit fortgeschrittenen Kenntnissen in R können auch auf den Source Code zurückgreifen. Empfohlen für NutzerInnen die einzelne Inhalte aus dem Codebook für andere Zwecke (z.B. Präsentationen, eigene Publikationen) weiterverwenden möchten.\\


#'\bottomrule

#'\end{longtable}
#'\end{centering}



#+
#'\newpage




#+
#'# Variablen
#'\label{variables}

#+
#'## Hinweise

#'\begin{itemize}
#'\item Fehlende Werte sind immer mit \enquote{NA} codiert
#'\item Strings können grundsätzlich alle in UTF-8 definierten Zeichen (insbesondere Buchstaben, Zahlen und Sonderzeichen) enthalten.
#'\end{itemize}

#+
#'## Erläuterungen zu den einzelnen Variablen



#'\ra{1.3}
#' 
#'\begin{centering}
#'\begin{longtable}{P{3.5cm}P{3cm}p{8cm}}
#' 
#'\toprule
#' 
#'Variable & Typ & Erläuterung\\
#' 
#'\midrule
#'
#'\endhead
#' 
#'doc\_id & String & (Nur CSV-Datei) Der Name der extrahierten XML-Datei.\\
#'text  & UTF-8 & (Nur CSV-Datei) Der vollständige Inhalt des Plenarprotokolls, so wie er in der XML-Datei dokumentiert ist.\\
#' wahlperiode & Natürliche Zahl & Die Wahlperiode der Plenarsitzung, die von dem Protokoll dokumentiert wird.\\
#'datum & Datum & Das Datum der Plenarsitzung im Format YYYY-MM-DD (Langform nach ISO-8601). Die Langform ist für Menschen einfacher lesbar und wird maschinell auch öfter automatisch als Datumsformat erkannt. In den XML-Rohdaten ist das Datum im Format DD.MM.YYYY enthalten und wurde vom Autor des Datensatzes in das ISO-Format transformiert.\\
#'jahr & Natürliche Zahl & (Nur CSV-Datei) Das Jahr der Plenarsitzung im Format YYYY (Langform nach ISO-8601). Wurde vom Autor des Datensatzes aus der Variable \enquote{datum} berechnet.\\
#' dokumentart & Alphabetisch & Es ist nur der Wert \enquote{PLENARPROTOKOLL} vergeben. Wird vor allem dann relevant, wenn dieser Korpus mit einem Drucksachen-Korpus verbunden wird.\\
#' titel & String & (Nur CSV-Datei) Der Titel des Plenarprotokolls, so wie er in der XML-Datei dokumentiert ist.\\
#' nummer\_dok & Natürliche Zahl & Die laufende Nummer des Plenarprotokolls. Die Nummerierung beginnt in jeder Wahlperiode bei 1 und steigt bis zur maximalen Anzahl der Plenarprotokolle einer Wahlperiode an.\\
#' nummer\_original & String & (Nur CSV-Datei) Eine Kombination von Wahlperiode und laufender Nummer des Plenarprotokolls, so wie sie in der XML-Datei dokumentiert ist. Beispielsweise steht \enquote{18/243} für das 243. Plenarprotokoll der 18. Wahlperiode.\\
#' tokens & Natürliche Zahl & (Nur CSV-Datei) Die Anzahl Tokens (beliebige Zeichenfolge getrennt durch whitespace) eines Dokumentes. Diese Zahl kann je nach Tokenizer und verwendeten Einstellungen erheblich schwanken. Für diese Berechnung wurde eine reine Tokenisierung ohne Entfernung von Inhalten durchgeführt. Benutzen Sie diesen Wert eher als Anhaltspunkt für die Größenordnung denn als exakte Aussage und führen sie ggf. mit ihrer eigenen Software eine Kontroll-Rechnung durch.\\
#' typen & Natürliche Zahl & (Nur CSV-Datei) Die Anzahl einzigartiger Tokens (beliebige Zeichenfolge getrennt durch whitespace) eines Dokumentes. Diese Zahl kann je nach Tokenizer und verwendeten Einstellungen erheblich schwanken. Für diese Berechnung wurde eine reine Tokenisierung und Typenzählung ohne Entfernung von Inhalten durchgeführt. Benutzen Sie diesen Wert eher als Anhaltspunkt für die Größenordnung denn als exakte Aussage und führen sie ggf. mit ihrer eigenen Software eine Kontroll-Rechnung durch.\\
#' saetze & Natürliche Zahl & (Nur CSV-Datei) Die Anzahl Sätze. Entsprechen in etwa dem üblichen Verständnis eines Satzes. Die Regeln für die Bestimmung von Satzanfang und Satzende sind im Detail sehr komplex und in \enquote{Unicode Standard Annex No 29} beschrieben. Diese Zahl kann je nach Software und verwendeten Einstellungen erheblich schwanken. Für diese Berechnung wurde eine reine Zählung ohne Entfernung von Inhalten durchgeführt. Benutzen Sie diesen Wert eher als Anhaltspunkt für die Größenordnung denn als exakte Aussage und führen sie ggf. mit ihrer eigenen Software eine Kontroll-Rechnung durch.\\
#' version & Datum & (Nur CSV-Datei) Die Versionsnummer des Datensatzes im Format YYYY-MM-DD (Langform nach ISO-8601). Die Versionsnummer entspricht immer dem Datum an dem der Datensatz erstellt und die Daten von der Webseite des Bundestages abgerufen wurden.\\
#' doi\_concept & String & (Nur CSV-Datei) Der Digital Object Identifier (DOI) des Gesamtkonzeptes des Datensatzes. Dieser ist langzeit-stabil (persistent). Über diese DOI kann via www.doi.org immer die \textbf{aktuellste Version} des Datensatzes abgerufen werden. Prinzip F1 der FAIR-Data Prinzipien (\enquote{data are assigned globally unique and persistent identifiers}) empfiehlt die Dokumentation jeder Messung mit einem persistenten Identifikator. Selbst wenn die CSV-Dateien ohne Kontext weitergegeben werden kann ihre Herkunft so immer zweifelsfrei und maschinenlesbar bestimmt werden.\\
#' doi\_version & String &  (Nur CSV-Datei) Der Digital Object Identifier (DOI) der \textbf{konkreten Version} des Datensatzes. Dieser ist langzeit-stabil (persistent). Über diese DOI kann via www.doi.org immer diese konkrete Version des Datensatzes abgerufen werden. Prinzip F1 der FAIR-Data Prinzipien (\enquote{data are assigned globally unique and persistent identifiers}) empfiehlt die Dokumentation jeder Messung mit einem persistenten Identifikator. Selbst wenn die CSV-Dateien ohne Kontext weitergegeben werden kann ihre Herkunft so immer zweifelsfrei und maschinenlesbar bestimmt werden.\\
#' 
#'\bottomrule
#' 
#'\end{longtable}
#'\end{centering}




#'\newpage
#'## Konkordanztabelle: XML-Struktur und CSV-Variablen

#'\bigskip

#'\begin{longtable}{p{5cm}p{4.5cm}p{4.5cm}}

#'\toprule

#' CSV-Variable & XPath & Attribut\\

#'\midrule

#' titel & /TITEL & -\\
#' dokumentart & /DOKUMENTART & -\\
#' wahlperiode & /WAHLPERIODE & -\\
#' nummer\_original & /NR & -\\
#' datum & /DATUM & -\\
#' text & /TEXT & -\\

#'\bottomrule

#'\end{longtable}

#'\medskip

#' Diese Konkordanztabelle bezieht sich auf die von der 1. bis zur 18. Wahlperiode gültige Document Type Definition (DTD) des Bundestages. Die DTD ist im Datensatz als separate Datei dokumentiert.
#'
#' Ab der 19. Wahlperiode wird eine stark verbesserte XML-Struktur mit höherem Detailgrad verwendet. Die neue XML-Struktur wird ebenfalls in diesem Codebook dokumentiert sobald die Plenarprotokolle der 19. Wahlperiode in den Datensatz aufgenommen sind.


#+
#'\newpage
#'# Vergleich GermaParl und CPP-BT

#'\label{polmine}

#'\begin{centering}
#'\begin{longtable}{p{5cm}p{4.5cm}p{4.5cm}}

#'\toprule

#'Metrik & CPP-BT & GermaParl\\

#'\midrule


#' Lizenz  & Public Domain & CC BY-NC-SA 4.0\\
#' Wahlperioden & 1 bis 18 & 13 bis 18\\
#' Umfang   & ca. 310 Mio Tokens & ca. 100 Mio Tokens\\
#' Format der Rohdaten & XML & PDF oder TXT\\
#' Format des Korpus & CSV und TXT & RData und XML (TEI)\\
#' Detailliertes Codebook & Ja & Nein\\
#' Sprache der Dokumentation & Deutsch & Englisch\\
#' Source Code verfügbar & Ja & Ja \\
#' Aufteilung nach Redner & Nein & Ja\\
#' Linguistische Annotation & Nein & Ja\\
#' LDA Topics Models & Nein & Ja\\


#'\bottomrule

#'\end{longtable}
#'\end{centering}

#'

#'
#' Der \datashort\ deckt drei mal soviele Wahlperioden ab und umfasst damit alle abgeschlossenen Wahlperioden seit 1949. Der Umfang ist daher mit ca. 310 Mio Tokens auch drei mal so groß wie der des GermaParl-Korpus (ca. 100 Mio Tokens). Aufgrund der XML-Basis ist der \datashort\ auch leichter erweiterbar und wird in Zukunft deutlich an Größe gewinnen.
#'
#' Als Rohdaten benutzt der \datashort\ die vom Bundestag bereitgestellten maschinenlesbaren XML-Varianten der Protokolle. Der GermaParl-Korpus nutzt die TXT- und PDF-Varianten. Insbesondere bei PDFs mit Zwei-Spalten-Layout zieht dies eine fehleranfällige Konvertierung nach sich.
#' 
#' Größter Vorteil des \datashort\ ist die technische und juristische Interoperabilität, eine zentrale Anforderung von FAIR Data und der Open Definition. Anders als der GermaParl-Korpus sind die Dokumente in einfach nutzbaren CSV- und TXT-Varianten verfügbar, eine spürbare Erleichterung gegenüber dem anspruchsvollen TEI-XML und dem nur mit R und der Corpus Workbench nutzbaren RData-Format von GermaParl. CSV und TXT sind hingegen mit allen Programmiersprachen und grafischen Programmen leicht nutzbar.
#' 
#' Die Dokumentation des \datashort\ ist detaillierter, in einem Codebook zentralisiert und auf Deutsch verfasst --- ein erheblicher Vorteil bei einem deutschsprachigen Korpus und einer deutschsprachigen Zielgruppe.
#'
#'
#' Schließlich steht der GermaParl-Korpus unter einer sehr restriktiven CC BY-NC-SA 4.0-Lizenz.\footnote{\url{https://polmine.github.io/GermaParl/}} Der \datashort\ wählt den Weg der vollständigen Urheberrechtsfreiheit, aus der Überzeugung heraus, dass nur weitgehende Transparenz staatlicher Daten Demokratie und Rechtsstaat in das 21. Jahrhundert führen kann.
#'
#'
#' Primärer Vorteil des GermaParl-Korpus ist die Aufteilung nach Rednern und die Bereitstellung von linguistischen Annotationen und vorberechneten LDA Topic Models. Die Aufteilung nach Rednern ist auch für den \datashort\ geplant.






#'\newpage
#+
#'# Computerlinguistische Kennzahlen
#' Zur besseren Einschätzung des inhaltlichen Umfangs des Korpus dokumentiere ich an dieser Stelle die Verteilung der Werte für drei verschiedene klassische computerlinguistische Kennzahlen:
#'
#'\begin{centering}
#'\begin{longtable}{P{3.5cm}p{10.5cm}}

#'\toprule

#'Kennzahl & Definition\\

#'\midrule

#' Tokens & Eine beliebige Zeichenfolge, getrennt durch whitespace-Zeichen, d.h. ein Token entspricht in der Regel einem \enquote{Wort}, kann aber gelegentlich auch sinnlose Zeichenfolgen enthalten, weil es rein syntaktisch berechnet wird.\\
#' Typen & Einzigartige Tokens. Beispiel: wenn das Token \enquote{Migration} zehnmal in einem Plenarprotokoll vorhanden ist, wird es als ein Typ gezählt.\\
#' Sätze & Entsprechen in etwa dem üblichen Verständnis eines Satzes. Die Regeln für die Bestimmung von Satzanfang und Satzende sind im Detail aber sehr komplex und in \enquote{Unicode Standard: Annex No 29} beschrieben.\\

#'\bottomrule

#'\end{longtable}
#'\end{centering}
#'
#' Es handelt sich bei den Diagrammen jeweils um "Density Charts", die sich besonders dafür eignen die Schwerpunkte von Variablen mit stark schwankenden numerischen Werten zu visualisieren. Die Interpretation ist denkbar einfach: je höher die Kurve, desto dichter sind in diesem Bereich die Werte der Variable. Der Wert der y-Achse kann außer Acht gelassen werden, wichtig sind nur die relativen Flächenverhältnisse und die x-Achse.
#'
#' Vorsicht bei der Interpretation: Die x-Achse it logarithmisch skaliert, d.h. in 10er-Potenzen und damit nicht-linear. Die kleinen Achsen-Markierungen zwischen den Schritten der Exponenten sind eine visuelle Hilfestellung um diese nicht-Linearität zu verstehen.
#'
#'\bigskip

#'## Werte der Kennzahlen

setnames(stats.ling, c("Kennzahl",
                       "Summe",
                       "Min",
                       "Quart1",
                       "Median",
                       "Mittel",
                       "Quart3",
                       "Max"))

kable(stats.ling,
      format.args = list(big.mark = ","),
      digits = 2,
      format = "latex",
      booktabs=TRUE,
      longtable=TRUE)






#'## Verteilung Tokens

#+ CPP-BT_04_Density_Tokens, fig.height = 6, fig.width = 9
ggplot(data = summary.corpus) +
    geom_density(aes(x = tokens),
                 fill = "black") +
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b")+
    coord_cartesian(xlim = c(1, 10^6))+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Verteilung der Tokens je Protokoll"),
        caption = paste("DOI:",
                        doi.version),
        x = "Tokens",
        y = "Dichte"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )



#'## Verteilung Typen

#+ CPP-BT_05_Density_Typen, fig.height = 6, fig.width = 9
ggplot(data = summary.corpus) +
    geom_density(aes(x = typen),
                 fill ="black") +
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b")+
    coord_cartesian(xlim = c(1, 10^6))+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Verteilung der Typen je Protokoll"),
        caption = paste("DOI:",
                        doi.version),
        x = "Typen",
        y = "Dichte"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )




#'## Verteilung Sätze

#+ CPP-BT_06_Density_Saetze, fig.height = 6, fig.width = 9
ggplot(data = summary.corpus) +
    geom_density(aes(x = saetze),
                 fill ="black") +
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b")+
    coord_cartesian(xlim = c(1, 10^6))+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Verteilung der Sätze je Protokoll"),
        caption = paste("DOI:",
                        doi.version),
        x = "Sätze",
        y = "Dichte"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )




    
#' \newpage
#' \ra{1.4}
#+
#'# Inhalt


#+
#'## Zusammenfassung

setnames(stats.docvars, c("Variable",
                          "Anzahl",
                          "Min",
                          "Quart1",
                          "Median",
                          "Mittel",
                          "Quart3",
                          "Max"))


kable(stats.docvars,
      digits = 2,
      format = "latex",
      booktabs=TRUE,
      longtable=TRUE)







#'## Nach Jahr

freqtable <- table.jahr[-.N][,lapply(.SD, as.numeric)]

#+ CPP-BT_03_Barplot_Jahr, fig.height = 7, fig.width = 11
ggplot(data = freqtable) +
    geom_bar(aes(x = jahr,
                 y = N),
             stat = "identity",
             fill = "black") +
    theme_bw() +
    scale_x_continuous(breaks = seq(1945,
                                    max(freqtable$jahr),
                                    10)) +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Plenarprotokolle je Jahr"),
        caption = paste("DOI:",
                        doi.version),
        x = "Jahr",
        y = "Plenarprotokolle"
    )+
    theme(
        text = element_text(size = 16),
        plot.title = element_text(size = 16,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )


#'\vspace{1cm}

kable(table.jahr,
      format = "latex",
      align = 'P{3cm}',
      booktabs=TRUE,
      longtable=TRUE,
      col.names = c("Jahr",
                    "Plenarprotokolle",
                    "% Gesamt",
                    "% Kumulativ")) %>% kable_styling(latex_options = "repeat_header")




#'\newpage
#'## Nach Wahlperiode

freqtable <- table.wahlperiode[-.N][order(-wahlperiode)]
freqtable <- freqtable[,lapply(.SD, as.numeric)]


#+ CPP-BT_02_Barplot_Wahlperiode, fig.height = 5, fig.width = 8
ggplot(data = freqtable) +
    geom_bar(aes(x = wahlperiode,
                 y = N),
             stat = "identity",
             fill = "black",
             color = "black",
             width = 0.5) +
    theme_bw()+
    scale_x_continuous(breaks = seq(1,
                                    max(freqtable$wahlperiode),
                                    1)) +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Plenarprotokolle je Wahlperiode"),
        caption = paste("DOI:",
                        doi.version),
        x = "Wahlperiode",
        y = "Plenarprotokolle"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )



#'\vspace{1cm}

kable(table.wahlperiode,
      format = "latex",
      align = 'P{3cm}',
      booktabs=TRUE,
      longtable=TRUE,
      col.names = c("Wahlperiode",
                    "Plenarprotokolle",
                    "% Gesamt",
                    "% Kumulativ")) %>% kable_styling(latex_options = "repeat_header")






#'# Dateigrößen

files.zip <- fread(hashfile)$filename
filesize <- round(file.size(files.zip) / 10^6, digits = 2)

table.size <- data.table(files.zip, filesize)



#' ![](ANALYSE/CPP-BT_07_DensityChart_Dateigroessen_XML-1.pdf)

#' ![](ANALYSE/CPP-BT_08_DensityChart_Dateigroessen_TXT-1.pdf)

#'\newpage

kable(table.size,
      format = "latex",
      align = c("l", "r"),
      booktabs = TRUE,
      longtable = TRUE,
      col.names = c("Datei",
                    "Größe in MB"))


#'\newpage
#+
#'# Signaturprüfung

#+
#'## Allgemeines
#' Die Integrität und Echtheit der einzelnen Archive des Datensatzes sind durch eine Zwei-Phasen-Signatur sichergestellt. In Phase I werden während der Kompilierung für jedes ZIP-Archiv Hash-Werte in zwei verschiedenen Verfahren berechnet und in einer CSV-Datei dokumentiert. In Phase II wird diese CSV-Datei mit meinem persönlichen geheimen GPG-Schlüssel signiert. Dieses Verfahren stellt sicher, dass die Kompilierung von jedermann durchgeführt werden kann --- insbesondere im Rahmen von Replikationen --- die persönliche Gewähr für Ergebnisse aber dennoch vorhanden bleibt.
#'
#' Dieses Codebook ist vollautomatisch erstellt und prüft die kryptographisch sicheren SHA3-512 Signaturen (\enquote{Hashes}) aller ZIP-Archive, sowie die GPG-Signatur der CSV-Datei, welche die SHA3-512 Signaturen enthält. SHA3-512 Signaturen werden durch einen system call zur OpenSSL library auf Linux-Systemen berechnet. Eine erfolgreiche Prüfung meldet \enquote{Signatur verifiziert!}. Eine gescheiterte Prüfung meldet \enquote{FEHLER!}

#+
#'## Persönliche GPG-Signatur
#' Die während der Kompilierung des Datensatzes erstellte CSV-Datei mit den Hash-Prüfsummen ist mit meiner persönlichen GPG-Signatur versehen. Der mit dieser Version korrespondierende Public Key ist sowohl mit dem Datensatz als auch mit dem Source Code hinterlegt. Er hat folgende Kenndaten:
#' 
#' **Name:** Sean Fobbe (fobbe-data@posteo.de)
#' 
#' **Fingerabdruck:** FE6F B888 F0E5 656C 1D25  3B9A 50C4 1384 F44A 4E42

#+
#'## Public Key importieren
#+ echo = TRUE
system2("gpg2", "--import GPG-Public-Key_Fobbe-Data.asc",
        stdout = TRUE,
        stderr = TRUE)





#'\newpage
#+
#'## Prüfung: GPG-Signatur der Hash-Datei

#+ echo = TRUE

# CSV-Datei mit Hashes
print(hashfile)
# GPG-Signatur
print(signaturefile)

# GPG-Signatur prüfen
testresult <- system2("gpg2",
                      paste("--verify", signaturefile, hashfile),
                      stdout = TRUE,
                      stderr = TRUE)

# Anführungsstriche entfernen um Anzeigefehler zu vermeiden
testresult <- gsub('"', '', testresult)

#+ echo = TRUE
kable(testresult, format = "latex", booktabs = TRUE,
      longtable=TRUE, col.names = c("Ergebnis"))


#'\newpage
#+
#'## Prüfung: SHA3-512 Hashes der ZIP-Archive
#+ echo = TRUE

# Prüf-Funktion definieren
sha3test <- function(filename, sig){
    sig.new <- system2("openssl",
                       paste("sha3-512", filename),
                       stdout = TRUE)
    sig.new <- gsub("^.*\\= ", "", sig.new)
    if (sig == sig.new){
        return("Signatur verifiziert!")
    }else{
        return("FEHLER!")
    }
}

# Ursprüngliche Signaturen importieren
table.hashes <- fread(hashfile)
filename <- table.hashes$filename
sha3.512 <- table.hashes$sha3.512

# Signaturprüfung durchführen 
sha3.512.result <- mcmapply(sha3test, filename, sha3.512, USE.NAMES = FALSE)

# Ergebnis anzeigen
testresult <- data.table(filename, sha3.512.result)

#+ echo = TRUE
kable(testresult, format = "latex", booktabs = TRUE,
      longtable = TRUE, col.names = c("Datei", "Ergebnis"))




#+
#'# Changelog
#'
#'\ra{1.3}
#'
#' 
#'\begin{centering}
#'\begin{longtable}{p{2.5cm}p{11.5cm}}
#'\toprule
#'Version &  Details\\
#'\midrule
#'

#' \version &
#'
#' \begin{itemize}
#' \item Erstveröffentlichung
#' \end{itemize}\\
#' 
#'\bottomrule
#'\end{longtable}
#'\end{centering}

#'\newpage
#+
#'# Parameter für strenge Replikationen

system2("openssl",  "version", stdout = TRUE)

sessionInfo()

#'# Literaturverzeichnis
