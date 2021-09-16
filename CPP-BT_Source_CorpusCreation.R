#'---
#'title: "Compilation Report | Corpus der Plenarprotokolle des Bundestags (CPP-BT)"
#'author: Seán Fobbe
#'papersize: a4
#'geometry: margin=3cm
#'fontsize: 11pt
#'output:
#'  pdf_document:
#'    toc: true
#'    toc_depth: 3
#'    number_sections: true
#'    pandoc_args: --listings
#'    includes:
#'      in_header: General_Source_TEX_Preamble_DE.tex
#'      before_body: [CPP-BT_Source_TEX_Definitions.tex,CPP-BT_Source_TEX_CompilationTitle.tex]
#'bibliography: packages.bib
#'nocite: '@*'
#' ---


#'\newpage
#+
#'# Einleitung
#'
#+
#'## Überblick
#' Dieses R-Skript lädt die Plenarprotokolle des Deutschen Bundestags im XML-Format von dessen Open Data Portal\footnote{\url{https://www.bundestag.de/services/opendata}} herunter und verarbeitet sie in einen reichhaltigen menschen- und maschinenlesbaren Korpus. Es ist die Basis für den \textbf{\datatitle\ (\datashort )}.
#'
#' Alle mit diesem Skript erstellten Datensätze werden dauerhaft kostenlos und urheberrechtsfrei auf Zenodo, dem wissenschaftlichen Archiv des CERN, veröffentlicht. Jede Version ist mit ihrem eigenen, persistenten Digital Object Identifier (DOI) versehen. Die neueste Version des Datensatzes ist immer über diesen Link erreichbar: \dataconcepturldoi


#+
#'## Funktionsweise

#' Primäre Endprodukte des Skripts sind folgende ZIP-Archive:
#' 
#' \begin{enumerate}
#' \item Der volle Datensatz im CSV-Format
#' \item Der volle Datensatz im TXT-Format (reduzierter Umfang an Metadaten)
#' \item Die Rohdaten im XML-Format
#' \item Alle Analyse-Ergebnisse (Tabellen als CSV, Grafiken als PDF und PNG)
#' \item Der Source Code und alle weiteren Quelldaten
#' \end{enumerate}
#'
#' Zusätzliche werden für alle ZIP-Archive kryptographische Signaturen (SHA2-256 und SHA3-512) berechnet und in einer CSV-Datei hinterlegt. Die Analyse-Ergebnisse werden zum Ende hin nicht gelöscht, damit sie für die Codebook-Erstellung verwendet werden können. Weiterhin kann optional ein PDF-Bericht erstellt werden (siehe unter "Kompilierung").



#+
#'## Systemanforderungen
#' Das Skript in seiner veröffentlichten Form kann nur unter Linux ausgeführt werden, da es Linux-spezifische Optimierungen (z.B. Fork Cluster) und Shell-Kommandos (z.B. OpenSSL) nutzt. Das Skript wurde unter Fedora Linux entwickelt und getestet. Die zur Kompilierung benutzte Version entnehmen Sie bitte dem **sessionInfo()**-Ausdruck am Ende dieses Berichts.
#'
#' In der Standard-Einstellung wird das Skript vollautomatisch die maximale Anzahl an Rechenkernen/Threads auf dem System zu nutzen. Wenn die Anzahl Threads (Variable "fullCores") auf 1 gesetzt wird, ist die Parallelisierung deaktiviert.
#'
#' Auf der Festplatte sollten 6 GB Speicherplatz vorhanden sein.
#' 
#' Um die PDF-Berichte kompilieren zu können benötigen Sie das R package **rmarkdown**, eine vollständige Installation von \LaTeX\ und alle in der Präambel-TEX-Datei angegebenen \LaTeX\ Packages.




#+
#'## Kompilierung
#' Mit der Funktion **render()** von **rmarkdown** können der **vollständige Datensatz** und das **Codebook** kompiliert und die Skripte mitsamt ihrer Rechenergebnisse in ein gut lesbares PDF-Format überführt werden.
#'
#' Alle Kommentare sind im roxygen2-Stil gehalten. Die beiden Skripte können daher auch **ohne render()** regulär als R-Skripte ausgeführt werden. Es wird in diesem Fall kein PDF-Bericht erstellt und Diagramme werden nicht abgespeichert.

#+
#'### Datensatz 
#' 
#' Um den **vollständigen Datensatz** zu kompilieren und einen PDF-Bericht zu erstellen, kopieren Sie bitte alle im Source-Archiv bereitgestellten Dateien in einen leeren Ordner und führen mit R diesen Befehl aus:

#+ eval = FALSE

rmarkdown::render(input = "CPP-BT_Source_CorpusCreation.R",
                  output_file = paste0("CPP-BT_",
                                       Sys.Date(),
                                       "_CompilationReport.pdf"),
                  envir = new.env())



#'### Codebook
#' Um das **Codebook** zu kompilieren und einen PDF-Bericht zu erstellen, kopieren Sie bitte alle im Source-Archiv bereitgestellten Dateien in einen leeren Ordner und führen im Anschluss an die Kompilierung des Datensatzes (!) untenstehenden Befehl mit R aus.
#'
#' Bei der Prüfung der GPG-Signatur wird ein Fehler auftreten und im Codebook dokumentiert, weil die Daten nicht mit meiner Original-Signatur versehen sind. Dieser Fehler hat jedoch keine Auswirkungen auf die Funktionalität und hindert die Kompilierung nicht.

#+ eval = FALSE

rmarkdown::render(input = "CPP-BT_Source_CodebookCreation.R",
                  output_file = paste0("CPP-BT_",
                                       Sys.Date(),
                                       "_Codebook.pdf"),
                  envir = new.env())







#'\newpage
#+
#'# Parameter

#+
#'## Name des Datensatzes
datasetname <- "CPP-BT"


#'## DOI des Datensatz-Konzeptes
doi.concept <- "10.5281/zenodo.4542661" # checked


#'## DOI der konkreten Version
doi.version <- "10.5281/zenodo.4542662" # checked


#'## Verzeichnis für Analyse-Ergebnisse
#' Muss mit einem Schrägstrich enden!
outputdir <- paste0(getwd(), "/ANALYSE/") 



#'## Debugging-Modus
#' Der Debugging-Modus reduziert den Download-Umfang auf den in der Variable "debug.sample" definierten Umfang zufällig ausgewählter Wahlperioden. Nur für Test- und Demonstrationszwecke. 

mode.debug <- FALSE
debug.sample <- 3



#'## Optionen: Quanteda
tokens_locale <- "de_DE"


#'## Optionen: Knitr

#+
#'### Ausgabe-Format
dev <- c("pdf", "png")

#'### DPI für Raster-Grafiken
dpi <- 300

#'### Ausrichtung von Grafiken im Compilation Report
fig.align <- "center"




#'## Frequenztabellen: Ignorierte Variablen

#' Diese Variablen werden bei der Erstellung der Frequenztabellen nicht berücksichtigt.

varremove <- c("text",
               "doc_id",
               "datum",
               "titel",
               "nummer_original")





#'# Vorbereitung

#'## Datumsstempel
#' Dieser Datumsstempel wird in alle Dateinamen eingefügt. Er wird am Anfang des Skripts gesetzt, für den den Fall, dass die Laufzeit die Datumsbarriere durchbricht.

datestamp <- Sys.Date()
print(datestamp)


#'## Datum und Uhrzeit (Beginn)

begin.script <- Sys.time()
print(begin.script)


#'## Ordner für Analyse-Ergebnisse erstellen
dir.create(outputdir)


#+
#'## Packages Laden

library(rvest)        # HTML/XML-Extraktion
library(doParallel)   # Parallelisierung
library(knitr)        # Professionelles Reporting
library(kableExtra)   # Verbesserte Kable Tabellen
library(ggplot2)      # Fortgeschrittene Datenvisualisierung
library(scales)       # Skalierung von Diagrammen
library(data.table)   # Fortgeschrittene Datenverarbeitung
library(quanteda)     # Fortgeschrittene Computerlinguistik




#'## Zusätzliche Funktionen einlesen
#' **Hinweis:** Die hieraus verwendeten Funktionen werden jeweils vor der ersten Benutzung in vollem Umfang angezeigt um den Lesefluss zu verbessern.

source("General_Source_Functions.R")


#'## Quanteda-Optionen setzen
quanteda_options(tokens_locale = tokens_locale)


#'## Knitr Optionen setzen
knitr::opts_chunk$set(fig.path = outputdir,
                      dev = dev,
                      dpi = dpi,
                      fig.align = fig.align)




#'## Vollzitate statistischer Software
knitr::write_bib(c(.packages()), "packages.bib")





#'## Parallelisierung aktivieren
#' Parallelisierung wird zur Beschleunigung des Parsens der XML-Strukturen und der Datenanalyse mittels **quanteda** und **data.table** verwendet. Die Anzahl Threads wird automatisch auf das verfügbare Maximum des Systems gesetzt, kann aber auch nach Belieben angepasst werden. Die Parallelisierung kann deaktiviert werden, indem die Variable \enquote{fullCores} auf 1 gesetzt wird.
#'
#' Der Download der Dateien von \url{https://www.bundestag.de} ist bewusst nicht parallelisiert, damit das Skript nicht versehentlich als DoS-Tool verwendet wird.
#'
#' Die hier verwendete Funktion **makeForkCluster()** ist viel schneller als die Alternativen, funktioniert aber nur auf Unix-basierten Systemen (Linux, MacOS).

#+
#'### Logische Kerne

fullCores <- detectCores()
print(fullCores)

#'### Quanteda
quanteda_options(threads = fullCores) 

#+
#'### Data.table
setDTthreads(threads = fullCores)  

#'### DoParallel
cl <- makeForkCluster(fullCores)
registerDoParallel(cl)






#+
#'# Download

#+
#'## Links zu den Datenquellen einlesen

links <- fread("CPP-BT_Source_DatenquelleLinks.csv")$links



#'## [Debugging-Modus] Reduzierung des Download-Umfangs

if (mode.debug == TRUE){
    links <- links[sample(length(links),
                          debug.sample)]
    }




#'## Zeitstempel: Download Beginn

begin.download <- Sys.time()
print(begin.download)



#'## Download durchführen

mapply(download.file,
       links,
       basename(links))



#'## Zeitstempel: Download Ende

end.download <- Sys.time()
print(end.download)



#'## Dauer: Download 
end.download - begin.download



#'## Download-Ergebnis

#+
#'### Anzahl herunterzuladender Dateien
length(links)

#'### Anzahl heruntergeladener Dateien
files.zip <- list.files(pattern = "\\.zip")
length(files.zip)

#'### Fehlbetrag
N.missing <- length(links) - length(files.zip)
print(N.missing)

#'### Fehlende Dateien
missing <- setdiff(basename(links),
                   files.zip)
print(missing)





#'# ZIP-Archive verarbeiten

#+
#'## Vektor der ZIP-Archive erstellen

files.zip <- list.files(pattern = "\\.zip")


#'## Entpacken

result <- lapply(files.zip,
                 unzip)


#'## Heruntergeladene Archive löschen

unlink(files.zip)



#'## Document Type Definition umbenennen

file.rename("BUNDESTAGSDOKUMENTE.dtd",
            paste(datasetname,
                  datestamp,
                  "DE_XML_DocumentTypeDefinition.dtd",
                  sep = "_"))




#'# XML analysieren

#+
#'## Vektor der XML-Dateien erstellen
files.xml <- list.files(pattern = "\\.xml")


#'## Anzahl XML-Dateien
length(files.xml)


#'## Zeitstempel: XML Parsen Beginn

begin.parse <- Sys.time()
print(begin.parse)



#'## XML Parsen


list.out <- foreach(i = seq_along(files.xml),
                    .errorhandling = 'pass') %dopar% {
                        
                        ## Dateinamen speichern
                        doc_id <- files.xml[i]


                        ## XML einlesen
                        XML <- read_xml(doc_id)

                        ## Metadaten extrahieren
                        wahlperiode <- xml_nodes(XML,
                                                 xpath = "//WAHLPERIODE") %>%
                            xml_text()
                        
                        dokumentart <- xml_nodes(XML,
                                                 xpath = "//DOKUMENTART") %>%
                            xml_text()
                        
                        nummer_original <- xml_nodes(XML,
                                                     xpath = "//NR") %>%
                            xml_text()
                        
                        datum <- xml_nodes(XML,
                                           xpath = "//DATUM") %>%
                            xml_text()
                        
                        titel <- xml_nodes(XML,
                                           xpath = "//TITEL") %>%
                            xml_text()
                        
                        text <- xml_nodes(XML,
                                          xpath = "//TEXT") %>%
                            xml_text()
                        
                        dt.temp <- data.table(doc_id,
                                              wahlperiode,
                                              dokumentart,
                                              nummer_original,
                                              datum,
                                              titel,
                                              text)

                        return(dt.temp)
                    }





#'## Zeitstempel: XML Parsen Ende

end.parse <- Sys.time()
print(end.parse)



#'## Dauer: Parse 
end.parse - begin.parse



#'## Liste zu Data Table konvertieren
txt.pp <- rbindlist(list.out)



#'## Datum formatieren

txt.pp[, datum := lapply(.SD,
                           function(x){as.IDate(x, format = "%d.%m.%Y")}),
         .SDcols = "datum"]




#'## Wahlperiode als numerische Variable
txt.pp$wahlperiode <- as.numeric(txt.pp$wahlperiode)






#'# Variablen hinzufügen

#+
#'## Variable "jahr" hinzufügen
txt.pp$jahr <- year(txt.pp$datum)


#'## Variable "nummer_dok" hinzufügen

txt.pp$nummer_dok <- gsub("[0-9]*/([0-9]*)",
                          "\\1",
                          txt.pp$nummer_original)


txt.pp$nummer_dok <- as.numeric(txt.pp$nummer_dok)



#'## Variable "doi_concept" hinzufügen

txt.pp$doi_concept <- rep(doi.concept,
                              txt.pp[,.N])


#'## Variable "doi_version" hinzufügen

txt.pp$doi_version <- rep(doi.version,
                              txt.pp[,.N])


#'## Variable "version" hinzufügen

txt.pp$version <- as.character(rep(datestamp,
                                       txt.pp[,.N]))









#'# Frequenztabellen erstellen

#+
#'## Funktion anzeigen

#+ results = "asis"
print(f.fast.freqtable)


#'## Ignorierte Variablen
print(varremove)



#'## Liste zu prüfender Variablen

varlist <- names(txt.pp)

varlist <- setdiff(varlist,
                   varremove)

print(varlist)



#'## Frequenztabellen erstellen

prefix <- paste0(datasetname,
                 "_01_Frequenztabelle_var-")


#+ results = "asis"
f.fast.freqtable(txt.pp,
                 varlist = varlist,
                 sumrow = TRUE,
                 output.list = FALSE,
                 output.kable = TRUE,
                 output.csv = TRUE,
                 outputdir = outputdir,
                 prefix = prefix)









#'# Frequenztabellen visualisieren


#+
#'## Präfix erstellen
prefix <- paste0("ANALYSE/",
                 datasetname,
                 "_")


#'## Frequenztabellen einlesen
table.wahlperiode <- fread(paste0(prefix,
                                  "01_Frequenztabelle_var-wahlperiode.csv"))

table.jahr  <- fread(paste0(prefix,
                            "01_Frequenztabelle_var-jahr.csv"))



#'\newpage
#'## Wahlperiode
    
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
        y = "Protokolle"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )


#'\newpage
#'## Jahr

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



#'# Korpus-Analytik


#+
#'## Berechnung linguistischer Kennwerte
#' An dieser Stelle werden für jedes Dokument die Anzahl Tokens, Typen und Sätze berechnet und mit den jeweiligen Metadaten verknüpft. Das Ergebnis ist grundsätzlich identisch mit dem eigentlichen Datensatz, nur ohne den Text der Protokolle.

#+
#'### Korpus-Objekt erstellen
corpus <- corpus(txt.pp)



#'### Zeitstempel: Kennwerte Beginn

begin.summarize <- Sys.time()
print(begin.summarize)



#'### Kennwerte berechnen

result <- foreach(i = seq_len(ndoc(corpus)),
                  .errorhandling = 'pass') %dopar% {
                      temp <- summary(corpus[i])
                      return(temp)
               }




#'### Zeitstempel: Kennwerte Ende

end.summarize <- Sys.time()
print(end.summarize)



#'### Dauer: Kennwerte
end.summarize - begin.summarize


#'### Liste zu Data Table konvertieren

summary.corpus <- rbindlist(result)



#'## Variablen-Namen anpassen

setnames(summary.corpus,
         old = c("Text",
                 "Tokens",
                 "Types",
                 "Sentences"),
         new = c("doc_id",
                 "tokens",
                 "typen",
                 "saetze"))


#'## Kennwerte dem Korpus hinzufügen

txt.pp$tokens <- summary.corpus$tokens
txt.pp$typen <- summary.corpus$typen
txt.pp$saetze <- summary.corpus$saetze



#'## Anzahl Variablen im Korpus
length(txt.pp)


#'## Namen aller Variablen im Korpus
names(txt.pp)





#'\newpage
#'## Linguistische Kennwerte
#' **Hinweis:** Typen sind definiert als einzigartige Tokens und werden für jedes Dokument gesondert berechnet. Daher ergibt es an dieser Stelle auch keinen Sinn die Typen zu summieren, denn bezogen auf den Korpus wäre der Kennwert ein anderer. Der Wert wird daher manuell auf "NA" gesetzt.

#+
#'### Zusammenfassungen berechnen

dt.summary.ling <- summary.corpus[,
                                  lapply(.SD,
                                           function(x)unclass(summary(x))),
                                  .SDcols = c("tokens",
                                              "saetze",
                                              "typen")]

dt.sums.ling <- summary.corpus[,
                               lapply(.SD, sum),
                               .SDcols = c("tokens",
                                           "saetze",
                                           "typen")]

dt.sums.ling$typen <- NA



dt.stats.ling <- rbind(dt.sums.ling,
                       dt.summary.ling)

dt.stats.ling <- transpose(dt.stats.ling,
                           keep.names = "names")


setnames(dt.stats.ling, c("Variable",
                          "Sum",
                          "Min",
                          "Quart1",
                          "Median",
                          "Mean",
                          "Quart3",
                          "Max"))


#'\newpage
#'### Zusammenfassungen anzeigen

kable(dt.stats.ling,
      format.args = list(big.mark = ","),
      format = "latex",
      booktabs = TRUE,
      longtable = TRUE)




#'### Zusammenfassungen speichern

fwrite(dt.stats.ling,
       paste0(outputdir,
              datasetname,
              "_00_KorpusStatistik_ZusammenfassungLinguistisch.csv"),
       na = "NA")






#'\newpage
#'## Quantitative Variablen


#+
#'### Datum

summary.corpus$datum <- as.IDate(summary.corpus$datum)

summary(summary.corpus$datum)





#'### Zusammenfassungen berechnen

dt.summary.docvars <- summary.corpus[,
                                     lapply(.SD,
                                            function(x)unclass(summary(na.omit(x)))),
                                     .SDcols = c("wahlperiode",
                                                 "jahr")]



dt.unique.docvars <- summary.corpus[,
                                    lapply(.SD,
                                             function(x)length(unique(na.omit(x)))),
                                    .SDcols = c("wahlperiode",
                                                "jahr")]


dt.stats.docvars <- rbind(dt.unique.docvars,
                          dt.summary.docvars)

dt.stats.docvars <- transpose(dt.stats.docvars,
                              keep.names = "names")


setnames(dt.stats.docvars, c("Variable",
                             "Unique",
                             "Min",
                             "Quart1",
                             "Median",
                             "Mean",
                             "Quart3",
                             "Max"))



#'\newpage
#'### Zusammenfassungen anzeigen

kable(dt.stats.docvars,
      format = "latex",
      booktabs=TRUE,
      longtable=TRUE)


#'### Zusammenfassungen speichern

fwrite(dt.stats.docvars,
       paste0(outputdir,
              datasetname,
              "_00_KorpusStatistik_ZusammenfassungDocvarsQuantitativ.csv"),
       na = "NA")






#'\newpage
#'## Density

#+
#'### Density Tokens

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



#'\newpage
#'### Density Typen

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

#'\newpage
#'### Density Sätze

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





#'# Beispiel-Werte für alle Metadaten anzeigen

print(summary.corpus)






#'# CSV-Dateien erstellen

#'## CSV mit vollem Datensatz speichern

csvname.full <- paste(datasetname,
                      datestamp,
                      "DE_CSV_Datensatz.csv",
                      sep = "_")

fwrite(txt.pp,
       csvname.full,
       na = "NA")




#'## CSV mit Metadaten speichern
#' Diese Datei ist grundsätzlich identisch mit dem eigentlichen Datensatz, nur ohne den Text der Protokolle.

csvname.meta <- paste(datasetname,
                      datestamp,
                      "DE_CSV_Metadaten.csv",
                      sep = "_")

fwrite(summary.corpus,
       csvname.meta,
       na = "NA")



#'# TXT-Dateien erstellen

#+
#'## Dateinamen erstellen

names.txt <-   paste0(datasetname,
                     "_",
                     "Bundestag_Plenarprotokoll",
                     "_",
                     txt.pp$wahlperiode,
                     "_",
                     txt.pp$nummer_dok,
                     "_",
                     txt.pp$datum,
                     ".txt")

names.txt <- gsub("/",
                 "-",
                 names.txt)




#'## TXT-Dateien speichern

out <- foreach(i = seq_len(txt.pp[,.N]),
               .errorhandling = 'pass') %dopar% {
                   write.table(txt.pp$text[i],
                               names.txt[i],
                               row.names=FALSE,
                               col.names=FALSE)
               }








#'# Dateigrößen analysieren

#+
#'## Gesamtgröße

#+
#'### Korpus-Objekt in RAM (MB)

print(object.size(corpus),
      standard = "SI",
      humanReadable = TRUE,
      units = "MB")


#'### CSV: Voller Datensatz (MB)
file.size(csvname.full) / 10 ^ 6


#'### CSV: Nur Metadaten (MB)
file.size(csvname.meta) / 10 ^ 6


#'### XML-Dateien (MB)
files.xml <- list.files(pattern = "\\.xml$",
                        ignore.case = TRUE)

xml.MB <- file.size(files.xml) / 10^6
sum(xml.MB)


#'### TXT-Dateien (MB)
files.txt <- list.files(pattern = "\\.txt$",
                        ignore.case = TRUE)

txt.MB <- file.size(files.txt) / 10^6
sum(txt.MB)




#'\newpage
#'## Verteilung der Dateigrößen (XML)

#+ CPP-BT_07_DensityChart_Dateigroessen_XML, fig.height = 6, fig.width = 9
ggplot(data = data.table(xml.MB),
       aes(x = xml.MB)) +
    geom_density(fill = "black") +
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b")+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Verteilung der Dateigrößen (XML)"),
        caption = paste("DOI:",
                        doi.version),
        x = "Dateigröße in MB",
        y = "Dichte"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )



#'\newpage
#'## Verteilung der Dateigrößen (TXT)


#+ CPP-BT_08_DensityChart_Dateigroessen_TXT, fig.height = 6, fig.width = 9
ggplot(data = data.table(txt.MB),
       aes(x = txt.MB)) +
    geom_density(fill = "black") +
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b")+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Verteilung der Dateigrößen (TXT)"),
        caption = paste("DOI:",
                        doi.version),
        x = "Dateigröße in MB",
        y = "Dichte"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )






#'# Erstellen der ZIP-Archive



#'## Verpacken der CSV-Dateien

#+ results = 'hide'
csvname.full.zip <- gsub(".csv",
                    ".zip",
                    csvname.full)

zip(csvname.full.zip,
    csvname.full)

unlink(csvname.full)


#+ results = 'hide'
csvname.meta.zip <- gsub(".csv",
                    ".zip",
                    csvname.meta)

zip(csvname.meta.zip,
    csvname.meta)


#' *Schlussbemerkung:* Die CSV-Datei mit den Metadaten wird an dieser Stelle nicht gelöscht um sie für die Codebook-Erstellung verwenden zu können.




#+
#'## Verpacken der XML-Dateien

#+ results = 'hide'
files.xml <- list.files(pattern="\\.xml",
                        ignore.case = TRUE)

zip(paste(datasetname,
          datestamp,
          "DE_XML_Datensatz.zip",
          sep = "_"),
    files.xml)

unlink(files.xml)


#'## Verpacken der TXT-Dateien


#+ results = 'hide'
files.txt <- list.files(pattern="\\.txt",
                        ignore.case = TRUE)

zip(paste(datasetname,
          datestamp,
          "DE_TXT_Datensatz.zip",
          sep = "_"),
    files.txt)

unlink(files.txt)


#'## Verpacken der Analyse-Dateien

zip(paste0(datasetname,
           "_",
           datestamp,
           "_DE_",
           basename(outputdir),
           ".zip"),
    basename(outputdir))



#'## Verpacken der Source-Dateien

files.source <- c(list.files(pattern = "Source"),
                  "buttons")


files.source <- grep("spin",
                     files.source,
                     value = TRUE,
                     ignore.case = TRUE,
                     invert = TRUE)

zip(paste(datasetname,
           datestamp,
           "Source_Files.zip",
           sep = "_"),
    files.source)



#'# Kryptographische Hashes
#' Dieses Modul berechnet für jedes ZIP-Archiv zwei Arten von Hashes: SHA2-256 und SHA3-512. Mit diesen kann die Authentizität der Dateien geprüft werden und es wird dokumentiert, dass sie aus diesem Source Code hervorgegangen sind. Die SHA-2 und SHA-3 Algorithmen sind äußerst resistent gegenüber *collision* und *pre-imaging* Angriffen, sie gelten derzeit als kryptographisch sicher. Ein SHA3-Hash mit 512 bit Länge ist nach Stand von Wissenschaft und Technik auch gegenüber quantenkryptoanalytischen Verfahren unter Einsatz des *Grover-Algorithmus* hinreichend resistent.

#+
#'## Liste der ZIP-Archive erstellen
files.zip <- list.files(pattern= "\\.zip$",
                        ignore.case = TRUE)


#'## Funktion anzeigen
#+ results = "asis"
print(f.dopar.multihashes)

#'## Hashes berechnen
multihashes <- f.dopar.multihashes(files.zip)


#'## In Data Table umwandeln
setDT(multihashes)



#'## Index hinzufügen
multihashes$index <- seq_len(multihashes[,.N])


#'## In Datei schreiben
fwrite(multihashes,
       paste(datasetname,
             datestamp,
             "KryptographischeHashes.csv",
             sep = "_"),
       na = "NA")


#'## Leerzeichen hinzufügen
#' Hierbei handelt es sich lediglich um eine optische Notwendigkeit. Die normale 128 Zeichen lange Zeichenfolge wird ansonsten nicht umgebrochen und verschwindet über die Seitengrenze. Das Leerzeichen erlaubt den automatischen Zeilenumbruch und damit einen für Menschen sinnvoll lesbaren Abdruck im Codebook. Diese Variante wird nur zur Anzeige verwendet und danach verworfen.

multihashes$sha3.512 <- paste(substr(multihashes$sha3.512, 1, 64),
                              substr(multihashes$sha3.512, 65, 128))


#'\newpage
#'## In Bericht anzeigen

kable(multihashes[,.(index,filename)],
      format = "latex",
      align = c("p{1cm}",
                "p{13cm}"),
      booktabs=TRUE,
      longtable=TRUE)


kable(multihashes[,.(index,sha2.256)],
      format = "latex",
      align = c("c",
                "p{13cm}"),
      booktabs=TRUE,
      longtable=TRUE)


#'\newpage

kable(multihashes[,.(index,sha3.512)],
      format = "latex",
      align = c("c",
                "p{13cm}"),
      booktabs=TRUE,
      longtable=TRUE)






#'# Abschluss

#'## Cluster stoppen
stopCluster(cl)


#'## Datum und Uhrzeit (Ende)
end.script <- Sys.time()
print(end.script)

#'## Laufzeit des gesamten Skripts
print(end.script - begin.script)


#'## Warnungen
warnings()



#'# Parameter für strenge Replikationen

system2("openssl",  "version", stdout = TRUE)

sessionInfo()


#'# Literaturverzeichnis

