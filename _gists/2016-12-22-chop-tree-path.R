# Given a tree path, turn it into untidy data with tidyr::separate and tidyr::unnest

# Example Data Frame with 3 Columns: 
# 1/ entity
# 2/ path = Kingdom (K) > Phylum (P) > Class (C) > Order (O) > Family (F) > Genus (G) > Species (S)
# 3/ pathlevel: K,P,C,O 
bio.classification<-tibble::tibble(entity=c("fly","horse-fly","spider","lobster"),
                     path=c("Animalia > Arthropoda > Insecta > Diptera",
                            "Animalia > Arthropoda > Insecta > Diptera > Tabanidae",
                            "Animalia > Arthropoda > Arachnida > Araneae",
                            "Animalia > Arthropoda > Malacostraca > Decapoda"))

bio.classification%>%tidyr::separate(col=path,
                       into=c("K","P","C","O","F"),
                       sep=" > ")

