Attribute VB_Name = "ModuleNormalizeString"
' Normalise le texte en supprimant les accents et les caractères spéciaux (', -, ., espace)
' Remplace les caractères accentués par leurs équivalents non accentués

Function NormalizeString(text As String) As String
    Const accents As String = "ÁÀÂÄÃÅÉÈÊËÍÌÎÏÓÒÔÖÕÚÙÛÜİÑÇáàâäãåéèêëíìîïóòôöõúùûüıñç"
    Const noAccents As String = "AAAAAAEEEEIIIIOOOOOUUUUYNCaaaaaaeeeeiiiiooooouuuuync"
    Const specialChar As String = "'- ."
    
    For i = 1 To Len(accents)
        text = Replace(text, Mid(accents, i, 1), Mid(noAccents, i, 1))
    Next i
    
    For i = 1 To Len(specialChar)
        text = Replace(text, Mid(specialChar, i, 1), "")
    Next i
    
    NormalizeString = text
End Function

