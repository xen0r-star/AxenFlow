Attribute VB_Name = "ModuleReplaceActionText"
' Remplace les mots-clés dans le texte par des valeurs spécifiques :
' [année], [year], [annee], [date] par l'année scolaire
' [nom], [name], [firstname] par le nom spécifié
' [prenom], [prénom], [secondname] par le prénom spécifié

Function ReplaceActionText(ByVal text As String, _
                            Optional ByVal name As String = "[name]", _
                            Optional ByVal firstName As String = "[FirstName]") As String
    Dim regex As Object
    
    Set regex = CreateObject("VBScript.RegExp")
    
    regex.IgnoreCase = True
    regex.Global = True
    
    regex.Pattern = "\[(année|year|annee|date)\]"
    text = regex.Replace(text, SchoolYear)
    
    regex.Pattern = "\[(nom|name|firstname)\]"
    text = regex.Replace(text, name)
    
    regex.Pattern = "\[(prenom|prénom|secondname)\]"
    text = regex.Replace(text, firstName)
    
    ReplaceActionText = text
End Function
