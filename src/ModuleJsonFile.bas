Attribute VB_Name = "ModuleJsonFile"
Function TextToJson(ByVal text As String) As String
    ' Convertit un texte en format JSON

     text = Replace(Replace(Replace(text, """", "\"""), vbCrLf, "\n"), "\", "\\")
     TextToJson = text
End Function

Function JsonToText(ByVal JSON As String) As String
    ' Convertit un texte JSON en format texte
     
    JSON = Replace(Replace(Replace(JSON, "{", ""), "}", ""), """", "")
    JSON = Replace(Replace(JSON, "\""", """"), "\\", "\")
    JsonToText = JSON
End Function

Function ExtractValue(ByVal JSON As String, ByVal Key As String) As String
    ' Extrait la valeur associée à une clé donnée dans une chaîne JSON.
    
    Dim position As Integer
    Dim startValue As Integer
    Dim endValue As Integer
    
    position = InStr(1, JSON, Key & ":", vbTextCompare)
    If position = 0 Then
        ExtractValue = ""
        Exit Function
    End If
    

    startValue = position + Len(Key) + 1
    
    endValue = InStr(startValue, JSON, "," & vbCrLf)
    If endValue = 0 Then endValue = Len(JSON) + 1
    
    ExtractValue = Trim(Mid(JSON, startValue, endValue - startValue))
End Function
